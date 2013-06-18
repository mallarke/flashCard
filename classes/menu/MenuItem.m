//
//  MenuItem.m
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "MenuItem.h"

#pragma mark - MenuItem extension -

@interface MenuItem()

@property (retain) UILabel *label;
@property (retain) UIView *divider;

@end

#pragma mark - MenuItem implementation

@implementation MenuItem

#pragma mark - Constructor/Destructor methods -

- (id)initTableViewCell:(NSString *)reuseID
{
    self = [super initTableViewCell:reuseID];

    if(self) 
	{
        self.label = [UILabel object];
        self.label.font = kCondensedBoldFont(16);
        self.label.backgroundColor = CLEAR_COLOR;
        self.label.textColor = WHITE_COLOR;
        [self addSubview:self.label];
        
        self.divider = [UIView object];
        self.divider.backgroundColor = MENU_ITEM_DIVIDER_COLOR;
        [self addSubview:self.divider];
    }

    return self;
}

- (void)dealloc
{
    self.label = nil;
    self.divider = nil;
    
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
    
    CGRect frame = bounds;
    frame.origin.x = MENU_ITEM_TEXT_PADDING;
    frame.size.width -= MENU_ITEM_TEXT_PADDING * 2;
    self.label.frame = frame;
    
    frame = CGRectZero;
    frame.origin.y = maxSize.height - DIVIDER_HEIGHT;
    frame.size.width = maxSize.width;
    frame.size.height = DIVIDER_HEIGHT;
    self.divider.frame = frame;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setSelected:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.divider.backgroundColor = MENU_ITEM_DIVIDER_COLOR;
}

#pragma mark - Getter/Setter methods -

- (NSString *)title
{
    return self.label.text;
}

- (void)setTitle:(NSString *)title
{
    self.label.text = title;
}

@end

