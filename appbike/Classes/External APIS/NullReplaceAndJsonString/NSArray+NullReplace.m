//
//  NSArray+NullReplace.m
//  NSDictNullReplace
//
//  Created by Jaydip Patel on 27/03/15.
//  Copyright (c) 2015 CSPL. All rights reserved.
//

#import "NSArray+NullReplace.h"
#import "NSDictionary+NullReplace.h"


@implementation NSArray (NullReplace)

- (NSArray *)arrayByReplacingNullsWithBlanks  {
    NSMutableArray *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    for (int idx = 0; idx < [replaced count]; idx++) {
        id object = [replaced objectAtIndex:idx];
        if (object == nul) [replaced replaceObjectAtIndex:idx withObject:blank];
        else if ([object isKindOfClass:[NSDictionary class]]) [replaced replaceObjectAtIndex:idx withObject:[object dictionaryByReplacingNullsWithBlanks]];
        else if ([object isKindOfClass:[NSArray class]]) [replaced replaceObjectAtIndex:idx withObject:[object arrayByReplacingNullsWithBlanks]];
    }
    return [replaced copy];
}

- (NSData *)MakeJsonStringFromArray:(NSArray *)DataArray Mangedobjectname:(NSManagedObject *)objectname
{
    NSMutableArray *arrAddActivity=[[NSMutableArray alloc]init];
    
    for (int i=0; i<DataArray.count; i++) {
        
        objectname=[DataArray objectAtIndex:i];
        
        NSEntityDescription *entity = [objectname entity];
        
        NSDictionary *attributes = [entity attributesByName];
        
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        
        for (NSString *attributeName in attributes) {
            id value = [objectname valueForKey:attributeName];
            if (value != nil) {
                [dict setValue:value forKey:attributeName];
            }
        }
        
        [arrAddActivity addObject:dict];
    }
    
    
    NSError *err=nil;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arrAddActivity options:NSJSONWritingPrettyPrinted error:&err];
    //NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonData as string:\n%@", jsonString);
    
    //return jsonString;
    return jsonData2;
    
}

@end
