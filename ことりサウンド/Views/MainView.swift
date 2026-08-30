import SwiftUI
import UIKit

struct MainView: View {
    @ObservedObject var viewModel: BirdSoundViewModel
    @ObservedObject var adConsentManager: AdConsentManager
    @EnvironmentObject private var purchaseManager: ProPurchaseManager
    let allowsAdLoading: Bool

    @State private var selectedBird: BirdSoundItem?
    @State private var isShowingAbout = false
    @State private var isShowingQuiz = false
    @State private var isShowingPurchase = false

    var body: some View {
        ZStack {
            BirdGardenBackground()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                titleSection

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        ForEach(BirdGroup.allCases) { group in
                            birdSection(group)
                                .id(group.id)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 15)
                    .padding(.bottom, 20)
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    bottomBar
                }
            }
        }
        .sheet(item: $selectedBird) { item in
            BirdDetailView(item: item)
                .environmentObject(purchaseManager)
        }
        .sheet(isPresented: $isShowingAbout) {
            AboutView(
                items: viewModel.items,
                isPrivacyOptionsRequired: adConsentManager.isPrivacyOptionsRequired,
                showPrivacyOptions: adConsentManager.presentPrivacyOptions
            )
        }
        .sheet(isPresented: $isShowingQuiz) {
            BirdQuizView()
                .environmentObject(purchaseManager)
        }
        .sheet(isPresented: $isShowingPurchase) {
            BirdPurchaseView()
                .environmentObject(purchaseManager)
        }
        .onAppear {
            #if DEBUG
            let arguments = ProcessInfo.processInfo.arguments
            if let flagIndex = arguments.firstIndex(of: "-showBirdDetail"),
               arguments.indices.contains(flagIndex + 1),
               let item = viewModel.items.first(
                   where: { $0.id == arguments[flagIndex + 1] }
               ) {
                selectedBird = item
            }
            #endif
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 11) {
                ZStack {
                    Circle()
                        .fill(Color(hex: 0xEAF4E7))

                    Image(systemName: "bird.fill")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(Color(hex: 0x2D755C))
                }
                .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 1) {
                    Text("ことりサウンド")
                        .font(.system(size: 27, weight: .black, design: .rounded))
                        .tracking(0.2)
                        .foregroundStyle(Color(hex: 0x174D3B))
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)

                    Text("鳥のくらし図鑑")
                        .font(.system(size: 10.5, weight: .bold, design: .rounded))
                        .tracking(2.1)
                        .foregroundStyle(Color(hex: 0x5B796E))
                }

                Spacer(minLength: 6)

                Text("\(viewModel.items.count)種")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundStyle(Color(hex: 0x2D755C))
                    .padding(.horizontal, 11)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.76))
                    )
            }

            Label(
                "見た目・くらし・鳴き声を、同じ目線でくらべよう",
                systemImage: "book.closed.fill"
            )
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(Color(hex: 0x315C4E))
            .lineLimit(1)
            .minimumScaleFactor(0.74)
        }
        .padding(.horizontal, 17)
        .padding(.top, 9)
        .padding(.bottom, 11)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color.white.opacity(0.78),
                    Color.white.opacity(0.34)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    private func birdSection(_ group: BirdGroup) -> some View {
        let groupItems = viewModel.items.filter { $0.group == group }

        return VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 9) {
                Image(systemName: group.symbol)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(group.color))

                VStack(alignment: .leading, spacing: 1) {
                    Text(group.title)
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(Color(hex: 0x1F4B3D))

                    Text(group.subtitle)
                        .font(.system(size: 10.5, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(hex: 0x5E766E))
                }

                Spacer(minLength: 0)

                Text("\(groupItems.count)種類")
                    .font(.system(size: 10.5, weight: .bold, design: .rounded))
                    .foregroundStyle(group.color)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color.white.opacity(0.78)))
            }
            .padding(.horizontal, 4)

            VStack(spacing: 13) {
                ForEach(Array(stride(from: 0, to: groupItems.count, by: 2)), id: \.self) { index in
                    HStack(spacing: 12) {
                        BirdFieldGuideCard(item: groupItems[index]) {
                            selectedBird = groupItems[index]
                        }

                        if groupItems.indices.contains(index + 1) {
                            BirdFieldGuideCard(item: groupItems[index + 1]) {
                                selectedBird = groupItems[index + 1]
                            }
                        } else {
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .frame(height: 184)
                        }
                    }
                }
            }
        }
    }

    private var bottomBar: some View {
        VStack(spacing: 8) {
            HStack {
                Label("鳥をタップすると、図鑑の特徴を見られます", systemImage: "hand.tap.fill")
                    .font(.system(size: 11.5, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: 0x294E42))

                Spacer(minLength: 0)

                Button {
                    isShowingAbout = true
                } label: {
                    Image(systemName: "info")
                        .font(.system(size: 12, weight: .black))
                        .foregroundStyle(Color(hex: 0x2D755C))
                        .frame(width: 30, height: 26)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("このアプリについて")
            }

            if !purchaseManager.isProUnlocked {
                Button {
                    isShowingPurchase = true
                } label: {
                    Label(
                        "すべての鳴き声を解放 \(purchaseManager.displayPrice)",
                        systemImage: "lock.open.fill"
                    )
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(Color(hex: 0x285F86))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.9))
                            .overlay(Capsule().stroke(Color(hex: 0x8AB6CF), lineWidth: 1))
                    )
                }
                .buttonStyle(.plain)
                .accessibilityHint("すべての鳥の鳴き声と無制限クイズの購入画面を開きます")
                .padding(.horizontal, 14)
            }

            Button {
                isShowingQuiz = true
            } label: {
                Label("鳴き声クイズをはじめる", systemImage: "speaker.wave.2.fill")
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(Color(hex: 0x2D755C))
                    )
            }
            .buttonStyle(.plain)
            .accessibilityHint("鳴き声を聞いて、鳥の名前を当てるクイズを開きます")
            .accessibilityIdentifier("startBirdSoundQuiz")
            .padding(.horizontal, 14)

            AdBannerBar(
                canLoadAds: allowsAdLoading && adConsentManager.canRequestAds
            )
        }
        .padding(.top, 7)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.white.opacity(0.7))
                .frame(height: 1)
        }
    }
}

