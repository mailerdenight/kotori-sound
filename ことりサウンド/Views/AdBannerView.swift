import GoogleMobileAds
import SwiftUI
import UIKit

struct AdBannerView: View {
    let availableWidth: CGFloat

    var body: some View {
        let bannerWidth = max(availableWidth.rounded(.down), 1)
        let adSize = largeAnchoredAdaptiveBanner(width: bannerWidth)

        BannerContainerView(adSize: adSize)
            .frame(height: adSize.size.height)
    }
}

private struct BannerContainerView: UIViewRepresentable {
    let adSize: AdSize

    func makeCoordinator() -> BannerCoordinator {
        BannerCoordinator()
    }

    func makeUIView(context: Context) -> BannerHostingView {
        let view = BannerHostingView()
        view.configure(
            adSize: adSize,
            adUnitID: AdMobConfiguration.bannerAdUnitID,
            delegate: context.coordinator
        )
        return view
    }

    func updateUIView(_ uiView: BannerHostingView, context: Context) {
        uiView.configure(
            adSize: adSize,
            adUnitID: AdMobConfiguration.bannerAdUnitID,
            delegate: context.coordinator
        )
    }
}

private final class BannerHostingView: UIView {
    private let bannerView = BannerView()
    private var currentSize: CGSize = .zero
    private var currentAdUnitID = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bannerView)

        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bannerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        adSize: AdSize,
        adUnitID: String,
        delegate: BannerViewDelegate
    ) {
        bannerView.delegate = delegate

        let nextSize = adSize.size
        let needsReload =
            currentSize != nextSize || currentAdUnitID != adUnitID

        guard needsReload else { return }

        currentSize = nextSize
        currentAdUnitID = adUnitID
        bannerView.adSize = adSize
        bannerView.adUnitID = adUnitID
        invalidateIntrinsicContentSize()
        bannerView.load(Request())
    }

    override var intrinsicContentSize: CGSize {
        currentSize
    }
}

private final class BannerCoordinator: NSObject, BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        #if DEBUG
        print("AdMob banner loaded size=\(bannerView.bounds.size)")
        #endif
    }

    func bannerView(
        _ bannerView: BannerView,
        didFailToReceiveAdWithError error: any Error
    ) {
        #if DEBUG
        print("AdMob banner failed: \(error.localizedDescription)")
        #endif
    }
}
