import Combine
import Foundation
import GoogleMobileAds
import UserMessagingPlatform

enum AdMobConfiguration {
    private static let productionBannerAdUnitIDKey = "AdMobProductionBannerAdUnitID"
    private static let testBannerAdUnitIDKey = "AdMobTestBannerAdUnitID"

    static var bannerAdUnitID: String {
        #if DEBUG
        return plistValue(for: testBannerAdUnitIDKey)
        #else
        return plistValue(for: productionBannerAdUnitIDKey)
        #endif
    }

    static func configure() {
        let configuration = MobileAds.shared.requestConfiguration
        configuration.ageRestrictedTreatment = .child
        configuration.maxAdContentRating = .general
        configuration.setPublisherFirstPartyIDEnabled(false)
        MobileAds.shared.disableSDKCrashReporting()
    }

    private static func plistValue(for key: String) -> String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
            !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            assertionFailure("Missing AdMob configuration for \(key)")
            return ""
        }

        return value
    }
}

@MainActor
final class AdConsentManager: ObservableObject {
    @Published private(set) var canRequestAds = false
    @Published private(set) var isPrivacyOptionsRequired = false

    private var hasRequestedConsent = false
    private var hasStartedMobileAds = false

    func requestConsentIfNeeded() {
        guard !hasRequestedConsent else { return }
        hasRequestedConsent = true

        let parameters = RequestParameters()
        parameters.isTaggedForUnderAgeOfConsent = true

        ConsentInformation.shared.requestConsentInfoUpdate(
            with: parameters
        ) { [weak self] requestError in
            Task { @MainActor [weak self] in
                guard let self else { return }

                if requestError == nil {
                    do {
                        try await ConsentForm.loadAndPresentIfRequired(from: nil)
                    } catch {
                        self.log(
                            "Unable to present consent form: \(error.localizedDescription)"
                        )
                    }
                } else if let requestError {
                    self.log(
                        "Unable to update consent information: \(requestError.localizedDescription)"
                    )
                }

                self.refreshConsentState()
            }
        }
    }

    func presentPrivacyOptions() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                try await ConsentForm.presentPrivacyOptionsForm(from: nil)
            } catch {
                self.log(
                    "Unable to present privacy options: \(error.localizedDescription)"
                )
            }

            self.refreshConsentState()
        }
    }

    private func refreshConsentState() {
        isPrivacyOptionsRequired =
            ConsentInformation.shared.privacyOptionsRequirementStatus == .required
        canRequestAds = ConsentInformation.shared.canRequestAds

        guard canRequestAds, !hasStartedMobileAds else { return }
        hasStartedMobileAds = true
        MobileAds.shared.start()
    }

    private func log(_ message: String) {
        #if DEBUG
        print("Ad consent: \(message)")
        #endif
    }
}