private struct BirdFieldGuideCard: View {
    let item: BirdSoundItem
    let openAction: () -> Void

    var body: some View {
        Button(action: openAction) {
            ZStack(alignment: .bottomLeading) {
                BirdArtworkView(item: item, contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                LinearGradient(
                    colors: [
                        Color.clear,
                        Color(hex: 0xFFFDF5).opacity(0.70),
                        Color(hex: 0xFFFDF5).opacity(0.98)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 80)

                VStack(alignment: .leading, spacing: 3) {
                    Text(item.title)
                        .font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundStyle(Color(hex: 0x243F37))
                        .lineLimit(1)
                        .minimumScaleFactor(0.68)
                        .allowsTightening(true)

                    Label("特徴を見る", systemImage: "book.closed.fill")
                        .font(.system(size: 10.5, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: 0x62766F))
                }
                .padding(.horizontal, 13)
                .padding(.bottom, 11)

                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(item.group.color)
                    .frame(width: 30, height: 30)
                    .background(Circle().fill(Color.white.opacity(0.94)))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(10)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 184)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(hex: 0xFFFDF5))
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white.opacity(0.94), lineWidth: 1.2)
            )
            .shadow(
                color: Color(hex: 0x285443).opacity(0.13),
                radius: 8,
                y: 5
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(item.title)の特徴を見る")
    }
}

struct BirdArtworkView: View {
    let item: BirdSoundItem
    var contentMode: ContentMode = .fit
    var useTransparentArtwork = false

    var body: some View {
        Group {
            if let image = artworkImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                Image(systemName: "bird.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(item.primaryColor)
                    .padding(54)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: 0xFFFCF2),
                    Color(hex: 0xEEF2DD)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .accessibilityHidden(true)
    }

    private var artworkImage: UIImage? {
        let directories = useTransparentArtwork
            ? ["BirdIllustrations/transparent", "BirdIllustrations"]
            : ["BirdIllustrations"]

        for directory in directories {
            if let url = Bundle.main.url(
                forResource: item.id,
                withExtension: "png",
                subdirectory: directory
            ), let image = UIImage(contentsOfFile: url.path) {
                return image
            }
        }

        return nil
    }
}

private struct BirdDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var purchaseManager: ProPurchaseManager
    @StateObject private var audioPlayer = BirdAudioPlayer()
    @State private var isShowingPurchase = false
    let item: BirdSoundItem

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Label(item.group.title, systemImage: item.group.symbol)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(item.group.color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(item.group.color.opacity(0.11))
                        )

                    Text(item.title)
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(Color(hex: 0x174D3B))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.72)

