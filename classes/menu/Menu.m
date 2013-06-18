//
//  Menu.m
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "Menu.h"

#import "MenuItem.h"

typedef enum
{
    MenuViewState_CLOSED,
    MenuViewState_OPEN,
    MenuViewState_ANIMATING_OPEN,
    MenuViewState_ANIMATING_CLOSED
} MenuViewState;

#define MIN_X -(MENU_WIDTH - (MENU_RIGHT_PADDING + MENU_RIGHT_BAR_WIDTH))

#pragma mark - MenuBackground interface -

@interface MenuBackground : UIView

@property (assign) CGGradientRef rightBarGradient;

@end

#pragma mark - MenuBackground implementation -

@implementation MenuBackground

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.backgroundColor = CLEAR_COLOR;
        
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        
        CGFloat locations[] = { 0, 1 };
        CGFloat colors[] =
        {
            MENU_RIGHT_BAR_LIGHT_COLOR, MENU_RIGHT_BAR_LIGHT_COLOR, MENU_RIGHT_BAR_LIGHT_COLOR, 1.0,
            MENU_RIGHT_BAR_DARK_COLOR, MENU_RIGHT_BAR_DARK_COLOR, MENU_RIGHT_BAR_DARK_COLOR, 1.0
        };
        
        self.rightBarGradient = CGGradientCreateWithColorComponents(colorspace, colors, locations, 2);

        CGColorSpaceRelease(colorspace);
        colorspace = NULL;
    }
    
    return self;
}

- (void)dealloc
{
    CGGradientRelease(self.rightBarGradient);
    
    [super dealloc];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGSize maxSize = self.bounds.size;
    maxSize.width -= MENU_RIGHT_PADDING;

    CGContextSaveGState(context);
    {
        CGRect bounds = CGRectZero;
        bounds.size = maxSize;
        
        CGContextSetFillColorWithColor(context, MENU_BACKGROUND_COLOR.CGColor);
        CGContextFillRect(context, bounds);
    }
    CGContextRestoreGState(context);

    CGContextSaveGState(context);
    {
        CGPoint startPoint = CGPointZero;
        startPoint.x = maxSize.width - MENU_RIGHT_BAR_WIDTH;
        
        CGPoint endPoint = CGPointZero;
        endPoint.x = maxSize.width;
        
        CGContextDrawLinearGradient(context, self.rightBarGradient, startPoint, endPoint, 0);
    }
    CGContextRestoreGState(context);
}

#pragma mark - Getter/Setter methods -

@end

#pragma mark - Menu extension -

@interface Menu() <UITableViewDataSource, UITableViewDelegate>

@property (retain) MenuBackground *background;

@property (retain) NSArray *content;
@property (retain) UITableView *tableView;

@property (nonatomic, assign) MenuViewState viewState;
@property (assign) CGPoint initialPointOnScreen;
@property (assign) CGPoint initialPointInView;

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture;
- (void)moveTo:(CGPoint)location;

- (void)animateMenu:(CGFloat)velocity location:(CGFloat)location close:(BOOL)close;

@end

#pragma mark - Menu implementation

@implementation Menu

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        static CGFloat radius = 5;
        
        CGRect rect = CGRectZero;
        rect.size = CGSizeMake(MENU_WIDTH, [UIScreen mainScreen].bounds.size.height);
        rect.size.width -= MENU_RIGHT_BAR_WIDTH + MENU_RIGHT_PADDING;
        
        self.layer.shadowColor = BLACK_COLOR.CGColor;
        self.layer.shadowOffset = CGSizeMake(radius, 0);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = radius;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
        
        NSMutableArray *content = [NSMutableArray array];
        [content addObject:ADD_CARD_TEXT];
        [content addObject:DELETE_CARD_TEXT];
        
        self.content = content;
        
        self.background = [MenuBackground object];
        [self addSubview:self.background];
        
        self.tableView = [UITableView object];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.rowHeight = MENU_ITEM_ROW_HEIGHT;
        self.tableView.scrollEnabled = false;
        [self addSubview:self.tableView];
        
        UIPanGestureRecognizer *panGesture = [UIPanGestureRecognizer object];
        [panGesture addTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGesture];

        dispatch_block_t block = ^
        {
            [self sizeToFit];
            self.x -= self.width - (MENU_RIGHT_BAR_WIDTH + MENU_RIGHT_PADDING);
        };
        
        dispatch_async(dispatch_get_main_queue(), block);
    }

    return self;
}

