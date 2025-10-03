import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()

    var body: some View {
        VStack(spacing: 40) {
            // Book Controls
            VStack(spacing: 20) {
                Text("Book Controls")
                    .font(.headline)

                HStack {
                    Button("Play") { audioManager.playBook() }
                    Button("Pause") { audioManager.pauseBook() }
                    Button("Stop") { audioManager.stopBook() }
                }
                .buttonStyle(.bordered)

                Slider(
                    value: $audioManager.bookCurrentTime,
                    in: 0...audioManager.bookDuration,
                    onEditingChanged: { editing in
                        if !editing {
                            audioManager.seekBook(to: audioManager.bookCurrentTime)
                        }
                    }
                )
                Text(String(format: "%.1fs / %.1fs", audioManager.bookCurrentTime, audioManager.bookDuration))

                Slider(
                    value: $audioManager.bookVolume,
                    in: 0...1,
                    onEditingChanged: { _ in
                        audioManager.setBookVolume(audioManager.bookVolume)
                    }
                )
                Text(String(format: "Volume: %.2f", audioManager.bookVolume))
            }

            // Music Controls
            VStack(spacing: 20) {
                Text("Music Controls")
                    .font(.headline)

                HStack {
                    Button("Play") { audioManager.playMusic() }
                    Button("Pause") { audioManager.pauseMusic() }
                    Button("Stop") { audioManager.stopMusic() }
                }
                .buttonStyle(.bordered)

                Slider(
                    value: $audioManager.musicCurrentTime,
                    in: 0...audioManager.musicDuration,
                    onEditingChanged: { editing in
                        if !editing {
                            audioManager.seekMusic(to: audioManager.musicCurrentTime)
                        }
                    }
                )
                Text(String(format: "%.1fs / %.1fs", audioManager.musicCurrentTime, audioManager.musicDuration))

                Slider(
                    value: $audioManager.musicVolume,
                    in: 0...1,
                    onEditingChanged: { _ in
                        audioManager.setMusicVolume(audioManager.musicVolume)
                    }
                )
                Text(String(format: "Volume: %.2f", audioManager.musicVolume))
            }
        }
        .padding()
    }
}

class AudioManager: ObservableObject {
    @Published var bookPlayer: AVAudioPlayer?
    @Published var musicPlayer: AVAudioPlayer?
    @Published var bookCurrentTime: TimeInterval = 0
    @Published var bookDuration: TimeInterval = 1
    @Published var musicCurrentTime: TimeInterval = 0
    @Published var musicDuration: TimeInterval = 1
    @Published var bookVolume: Float = 1.0
    @Published var musicVolume: Float = 1.0

    var bookTimer: Timer?
    var musicTimer: Timer?

    init() {
        if let url1 = Bundle.main.url(forResource: "book", withExtension: "mp3") {
            bookPlayer = try? AVAudioPlayer(contentsOf: url1)
            bookPlayer?.prepareToPlay()
            bookDuration = bookPlayer?.duration ?? 1
            bookPlayer?.volume = bookVolume
        }
        if let url2 = Bundle.main.url(forResource: "music", withExtension: "mp3") {
            musicPlayer = try? AVAudioPlayer(contentsOf: url2)
            musicPlayer?.prepareToPlay()
            musicDuration = musicPlayer?.duration ?? 1
            musicPlayer?.volume = musicVolume
        }
    }

    // Book Controls
    func playBook() {
        bookPlayer?.play()
        startBookTimer()
    }
    func pauseBook() {
        bookPlayer?.pause()
        stopBookTimer()
    }
    func stopBook() {
        bookPlayer?.stop()
        bookPlayer?.currentTime = 0
        bookCurrentTime = 0
        stopBookTimer()
    }
    func setBookVolume(_ volume: Float) {
        bookPlayer?.volume = volume
        bookVolume = volume
    }
    func seekBook(to time: TimeInterval) {
        bookPlayer?.currentTime = time
        bookCurrentTime = time
    }
    private func startBookTimer() {
        stopBookTimer()
        bookTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.bookCurrentTime = self.bookPlayer?.currentTime ?? 0
        }
    }
    private func stopBookTimer() {
        bookTimer?.invalidate()
        bookTimer = nil
    }

    // Music Controls
    func playMusic() {
        musicPlayer?.play()
        startMusicTimer()
    }
    func pauseMusic() {
        musicPlayer?.pause()
        stopMusicTimer()
    }
    func stopMusic() {
        musicPlayer?.stop()
        musicPlayer?.currentTime = 0
        musicCurrentTime = 0
        stopMusicTimer()
    }
    func setMusicVolume(_ volume: Float) {
        musicPlayer?.volume = volume
        musicVolume = volume
    }
    func seekMusic(to time: TimeInterval) {
        musicPlayer?.currentTime = time
        musicCurrentTime = time
    }
    private func startMusicTimer() {
        stopMusicTimer()
        musicTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.musicCurrentTime = self.musicPlayer?.currentTime ?? 0
        }
    }
    private func stopMusicTimer() {
        musicTimer?.invalidate()
        musicTimer = nil
    }
}
