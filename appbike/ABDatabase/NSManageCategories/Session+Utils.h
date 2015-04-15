//
//  Session+Utils.h
//  appbike
//
//  Created by Ashwin Jumani on 4/6/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "Session.h"

@interface Session (Utils)

+ (Session *)findOrCreateById:(NSString *)cartId;
+ (Session *)getSessionWithId:(NSString *)cartId;
+ (void)addItemToSession:(NSDictionary *)data;
+ (NSArray *)getAllSessionItems;
+ (BOOL)removeAllSessionItems;
+ (int)getMaxId;
+ (float)getGrandTotal;
- (void)removeItemFromSession;
-(void)updateQuantityWithId:(NSString *)cartId :(NSString *)quantity;

@end
