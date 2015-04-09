//
//  SessionManager.h
//  appbike
//
//  Created by Ashwin Jumani on 4/9/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager

static SessionManager *sharedManager;

+ (SessionManager *)sharedManager
{
    @synchronized(self)
    {
        if (!sharedManager)
            sharedManager = [[SessionManager alloc] init];
    }
    return sharedManager;
}

+(id)alloc
{
    @synchronized(self)
    {
        NSAssert(sharedManager == nil, @"Attempted to allocate a second instance of a singleton LocationController.");
        sharedManager = [super alloc];
    }
    return sharedManager;
}

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

@end