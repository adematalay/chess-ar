//
//  BoardConstants.swift
//  ChessAR
//
//  Created by Adem Atalay on 2.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import SceneKit
import ChessEngine.Swift

enum HighlightReason {
    case PossiblePosition
    case PieceIsOnPosition
    
    func color() -> UIColor {
        switch self {
        case .PossiblePosition:
            return UIColor.green
        case .PieceIsOnPosition:
            return UIColor.blue
        }
    }
}

enum BoardSpecs: CGFloat {
    case pieceWidth = 0.08
    case boardHeight = 0.01
    case scaleValue = 0.020
}

enum ARModels: String {
    case ChessScene = "art.scnassets/chess.scn"
    case ChessReferenceObjectGroup = "AR Resources"
}

extension BoardPosition {
    func matrixPosition() -> [Int] {
        let c1: UInt32 = self.rawValue.first?.unicodeScalars.first?.value ?? 0
        let a: UInt32 = "A".unicodeScalars.first?.value ?? 0
        let c2: UInt32 = (UInt32(String(self.rawValue.last ?? "1")) ?? 1) - 1
        return [ Int(c1 - a), Int(c2) ]
    }
    
    func positionVector() -> SCNVector3 {
        let m = self.matrixPosition()
        let k = Double(BoardSpecs.pieceWidth.rawValue)
        return SCNVector3(Double(m[0])*k - 4*k, 0, 4*k - Double(m[1])*k)
    }
    
    func color() -> PieceColor {
        let m = self.matrixPosition()
        return (m[0] + m[1]) % 2 == 1 ? .White : .Black
    }
}
