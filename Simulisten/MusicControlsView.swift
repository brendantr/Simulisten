//
//  MusicControlsView.swift
//  Simulisten
//
//  Created by Brendan Rodriguez on 11/25/25.
//

import SwiftUI

struct MusicControlsView: View {
    @ObservedObject var audioManager: AudioManager
    @Binding var selectedMusic: String
    let musicOptions: [String]

    var body: some View {
        PlayerControlsView(
            title: "Music Controls",
            systemImage: "music.note",
            options: musicOptions,
            selected: $selectedMusic,
            playAction: audioManager.playMusic,
            pauseAction: audioManager.pauseMusic,
            stopAction: audioManager.stopMusic,
            currentTime: $audioManager.musicCurrentTime,
            duration: audioManager.musicDuration,
            seekAction: audioManager.seekMusic(to:),
            volume: $audioManager.musicVolume,
            setVolumeAction: audioManager.setMusicVolume(_:),
            accentColor: .orange,
            timeAccentColor: .purple
        )
    }
}
