//
//  AudioProtocol.swift
//  ChessAR
//
//  Created by Adem Atalay on 3.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import Foundation

enum SoundType: String {
    case check = "check"
    case takePiece = "piecetake"
    case promoe = "promotion"
    case illegal = "illegal"
    case lose = "lose"
    case win = "win"
    case pieceMove = "piecemove"
    case IMReceived = "incomingim"
    case IMSent = "outgoingim"
}

protocol AudioServiceProtocol {
    func playSound(_ type: SoundType)
}

