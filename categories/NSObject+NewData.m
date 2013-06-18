//
//  NSObject+NewData.m
//  libgp
//
//  Created by Jeremiah Smith on 8/18/12.
//  Copyright (c) 2012 givepulse, inc. All rights reserved.
//

#import "NSObject+NewData.h"

@implementation NSObject (NewData)

+ (id)object
{
    return [[self new] autorelease];
}

@end
