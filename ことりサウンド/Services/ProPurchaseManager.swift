import Foundation
import StoreKit

@MainActor
final class ProPurchaseManager: ObservableObject {
    static let productID = "com.ac.kotorisounds.pro"
    static let fallbackDisplayPrice = "¥200"

    @Published private(set) var isProUnlocked = false
    @Published private(set) var product: Product?
    @Published private(set) var isWorking = false
    @Published var errorMessage: String?

    private var transactionUpdates: Task<Void, Never>?

    var displayPrice: String {
        product?.displayPrice ?? Self.fallbackDisplayPrice
    }

    init() {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-proUnlocked") {
            isProUnlocked = true
        }
        #endif

        transactionUpdates = observeTransactionUpdates()
        Task {
            await loadProduct()
            await refreshEntitlement()
        }
    }

    deinit {
        transactionUpdates?.cancel()
    }

    func purchase() async {
        guard let product else {
            await loadProduct()
            if self.product == nil {
                errorMessage = "購入情報を読み込めませんでした。通信環境を確認してください。"
            }
            return
        }

        isWorking = true
        errorMessage = nil
        defer { isWorking = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try verified(verification)
                isProUnlocked = true
                await transaction.finish()
            case .pending:
                errorMessage = "購入の承認を待っています。"
            case .userCancelled:
                break
            @unknown default:
                errorMessage = "購入を完了できませんでした。"
            }
        } catch {
            errorMessage = "購入を完了できませんでした。もう一度お試しください。"
        }
    }

    func restore() async {
        isWorking = true
        errorMessage = nil
        defer { isWorking = false }

        do {
            try await AppStore.sync()
            await refreshEntitlement()
            if !isProUnlocked {
                errorMessage = "復元できる購入履歴が見つかりませんでした。"
            }
        } catch {
            errorMessage = "購入履歴を復元できませんでした。"
        }
    }

    func refreshEntitlement() async {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-proUnlocked") {
            isProUnlocked = true
            return
        }
        #endif

        var unlocked = false
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? verified(result) else { continue }
            if transaction.productID == Self.productID,
               transaction.revocationDate == nil {
                unlocked = true
                break
            }
        }
        isProUnlocked = unlocked
    }

    private func loadProduct() async {
        do {
            product = try await Product.products(for: [Self.productID]).first
        } catch {
            product = nil
        }
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task { [weak self] in
            for await result in Transaction.updates {
                guard let self,
                      let transaction = try? self.verified(result) else {
                    continue
                }
                await self.refreshEntitlement()
                await transaction.finish()
            }
        }
    }

    private func verified<T>(
        _ result: VerificationResult<T>
    ) throws -> T {
        switch result {
        case .verified(let value):
            return value
        case .unverified:
            throw PurchaseError.failedVerification
        }
    }
}

private enum PurchaseError: Error {
    case failedVerification
}
