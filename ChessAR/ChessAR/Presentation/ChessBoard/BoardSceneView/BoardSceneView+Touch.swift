//
//  BoardSceneView+Touch.swift
//  ChessAR
//
//  Created by Adem Atalay on 4.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import SceneKit
import ChessEngine.StockFish

extension BoardSceneView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if StockFish.isWhitesTurn == false {
            selectPiece(nil, selectedPlaces: [])
            selectedPiece = nil
            selectedPiecePosition = nil
            return
        }
        
        if let piece = touchedPiece(touch: touches.first) {
            selectedPiece = piece
            selectedPiecePosition = piece.boardPosition
            let validPositions = engine?.validMoves(square: piece.boardPosition) ?? []
            selectPiece(piece, selectedPlaces: validPositions)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for position in BoardPosition.allCases where board[position]?.highlight != nil {
            board[position]?.highlight = .PossiblePosition
        }
        
        if let brdPiece = touchedBoardPosition(touch: touches.first), brdPiece.highlight != nil {
            brdPiece.highlight = .PieceIsOnPosition
            selectedPiece?.boardPosition = brdPiece.boardPosition
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brdPiece = touchedBoardPosition(touch: touches.first), let originalPosition = selectedPiecePosition {
            if brdPiece.highlight == nil || originalPosition == brdPiece.boardPosition {
                // put back
                print("Invalid move, putting back")
                selectedPiece?.boardPosition = originalPosition
                audioManager?.playSound(.illegal)
            } else {
                // send move
                let move = originalPosition.rawValue.lowercased() + brdPiece.boardPosition.rawValue.lowercased()
                print("Sending move: \(move)")
                engine?.sendMove(move, timeLeft: 400)
            }
        } else if let originalPosition = selectedPiecePosition {
            print("Move cannot be detected -> \(originalPosition)")
            selectedPiece?.boardPosition = originalPosition
        } else {
            print("Move cannot be detected -> nil")
        }
        
        selectPiece(nil, selectedPlaces: [])
        selectedPiece = nil
        selectedPiecePosition = nil
    }
    
    //MARK: Private methods
    private func touchedPiece(touch: UITouch?) -> PieceNode? {
        return touchedNode(touch: touch) as? PieceNode
    }
    
    private func touchedBoardPosition(touch: UITouch?) -> BoardNode? {
        return touchedNode(touch: touch) as? BoardNode
    }
    
    private func touchedNode(touch: UITouch?) -> SCNNode? {
        guard let touch = touch else { return nil }
        if(touch.view == self){
            let viewTouchLocation:CGPoint = touch.location(in: self)
            return self.hitTest(viewTouchLocation, options: nil).first?.node
        }
        return nil
    }
}
