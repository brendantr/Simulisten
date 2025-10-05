import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()
    
    // Track options
    let bookOptions = ["book1.mp3", "book2.mp3", "book3.mp3", "book4.mp3"]
    let musicOptions = ["music1.mp3", "music2.mp3", "music3.mp3", "music4.mp3"]
    
    // Selection State
    @State private var selectedBook = "book1.mp3"
    @State private var selectedMusic = "music1.mp3"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 8) {
                    Text("Audio Suite")
                        .font(.largeTitle.bold())
                    Text("Advanced Book & Music Player")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)

                // Book Controls
                GroupBox(label: Label("Book Controls", systemImage: "book.closed")
                    .font(.headline)) {
                    VStack(spacing: 16) {
                        Picker("Book", selection: $selectedBook) {
                            ForEach(bookOptions, id: \.self) { book in
                                Text(book.replacingOccurrences(of: ".mp3", with: "").capitalized)
                                    .tag(book)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedBook) { _, newBook in
                            audioManager.loadBook(named: newBook)
                        }

                        HStack(spacing: 24) {
                            Button {
                                audioManager.playBook()
                            } label: {
                                Label("Play", systemImage: "play.fill")
                            }
                            .buttonStyle(.borderedProminent)

                            Button {
                                audioManager.pauseBook()
                            } label: {
                                Label("Pause", systemImage: "pause.fill")
                            }
                            .buttonStyle(.bordered)

                            Button {
                                audioManager.stopBook()
                            } label: {
                                Label("Stop", systemImage: "stop.fill")
                            }
                            .buttonStyle(.bordered)
                        }

                        VStack(spacing: 10) {
                            Slider(
                                value: $audioManager.bookCurrentTime,
                                in: 0...audioManager.bookDuration,
                                onEditingChanged: { editing in
                                    if !editing {
                                        audioManager.seekBook(to: audioManager.bookCurrentTime)
                                    }
                                }
                            )
                            .accentColor(.blue)
                            Text(String(format: "%.1fs / %.1fs", audioManager.bookCurrentTime, audioManager.bookDuration))
                                .font(.caption)
                        }

                        VStack(spacing: 10) {
                            Slider(
                                value: $audioManager.bookVolume,
                                in: 0...1,
                                onEditingChanged: { _ in
                                    audioManager.setBookVolume(audioManager.bookVolume)
                                }
                            )
                            .accentColor(.green)
                            Text(String(format: "Volume: %.2f", audioManager.bookVolume))
                                .font(.caption2)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.18), radius: 12, x: 0, y: 4)

                // Music Controls
                GroupBox(label: Label("Music Controls", systemImage: "music.note")
                    .font(.headline)) {
                    VStack(spacing: 16) {
                        Picker("Music", selection: $selectedMusic) {
                            ForEach(musicOptions, id: \.self) { music in
                                Text(music.replacingOccurrences(of: ".mp3", with: "").capitalized)
                                    .tag(music)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedMusic) { _, newMusic in
                            audioManager.loadMusic(named: newMusic)
                        }

                        HStack(spacing: 24) {
                            Button {
                                audioManager.playMusic()
                            } label: {
                                Label("Play", systemImage: "play.fill")
                            }
                            .buttonStyle(.borderedProminent)

                            Button {
                                audioManager.pauseMusic()
                            } label: {
                                Label("Pause", systemImage: "pause.fill")
                            }
                            .buttonStyle(.bordered)

                            Button {
                                audioManager.stopMusic()
                            } label: {
                                Label("Stop", systemImage: "stop.fill")
                            }
                            .buttonStyle(.bordered)
                        }

                        VStack(spacing: 10) {
                            Slider(
                                value: $audioManager.musicCurrentTime,
                                in: 0...audioManager.musicDuration,
                                onEditingChanged: { editing in
                                    if !editing {
                                        audioManager.seekMusic(to: audioManager.musicCurrentTime)
                                    }
                                }
                            )
                            .accentColor(.purple)
                            Text(String(format: "%.1fs / %.1fs", audioManager.musicCurrentTime, audioManager.musicDuration))
                                .font(.caption)
                        }

                        VStack(spacing: 10) {
                            Slider(
                                value: $audioManager.musicVolume,
                                in: 0...1,
                                onEditingChanged: { _ in
                                    audioManager.setMusicVolume(audioManager.musicVolume)
                                }
                            )
                            .accentColor(.orange)
                            Text(String(format: "Volume: %.2f", audioManager.musicVolume))
                                .font(.caption2)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.18), radius: 12, x: 0, y: 4)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            audioManager.loadBook(named: selectedBook)
            audioManager.loadMusic(named: selectedMusic)
        }
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

    // Load Book by name
    func loadBook(named name: String) {
        stopBook()
        if let url = Bundle.main.url(
            forResource: name.replacingOccurrences(of: ".mp3", with: ""), withExtension: "mp3") {
            bookPlayer = try? AVAudioPlayer(contentsOf: url)
            bookPlayer?.prepareToPlay()
            bookDuration = bookPlayer?.duration ?? 1
            bookPlayer?.volume = bookVolume
            bookCurrentTime = 0
        }
    }

    // Load Music by name
    func loadMusic(named name: String) {
        stopMusic()
        if let url = Bundle.main.url(
            forResource: name.replacingOccurrences(of: ".mp3", with: ""), withExtension: "mp3") {
            musicPlayer = try? AVAudioPlayer(contentsOf: url)
            musicPlayer?.prepareToPlay()
            musicDuration = musicPlayer?.duration ?? 1
            musicPlayer?.volume = musicVolume
            musicCurrentTime = 0
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
