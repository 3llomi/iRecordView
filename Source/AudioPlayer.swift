//
//  AudioPlayer.swift
//  iRecordView
//
//  Created by Devlomi on 8/19/19.
//  Copyright © 2019 Devlomi. All rights reserved.
//

import AVKit


enum AudioPlayerSounds {
    case start, end, error
}

 class AudioPlayer {

    private var player: AVAudioPlayer!

    init() {
        player = AVAudioPlayer()
    }

    public func playAudioFile(soundType: AudioPlayerSounds) {

        
        let path = Bundle(for: RecordView.self).path(forResource: getPathByType(soundType: soundType), ofType: "wav")!
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()

        } catch {

            print("could not play audio file!")

        }

    }

    private func getPathByType(soundType: AudioPlayerSounds) -> String {
        switch soundType {
        case .start:
            return "record_start"
        case .end:
            return "record_finished"
        case .error:
            return "record_error"


        }
    }

}
