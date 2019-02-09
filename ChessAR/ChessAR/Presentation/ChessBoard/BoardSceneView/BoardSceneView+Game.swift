
//
//  BoardSceneView+Game.swift
//  ChessAR
//
//  Created by Adem Atalay on 4.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import Foundation
import ChessEngine.Swift

extension BoardSceneView: ChessGameDelegate {
    func gameOver(engine: ChessEngineProtocol, winner: PieceColor, staleMate: Bool, pointDiff: Int) {
        let sound = winner == PieceColor.White ? SoundType.win : SoundType.lose
        audioManager?.playSound(sound)
    }
    
    func moveReceived(engine: ChessEngineProtocol, move: ChessMove) {
        guard let piece = pieces[move.from] else { return }
        var sound = SoundType.pieceMove
        if let toPiece = pieces[move.to] {
            toPiece.removeFromParentNode()
            pieces[move.to] = nil
            sound = SoundType.takePiece
        }
        piece.boardPosition = move.to
        pieces[move.to] = piece
        pieces[move.from] = nil
        
        audioManager?.playSound(sound)
    }
    
    func shouldPerformMove(engine: ChessEngineProtocol, move: String) -> Bool {
        return true
    }
    
    // MARK: not needed now
    func playerIsReadyToBegin(engine: ChessEngineProtocol) { }
    func startNewGame(engine: ChessEngineProtocol) { }
    func validMovesReceived(engine: ChessEngineProtocol, validMoves: [Any]) { }
}
