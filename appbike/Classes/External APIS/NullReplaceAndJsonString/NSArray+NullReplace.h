//
//  NSArray+NullReplace.h
//  NSDictNullReplace
//
//  Created by Jaydip Patel on 27/03/15.
//  Copyright (c) 2015 CSPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSArray (NullReplace)
- (NSArray *)arrayByReplacingNullsWithBlanks;
-(NSData *)MakeJsonStringFromArray:(NSArray *)DataArray Mangedobjectname:(NSManagedObject *)objectname;
@end
