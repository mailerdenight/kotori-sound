import AVFoundation

@MainActor
final class BirdAudioPlayer: NSObject, ObservableObject {
    @Published private(set) var isPlaying = false
    @Published private(set) var playingClipID: BirdAudioClip.ID?
    @Published private(set) var errorMessage: String?

    private var player: AVAudioPlayer?
    private var effectPlayers: [String: AVAudioPlayer] = [:]

    func toggle(_ clip: BirdAudioClip) {
        if playingClipID == clip.id {
            stop()
        } else {
            play(clip)
        }
    }

    func play(_ clip: BirdAudioClip) {
        stop()
        errorMessage = nil

        guard let url = audioURL(for: clip) else {
            errorMessage = "音源を読み込めませんでした。"
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            player.play()
            self.player = player
            playingClipID = clip.id
            isPlaying = true
        } catch {
            errorMessage = "音源を再生できませんでした。"
        }
    }

    func stop() {
        player?.stop()
        player = nil
        playingClipID = nil
        isPlaying = false
    }

    @discardableResult
    func playEffect(named fileName: String) -> TimeInterval {
        let effectPlayer: AVAudioPlayer
        if let existingPlayer = effectPlayers[fileName] {
            effectPlayer = existingPlayer
        } else {
            guard let url = audioURL(for: fileName),
                  let loadedPlayer = try? AVAudioPlayer(contentsOf: url) else {
                return 0
            }
            loadedPlayer.prepareToPlay()
            effectPlayers[fileName] = loadedPlayer
            effectPlayer = loadedPlayer
        }

        effectPlayer.stop()
        effectPlayer.numberOfLoops = 0
        effectPlayer.currentTime = 0
        return effectPlayer.play() ? effectPlayer.duration : 0
    }

    func stopAll() {
        stop()
        for effectPlayer in effectPlayers.values {
            effectPlayer.stop()
        }
    }

    private func audioURL(for clip: BirdAudioClip) -> URL? {
        audioURL(for: clip.fileName)
    }

    private func audioURL(for fileName: String) -> URL? {
        if let url = Bundle.main.url(
            forResource: fileName,
            withExtension: nil,
            subdirectory: "BirdAudio"
        ) {
            return url
        }

        let normalizedName = fileName.precomposedStringWithCanonicalMapping
        return Bundle.main
            .urls(forResourcesWithExtension: nil, subdirectory: "BirdAudio")?
            .first {
                $0.lastPathComponent.precomposedStringWithCanonicalMapping == normalizedName
            }
    }
}

extension BirdAudioPlayer: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            self.isPlaying = false
            self.playingClipID = nil
        }
    }
}
