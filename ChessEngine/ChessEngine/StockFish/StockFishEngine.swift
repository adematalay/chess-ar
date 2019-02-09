//
//  StockFishEngine.swift
//  ChessAR
//
//  Created by Adem Atalay on 3.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import Foundation

public class StockFishEngine: NSObject {
    public var gameDelegate: ChessGameDelegate?
    private var level: EngineSkillLevel
    private var computerDepth: Int = 20
    private var history: String = ""
    private var isComputerBlack: Bool = true
    
    private var fenBoard: String
    public var fen: String {
        get {
            return fenBoard
        }
        set (newValue) {
            self.fenBoard = newValue
            history = "position fen \(newValue)"
            StockFish.executeCommand(history)
        }
    }
    
    public init(level: EngineSkillLevel, fen board: String? = nil) {
        self.fenBoard = board ?? "startpos"
        self.level = level
        super.init()
        startEngine(level: level)
    }
    
    private func startEngine(level: EngineSkillLevel) {
        if StockFish.stockFishInstance != nil {
            self.stopEngine()
        }
        
        history = "position \(fen)"
        computerDepth = level.rawValue
        StockFish.stockFishInstance = self
        StockFish.initStockFish()
        StockFish.executeCommand("setoption name Skill Level value \(computerDepth)\n")
        StockFish.executeCommand(history)
    }
}

extension StockFishEngine: ChessBoardProtocol {
    public var board: [BoardPosition : ChessPiece] {
        get {
            var brd: [BoardPosition : ChessPiece] = [:]
            for (key, val) in StockFish.board {
                if let pos = BoardPosition(rawValue: key),
                   let color = PieceColor(rawValue: val.color),
                   let type = PieceType(rawValue: val.type) {
                    brd[pos] = ChessPiece.piece(color: color, type: type)
                } else if let pos = BoardPosition(rawValue: key) {
                    brd[pos] = ChessPiece.none
                }
            }
            return brd
        }
    }
}

extension StockFishEngine: ChessEngineProtocol {
    
    public func stopEngine() {
        StockFish.executeCommand("quit")
        StockFish.stockFishInstance = nil
    }
    
    public func undoLastMove() {
        
    }
    
    public func restartGame() {
        
    }
    
    public func putBoardPieces(fen: String) {
        
    }
    
    public func validMoves(square: BoardPosition) -> [BoardPosition] {
        return StockFish.validMoves(forSquare: square.rawValue).compactMap{ BoardPosition(rawValue: $0) }
    }
}

extension StockFishEngine: StockFishMoveDelegate {
    public func sendMove(_ move: String, timeLeft time: Int) {
        if gameDelegate?.shouldPerformMove(engine: self, move: move) == false {
            print("Move is not permitted: \(move)")
            return
        }
        
        if(move.count < 4){
            print("Invalid move: \(move)")
            return;
        }
        
        print((StockFish.isWhitesTurn ? "W" : "B") +  " = move: \(move)")
        
        history.append( history.contains("moves") ? " \(move)" : " moves \(move)" )
        StockFish.executeCommand(history)
        let isWhiteTurn = StockFish.isWhitesTurn
        
        let start = move.index(move.startIndex, offsetBy: 2)
        let end = move.index(start, offsetBy: 2)
        let range = start..<end
        
        if let from = BoardPosition(rawValue: String(move.prefix(2).uppercased())), let to = BoardPosition(rawValue: String(move[range]).uppercased()) {
            let chessMove = ChessMove.init(from: from, to: to, turn: isWhiteTurn ? .White : .Black)
            self.gameDelegate?.moveReceived(engine: self, move: chessMove)
        } else {
            print("\(move) cannot be decoded")
        }
        
        let finish = StockFish.status
        if finish != GF_NONE {
            self.gameDelegate?.gameOver(engine: self,
                                        winner: isWhiteTurn ? .Black : .White,
                                        staleMate: finish == GF_STALE,
                                        pointDiff: 0)
            return;
        }
        
        if (!isWhiteTurn && isComputerBlack) || (isWhiteTurn && !isComputerBlack) {
            self.calculateMove()
        }
    }
    
    private func calculateMove() {
        if(computerDepth == 0){
            StockFish.executeCommand("go\n")
        } else{
            let commandStr = "go wtime 60000 btime 60000 winc 0 binc 0 depth \(computerDepth)"
            print("Calculate command => \(commandStr)")
            StockFish.executeCommand(commandStr)
        }
    }
}
