//
//  UIView+Frame.h
//  libgp
//
//  Created by mallarke on 1/12/13.
//  Copyright (c) 2013 givepulse, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (assign) CGPoint origin;
@property (assign) CGSize size;

@property (assign) CGFloat x;
@property (assign) CGFloat y;

@property (assign) CGFloat width;
@property (assign) CGFloat height;

@property (readonly) CGPoint middle;

@end
