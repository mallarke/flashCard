//
//  MainView.m
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "MainView.h"

#import "Menu.h"
#import "FlashCard.h"

#pragma mark - MainView extension -

@interface MainView() <MenuDelegate>

@property (retain) Menu *menu;

@property (retain) NSMutableArray *flashCards;
@property (readonly) FlashCard *currentCard;

- (void)addCard;
- (void)removeCard;

@end

#pragma mark - MainView implementation

@implementation MainView

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.flashCards = [NSMutableArray array];
        
        self.menu = [Menu object];
        self.menu.delegate = self;
        [self addSubview:self.menu];
    }

    return self;
}

- (void)dealloc
{
    self.menu = nil;
    
    self.flashCards = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

- (void)addCard
{
    FlashCard *card = [FlashCard object];
    [self insertSubview:card belowSubview:self.menu];
    
    [self.flashCards addObject:card];
    
    [card animateOn];
    
}

- (void)removeCard
{
    [self.currentCard animateOff];
    [self.flashCards removeLastObject];
}

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

- (FlashCard *)currentCard
{
    return [self.flashCards lastObject];
}

#pragma mark - MenuDelegate methods -

- (void)menu:(Menu *)menu didSelectIndex:(MenuOptions)option
{
    switch(option)
    {
        case MenuOptions_ADD:
            [self addCard];
            break;
            
        case MenuOptions_DELETE:
            [self removeCard];
            break;
    }
}

@end
