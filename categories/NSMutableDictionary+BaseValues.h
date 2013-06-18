//
//  NSMutableDictionary+BaseValues.h
//  libgp
//
//  Created by mallarke on 4/12/13.
//  Copyright (c) 2013 givepulse, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (BaseValues)

- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setInt:(int)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;

- (void)setDate:(NSDate *)date forKey:(NSString *)key;

@end
