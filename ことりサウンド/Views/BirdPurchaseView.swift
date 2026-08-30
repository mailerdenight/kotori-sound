import SwiftUI

struct BirdPurchaseView: View {
    @EnvironmentObject private var purchaseManager: ProPurchaseManager
    @Environment(\.dismiss) private var dismiss

    @State private var challenge = BirdParentChallenge.make()
    @State private var didPassGate = false
    @State private var didChooseWrongAnswer = false

    var body: some View {
        NavigationView {
            Group {
                if didPassGate {
                    purchaseDetails
                } else {
                    parentGate
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0xF4FAF8))
            .navigationTitle("おうちのかたへ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
        .onChange(of: purchaseManager.isProUnlocked) { isUnlocked in
            if isUnlocked {
                dismiss()
            }
        }
    }

    private var parentGate: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color(hex: 0x2D755C))

            Text("おうちのかた向け画面を開くには、\n保護者のかたが答えてください。")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: 0x243F37))
                .multilineTextAlignment(.center)

            Text("\(challenge.firstNumber) ＋ \(challenge.secondNumber) ＝ ？")
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(Color(hex: 0x285F86))

            HStack(spacing: 12) {
                ForEach(challenge.choices, id: \.self) { choice in
                    Button {
                        if choice == challenge.answer {
                            didPassGate = true
                            didChooseWrongAnswer = false
                        } else {
                            didChooseWrongAnswer = true
                            challenge = BirdParentChallenge.make()
                        }
                    } label: {
                        Text("\(choice)")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                Color(hex: 0x3A8B68),
                                in: RoundedRectangle(cornerRadius: 14)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }

            if didChooseWrongAnswer {
                Text("答えが違います。別の問題をお試しください。")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.red)
            }

            Spacer()
        }
    }

    private var purchaseDetails: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: purchaseManager.isProUnlocked ? "checkmark.seal.fill" : "bird.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(Color(hex: 0xE78B3C))

                Text("ことりサウンドをすべて楽しむ")
                    .font(.system(size: 23, weight: .black, design: .rounded))
                    .foregroundStyle(Color(hex: 0x214C3D))
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 12) {
                    Label("全種類の鳥の鳴き声を聴けます", systemImage: "speaker.wave.2.fill")
                    Label("複数の鳴き声もすべて再生できます", systemImage: "square.grid.2x2.fill")
                    Label("鳴き声クイズを無制限で遊べます", systemImage: "infinity")
                }
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: 0x294E42))
                .frame(maxWidth: .infinity, alignment: .leading)

                if purchaseManager.isProUnlocked {
                    Label("購入済みです。すべて解放されています。", systemImage: "checkmark.seal.fill")
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundStyle(Color(hex: 0x277552))
                } else {
                    Text("買い切り \(purchaseManager.displayPrice)・追加料金なし")
                        .font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundStyle(Color(hex: 0x277552))

                    Button {
                        Task {
                            await purchaseManager.purchase()
                        }
                    } label: {
                        Group {
                            if purchaseManager.isWorking {
                                ProgressView().tint(.white)
                            } else {
                                Text("\(purchaseManager.displayPrice)で購入")
                            }
                        }
                        .font(.system(size: 21, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(
                            Color(hex: 0xE4773C),
                            in: RoundedRectangle(cornerRadius: 18)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(purchaseManager.isWorking)

                    Button("購入を復元") {
                        Task {
                            await purchaseManager.restore()
                        }
                    }
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .disabled(purchaseManager.isWorking)

                    if let errorMessage = purchaseManager.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: 0xA65B28))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 24)
        }
    }
}

private struct BirdParentChallenge {
    let firstNumber: Int
    let secondNumber: Int
    let choices: [Int]

    var answer: Int {
        firstNumber + secondNumber
    }

    static func make() -> BirdParentChallenge {
        let firstNumber = Int.random(in: 14...27)
        let secondNumber = Int.random(in: 6...14)
        let answer = firstNumber + secondNumber
        let wrongAnswers = [-4, -2, 2, 5].shuffled()
            .prefix(2)
            .map { answer + $0 }
        return BirdParentChallenge(
            firstNumber: firstNumber,
            secondNumber: secondNumber,
            choices: ([answer] + wrongAnswers).shuffled()
        )
    }
}
