# Simulisten

**Simulisten** is a SwiftUI iOS application for playing simultaneous book and music audio tracks, with per-track selection and independent controls. Users can choose between multiple books or music tracks for a personalized listening experience.

---

## Features

- Select from multiple book and music audio tracks using dropdown menus
- Play, pause, and stop controls for both book and music audio streams
- Individual volume and progress (scrub) controls for each track
- Clean, accessible SwiftUI user interface
- Easily extensible: add more audio tracks simply by placing files in the project and updating the options lists

---

## Screenshots

<!-- Add screenshots to the repository and then reference them here.  
Example:  
![Simulisten Main Screen](screenshots/main.png)
-->

---

## Getting Started

### Prerequisites

- Xcode 15 or newer
- iOS 17.0+ (built with SwiftUI latest best practices)
- Swift 5.9+

### Installation

1. Clone the repository:

    ```
    git clone https://github.com/yourusername/simulisten.git
    cd simulisten
    ```

2. Open `Simulisten.xcodeproj` in Xcode.

3. Build and run on the Simulator or a real device.

4. To add additional audio tracks, drag new `.mp3` files into the designated assets or project folder, and update the `bookOptions` and `musicOptions` arrays in `ContentView.swift`.

---

## Usage

1. Choose a book and music track from the dropdown menus.
2. Use dedicated Play, Pause, and Stop buttons for each audio stream.
3. Adjust volume and time sliders independently for book and music.

---

## Project Structure

- `ContentView.swift` – The main SwiftUI view and core UI logic
- `AudioManager.swift` (or within ContentView if not split) – Handles audio playback logic
- `Assets/` – Contains bundled audio files (e.g., `book1.mp3`, `book2.mp3`, `music1.mp3`, `music2.mp3`)
- `README.md` – This documentation file

---

## Contributing

Contributions, improvements, and bug reports are welcome!  
To propose changes:

1. Fork the repository
2. Create a new feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -am 'Describe your feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Create a Pull Request

---

## License

[MIT License](LICENSE)

---

## Author

- [Brendan Rodriguez] –

---

## Acknowledgments

- Inspired by usability and accessibility best practices in iOS app development
- Built using SwiftUI and AVFoundation


