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
@property (nonatomic) int numberMatchedCards;
@property (strong,nonatomic) NSMutableArray *matchedCards; // of otherCard
@property (strong,nonatomic) NSMutableArray *contentsOfMatchedCards;  // of contents of matchedCards

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
        if (!_cards) _cards =[[NSMutableArray alloc] init];
        return _cards;
}

- (NSMutableArray *)matchedCards
{
    if (!_matchedCards) _matchedCards =[[NSMutableArray alloc] init];
    return _matchedCards;
}

- (NSMutableArray *)contentsOfMatchedCards
{
    if (!_contentsOfMatchedCards) _contentsOfMatchedCards =[[NSMutableArray alloc] init];
    return _contentsOfMatchedCards;
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
    [self.matchedCards removeAllObjects];

    if (card && !card.isUnplayable) {
        self.resultOfFlip =[NSString stringWithFormat:@"Flipped down"];        
        if (!card.isFaceUp) {                                 //------ if 1
         self.resultOfFlip =[NSString stringWithFormat:@"Flipped up %@! %d point minus",card.contents,FLIP_COST];
            
//----------------------Begin of cicle for self.cards-----------------------------------------
        for (Card *otherCard in self.cards) {
            if (otherCard.isFaceUp && !otherCard.isUnplayable) {  //----- if 2
                [self.matchedCards addObject:otherCard];
// ------decision on match ----------
             if ([self.matchedCards count]>= (self.numberMatchedCards -1)) {
                 [self.contentsOfMatchedCards removeAllObjects];
                 [self.contentsOfMatchedCards addObject:card.contents];
                  for (Card *matchedCard in self.matchedCards) {
                      [self.contentsOfMatchedCards addObject:matchedCard.contents];
                  }
                int matchScore = [card match:self.matchedCards];
                if (matchScore) {
                    card.Unplayable =YES;
                    
                    for (Card *matchedCard in self.matchedCards) {
                        matchedCard.Unplayable = YES;
                                            }
                    self.score = matchScore*MATCH_BONUS;
                    [self.matchedCards addObject:card];
                    self.resultOfFlip =[NSString stringWithFormat:@"Matched %@& for %d points ",[self.contentsOfMatchedCards  componentsJoinedByString:@"&"],MATCH_BONUS];
                    
                }else {
                    for (Card *matchedCard in self.matchedCards) {
                         matchedCard.faceUp = NO;
                    }
                    [self.matchedCards addObject:card];
                     self.score -= MISMATCH_PENALTY;
                    [self.matchedCards addObject:card];
                    self.resultOfFlip =[NSString stringWithFormat:@"%@ don't match! %d point penalty ",[self.contentsOfMatchedCards componentsJoinedByString:@"&"],MISMATCH_PENALTY];
                }
                               break;
             }
// ------decision on match ----------
            }    //-------- if 2
        }   //-- for
//----------------------End of cicle for self.cards-----------------------------------------
            
         self.score -= FLIP_COST;
        }                                        //------- if 1
        card.faceUp = !card.faceUp;
    }
}


- (Card *)cardAtIndex:(NSInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck numberMatchedCards:(int) numberCards
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
        self.numberMatchedCards = numberCards;
        [self.matchedCards removeAllObjects];
    }
    return self;
}
@end
