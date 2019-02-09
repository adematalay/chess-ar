//
//  ChessGameDelegate.swift
//  ChessAR
//
//  Created by Adem Atalay on 3.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import Foundation

public protocol ChessGameDelegate {
    func gameOver(engine: ChessEngineProtocol, winner: PieceColor, staleMate: Bool, pointDiff: Int)
    func playerIsReadyToBegin(engine: ChessEngineProtocol)
    func startNewGame(engine: ChessEngineProtocol)

    func validMovesReceived(engine: ChessEngineProtocol, validMoves: [Any])
    func moveReceived(engine: ChessEngineProtocol, move: ChessMove)
    func shouldPerformMove(engine: ChessEngineProtocol, move: String) -> Bool
}
