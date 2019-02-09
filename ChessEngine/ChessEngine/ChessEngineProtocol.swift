//
//  ChessEngineProtocol.swift
//  ChessAR
//
//  Created by Adem Atalay on 3.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import Foundation

public typealias ChessEngine = ChessEngineProtocol & ChessBoardProtocol & StockFishMoveDelegate

public enum EngineSkillLevel: Int {
    case veryWeak = 1
    case weak = 2
    case normal = 4
    case strong = 9
    case ultimate = 20
}

public protocol ChessBoardProtocol {
    var board: [BoardPosition: ChessPiece] { get }
}

public protocol ChessEngineProtocol {
    var fen: String { get set }
    var gameDelegate: ChessGameDelegate? { get set }
    
    func stopEngine()
    func undoLastMove()
    func restartGame()
    func putBoardPieces(fen: String)
    func validMoves(square: BoardPosition) -> [BoardPosition]
}
