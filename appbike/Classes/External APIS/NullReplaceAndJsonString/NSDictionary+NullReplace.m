//
//  NSDictionary+NullReplace.m
//  NSDictNullReplace
//
//  Created by Jaydip Patel on 27/03/15.
//  Copyright (c) 2015 CSPL. All rights reserved.
//

#import "NSDictionary+NullReplace.h"
#import "NSArray+NullReplace.h"
@implementation NSDictionary (NullReplace)
- (NSDictionary *)dictionaryByReplacingNullsWithBlanks {
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id null = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        id object = [self objectForKey:key];
        if (object == null) [replaced setObject:blank forKey:key];
        else if ([object isKindOfClass:[NSDictionary class]]) [replaced setObject:[object dictionaryByReplacingNullsWithBlanks] forKey:key];
        else if ([object isKindOfClass:[NSArray class]]) [replaced setObject:[object arrayByReplacingNullsWithBlanks] forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:[replaced copy]];
}
@end
