import SwiftUI

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()

    let bookOptions = ["book1.mp3", "book2.mp3", "book3.mp3", "book4.mp3", "book5.mp3", "book6.mp3", "book7.mp3", "book8.mp3"]
    let musicOptions = ["music1.mp3", "music2.mp3", "music3.mp3", "music4.mp3", "music5.mp3", "music6.mp3", "music7.mp3", "music8.mp3"]

    @State private var selectedBook = "book1.mp3"
    @State private var selectedMusic = "music1.mp3"

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("Simulisten")
                        .font(.largeTitle.bold())
                    Text("Advanced Book & Music Player")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)

                BookControlsView(
                    audioManager: audioManager,
                    selectedBook: $selectedBook,
                    bookOptions: bookOptions
                )

                MusicControlsView(
                    audioManager: audioManager,
                    selectedMusic: $selectedMusic,
                    musicOptions: musicOptions
                )
            }
            .padding()
            .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            audioManager.loadBook(named: selectedBook)
            audioManager.loadMusic(named: selectedMusic)
        }
        .onChange(of: selectedBook) { _, newValue in
            audioManager.loadBook(named: newValue)
        }
        .onChange(of: selectedMusic) { _, newValue in
            audioManager.loadMusic(named: newValue)
        }
    }
}
