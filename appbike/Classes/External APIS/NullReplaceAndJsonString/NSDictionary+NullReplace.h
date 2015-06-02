//
//  NSDictionary+NullReplace.h
//  NSDictNullReplace
//
//  Created by Jaydip Patel on 27/03/15.
//  Copyright (c) 2015 CSPL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullReplace)
- (NSDictionary *)dictionaryByReplacingNullsWithBlanks;
@end
