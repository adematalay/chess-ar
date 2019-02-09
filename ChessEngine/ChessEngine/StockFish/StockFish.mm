//
//  StockFish.m
//  ChessAR
//
//  Created by Adem Atalay on 3.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

#import "StockFish.h"

#include <iomanip>
#include <sstream>
#include "bitboard.h"
#include "endgame.h"
#include "evaluate.h"
#include "material.h"
#include "search.h"
#include "thread.h"
#include "tt.h"
#include "ucioption.h"

#define X_COORD @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H"]

Position pos;

void pv_to_ui(const std::string &pv, int depth, int score, int scoreType, bool mate) { }
void currmove_to_ui(const std::string currmove, int currmovenum, int movenum, int depth) { }
void searchstats_to_ui(int64_t nodes, long time) { }

void bestmove_to_ui(const std::string &best, const std::string &ponder) {
    NSString *move = [NSString stringWithCString:best.c_str() encoding:NSUTF8StringEncoding];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [StockFish.stockFishInstance sendMove:move timeLeft:300];
    });
}

void position_to_ui(Position new_pos){
    pos = new_pos;
}

extern void execute_command(const std::string &command);

void command_to_engine(const std::string &command) { execute_command(command); }

// =================================================================================================================

@implementation CEChessPiece

- (instancetype)initWithType:(NSString *)type color:(NSString *)color {
    self = [super init];
    if (self) {
        _type = type.copy;
        _color = color.copy;
    }
    return self;
}

@end

@implementation StockFish
static id<StockFishMoveDelegate> _instance;

+ (void)setStockFishInstance:(nullable id<StockFishMoveDelegate>)stockFishInstance {
    _instance = stockFishInstance;
}

+ (id<StockFishMoveDelegate>)stockFishInstance {
    return _instance;
}

+ (void)initStockFish {
    UCI::init(Options);
    Bitboards::init();
    Position::init();
    Bitbases::init_kpk();
    Search::init();
    Pawns::init();
    Eval::init();
    Threads.init();
    TT.resize(Options["Hash"]);
}

+ (void)executeCommand:(NSString *)command {
    if([command hasPrefix:@"\n"])
        execute_command([command UTF8String]);
    else{
        execute_command([[command stringByAppendingString:@"\n"] UTF8String]);
    }
}

+ (NSArray <NSString *> *)validMovesForSquare:(nullable NSString*)square {
    NSAssert([NSOperationQueue currentQueue] == [NSOperationQueue mainQueue], @"Valid move must be syncronized");

    ExtMove *validMoves = (ExtMove *) malloc(sizeof(ExtMove) * 64);
    memset(validMoves, 0, sizeof(ExtMove) * 64);

    generate<LEGAL>(pos, validMoves);

    NSMutableArray *valid = [NSMutableArray array];
    for(int i=0;i<64;i++){
        Move m = validMoves[i].move;
        //Move is 16-bit value, so if value is bigger than 2^16 break the loop
        if((int)m > 65536 || m < 0) continue;
        
        NSString *fromSq = [NSString stringWithCString:to_string(from_sq(m)).c_str() encoding:NSUTF8StringEncoding];
        
        if(m != Move::MOVE_NONE &&
           (!square  || [[fromSq uppercaseString] isEqualToString:square]) &&
           pos.moved_piece(m) != NO_PIECE &&
           pos.legal(m, pos.pinned_pieces(pos.side_to_move()))) {
            
            MoveType moveType = type_of(m);
            
            NSString *moveStr = [[NSString stringWithCString:to_string(to_sq(m)).c_str() encoding:NSUTF8StringEncoding] uppercaseString];
            
            if(moveType == CASTLING){
                if((int)to_sq(m) > (int)from_sq(m)){
                    moveStr = [[NSString stringWithCString:to_string((Square)((int)from_sq(m) + 2)).c_str() encoding:NSUTF8StringEncoding] uppercaseString];
                }else{
                    moveStr = [[NSString stringWithCString:to_string((Square)((int)from_sq(m) - 2)).c_str() encoding:NSUTF8StringEncoding] uppercaseString];
                }
            }
            
            [valid addObject:moveStr];
        }
    }
    free(validMoves);

    return valid;
}

+ (NSDictionary<NSString *, CEChessPiece *> *)board {
    NSMutableDictionary<NSString *, CEChessPiece *> *board = [NSMutableDictionary dictionary];
    for(int i=0;i<64;i++){
        Move m = (Move)(i);
        Piece piece = pos.piece_on(to_sq(m));
        PieceType type = type_of(piece);
        
        NSString *color;
        if(type != PieceType::NO_PIECE_TYPE && color_of(piece) == Color::BLACK) color = @"b";
        else if(type != PieceType::NO_PIECE_TYPE && color_of(piece) == Color::WHITE) color = @"w";
        
        NSString *ptype;
        switch (type) {
            case PieceType::BISHOP:
                ptype = @"bishop";
                break;
            case PieceType::KING:
                ptype = @"king";
                break;
            case PieceType::KNIGHT:
                ptype = @"knight";
                break;
            case PieceType::PAWN:
                ptype = @"pawn";
                break;
            case PieceType::ROOK:
                ptype = @"rook";
                break;
            case PieceType::QUEEN:
                ptype = @"queen";
                break;
            default:
                break;
        };
        
        NSString *key = [[NSString stringWithCString:to_string(to_sq(m)).c_str() encoding:NSUTF8StringEncoding] uppercaseString];
        if(color) {
            board[key] = [[CEChessPiece alloc] initWithType:ptype color:color];
        } else {
            board[key] = [[CEChessPiece alloc] initWithType:@"" color:@""];
        }
    }
    
    return board;
}

+ (BOOL)isWhitesTurn {
    return pos.side_to_move() == Color::WHITE;
}

+ (GameFinish)status {
    NSArray *validMoves = [self validMovesForSquare:nil];
    
    if(pos.checkers() && validMoves.count == 0) return GF_MATE;
    
    if(!pos.checkers() && validMoves.count == 0) return GF_STALE;
    
    return GF_NONE;
}

@end
