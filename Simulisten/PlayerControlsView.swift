//
//  PlayerControlsView.swift
//  Simulisten
//
//  Created by Brendan Rodriguez on 11/25/25.
//

import SwiftUI

struct PlayerControlsView: View {
    let title: String
    let systemImage: String
    let options: [String]
    @Binding var selected: String

    let playAction: () -> Void
    let pauseAction: () -> Void
    let stopAction: () -> Void

    @Binding var currentTime: TimeInterval
    let duration: TimeInterval
    let seekAction: (TimeInterval) -> Void

    @Binding var volume: Float
    let setVolumeAction: (Float) -> Void
    let accentColor: Color
    let timeAccentColor: Color

    var body: some View {
        GroupBox(label: Label(title, systemImage: systemImage).font(.headline)) {
            VStack(spacing: 16) {
                Picker(title, selection: $selected) {
                    ForEach(options, id: \.self) { item in
                        Text(item.replacingOccurrences(of: ".mp3", with: "").capitalized)
                            .tag(item)
                    }
                }
                .pickerStyle(.menu)

                HStack(spacing: 24) {
                    Button(action: playAction) {
                        Label("Play", systemImage: "play.fill")
                    }
                    .buttonStyle(.borderedProminent)

                    Button(action: pauseAction) {
                        Label("Pause", systemImage: "pause.fill")
                    }
                    .buttonStyle(.bordered)

                    Button(action: stopAction) {
                        Label("Stop", systemImage: "stop.fill")
                    }
                    .buttonStyle(.bordered)
                }

                VStack(spacing: 10) {
                    Slider(
                        value: $currentTime,
                        in: 0...duration,
                        onEditingChanged: { editing in
                            if !editing {
                                seekAction(currentTime)
                            }
                        }
                    )
                    .accentColor(timeAccentColor)

                    Text(String(format: "%.1fs / %.1fs", currentTime, duration))
                        .font(.caption)
                }

                VStack(spacing: 10) {
                    Slider(
                        value: $volume,
                        in: 0...1,
                        onEditingChanged: { _ in
                            setVolumeAction(volume)
                        }
                    )
                    .accentColor(accentColor)

                    Text(String(format: "Volume: %.2f", volume))
                        .font(.caption2)
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.18), radius: 12, x: 0, y: 4)
    }
}
