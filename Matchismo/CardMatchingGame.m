//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Tatiana Kornilova on 1/30/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()

@property (readwrite, nonatomic) int score;
@property (strong,nonatomic) NSMutableArray *cards; // of Card
@property (readwrite,nonatomic) NSString *resultOfFlip;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
        if (!_cards) _cards =[[NSMutableArray alloc] init];
        return _cards;
}

- (NSString *)resultOfFlip
{
    if (!_resultOfFlip) _resultOfFlip =@"";
    return _resultOfFlip;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST  1

- (void)flipCardAtIndex:(NSInteger)index
{
    self.resultOfFlip = @"";
    Card *card = [self cardAtIndex: index];
    if (card && !card.isUnplayable) {
        self.resultOfFlip =[NSString stringWithFormat:@"Flipped down"];        
        if (!card.isFaceUp) {
         self.resultOfFlip =[NSString stringWithFormat:@"Flipped up %@! %d point minus ",card.contents,FLIP_COST];
         for (Card *otherCard in self.cards) {
            if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                int matchScore = [card match:@[otherCard]];
                if (matchScore) {
                    card.Unplayable =YES;
                    otherCard.Unplayable = YES;
                    self.score =matchScore*MATCH_BONUS;
                    self.resultOfFlip =[NSString stringWithFormat:@"Matched %@&%@ for %d points ",card.contents,otherCard.contents,MATCH_BONUS];
                    
                }else {
                    otherCard.faceUp =NO;
                    self.score -= MISMATCH_PENALTY;
                    self.resultOfFlip =[NSString stringWithFormat:@"%@&%@ don't match! %d point penalty ",card.contents,otherCard.contents,MISMATCH_PENALTY];
                }
                break;
            }
         }
         self.score -= FLIP_COST;
        }
        card.faceUp = !card.faceUp;
    }
}


- (Card *)cardAtIndex:(NSInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i =0; i< count; i++) {
            Card *card = [deck drawRandomCard];
            if(card) {
                self.cards[i] =card;
            }else {
                self =nil;
                break;
            }
                        
        }
    }
    return self;
}
@end
