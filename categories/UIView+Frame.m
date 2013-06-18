//
//  UIView+Frame.m
//  libgp
//
//  Created by mallarke on 1/12/13.
//  Copyright (c) 2013 givepulse, inc. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect viewCustomframe = self.frame;
    viewCustomframe.origin = origin;
    self.frame = viewCustomframe;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect viewCustomframe = self.frame;
    viewCustomframe.size = size;
    self.frame = viewCustomframe;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect viewCustomframe = self.frame;
    viewCustomframe.origin.x = x;
    self.frame = viewCustomframe;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect viewCustomframe = self.frame;
    viewCustomframe.origin.y = y;
    self.frame = viewCustomframe;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect viewCustomframe = self.frame;
    viewCustomframe.size.width = width;
    self.frame = viewCustomframe;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect viewCustomframe = self.frame;
    viewCustomframe.size.height = height;
    self.frame = viewCustomframe;
}

- (CGPoint)middle
{
    CGPoint point = CGPointZero;
    point.x = self.width / 2.0;
    point.y = self.height / 2.0;
    
    return point;
}

@end
