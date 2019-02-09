//
//  SettingsService.swift
//  ChessAR
//
//  Created by Adem Atalay on 3.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import Foundation

class SettingsService: SettingsProtocol {
    private let settingsFile: URL?
    
    init() {
        let workingDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        settingsFile = workingDirectory?.appendingPathComponent("settings.plist")
        checkSettings()
    }
    
    func storeSettings(value: Any, key: SettingKey) {
        guard let file = settingsFile, let settings = NSMutableDictionary(contentsOf: file) else { return }
        settings.setObject(value, forKey: key.rawValue as NSString)
        try? settings.write(to: file)
    }
    
    func settings(for key: SettingKey) -> String? {
        guard let file = settingsFile, let settings = NSMutableDictionary(contentsOf: file) else { return nil }
        if let val = settings.object(forKey: key.rawValue) {
            return "\(val)"
        }
        return ""
    }
    
    private func checkSettings() {
        guard let file = settingsFile else { return }
        if let _ = NSMutableDictionary(contentsOf: file) { return }
        
        let settings = NSMutableDictionary()
        settings.setObject(false, forKey: SettingKey.screenLock.rawValue as NSString)
        settings.setObject(true, forKey: SettingKey.sounds.rawValue as NSString)
        settings.setObject(true, forKey: SettingKey.chats.rawValue as NSString)
        try? settings.write(to: file)
    }
}
