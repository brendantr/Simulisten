import Foundation
import AVFoundation
import Combine

@MainActor
final class AudioManager: ObservableObject {

    @Published var bookCurrentTime: TimeInterval = 0
    @Published var musicCurrentTime: TimeInterval = 0

    @Published var bookVolume: Float = 1.0 {
        didSet { setBookVolume(bookVolume) }
    }
    @Published var musicVolume: Float = 1.0 {
        didSet { setMusicVolume(musicVolume) }
    }

    private(set) var bookDuration: TimeInterval = 0
    private(set) var musicDuration: TimeInterval = 0

    // Keep same property names accessible to views
    var bookDurationPublic: TimeInterval { bookDuration }
    var musicDurationPublic: TimeInterval { musicDuration }

    private var bookPlayer: AVAudioPlayer?
    private var musicPlayer: AVAudioPlayer?

    private var timer: Timer?

    init() {
        startTimer()
    }

    deinit {
        timer?.invalidate()
    }

    func loadBook(named name: String) {
        bookPlayer = loadPlayer(named: name)
        bookPlayer?.volume = bookVolume
        bookDuration = bookPlayer?.duration ?? 0
        bookCurrentTime = 0
        objectWillChange.send()
    }

    func loadMusic(named name: String) {
        musicPlayer = loadPlayer(named: name)
        musicPlayer?.volume = musicVolume
        musicDuration = musicPlayer?.duration ?? 0
        musicCurrentTime = 0
        objectWillChange.send()
    }

    private func loadPlayer(named name: String) -> AVAudioPlayer? {
        let components = name.split(separator: ".")
        guard components.count >= 2,
              let url = Bundle.main.url(forResource: components.dropLast().joined(separator: "."),
                                        withExtension: String(components.last!)) else {
            print("AudioManager: Failed to find resource \(name) in bundle.")
            return nil
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            return player
        } catch {
            print("AudioManager: Failed to init AVAudioPlayer for \(name): \(error)")
            return nil
        }
    }

    func playBook() { bookPlayer?.play() }
    func pauseBook() { bookPlayer?.pause() }
    func stopBook() {
        bookPlayer?.stop()
        bookPlayer?.currentTime = 0
        bookCurrentTime = 0
    }
    func seekBook(to time: TimeInterval) {
        guard let player = bookPlayer else { return }
        player.currentTime = max(0, min(time, player.duration))
        bookCurrentTime = player.currentTime
    }
    func setBookVolume(_ volume: Float) {
        bookPlayer?.volume = max(0, min(volume, 1))
    }

    func playMusic() { musicPlayer?.play() }
    func pauseMusic() { musicPlayer?.pause() }
    func stopMusic() {
        musicPlayer?.stop()
        musicPlayer?.currentTime = 0
        musicCurrentTime = 0
    }
    func seekMusic(to time: TimeInterval) {
        guard let player = musicPlayer else { return }
        player.currentTime = max(0, min(time, player.duration))
        musicCurrentTime = player.currentTime
    }
    func setMusicVolume(_ volume: Float) {
        musicPlayer?.volume = max(0, min(volume, 1))
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                if let bp = self.bookPlayer {
                    self.bookCurrentTime = bp.currentTime
                    self.bookDuration = bp.duration
                }
                if let mp = self.musicPlayer {
                    self.musicCurrentTime = mp.currentTime
                    self.musicDuration = mp.duration
                }
            }
        }
        if let timer { RunLoop.main.add(timer, forMode: .common) }
    }
}
