//
//  Router.swift
//  ChessAR
//
//  Created by Adem Atalay on 3.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import UIKit
import ChessEngine.Swift

class AppRouter {
    var state: AppState = .start
    
    private lazy var settingsService: SettingsProtocol = {
       return SettingsService()
    }()
    
    private lazy var audioService: AudioServiceProtocol = {
        return AudioManager(setting: settingsService)
    }()
    
    private lazy var chessEngine: ChessEngine = {
        return StockFishEngine(level: .normal, fen: nil)
    }()
    
    let navigationController: MainNavigationViewController
    
    init() {
        navigationController = MainNavigationViewController(nibName: nil, bundle: nil)
        navigationController.viewControllers = [nextViewController()]
        navigationController.isNavigationBarHidden = true
    }
    
    func nextViewController() -> UIViewController {
        switch state {
        case .start:
            return StartupViewController(router: self)
        case .singlePlayer:
            return ChessViewController(router: self, engine: chessEngine, audio: audioService)
        default:
            return UIViewController()
        }
    }
    
    func presentNextViewController() {
        let next = nextViewController()
        navigationController.present(next, animated: true, completion: nil)
    }
}
