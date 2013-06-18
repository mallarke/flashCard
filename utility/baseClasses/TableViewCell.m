//
//  TableViewCell.m
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "TableViewCell.h"

#pragma mark - TableViewCell extension -

@interface TableViewCell()

@end

#pragma mark - TableViewCell implementation

@implementation TableViewCell

#pragma mark - Constructor/Destructor methods -

- (id)initTableViewCell:(NSString *)reuseID
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    return self;
}

+ (id)tableViewCell:(NSString *)reuseID
{
    return [[[self alloc] initTableViewCell:reuseID] autorelease];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

@end