                    BirdArtworkView(
                        item: item,
                        useTransparentArtwork: true
                    )
                        .frame(maxWidth: .infinity)
                        .frame(height: 290)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(Color.white.opacity(0.9), lineWidth: 2)
                        )
                        .shadow(
                            color: Color(hex: 0x244B3E).opacity(0.16),
                            radius: 18,
                            y: 9
                        )

                    if !item.audioClips.isEmpty {
                        VStack(spacing: 11) {
                            Label("代表的な鳴き声", systemImage: "speaker.wave.2.fill")
                                .font(.system(size: 17, weight: .black, design: .rounded))
                                .foregroundStyle(Color(hex: 0x285F86))

                            if item.isPremiumAudio && !purchaseManager.isProUnlocked {
                                Text("この鳥の鳴き声は購入後に聴けます")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(hex: 0x5E766E))
                                    .multilineTextAlignment(.center)
                            }

                            if item.audioClips.count == 1, let clip = item.audioClips.first {
                                audioButton(for: clip, total: 1)
                            } else {
                                LazyVGrid(
                                    columns: [
                                        GridItem(.flexible(), spacing: 10),
                                        GridItem(.flexible(), spacing: 10)
                                    ],
                                    spacing: 10
                                ) {
                                    ForEach(item.audioClips.indices, id: \.self) { index in
                                        audioButton(
                                            for: item.audioClips[index],
                                            total: item.audioClips.count
                                        )
                                    }
                                }
                            }

                        }
                        .padding(17)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(Color.white.opacity(0.88))
                        )
                    }

                    if item.isPremiumAudio && !purchaseManager.isProUnlocked {
                        Button {
                            isShowingPurchase = true
                        } label: {
                            Label("購入してこの鳥の鳴き声を聴く", systemImage: "lock.open.fill")
                                .font(.system(size: 14, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    Capsule()
                                        .fill(Color(hex: 0x285F86))
                                )
                        }
                        .buttonStyle(.plain)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        Label("この鳥の特徴", systemImage: "binoculars.fill")
                            .font(.system(size: 19, weight: .black, design: .rounded))
                            .foregroundStyle(Color(hex: 0x214C3D))
                            .padding(.horizontal, 18)
                            .padding(.top, 18)
                            .padding(.bottom, 13)

                        Divider()
                            .padding(.horizontal, 18)

                        TraitRow(
                            symbol: "globe",
                            title: "英語名",
                            text: item.englishName,
                            color: Color(hex: 0x5B6FA6)
                        )

                        Divider()
                            .padding(.leading, 66)

                        TraitRow(
                            symbol: "textformat.abc",
                            title: "学名",
                            text: item.scientificName,
                            color: Color(hex: 0x7B6A9B)
                        )

                        Divider()
                            .padding(.leading, 66)

                        TraitRow(
                            symbol: "eye.fill",
                            title: "見た目",
                            text: item.profile.appearance,
                            color: Color(hex: 0xC17448)
                        )

                        Divider()
                            .padding(.leading, 66)

                        TraitRow(
                            symbol: "leaf.fill",
                            title: "くらし",
                            text: item.profile.habitat,
                            color: Color(hex: 0x3A8B68)
                        )

                        Divider()
                            .padding(.leading, 66)

                        TraitRow(
                            symbol: "waveform",
                            title: "鳴き声",
                            text: item.profile.voice,
                            color: Color(hex: 0x507EAA)
                        )
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.white.opacity(0.86))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.white.opacity(0.92), lineWidth: 1)
                    )

                    Text("鳴き声や羽色には、地域・季節・年齢・個体による違いがあります。")
                        .font(.system(size: 11.5, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)
                .padding(.bottom, 34)
            }
            .background(
                LinearGradient(
                    colors: [
                        item.group.color.opacity(0.14),
                        Color(hex: 0xE9F3E8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("ことりずかん")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("戻る") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingPurchase) {
            BirdPurchaseView()
                .environmentObject(purchaseManager)
        }
        .onDisappear { audioPlayer.stop() }
    }

    private func audioButton(
        for clip: BirdAudioClip,
        total: Int
    ) -> some View {
        let isLocked = item.isPremiumAudio && !purchaseManager.isProUnlocked

        return Button {
            if isLocked {
                isShowingPurchase = true
            } else {
                audioPlayer.toggle(clip)
            }
        } label: {
            Label(
                isLocked
                    ? "購入で聴けます"
                    : audioPlayer.playingClipID == clip.id
                    ? "再生中…"
                    : total > 1 ? clip.displayName : "鳴き声を聴く",
                systemImage: isLocked
                    ? "lock.fill"
                    : audioPlayer.playingClipID == clip.id
                    ? "speaker.wave.3.fill"
                    : "play.fill"
            )
            .font(.system(size: 15, weight: .black, design: .rounded))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(.borderedProminent)
        .tint(Color(hex: 0x3A7BA5))
        .accessibilityHint(
            isLocked
                ? "購入すると、この鳥の鳴き声を再生できます"
                : audioPlayer.playingClipID == clip.id
                ? "もう一度タップすると停止します"
                : "タップすると、この鳥の鳴き声を再生します"
        )
        .accessibilityLabel(
            isLocked
                ? "購入して鳴き声を聴く"
                : total > 1 ? "\(clip.displayName)を再生" : "鳴き声を聴く"
        )
    }

}

private struct TraitRow: View {
    let symbol: String
    let title: String
    let text: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            Image(systemName: symbol)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(color)
                )

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(color)

                Text(text)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(hex: 0x29443A))
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

private struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    let items: [BirdSoundItem]
    let isPrivacyOptionsRequired: Bool
    let showPrivacyOptions: () -> Void

    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("ことりサウンド")
                            .font(.system(size: 22, weight: .black, design: .rounded))

                        Text("\(items.count)種類の鳥を、図鑑画と「見た目・くらし・鳴き声」の3項目で楽しめる鳥図鑑です。")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 6)
                }

                Section("図鑑について") {
                    Label("すべての鳥を同じ3項目で掲載", systemImage: "list.bullet.rectangle")
                            Label("\(BirdAudioClip.all.count)件の鳴き声を収録", systemImage: "speaker.wave.2.fill")
                    Label("音源の出典とライセンスはクイズ画面から確認できます", systemImage: "doc.text.fill")
                    Label("野外観察では鳥との距離を保ちましょう", systemImage: "binoculars.fill")
                }

                if isPrivacyOptionsRequired {
                    Section("プライバシー") {
                        Button("広告のプライバシー設定") {
                            showPrivacyOptions()
                        }
                    }
                }
            }
            .navigationTitle("このアプリについて")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("閉じる") {
                        dismiss()
                    }
                }
            }
        }
    }
}

