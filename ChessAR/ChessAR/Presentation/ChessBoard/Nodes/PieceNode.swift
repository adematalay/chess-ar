//
//  PieceNode.swift
//  ChessAR
//
//  Created by Adem Atalay on 2.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import SceneKit
import ChessEngine

class PieceNode: SCNNode {
    let color: PieceColor
    let type: PieceType
    let nodeName: String
    private let scene: SCNScene
    private var boardPos: BoardPosition = .A1
    var boardPosition: BoardPosition {
        get {
            return boardPos
        }
        set (newValue) {
            self.boardPos = newValue
            setPosition()
        }
    }
    
    private var selected: Bool = false
    var isSelected: Bool {
        get {
            return selected
        }
        set (newValue) {
            self.selected = newValue
            setPosition()
        }
    }
    
    init(color: PieceColor, type: PieceType, scene: SCNScene? = nil) {
        self.color = color
        self.type = type
        self.nodeName = "\(color.rawValue)_\(type.rawValue)"
        self.scene = scene ?? (SCNScene(named: ARModels.ChessScene.rawValue) ?? SCNScene())
        super.init()
        
        let chessNode = self.scene.rootNode.childNode(withName: nodeName, recursively: true)
        self.geometry = chessNode?.geometry
        let scaleValue = BoardSpecs.scaleValue.rawValue
        self.scale = SCNVector3(scaleValue, scaleValue, scaleValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPosition() {
        var pos = boardPosition.positionVector()
        pos.y = Float((self.selected ? 4 : 1) * BoardSpecs.boardHeight.rawValue)
        self.position = pos
    }
}
