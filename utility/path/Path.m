//
//  Path.m
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "Path.h"

#pragma mark - Path extension -

@interface Path()

@property (retain, readwrite) UIBezierPath *bezierPath;
@property (retain) NSMutableArray *locations;

@end

#pragma mark - Path implementation

@implementation Path

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    NSAssert(false, @"Use initPaht: or path: instead");
    return nil;
}

- (id)initPath:(CGPoint)location
{
    self = [super init];

    if(self) 
	{
        self.bezierPath = [UIBezierPath bezierPath];
        self.bezierPath.lineWidth = 3.0;
        [self.bezierPath moveToPoint:location];
        
        NSValue *value = [NSValue valueWithCGPoint:location];
        
        self.locations = [NSMutableArray array];
        [self.locations addObject:value];
    }

    return self;
}

+ (id)path:(CGPoint)location
{
    return [[[self alloc] initPath:location] autorelease];
}

- (void)dealloc
{
    self.bezierPath = nil;
    self.locations = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

- (void)addLocation:(CGPoint)location
{
    NSValue *value = [NSValue valueWithCGPoint:location];
    [self.locations addObject:value];
    
    [self.bezierPath addLineToPoint:location];
}

#pragma mark - Private methods -

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

- (CGPathRef)CGPath
{
    return self.bezierPath.CGPath;
}

@end

