//
//  main.m
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        int retVal = -1;
        
        @try
        {
            retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *exception)
        {
            NSLog(@"*** Terminating app due to uncaught exception: %@", [exception reason]);
            NSLog(@"Stack trace: %@", [exception callStackSymbols]);
            [exception raise];
        }
        
        return retVal;
    }
}
