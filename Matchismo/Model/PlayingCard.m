//
//  PlayingCard.m
//  Matchismo
//
//  Created by Tatiana Kornilova on 1/29/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard
@synthesize suit =_suit;     // because we provide setter AND getter

-(int)match:(NSArray *)otherCards
{
    int score =0;
    if ([otherCards count] == 1) {
        PlayingCard *otherCard =[otherCards lastObject ];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank){
            score =4;
        }
    }
    return score;
}

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit ];
}
+ (NSArray *)validSuits
{
    static NSArray *validSuits =nil;
    if (!validSuits) validSuits = @[@"♥",@"♦",@"♠",@"♣"];
    return validSuits;
}
- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit =suit;
    }
}
- (NSString *)suit {
    return _suit ? _suit : @"?";
}

+(NSArray *)rankStrings
{
    static NSArray *rankStrings =nil;
    if (!rankStrings) rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    return rankStrings;
}
+ (NSInteger)maxRank { return [self rankStrings].count-1;}

-(void)setRank:(NSInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank =rank;
    }
}


@end
