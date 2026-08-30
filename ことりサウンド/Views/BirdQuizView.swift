import SwiftUI

struct BirdQuizView: View {
    @EnvironmentObject private var purchaseManager: ProPurchaseManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var viewModel: BirdQuizViewModel
    @State private var isShowingPurchase = false

    init() {
        _viewModel = StateObject(
            wrappedValue: BirdQuizViewModel(
                clips: BirdAudioClip.all,
                availableBirds: BirdSoundItem.all,
                isFullVersion: false
            )
        )
    }

    var body: some View {
        ZStack {
            BirdQuizBackground()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                quizHeader

                if viewModel.isFinished {
                    resultView
                } else {
                    questionView
                }
            }

            if let feedback = viewModel.feedback {
                BirdFeedbackOverlay(isCorrect: feedback.isCorrect)
                    .allowsHitTesting(false)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.32, dampingFraction: 0.72), value: viewModel.feedback)
        .onAppear {
            if purchaseManager.isProUnlocked {
                viewModel.startFullVersion()
            }
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase != .active {
                viewModel.stop()
            } else {
                viewModel.resume()
            }
        }
        .onChange(of: purchaseManager.isProUnlocked) { isUnlocked in
            if isUnlocked {
                viewModel.startFullVersion()
            }
        }
        .sheet(isPresented: $isShowingPurchase) {
            BirdPurchaseView()
                .environmentObject(purchaseManager)
        }
    }

    private var quizHeader: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(Color(hex: 0x285F86))
                    .frame(width: 46, height: 46)
                    .background(.white.opacity(0.94), in: Circle())
                    .shadow(color: .black.opacity(0.12), radius: 8, y: 3)
            }
            .accessibilityLabel("クイズを閉じる")

            Spacer()

            VStack(spacing: 1) {
                Text("鳴き声クイズ")
                    .font(.system(size: 25, weight: .black, design: .rounded))
                    .foregroundStyle(Color(hex: 0x285F86))

                if !viewModel.isFinished {
                    Text("\(viewModel.questionNumber) / \(viewModel.totalQuestions)")
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: 0x4F6674))
                }
            }

            Spacer()

            Button {
                viewModel.replayQuestion()
            } label: {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 19, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 46, height: 46)
                    .background(Color(hex: 0xE4773C), in: Circle())
                    .shadow(color: .black.opacity(0.12), radius: 8, y: 3)
            }
            .disabled(viewModel.isFinished || viewModel.feedback != nil)
            .opacity(viewModel.isFinished ? 0 : 1)
            .accessibilityLabel("問題の鳴き声をもう一度聞く")
        }
        .padding(.horizontal, 18)
        .padding(.top, 12)
        .padding(.bottom, 6)
    }

    private var questionView: some View {
        GeometryReader { proxy in
            let isCompact = proxy.size.height < 590

            VStack(spacing: isCompact ? 14 : 24) {
                Spacer(minLength: isCompact ? 4 : 14)

                VStack(spacing: 10) {
                    Text("この こえは だれ？")
                        .font(.system(size: isCompact ? 27 : 32, weight: .black, design: .rounded))
                        .foregroundStyle(Color(hex: 0x243F37))
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)

                    Button {
                        viewModel.replayQuestion()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "speaker.wave.3.fill")
                                .font(.system(size: isCompact ? 24 : 30, weight: .bold))
                            Text("もういちど きく")
                                .font(.system(size: isCompact ? 18 : 21, weight: .black, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .frame(height: isCompact ? 48 : 56)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: 0xF49A2D), Color(hex: 0xE4773C)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            in: Capsule()
                        )
                        .shadow(color: Color.orange.opacity(0.28), radius: 10, y: 5)
                    }
                    .disabled(viewModel.feedback != nil)
                }

                Spacer(minLength: 0)

                HStack(alignment: .top, spacing: isCompact ? 8 : 12) {
                    ForEach(viewModel.choices) { bird in
                        BirdQuizChoiceCard(
                            bird: bird,
                            isCompact: isCompact,
                            isSelected: viewModel.feedback?.selectedID == bird.id,
                            selectedCorrectly: viewModel.feedback?.isCorrect == true,
                            action: { viewModel.choose(bird) }
                        )
                        .disabled(viewModel.feedback != nil)
                    }
                }
                .padding(.horizontal, isCompact ? 10 : 14)

                Spacer(minLength: isCompact ? 12 : 30)

                Text("えを タップして こたえてね！")
                    .font(.system(size: isCompact ? 16 : 19, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: 0x496475))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.white.opacity(0.76), in: Capsule())

                Spacer(minLength: isCompact ? 10 : 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var resultView: some View {
        VStack(spacing: 20) {
            Spacer()

            Text(viewModel.isFullVersion ? "ぜんもん せいかい！" : "おためし クリア！")
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(Color(hex: 0x285F86))
                .multilineTextAlignment(.center)

            HStack(spacing: 6) {
                ForEach(0..<viewModel.totalQuestions, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(Color(hex: 0xF2B93B))
                        .shadow(color: .orange.opacity(0.25), radius: 4, y: 2)
                }
            }

            Text("よく できました！")
                .font(.system(size: 26, weight: .black, design: .rounded))
                .foregroundStyle(Color(hex: 0x3F5663))

            if viewModel.isFullVersion {
                Button {
                    viewModel.restart()
                } label: {
                    Text("もういちど")
                        .font(.system(size: 23, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: 270)
                        .frame(height: 58)
                        .background(Color(hex: 0x3A8B68), in: Capsule())
                }
            } else {
                VStack(spacing: 12) {
                    Text("もっとクイズであそんで\nすべての鳴き声を聴こう！")
                        .font(.system(size: 21, weight: .black, design: .rounded))
                        .foregroundStyle(Color(hex: 0x294E42))
                        .multilineTextAlignment(.center)

                    Button {
                        isShowingPurchase = true
                    } label: {
                        HStack(spacing: 9) {
                            Image(systemName: "lock.open.fill")
                            Text("ぜんぶであそぶ \(purchaseManager.displayPrice)")
                        }
                        .font(.system(size: 21, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: 310)
                        .frame(height: 62)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: 0xE4773C), Color(hex: 0xC95B63)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            in: Capsule()
                        )
                        .shadow(color: .pink.opacity(0.28), radius: 10, y: 5)
                    }
                }
                .padding(.top, 6)
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct BirdQuizChoiceCard: View {
    let bird: BirdSoundItem
    let isCompact: Bool
    let isSelected: Bool
    let selectedCorrectly: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: isCompact ? 2 : 6) {
                BirdArtworkView(item: bird, contentMode: .fit, useTransparentArtwork: true)
                    .frame(height: isCompact ? 86 : 108)

                Text(bird.title)
                    .font(.system(size: isCompact ? 16 : 19, weight: .black, design: .rounded))
                    .foregroundStyle(Color(hex: 0x243F37))
                    .lineLimit(1)
                    .minimumScaleFactor(0.64)
            }
            .padding(.horizontal, isCompact ? 4 : 6)
            .padding(.vertical, isCompact ? 8 : 11)
            .frame(maxWidth: .infinity)
            .background(.white.opacity(0.96), in: RoundedRectangle(cornerRadius: 24))
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        isSelected
                            ? (selectedCorrectly ? Color.green : Color.red)
                            : bird.group.color.opacity(0.72),
                        lineWidth: isSelected ? 6 : 4
                    )
            }
            .shadow(color: .black.opacity(0.14), radius: 10, y: 5)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(bird.title)を選ぶ")
    }
}

private struct BirdFeedbackOverlay: View {
    let isCorrect: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.10)
                .ignoresSafeArea()

            VStack(spacing: 4) {
                Text(isCorrect ? "○" : "×")
                    .font(.system(size: 190, weight: .black, design: .rounded))
                    .foregroundStyle(isCorrect ? Color.red : Color.blue)
                    .shadow(color: .white, radius: 2)
                    .shadow(color: .black.opacity(0.18), radius: 12, y: 6)

                Text(isCorrect ? "せいかい！" : "もういちど！")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(Color(hex: 0x294E42))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 9)
                    .background(.white.opacity(0.94), in: Capsule())
            }
        }
    }
}

private struct BirdQuizBackground: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(hex: 0x7BDCF4),
                        Color(hex: 0xEAF5B6),
                        Color(hex: 0xFFE08B)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                Circle()
                    .fill(.white.opacity(0.22))
                    .frame(width: 210, height: 210)
                    .position(x: 20, y: proxy.size.height * 0.28)

                Circle()
                    .fill(Color.yellow.opacity(0.18))
                    .frame(width: 260, height: 260)
                    .position(x: proxy.size.width, y: proxy.size.height * 0.68)
            }
        }
    }
}
