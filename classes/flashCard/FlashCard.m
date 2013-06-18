//
//  FlashCard.m
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "FlashCard.h"

#import "Path.h"

typedef enum
{
    FlashCardViewState_FRONT,
    FlashCardViewState_BACK
} FlashCardViewState;

#pragma mark - TouchView interface - 

@interface TouchView : UIView

@property (retain) Path *currentPath;
@property (retain) NSMutableArray *paths;

@property (assign) BOOL ignoreTouch;

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture;

@end

#pragma mark - TouchView implementation -

@implementation TouchView

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.backgroundColor = CLEAR_COLOR;
        self.paths = [NSMutableArray array];
        
        UIPanGestureRecognizer *panGesture = [UIPanGestureRecognizer object];
        [panGesture addTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGesture];
    }
    
    return self;
}

- (void)dealloc
{
    self.currentPath = nil;
    self.paths = nil;
    
    [super dealloc];
}

#pragma mark - Private methods -

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self];
    
    switch(gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            self.currentPath = [Path path:location];
            [self.paths addObject:self.currentPath];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self.currentPath addLocation:location];
            [self setNeedsDisplay];
            break;
            
        case UIGestureRecognizerStateEnded:
            self.currentPath = nil;
            break;
            
        default:
            break;
    }
}

#pragma mark - Protected methods -

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(self.ignoreTouch)
    {
        return false;
    }
    
    point = [self convertPoint:point toView:self];
    return CGRectContainsPoint(self.bounds, point);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, BLACK_COLOR.CGColor);
    CGContextSetLineWidth(context, 3);
    
    for(Path *path in self.paths)
    {
        CGContextSaveGState(context);
        {
            CGContextAddPath(context, path.CGPath);
            CGContextStrokePath(context);
        }
        CGContextRestoreGState(context);
    }
}

@end

#pragma mark - CardFace interface -

@interface CardFace : UIView

@property (nonatomic, assign) BOOL hasLines;
@property (assign) BOOL ignoreTouch;

// private
@property (retain) UIView *lines;
@property (retain) TouchView *touchView;

@property (assign) CGRect lastFrame;

@end

#pragma mark - CardFace implementation -

@implementation CardFace

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];
    
    if(self)
	{
        self.backgroundColor = WHITE_COLOR;
        
        self.lines = [UIView object];
        self.lines.hidden = true;
        [self addSubview:self.lines];
        
        self.touchView = [TouchView object];
        [self addSubview:self.touchView];
    }
    
    return self;
}

- (void)dealloc
{
    self.lines = nil;
    self.touchView = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

- (void)layoutSubviews
{
	[super layoutSubviews];
    
	CGRect bounds = self.bounds;
	CGSize maxSize = bounds.size;
    
    self.lines.frame = bounds;
    self.touchView.frame = bounds;
    
    if(!CGRectEqualToRect(bounds, self.lastFrame) && !self.lines.hidden)
    {
        self.lastFrame = bounds;
        
        for(UIView *view in self.lines.subviews)
        {
            [view removeFromSuperview];
        }
        
        CGFloat y = FLASH_CARD_LINE_START_HEIGHT;
        
        CGRect frame = CGRectZero;
        frame.size.width = maxSize.width;
        frame.size.height = DIVIDER_HEIGHT;
        
        while(y < maxSize.height)
        {
            frame.origin.y = y;
            
            UIView *line = [UIView object];
            line.frame = frame;
            line.backgroundColor = FLASH_CARD_LINE_COLOR;
            [self.lines addSubview:line];
            
            y += FLASH_CARD_LINE_HEIGHT;
        }
    }
}

#pragma mark - Getter/Setter methods -

- (void)setHasLines:(BOOL)hasLines
{
    _hasLines = hasLines;
    
    self.lines.hidden = !hasLines;
}

- (BOOL)ignoreTouch
{
    return self.touchView.ignoreTouch;
}

- (void)setIgnoreTouch:(BOOL)ignoreTouch
{
    self.touchView.ignoreTouch = ignoreTouch;
}

@end

#pragma mark - FlashCard extension -

@interface FlashCard() <UIGestureRecognizerDelegate>

@property (retain) UIView *wrapper;
@property (retain) CardFace *front;
@property (retain) CardFace *back;

@property (nonatomic, assign) FlashCardViewState viewState;

@property (assign) BOOL isAnimating;
@property (assign) CGRect flipArea;
@property (assign) CGPoint initialPointOnScreen;
@property (assign) BOOL shouldPanView;

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture;
- (BOOL)touchInRange:(CGPoint)location;
- (CGFloat)distanceTraveled:(CGPoint)initial current:(CGPoint)current;
- (void)handlePan:(CGFloat)distance;

- (CATransform3D)transformForAngle:(CGFloat)angle;

@end

#pragma mark - FlashCard implementation

@implementation FlashCard

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        self.wrapper = [UIView object];
        [self addSubview:self.wrapper];
        
        static CGFloat radius = 8;
        
        CGSize size = FLASH_CARD_SIZE;
        size.width -= radius;
        size.height -= radius;
        
        CGRect rect = CGRectZero;
        rect.size = size;

        self.wrapper.layer.shadowColor = BLACK_COLOR.CGColor;
        self.wrapper.layer.shadowOffset = CGSizeMake(radius, radius);
        self.wrapper.layer.shadowOpacity = 0.7;
        self.wrapper.layer.shadowRadius = radius;
        self.wrapper.layer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
        
        self.back = [CardFace object];
        [self.wrapper addSubview:self.back];

        self.front = [CardFace object];
        self.front.hasLines = true;
        [self.wrapper addSubview:self.front];
        
        UIPanGestureRecognizer *panGesture = [UIPanGestureRecognizer object];
        [panGesture addTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGesture];
        
        self.viewState = FlashCardViewState_FRONT;
    }

    return self;
}

