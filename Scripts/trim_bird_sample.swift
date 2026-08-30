import AVFoundation
import Foundation

enum TrimError: Error, CustomStringConvertible {
    case usage
    case unsupportedAudioFormat
    case exportUnavailable
    case exportFailed(String)

    var description: String {
        switch self {
        case .usage:
            return "Usage: swift trim_bird_sample.swift INPUT OUTPUT DURATION_SECONDS"
        case .unsupportedAudioFormat:
            return "The input audio could not be decoded as floating-point PCM."
        case .exportUnavailable:
            return "An M4A export session could not be created."
        case let .exportFailed(message):
            return "Export failed: \(message)"
        }
    }
}

func findDenseStart(inputURL: URL, duration: Double) throws -> (start: Double, inputDuration: Double) {
    let file = try AVAudioFile(forReading: inputURL)
    let format = file.processingFormat
    let sampleRate = format.sampleRate
    let inputDuration = Double(file.length) / sampleRate
    let binDuration = 0.1
    let binFrames = AVAudioFrameCount(sampleRate * binDuration)
    var levels: [Double] = []

    while file.framePosition < file.length {
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: binFrames) else {
            throw TrimError.unsupportedAudioFormat
        }
        try file.read(into: buffer, frameCount: binFrames)

        let frameCount = Int(buffer.frameLength)
        guard frameCount > 0, let channels = buffer.floatChannelData else { break }

        var sumSquares = 0.0
        for channel in 0 ..< Int(format.channelCount) {
            for frame in 0 ..< frameCount {
                let sample = Double(channels[channel][frame])
                sumSquares += sample * sample
            }
        }

        let sampleCount = Double(frameCount * Int(format.channelCount))
        levels.append(sqrt(sumSquares / sampleCount))
    }

    guard inputDuration > duration, !levels.isEmpty else {
        return (0, inputDuration)
    }

    let windowBins = min(levels.count, max(1, Int(duration / binDuration)))
    var rolling = levels.prefix(windowBins).reduce(0, +)
    var bestScore = rolling
    var bestIndex = 0

    if levels.count > windowBins {
        for index in windowBins ..< levels.count {
            rolling += levels[index] - levels[index - windowBins]
            if rolling > bestScore {
                bestScore = rolling
                bestIndex = index - windowBins + 1
            }
        }
    }

    // Give the first call a little lead-in when there is room.
    let rawStart = Double(bestIndex) * binDuration
    let adjustedStart = min(max(0, rawStart - 0.3), inputDuration - duration)
    return (adjustedStart, inputDuration)
}

func exportSegment(inputURL: URL, outputURL: URL, start: Double, duration: Double) throws {
    let asset = AVURLAsset(url: inputURL)
    guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
        throw TrimError.exportUnavailable
    }

    try? FileManager.default.removeItem(at: outputURL)
    exporter.outputURL = outputURL
    exporter.outputFileType = .m4a
    exporter.timeRange = CMTimeRange(
        start: CMTime(seconds: start, preferredTimescale: 48_000),
        duration: CMTime(seconds: duration, preferredTimescale: 48_000)
    )

    let semaphore = DispatchSemaphore(value: 0)
    exporter.exportAsynchronously {
        semaphore.signal()
    }
    semaphore.wait()

    guard exporter.status == .completed else {
        throw TrimError.exportFailed(exporter.error?.localizedDescription ?? "unknown error")
    }
}

do {
    guard CommandLine.arguments.count == 4,
          let duration = Double(CommandLine.arguments[3]),
          duration > 0
    else {
        throw TrimError.usage
    }

    let inputURL = URL(fileURLWithPath: CommandLine.arguments[1])
    let outputURL = URL(fileURLWithPath: CommandLine.arguments[2])
    let selection = try findDenseStart(inputURL: inputURL, duration: duration)
    let exportDuration = min(duration, selection.inputDuration)

    try exportSegment(
        inputURL: inputURL,
        outputURL: outputURL,
        start: selection.start,
        duration: exportDuration
    )

    print(
        String(
            format: "Selected %.1f–%.1f seconds from %.1f-second input.",
            selection.start,
            selection.start + exportDuration,
            selection.inputDuration
        )
    )
} catch {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(1)
}