private struct AdBannerBar: View {
    let canLoadAds: Bool

    var body: some View {
        GeometryReader { proxy in
            if canLoadAds {
                let horizontalInset: CGFloat = 12
                let availableWidth = max(proxy.size.width - horizontalInset * 2, 1)

                AdBannerView(availableWidth: availableWidth)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, horizontalInset)
                    .padding(.vertical, 4)
            } else {
                Color.clear
            }
        }
        .frame(height: canLoadAds ? 58 : 0)
        .clipped()
    }
}

private struct BirdGardenBackground: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(hex: 0xBDEBFA),
                        Color(hex: 0xEDF6D5),
                        Color(hex: 0xD4E8AE)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                Circle()
                    .fill(Color(hex: 0xFFF3A5).opacity(0.78))
                    .frame(width: 128, height: 128)
                    .blur(radius: 3)
                    .position(x: proxy.size.width - 30, y: 90)

                Cloud()
                    .fill(Color.white.opacity(0.64))
                    .frame(width: 105, height: 42)
                    .position(x: 35, y: proxy.size.height * 0.23)

                Cloud()
                    .fill(Color.white.opacity(0.46))
                    .frame(width: 82, height: 34)
                    .position(x: proxy.size.width - 25, y: proxy.size.height * 0.42)

                branchLayer(size: proxy.size)
            }
        }
    }

    private func branchLayer(size: CGSize) -> some View {
        ZStack {
            Capsule()
                .fill(Color(hex: 0x8B6847).opacity(0.35))
                .frame(width: size.width * 0.9, height: 15)
                .rotationEffect(.degrees(-8))
                .position(x: size.width * 0.05, y: size.height * 0.78)

            ForEach(0..<7, id: \.self) { index in
                LeafShape()
                    .fill(
                        Color(hex: index.isMultiple(of: 2) ? 0x6CAF5A : 0x88C86A)
                            .opacity(0.36)
                    )
                    .frame(width: 56, height: 34)
                    .rotationEffect(.degrees(Double(index * 31 - 70)))
                    .position(
                        x: index.isMultiple(of: 2)
                            ? 20
                            : size.width - 20,
                        y: size.height * (0.12 + Double(index) * 0.13)
                    )
            }
        }
    }
}

private struct Cloud: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(
            in: CGRect(
                x: rect.width * 0.05,
                y: rect.height * 0.36,
                width: rect.width * 0.42,
                height: rect.height * 0.55
            )
        )
        path.addEllipse(
            in: CGRect(
                x: rect.width * 0.28,
                y: rect.height * 0.05,
                width: rect.width * 0.43,
                height: rect.height * 0.8
            )
        )
        path.addEllipse(
            in: CGRect(
                x: rect.width * 0.55,
                y: rect.height * 0.28,
                width: rect.width * 0.4,
                height: rect.height * 0.62
            )
        )
        path.addRoundedRect(
            in: CGRect(
                x: rect.width * 0.08,
                y: rect.height * 0.55,
                width: rect.width * 0.84,
                height: rect.height * 0.4
            ),
            cornerSize: CGSize(width: rect.height * 0.2, height: rect.height * 0.2)
        )
        return path
    }
}

private struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control1: CGPoint(x: rect.width * 0.27, y: rect.minY),
            control2: CGPoint(x: rect.width * 0.73, y: rect.minY)
        )
        path.addCurve(
            to: CGPoint(x: rect.minX, y: rect.midY),
            control1: CGPoint(x: rect.width * 0.73, y: rect.maxY),
            control2: CGPoint(x: rect.width * 0.27, y: rect.maxY)
        )
        return path
    }
}