- (void)dealloc
{
    self.wrapper = nil;
    self.front = nil;
    self.back = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

- (void)animateOn
{
    [self sizeToFit];
    
    // force a screen layout
    [self layoutSubviews];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;    
    CGFloat y = screenSize.height;
    
    self.origin = CGPointMake(MENU_RIGHT_PADDING + MENU_RIGHT_BAR_WIDTH, y);
    
    y = 10;
    self.isAnimating = true;
    
    [UIView animateWithDuration:ANIMATION_SPEED animations:^
     {
         self.y = y;
     }
     completion:^(BOOL finished)
     {
         self.isAnimating = false;
     }];
}

- (void)animateOff
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat y = screenSize.height;
    self.isAnimating = true;
    
    [UIView animateWithDuration:ANIMATION_SPEED animations:^
     {
         self.y = y;
     }
     completion:^(BOOL finished)
     {
         self.isAnimating = false;
     }];
}

#pragma mark - Private methods -

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self];
    
    switch(gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            if(![self touchInRange:location])
            {
                self.shouldPanView = false;
                return;
            }
            
            self.initialPointOnScreen = [gesture locationInView:self.superview];
            self.shouldPanView = true;
            break;
            
        case UIGestureRecognizerStateChanged:
            if(!self.shouldPanView)
            {
                return;
            }
            
            {
                CGPoint initial = self.initialPointOnScreen;
                CGPoint current = [gesture locationInView:self.superview];
                CGFloat percentage = [self distanceTraveled:initial current:current];
                
                [self handlePan:percentage];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            {
                CGPoint initial = self.initialPointOnScreen;
                CGPoint current = [gesture locationInView:self.superview];
                CGFloat percentage = [self distanceTraveled:initial current:current];
                
                if(percentage == 1)
                {
                    self.viewState = (self.viewState == FlashCardViewState_FRONT ? FlashCardViewState_BACK : FlashCardViewState_FRONT);
                }
                else
                {
                    CGFloat angle = (percentage < 0.5 ? 0 : M_PI);
                    
                    [UIView animateWithDuration:FAST_ANIMATION_SPEED animations:^
                     {
                         self.wrapper.layer.transform = [self transformForAngle:angle];
                     }
                     completion:^(BOOL finished)
                     {
                         if(percentage >= 0.5)
                             self.viewState = (self.viewState == FlashCardViewState_FRONT ? FlashCardViewState_BACK : FlashCardViewState_FRONT);
                     }];
                }
            }
            
            self.initialPointOnScreen = CGPointZero;
            self.shouldPanView = true;
            break;
            
        default:
            break;
    }
}

- (BOOL)touchInRange:(CGPoint)location
{
    location = [self convertPoint:location toView:self];
    return CGRectContainsPoint(self.flipArea, location);
}

- (CGFloat)distanceTraveled:(CGPoint)initial current:(CGPoint)current
{
    CGFloat distance = initial.x - current.x;
    
    if(distance < 0)
        distance = 0;
    
    CGFloat maxWidth = FLASH_CARD_SIZE.width * 0.4;
    CGFloat percentage = distance / maxWidth;
    
    if(percentage > 1)
        percentage = 1;
    
    return percentage;
}

- (void)handlePan:(CGFloat)distance
{
    switch(self.viewState)
    {
        case FlashCardViewState_FRONT:
            self.front.hidden = (distance >= 0.5);
            break;
            
        case FlashCardViewState_BACK:
            self.front.hidden = !(distance >= 0.5);
            break;
    }
    
    CGFloat angle = M_PI * distance;
    self.wrapper.layer.transform = [self transformForAngle:angle];
}

- (CATransform3D)transformForAngle:(CGFloat)angle
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500.0;
    transform = CATransform3DRotate(transform, angle, 0, 0.5, 0);

    return transform;
}

#pragma mark - Protected methods -

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(CGRectContainsPoint(self.frame, point))
    {
        if([self touchInRange:point])
        {
            self.front.ignoreTouch = true;
            self.back.ignoreTouch = true;
        }
        else
        {
            self.front.ignoreTouch = false;
            self.back.ignoreTouch = false;
        }
        
        return true;
    }
    
    return false;
}

- (void)sizeToFit
{
    CGRect frame = self.frame;
    frame.size = FLASH_CARD_SIZE;
    self.frame = frame;
}

- (void)layoutSubviews
{
	CGRect bounds = self.bounds;
    CGSize maxSize = bounds.size;
    
    CGRect rect = CGRectZero;
    rect.origin.x = maxSize.width - FLASH_CARD_FLIP_AREA_WIDTH;
    rect.size.width = FLASH_CARD_FLIP_AREA_WIDTH;
    rect.size.height = maxSize.height;
    
    self.flipArea = rect;
    
    if(self.isAnimating)
    {
        return;
    }
    
	[super layoutSubviews];
    
    self.wrapper.frame = bounds;
    self.front.frame = bounds;
    self.back.frame = bounds;
}

#pragma mark - Getter/Setter methods -

- (void)setViewState:(FlashCardViewState)viewState
{
    _viewState = viewState;
    
    CATransform3D baseTransform = [self transformForAngle:0];
    CATransform3D flippedTransform = [self transformForAngle:M_PI];
    
    switch(viewState)
    {
        case FlashCardViewState_FRONT:
            self.wrapper.layer.transform = baseTransform;
            self.front.layer.transform = baseTransform;
            self.back.layer.transform = flippedTransform;
            break;
            
        case FlashCardViewState_BACK:
            self.wrapper.layer.transform = baseTransform;
            self.back.layer.transform = baseTransform;
            self.front.layer.transform = flippedTransform;
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate methods -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}

@end
