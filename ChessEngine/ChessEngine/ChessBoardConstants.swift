//
//  ChessBoardConstants.swift
//  ChessEngine
//
//  Created by Adem Atalay on 8.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import Foundation

public enum PieceColor: String {
    case Black = "b"
    case White = "w"
}


public enum PieceType: String {
    case Rook = "rook"
    case Knight = "knight"
    case Bishop = "bishop"
    case Queen = "queen"
    case King = "king"
    case Pawn = "pawn"
}

public enum ChessPiece {
    case piece(color: PieceColor, type: PieceType)
    case none
}

public enum BoardPosition: String, CaseIterable {
    case A1
    case A2
    case A3
    case A4
    case A5
    case A6
    case A7
    case A8
    
    case B1
    case B2
    case B3
    case B4
    case B5
    case B6
    case B7
    case B8
    
    case C1
    case C2
    case C3
    case C4
    case C5
    case C6
    case C7
    case C8
    
    case D1
    case D2
    case D3
    case D4
    case D5
    case D6
    case D7
    case D8
    
    case E1
    case E2
    case E3
    case E4
    case E5
    case E6
    case E7
    case E8
    
    case F1
    case F2
    case F3
    case F4
    case F5
    case F6
    case F7
    case F8
    
    case G1
    case G2
    case G3
    case G4
    case G5
    case G6
    case G7
    case G8
    
    case H1
    case H2
    case H3
    case H4
    case H5
    case H6
    case H7
    case H8
}
