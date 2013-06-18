//
//  Path.h
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Path : NSObject

@property (retain, readonly) UIBezierPath *bezierPath;
@property (readonly) CGPathRef CGPath;

- (id)initPath:(CGPoint)location;
+ (id)path:(CGPoint)location;

- (void)addLocation:(CGPoint)location;

@end
