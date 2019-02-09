//
//  BoardNode.swift
//  ChessAR
//
//  Created by Adem Atalay on 3.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import SceneKit
import ChessEngine.Swift

class BoardNode: SCNNode {
    let boardPosition: BoardPosition
    let color: PieceColor
    private var highlightFor: HighlightReason? = nil
    var highlight: HighlightReason? {
        get {
            return highlightFor
        }
        set (newValue) {
            self.highlightFor = newValue
            self.geometry?.materials.first?.diffuse.contents = internalColor()
        }
    }
    
    init(position: BoardPosition) {
        boardPosition = position
        color = position.color()
        super.init()
        setupGeometry()
        self.position = position.positionVector()
    }
    
    private func setupGeometry() {
        let geometry = SCNBox(width: BoardSpecs.pieceWidth.rawValue,
                              height: BoardSpecs.boardHeight.rawValue,
                              length: BoardSpecs.pieceWidth.rawValue,
                              chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = internalColor()
        geometry.materials = [material]
        self.geometry = geometry
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func internalColor() -> UIColor {
        if let clr = highlightFor?.color() { return clr }
        return color == .White ? UIColor.white : UIColor.black
    }
    
}
