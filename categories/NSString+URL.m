//
//  NSString+URL.m
//  GivePulse
//  Created by mallarke on 11/26/12.
//  Copyright (c) 2012 givepulse, inc. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString(URL)

- (NSURL *)url
{
    return [NSURL URLWithString:self];
}

- (NSURL *)encodedURL
{
    return [[self urlEncode] url];
}

- (NSString *)urlEncode
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
