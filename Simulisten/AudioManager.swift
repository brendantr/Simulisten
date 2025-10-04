import Foundation

class AudioManager: ObservableObject {
    @Published var book = AudioController()
    @Published var music = AudioController()
}
