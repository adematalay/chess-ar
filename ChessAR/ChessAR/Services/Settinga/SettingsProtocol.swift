//
//  SettingsProtocol.swift
//  ChessAR
//
//  Created by Adem Atalay on 3.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import Foundation

enum SettingKey: String {
    case screenLock = "screenLock"
    case sounds = "enableSounds"
    case chats = "enableChats"
    case difficulty = "gameDifficulty"
    case pieceTheme = "pieceTheme"
}

protocol SettingsProtocol {
    func storeSettings(value: Any, key: SettingKey)
    func settings(for key: SettingKey) -> String?
}
