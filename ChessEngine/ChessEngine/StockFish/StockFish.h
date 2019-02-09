//
//  StockFish.h
//  ChessAR
//
//  Created by Adem Atalay on 3.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum GameFinish{
    GF_MATE,
    GF_STALE,
    GF_DRAW,
    GF_NONE
} GameFinish;

@protocol StockFishMoveDelegate <NSObject>

-(void)sendMove:(NSString*)move timeLeft:(NSInteger)time;

@end

@interface CEChessPiece: NSObject

@property (nonatomic, copy, readonly) NSString *color;
@property (nonatomic, copy,readonly) NSString *type;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithType:(NSString *)type color:(NSString *)color NS_DESIGNATED_INITIALIZER;

@end

@interface StockFish : NSObject

@property (class, nonatomic, nullable) id<StockFishMoveDelegate> stockFishInstance;
@property (class, nonatomic, readonly) NSDictionary<NSString *, CEChessPiece *> *board;
@property (class, nonatomic, readonly) BOOL isWhitesTurn;
@property (class, nonatomic, readonly) GameFinish status;

+ (void)initStockFish;
+ (void)executeCommand:(NSString *)command;

+ (NSArray <NSString *> *)validMovesForSquare:(nullable NSString*)square;

@end

NS_ASSUME_NONNULL_END