- (void)dealloc
{
    self.background = nil;
    
    self.content = nil;
    self.tableView = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    switch(self.viewState)
    {
        case MenuViewState_ANIMATING_CLOSED:
        case MenuViewState_ANIMATING_OPEN:
            return;
            
        default:
            break;
    }
    
    CGPoint location = [gesture locationInView:self.superview];
    CGFloat velocity = [gesture velocityInView:self.superview].x;
    
    switch(gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            self.initialPointOnScreen = location;
            self.initialPointInView = [gesture locationInView:self];
            break;
            
        case UIGestureRecognizerStateChanged:
            location.x = location.x - self.initialPointInView.x;
            [self moveTo:location];
            break;
            
        case UIGestureRecognizerStateEnded:
            location.x = location.x - self.initialPointOnScreen.x;
            
            if(location.x < 0)
                location.x = -location.x;
            
            if(location.x > MINIMUM_MENU_PAN_DISTANCE)
            {
                switch(self.viewState)
                {
                    case MenuViewState_CLOSED:
                        location.x = 0;
                        break;
                        
                    case MenuViewState_OPEN:
                        location.x = MIN_X;
                        break;
                        
                    default:
                        return;
                }
            }
            
            [self animateMenu:velocity location:location.x close:(self.viewState == MenuViewState_OPEN)];
            self.initialPointOnScreen = self.initialPointInView = CGPointZero;
            break;
            
        default:
            break;
    }
}

- (void)moveTo:(CGPoint)location
{
    if(location.x > 0)
        location.x = 0;
    
    if(location.x < MIN_X)
        location.x = MIN_X;
    
    self.x = location.x;
}

- (void)animateMenu:(CGFloat)velocity location:(CGFloat)location close:(BOOL)close
{
    self.userInteractionEnabled = false;
    self.viewState = (close ? MenuViewState_ANIMATING_CLOSED : MenuViewState_ANIMATING_OPEN);
    
    if(velocity < 0)
        velocity = -velocity;
    
    CGFloat diff = location - self.x;
    
    if(close)
        diff = -diff;

    CGFloat duration = diff / velocity;
    
    if(duration > FAST_ANIMATION_SPEED || duration == 0)
        duration = FAST_ANIMATION_SPEED;
    
    [UIView animateWithDuration:duration animations:^
     {
         self.x = location;
     }
     completion:^(BOOL finished)
    {
        self.viewState = (close ? MenuViewState_CLOSED : MenuViewState_OPEN);
        self.userInteractionEnabled = true;
    }];
}

#pragma mark - Protected methods -

- (void)sizeToFit
{
    CGRect frame = self.frame;
    frame.size.width = MENU_WIDTH;
    frame.size.height = self.superview.height;
    self.frame = frame;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;
    
    self.background.frame = bounds;
    
    CGRect frame = bounds;
    frame.size.width -= MENU_RIGHT_BAR_WIDTH + MENU_RIGHT_PADDING;
    self.tableView.frame = frame;;
}

#pragma mark - Getter/Setter methods -

#pragma mark - UITableViewDataSource methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"menuCellID";
    
    MenuItem *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [MenuItem tableViewCell:cellID];
    }
    
    NSString *title = [self.content objectAtIndex:indexPath.row];
    cell.title = title;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self.delegate menu:self didSelectIndex:indexPath.row];
    
    [self animateMenu:0 location:MIN_X close:true];
}

@end
