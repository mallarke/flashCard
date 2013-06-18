//
//  MainViewController.m
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "MainViewController.h"

#import "MainView.h"

#pragma mark - MainViewController extension -

@interface MainViewController()

@property (nonatomic, retain) MainView *view;

@end

#pragma mark - MainViewController implementation

@implementation MainViewController

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{

    }

    return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark - View life cycle methods -

- (void)loadView
{
    MainView *view = [MainView object];
    
    self.view = view;
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

@end
