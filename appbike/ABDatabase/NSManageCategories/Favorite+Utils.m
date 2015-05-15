//
//  Favorite+Utils.m
//  appbike
//
//  Created by Ashwin Jumani on 4/21/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import "Favorite+Utils.h"

@implementation Favorite (Utils)


+ (Favorite *)getFavoriteWithTitle:(NSString *)sessionId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    //NSManagedObjectContext *context = [NSManagedObjectContext MR_context]
    
    Favorite *cart = [Favorite MR_findFirstByAttribute:@"f_title" withValue:sessionId inContext:context];
    
    return cart;
}

+ (Favorite *)getFavoriteWithId:(NSString *)sessionId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    //NSManagedObjectContext *context = [NSManagedObjectContext MR_context]
    
    Favorite *cart = [Favorite MR_findFirstByAttribute:@"f_id" withValue:sessionId inContext:context];
    
    return cart;
}

+ (Favorite *)getFavoriteWithItemId:(NSString *)itemId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    Favorite *cart = [Favorite MR_findFirstByAttribute:@"f_id" withValue:itemId inContext:context];
    return cart;
}

+ (Favorite *)findOrCreateById:(NSString *)cartId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    Favorite *cart = [Favorite getFavoriteWithId:cartId];
    
    if (!cart)
    {
        cart = [Favorite MR_createInContext:context];
        cart.f_id = cartId;
    }
    
    return cart;
}


- (void)saveWithCompletion:(void (^)(BOOL saved))completion
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    Favorite *item = [Favorite getFavoriteWithId:self.f_id];
    if (!item)
    {
        item = [Favorite MR_createInContext:context];
        item.f_id = self.f_id;
    }
    
    item.f_id               = self.f_id;
    item.f_ishome           = self.f_ishome;
    item.f_title            = self.f_title;
    item.f_latitude         = self.f_latitude;
    item.f_longitude        = self.f_longitude;
    
    [context MR_saveWithOptions:MRSaveSynchronously completion:^(BOOL success, NSError *error) {
        NSLog(@"completion handler success : %d and error : %@",success,error.description);
        completion(success);
    }];
}

+ (void)addItemToFavorite:(NSDictionary *)data
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    Favorite *cart = [Favorite getFavoriteWithTitle:[data objectForKey:@"title"]];
    if (!cart)
    {
        cart = [Favorite MR_createInContext:context];
        cart.f_id = [NSNumber numberWithInt:[self getMaxId]];
        //cart.s_start = [NSDate date];
        cart.f_ishome = [data objectForKey:@"ishome"];
        cart.f_latitude = [data objectForKey:@"latitude"];
        cart.f_longitude = [data objectForKey:@"longitude"];
        
        cart.f_title = [data objectForKey:@"title"];
        
        

    }else
    {
       
        cart.f_id = cart.f_id;
        //cart.s_start = [NSDate date];
        cart.f_ishome = [data objectForKey:@"ishome"];
        cart.f_title = [data objectForKey:@"title"];
        cart.f_latitude = [data objectForKey:@"latitude"];
        cart.f_longitude = [data objectForKey:@"longitude"];
     
//        NSString *isHome = [data objectForKey:@"ishome"];
//        if([isHome isEqualToString:@"yes"])
//        {
//            NSArray *arrHome = [Favorite getHomeFavorite];
//            if(arrHome.count > 0)
//            {
//                Favorite *thisHome = (Favorite *) [arrHome firstObject];
//                thisHome.f_ishome = @"no";
//                thisHome.f_title = thisHome.f_title;
//                thisHome.f_latitude = thisHome.f_latitude;
//                thisHome.f_longitude = thisHome.f_longitude;
//                thisHome.f_id = thisHome.f_id;
//                [thisHome saveWithCompletion:^(BOOL saved) {
//                    if (saved)
//                    {
//                        NSLog(@"Saved successfully");
//                    }
//                }];
//            }
//        }
    }
    
    
    [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if(contextDidSave)
        {
            NSLog(@"Saved success");
            NSString *isHome = [data objectForKey:@"ishome"];
            if([isHome isEqualToString:@"yes"])
            {
                NSArray *arrHome = [Favorite getHomeFavorite];
                if(arrHome.count > 0)
                {
                    for(int i=0; i < arrHome.count; i++)
                    {
                        Favorite *thisHome = (Favorite *) [arrHome objectAtIndex:i];
                        if(![thisHome.f_title isEqualToString:[data objectForKey:@"title"]])
                        {
                            thisHome.f_ishome = @"no";
                            thisHome.f_title = thisHome.f_title;
                            thisHome.f_latitude = thisHome.f_latitude;
                            thisHome.f_longitude = thisHome.f_longitude;
                            thisHome.f_id = thisHome.f_id;
                            [thisHome saveWithCompletion:^(BOOL saved) {
                                if (saved)
                                {
                                    NSLog(@"Saved successfully");
                                }
                            }];
                        }
                    }
                }
            }

        }
        if(error)
        {
            NSLog(@"Error : %@",error.description);
        }
        
    }];
    
//    [context MR_saveOnlySelfWithCompletion:^(BOOL contextDidSave, NSError *error) {
//        if(contextDidSave)
//        {
//            NSLog(@"Saved success");
//            
//            NSString *isHome = [data objectForKey:@"ishome"];
//            if([isHome isEqualToString:@"yes"])
//            {
//                NSArray *arrHome = [Favorite getHomeFavorite];
//                if(arrHome.count > 0)
//                {
//                    for(int i=0; i < arrHome.count; i++)
//                    {
//                        Favorite *thisHome = (Favorite *) [arrHome objectAtIndex:i];
//                        if(![thisHome.f_title isEqualToString:[data objectForKey:@"title"]])
//                        {
//                            thisHome.f_ishome = @"no";
//                            thisHome.f_title = thisHome.f_title;
//                            thisHome.f_latitude = thisHome.f_latitude;
//                            thisHome.f_longitude = thisHome.f_longitude;
//                            thisHome.f_id = thisHome.f_id;
//                            [thisHome saveWithCompletion:^(BOOL saved) {
//                                if (saved)
//                                {
//                                    NSLog(@"Saved successfully");
//                                }
//                            }];
//                        }
//                    }
//                }
//            }
//
//        }
//        if(error)
//        {
//            NSLog(@"Error : %@",error.description);
//        }
//    }];
    
}

+ (int)getMaxId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    NSArray *arrAllRecord = [Favorite MR_findAllInContext:context];
    NSNumber *max=[arrAllRecord valueForKeyPath:@"@max.f_id"];
    
    return [max integerValue] + 1;
}

- (void)removeItemFromFavorite
{
    [self MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


+ (NSArray *)getAllFavoriteItems
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];

    return [Favorite MR_findAllInContext:context];
}

+ (BOOL)removeAllFavoriteItems
{
    return [Favorite MR_truncateAll];
}

// ------------------------- Get Item -------------------------
+ (NSArray *)getHomeFavorite
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"f_ishome == 'yes'"];
    
    NSArray *arrCheckIns = [Favorite MR_findAllWithPredicate:pre inContext:context];
    
    return arrCheckIns;
}

+ (NSArray *)getOtherFavorite
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"f_ishome == 'no'"];
    
    NSArray *arrCheckIns = [Favorite MR_findAllWithPredicate:pre inContext:context];
    
    return arrCheckIns;
}



@end
