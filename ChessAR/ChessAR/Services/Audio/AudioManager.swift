//
//  AudioManager.swift
//  ChessAR
//
//  Created by Adem Atalay on 3.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager: AudioServiceProtocol {
    private var player: AVAudioPlayer?
    private let settings: SettingsProtocol
    
    init(setting: SettingsProtocol) {
        self.settings = setting
    }
    
    func playSound(_ type: SoundType) {
        let shouldPlay = Int(self.settings.settings(for: .sounds) ?? "0")
        if shouldPlay == nil || shouldPlay == 0 { return }
        
        guard let path = Bundle.main.path(forResource: type.rawValue, ofType: "mp3") else {
            return
        }
        
        let file = URL(fileURLWithPath: path)
        player = try? AVAudioPlayer(contentsOf: file)
        player?.play()
    }
}
