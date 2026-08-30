import SwiftUI

@main
struct KotoriSoundApp: App {
    @StateObject private var viewModel = BirdSoundViewModel()
    @StateObject private var adConsentManager = AdConsentManager()
    @StateObject private var purchaseManager = ProPurchaseManager()

    private let isStoreScreenshotMode: Bool = {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("-storeScreenshotMode")
        #else
        return false
        #endif
    }()

    init() {
        AdMobConfiguration.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainView(
                viewModel: viewModel,
                adConsentManager: adConsentManager,
                allowsAdLoading: !isStoreScreenshotMode
            )
            .environmentObject(purchaseManager)
            .onAppear {
                if !isStoreScreenshotMode {
                    adConsentManager.requestConsentIfNeeded()
                }
            }
        }
    }
}
