//
//  AppDelegate.h
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

/*
 * Application that displays flash cards.
 * swipe left to right on left edge of screen
 * select Add a card
 * write whatever you would like
 * swipe right to left on right edge of card
 * write whatever you would like on the back side of the card
 * swipe right to left on right edge of card to go back to the front
 */

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) MainViewController *viewController;

@end
