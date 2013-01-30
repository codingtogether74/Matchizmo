//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tatiana Kornilova on 1/29/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "CardGameViewController.h"

#import "PlayingCard.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property(nonatomic) int flipCount;
@property (strong,nonatomic) PlayingCardDeck *deck;
@end

@implementation CardGameViewController

-(PlayingCardDeck *)deck {
    if (!_deck) _deck = [[PlayingCardDeck alloc]init];
    return _deck;
}


-(void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    if (!sender.isSelected){
        Card *card =[self.deck drawRandomCard];
        if (card) {
            [sender setTitle:(NSString *)card.contents forState:UIControlStateSelected];
        }else {
            [sender setTitle:@"X" forState:UIControlStateSelected];
            self.flipsLabel.text =@"Deck is empty ";
        }
    }
    sender.selected = !sender.selected;
    self.flipCount++;
    
}

@end
