//
//  NSDictionary+BaseValues.m
//  libgp
//
//  Created by mallarke on 5/10/13.
//  Copyright (c) 2013 givepulse, inc. All rights reserved.
//

#import "NSDictionary+BaseValues.h"

@implementation NSDictionary (BaseValues)

- (BOOL)boolForKey:(NSString *)key
{
    return [[self valueForKey:key] boolValue];
}

- (int)intForKey:(NSString *)key
{
    return [[self valueForKey:key] intValue];
}

- (float)floatForKey:(NSString *)key
{
    return [[self valueForKey:key] floatValue];
}

- (double)doubleForKey:(NSString *)key
{
    return [[self valueForKey:key] doubleValue];
}

- (NSDate *)dateForKey:(NSString *)key
{
    NSTimeInterval interval = [self doubleForKey:key];
    
    if(interval == 0)
    {
        return nil;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

@end
