//
//  Favorite+Utils.h
//  appbike
//
//  Created by Ashwin Jumani on 4/21/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "Favorite.h"

@interface Favorite (Utils)

+ (Favorite *)findOrCreateById:(NSString *)cartId;
+ (Favorite *)getFavoriteWithId:(NSString *)cartId;
+ (void)addItemToFavorite:(NSDictionary *)data;
+ (NSArray *)getAllFavoriteItems;
+ (BOOL)removeAllFavoriteItems;
+ (int)getMaxId;
- (void)removeItemFromFavorite;

@end
