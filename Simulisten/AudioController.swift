import Foundation
import AVFoundation

class AudioController: ObservableObject {
    @Published var player: AVAudioPlayer?
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 1
    @Published var volume: Float = 1.0
    
    private var timer: Timer?

    func load(named name: String) {
        stop()
        if let url = Bundle.main.url(forResource: name.replacingOccurrences(of: ".mp3", with: ""), withExtension: "mp3") {
            player = try? AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            duration = player?.duration ?? 1
            player?.volume = volume
            currentTime = 0
        }
    }

    func play() {
        player?.play()
        startTimer()
    }
    func pause() {
        player?.pause()
        stopTimer()
    }
    func stop() {
        player?.stop()
        player?.currentTime = 0
        currentTime = 0
        stopTimer()
    }
    func setVolume(_ volume: Float) {
        player?.volume = volume
        self.volume = volume
    }
    func seek(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
    }
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentTime = self.player?.currentTime ?? 0
        }
    }
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
