//
//  Menu.h
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    MenuOptions_ADD,
    MenuOptions_DELETE
} MenuOptions;

@protocol MenuDelegate;

@interface Menu : UIView

@property (assign) id<MenuDelegate> delegate;

@end

@protocol MenuDelegate <NSObject>

- (void)menu:(Menu *)menu didSelectIndex:(MenuOptions)option;

@end