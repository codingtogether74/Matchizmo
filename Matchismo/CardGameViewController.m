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
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property(nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong,nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultOfFlip;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeChanged;
@property (nonatomic) int numberMatchedCards;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc]init] numberMatchedCards:self.numberMatchedCards];
    return _game;
    
}

-(int)numberMatchedCards
{
    if(!_numberMatchedCards) _numberMatchedCards =2;
    return _numberMatchedCards;
}

-(void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}
-(void)updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"back-blue-75-1.png"];
    for (UIButton *cardButton  in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        if (!card.isFaceUp)[cardButton setImage:cardBackImage forState:UIControlStateNormal];
        if (card.isFaceUp)[cardButton setImage:nil forState:UIControlStateNormal];
        cardButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        cardButton.selected = card.faceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultOfFlip.text = [NSString stringWithFormat:@"%@", self.game.resultOfFlip];
    
}

-(void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.modeChanged.enabled =NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    
}
- (IBAction)pressDeal:(id)sender
{
    self.game =nil;
    self.modeChanged.enabled =YES;
    [self updateUI];
}
- (IBAction)modeChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.numberMatchedCards=2;
            self.game =nil;
            [self updateUI];
            break;
        case 1:
            self.numberMatchedCards=3;
            self.game =nil;
            [self updateUI];
            break;
        default:
            self.numberMatchedCards=2;
            self.game =nil;
            [self updateUI];
            break;
    }
}

@end
