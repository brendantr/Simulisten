//
//  BookControlsView.swift
//  Simulisten
//
//  Created by Brendan Rodriguez on 11/25/25.
//

import SwiftUI

struct BookControlsView: View {
    @ObservedObject var audioManager: AudioManager
    @Binding var selectedBook: String
    let bookOptions: [String]

    var body: some View {
        PlayerControlsView(
            title: "Learning Controls",
            systemImage: "book.closed",
            options: bookOptions,
            selected: $selectedBook,
            playAction: audioManager.playBook,
            pauseAction: audioManager.pauseBook,
            stopAction: audioManager.stopBook,
            currentTime: $audioManager.bookCurrentTime,
            duration: audioManager.bookDuration,
            seekAction: audioManager.seekBook(to:),
            volume: $audioManager.bookVolume,
            setVolumeAction: audioManager.setBookVolume(_:),
            accentColor: .green,
            timeAccentColor: .blue
        )
    }
}
