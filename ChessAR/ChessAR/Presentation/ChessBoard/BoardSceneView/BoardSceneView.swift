//
//  BoardSceneView.swift
//  ChessAR
//
//  Created by Adem Atalay on 2.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import SceneKit
import ChessEngine.Swift
import ARKit

class BoardSceneView: ARSCNView {
    var pieces: [BoardPosition: PieceNode] = [:]
    var board: [BoardPosition: BoardNode] = [:]
    var selectedPiece: PieceNode?
    var selectedPiecePosition: BoardPosition?
    var mainNode: SCNNode?
    
    var engine: ChessEngine?
    let audioManager: AudioServiceProtocol?
    
    var fen: String {
        get {
            return self.engine?.fen ?? "startpos"
        }
        set (newValue) {
            self.engine?.fen = newValue
            if let node = mainNode {
                let position = node.position
                node.removeFromParentNode()
                placeBoard(at: position)
            }
        }
    }
    
    init(engine: ChessEngine?, audio: AudioServiceProtocol?) {
        self.engine = engine
        self.audioManager = audio
        super.init(frame: CGRect.zero, options: nil)
        self.engine?.gameDelegate = self
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Show statistics such as fps and timing information
        self.showsStatistics = true
        self.autoenablesDefaultLighting = true
        self.automaticallyUpdatesLighting = true
        
        // Set the scene to the view
        self.scene = SCNScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func placeBoard(at position: SCNVector3) {
        let node = SCNNode()
        node.position = position
        scene.rootNode.addChildNode(node)
        placeBoard(on: node)
        mainNode = node
    }
    
    func placeBoard(on node: SCNNode) {
        initializeBoard()
        refreshPieces()
        
        for position in BoardPosition.allCases {
            if let piece = pieces[position] {
                piece.boardPosition = position
                node.addChildNode(piece)
            }
            
            if let boardPiece = board[position] {
                node.addChildNode(boardPiece)
            }
        }
    }
    
    func initializeBoard() {
        board = [:]
        for position in BoardPosition.allCases {
            board[position] = BoardNode(position: position)
        }
    }
    
    func refreshPieces() {
        for (key, val) in engine?.board ?? [:] {
            switch val {
            case .none:
                pieces[key] = nil
            case .piece(let color, let type):
                if let existing = pieces[key],
                    existing.color == color,
                    existing.type == type {
                } else {
                    pieces[key] = PieceNode(color: color, type: type)
                }
            }
        }
    }
    
    func selectPiece(_ piece: PieceNode?, selectedPlaces: [BoardPosition]) {
        for position in BoardPosition.allCases {
            if let piece = pieces[position], piece.isSelected == true {
                piece.isSelected = false
            }
            
            if let brdPiece = board[position], brdPiece.highlight != nil {
                brdPiece.highlight = nil
            }
            
            piece?.isSelected = true
            for pos in selectedPlaces {
                board[pos]?.highlight = .PossiblePosition
            }
        }
    }
}

