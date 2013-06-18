//
//  NSString+URL.h
//  GivePulse
//  Created by mallarke on 11/26/12.
//  Copyright (c) 2012 givepulse, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

- (NSURL *)url;
- (NSURL *)encodedURL;

- (NSString *)urlEncode;

@end
