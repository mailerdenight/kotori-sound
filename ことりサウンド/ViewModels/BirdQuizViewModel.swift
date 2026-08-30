import Foundation

@MainActor
final class BirdQuizViewModel: ObservableObject {
    struct Feedback: Equatable {
        let selectedID: BirdSoundItem.ID
        let isCorrect: Bool
    }

    @Published private(set) var currentQuestion: BirdAudioClip?
    @Published private(set) var choices: [BirdSoundItem] = []
    @Published private(set) var feedback: Feedback?
    @Published private(set) var questionNumber = 0
    @Published private(set) var isFinished = false
    @Published private(set) var isFullVersion: Bool

    private let allClips: [BirdAudioClip]
    private let allBirds: [BirdSoundItem]
    private let audioPlayer = BirdAudioPlayer()
    private var questionOrder: [BirdAudioClip] = []
    private var transitionTask: Task<Void, Never>?

    var totalQuestions: Int {
        isFullVersion ? 5 : 3
    }

    init(
        clips: [BirdAudioClip],
        availableBirds: [BirdSoundItem],
        isFullVersion: Bool
    ) {
        self.allClips = clips
        self.allBirds = availableBirds
        self.isFullVersion = isFullVersion
    }

    deinit {
        transitionTask?.cancel()
    }

    func start() {
        guard currentQuestion == nil else { return }
        startNewRound()
    }

    func startFullVersion() {
        guard !isFullVersion else { return }
        isFullVersion = true
        startNewRound()
    }

    func restart() {
        startNewRound()
    }

    func resume() {
        guard !isFinished else { return }
        feedback = nil
        if currentQuestion == nil {
            advanceOrFinish()
        } else {
            replayQuestion()
        }
    }

    func replayQuestion() {
        guard feedback == nil, let currentQuestion else { return }
        audioPlayer.stopAll()
        audioPlayer.play(currentQuestion)
    }

    func choose(_ bird: BirdSoundItem) {
        guard feedback == nil, let currentQuestion, !isFinished else { return }

        audioPlayer.stopAll()
        let isCorrect = bird.id == currentQuestion.birdID
        feedback = Feedback(selectedID: bird.id, isCorrect: isCorrect)

        if isCorrect {
            let effectDuration = audioPlayer.playEffect(named: "正解.mp3")
            scheduleTransition(after: max(effectDuration + 0.10, 1.15)) { [weak self] in
                self?.advanceOrFinish()
            }
        } else {
            let effectDuration = audioPlayer.playEffect(named: "不正解.mp3")
            scheduleTransition(after: max(effectDuration + 0.10, 0.95)) { [weak self] in
                guard let self else { return }
                self.feedback = nil
                self.replayQuestion()
            }
        }
    }

    func stop() {
        transitionTask?.cancel()
        transitionTask = nil
        audioPlayer.stopAll()
    }

    private func startNewRound() {
        transitionTask?.cancel()
        audioPlayer.stopAll()
        questionOrder = Array(activeClips.shuffled().prefix(totalQuestions))
        currentQuestion = nil
        choices = []
        feedback = nil
        questionNumber = 0
        isFinished = false
        advanceOrFinish()
    }

    private func advanceOrFinish() {
        feedback = nil

        guard questionNumber < totalQuestions,
              questionNumber < questionOrder.count else {
            currentQuestion = nil
            choices = []
            isFinished = true
            return
        }

        let question = questionOrder[questionNumber]
        currentQuestion = question
        let distractors = activeBirds
            .filter { $0.id != question.birdID }
            .shuffled()
            .prefix(2)
        choices = ([question.bird] + distractors).shuffled()
        questionNumber += 1

        scheduleTransition(after: 0.35) { [weak self] in
            self?.replayQuestion()
        }
    }

    private var activeClips: [BirdAudioClip] {
        isFullVersion
            ? allClips
            : allClips.filter { !$0.bird.isPremiumAudio }
    }

    private var activeBirds: [BirdSoundItem] {
        isFullVersion
            ? allBirds
            : allBirds.filter { !$0.isPremiumAudio }
    }

    private func scheduleTransition(
        after seconds: TimeInterval,
        action: @escaping @MainActor () -> Void
    ) {
        transitionTask?.cancel()
        transitionTask = Task {
            let nanoseconds = UInt64(max(seconds, 0.05) * 1_000_000_000)
            try? await Task.sleep(nanoseconds: nanoseconds)
            guard !Task.isCancelled else { return }
            action()
        }
    }
}
