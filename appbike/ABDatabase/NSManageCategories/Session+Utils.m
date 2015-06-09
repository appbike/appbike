//
//  Session+Utils.m
//  appbike
//
//  Created by Ashwin Jumani on 4/6/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import "Session+Utils.h"
#import "AppDelegate.h"

@implementation Session (Utils)

+ (Session *)getSessionWithId:(NSString *)sessionId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    //NSManagedObjectContext *context = [NSManagedObjectContext MR_context]
    
    Session *cart = [Session MR_findFirstByAttribute:@"s_id" withValue:sessionId inContext:context];
    
    return cart;
}

- (void)saveWithCompletion:(void (^)(BOOL saved))completion
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    Session *item = [Session getSessionWithId:self.s_id];
    if (!item)
    {
        item = [Session MR_createInContext:context];
        item.s_id = self.s_id;
    }
    
    item.s_id               = self.s_id;
    item.s_is_share         = self.s_is_share;
    item.s_avgkm            = self.s_avgkm;
    item.s_cal              = self.s_cal;
    item.s_end              = self.s_end;
    item.s_endlocation      = self.s_endlocation;
    item.s_json             = self.s_json;
    item.s_km               = self.s_km;
    item.s_start            = self.s_start;
    item.s_startlocation    = self.s_startlocation;
    item.s_visible          = self.s_visible;
    
    [context MR_saveWithOptions:MRSaveSynchronously completion:^(BOOL success, NSError *error) {
        NSLog(@"completion handler success : %d and error : %@",success,error.description);
        completion(success);
    }];
}


+ (Session *)getSessionWithItemId:(NSString *)itemId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    Session *cart = [Session MR_findFirstByAttribute:@"s_id" withValue:itemId inContext:context];
    return cart;
}

+ (Session *)findOrCreateById:(NSString *)cartId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    Session *cart = [Session getSessionWithId:cartId];
    
    if (!cart)
    {
        cart = [Session MR_createInContext:context];
        cart.s_id = cartId;
    }
    
    return cart;
}


+ (void)addItemToSession:(NSDictionary *)data
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    Session *cart = [Session getSessionWithId:[data objectForKey:@"id"]];
    if (!cart)
    {
        cart = [Session MR_createInContext:context];
        cart.s_id = [NSNumber numberWithInt:[self getMaxId]];
        //cart.s_start = [NSDate date];
        cart.s_start = [data objectForKey:@"start"];
        cart.s_end = [NSDate date];
        cart.s_json = [data objectForKey:@"json"];
        cart.s_is_share = [data objectForKey:@"is_share"];
        cart.s_cal = [NSNumber numberWithInt:[[data objectForKey:@"cal"] integerValue]];
        cart.s_km = [NSNumber numberWithInt:[[data objectForKey:@"km"] integerValue]];
        cart.s_avgkm = [NSNumber numberWithInt:[[data objectForKey:@"avgkm"] integerValue]];
        cart.s_visible = [NSNumber numberWithInt:1];
        cart.s_startlocation = appDelegate().strFromAddress;
        cart.s_endlocation = appDelegate().strToAddress;
        
    }else
    {
        cart.s_id = cart.s_id;
        cart.s_start = [data objectForKey:@"start"];
        cart.s_end = [NSDate date];
        cart.s_json = [data objectForKey:@"json"];
        cart.s_is_share = [data objectForKey:@"is_share"];
        cart.s_cal = [NSNumber numberWithInt:[[data objectForKey:@"cal"] integerValue]];
        cart.s_km = [NSNumber numberWithInt:[[data objectForKey:@"km"] integerValue]];
        cart.s_avgkm = [NSNumber numberWithInt:[[data objectForKey:@"avgkm"] integerValue]];
        cart.s_visible = [NSNumber numberWithInt:1];
        //cart.s_startlocation = @"Milano";
        //cart.s_endlocation = @"Como";
        cart.s_startlocation = appDelegate().strFromAddress;
        cart.s_endlocation = appDelegate().strToAddress;

        
        
    }
    
    [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if(contextDidSave)
        {
            NSLog(@"Saved success");
        }
        if(error)
        {
            NSLog(@"Error : %@",error.description);
        }

    }];
   // [context MR_saveOnlySelfWithCompletion:^(BOOL contextDidSave, NSError *error) {
     //      }];
    
}

+ (int)getMaxId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    NSArray *arrAllRecord = [Session MR_findAllInContext:context];
    NSNumber *max=[arrAllRecord valueForKeyPath:@"@max.s_id"];
    
    return [max integerValue] + 1;
}

//-(void)updateQuantityWithId:(NSString *)cartId :(NSString *)quantity
//{
//    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
//    Session *cart = [Session getSessionWithId:cartId];
//    cart.c_id = cart.c_id;
//    cart.c_instruction = cart.c_instruction;
//    cart.c_item_id = cart.c_item_id;
//    cart.c_quantity = [NSNumber numberWithInt:[quantity integerValue]];
//    cart.c_rest_id = cart.c_rest_id;
//    
//    [context MR_saveToPersistentStoreAndWait];
//}

- (void)removeItemFromSession
{
    [self MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


+ (NSArray *)getAllSessionItems
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    //DebugLog(@"%@",[Session MR_findAllInContext:context]);
    return [Session MR_findAllInContext:context];
}

+ (BOOL)removeAllSessionItems
{
    return [Session MR_truncateAll];
}

+ (NSArray *)findThisWeek
{
    NSDate *endDate = [NSDate date];
    NSDate *now = [NSDate date];
    NSDate *startDate = [now dateByAddingTimeInterval:-7*24*60*60];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(s_end >= %@) AND (s_start <= %@)", startDate, endDate];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    NSArray *arrThisWeek = [Session MR_findAllWithPredicate:predicate inContext:context];
    
    return arrThisWeek;
}

+ (NSArray *)findLastWeek
{
    NSDate *sevendayago = [NSDate date];
    NSDate *endDate = [sevendayago dateByAddingTimeInterval:-7*24*60*60];
    NSDate *now = [NSDate date];
    NSDate *startDate = [now dateByAddingTimeInterval:-14*24*60*60];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(s_end >= %@) AND (s_start <= %@)", startDate, endDate];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    NSArray *arrThisWeek = [Session MR_findAllWithPredicate:predicate inContext:context];
    
    return arrThisWeek;
}

@end
