import AVFoundation
import Foundation

func decibels(_ value: Double) -> Double {
    20 * log10(max(value, 0.000_000_1))
}

func percentile(_ sorted: [Double], _ fraction: Double) -> Double {
    guard !sorted.isEmpty else { return -160 }
    let index = min(sorted.count - 1, max(0, Int(Double(sorted.count - 1) * fraction)))
    return sorted[index]
}

for path in CommandLine.arguments.dropFirst() {
    let url = URL(fileURLWithPath: path)

    do {
        let file = try AVAudioFile(forReading: url)
        let format = file.processingFormat
        let binFrames = AVAudioFrameCount(format.sampleRate * 0.1)
        var rmsLevels: [Double] = []
        var peak = 0.0
        var clippedSamples = 0
        var totalSamples = 0

        while file.framePosition < file.length {
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: binFrames) else {
                break
            }
            try file.read(into: buffer, frameCount: binFrames)
            let frameCount = Int(buffer.frameLength)
            guard frameCount > 0, let channels = buffer.floatChannelData else { break }

            var sumSquares = 0.0
            for channel in 0 ..< Int(format.channelCount) {
                for frame in 0 ..< frameCount {
                    let value = abs(Double(channels[channel][frame]))
                    sumSquares += value * value
                    peak = max(peak, value)
                    if value >= 0.999 {
                        clippedSamples += 1
                    }
                    totalSamples += 1
                }
            }

            rmsLevels.append(decibels(sqrt(sumSquares / Double(frameCount * Int(format.channelCount)))))
        }

        let sorted = rmsLevels.sorted()
        let low = percentile(sorted, 0.1)
        let median = percentile(sorted, 0.5)
        let high = percentile(sorted, 0.9)
        let clippingPercent = totalSamples > 0
            ? Double(clippedSamples) / Double(totalSamples) * 100
            : 0

        print(
            String(
                format: "%@ | %.1fs | peak %.1f dBFS | RMS p10 %.1f / p50 %.1f / p90 %.1f dBFS | contrast %.1f dB | clipped %.4f%%",
                url.lastPathComponent,
                Double(file.length) / format.sampleRate,
                decibels(peak),
                low,
                median,
                high,
                high - low,
                clippingPercent
            )
        )
    } catch {
        print("\(url.lastPathComponent) | ERROR: \(error.localizedDescription)")
    }
}
