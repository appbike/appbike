//
//  Session+Utils.m
//  appbike
//
//  Created by Ashwin Jumani on 4/6/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import "Session+Utils.h"

@implementation Session (Utils)

+ (Session *)getSessionWithId:(NSString *)sessionId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    //NSManagedObjectContext *context = [NSManagedObjectContext MR_context]
    
    Session *cart = [Session MR_findFirstByAttribute:@"s_id" withValue:sessionId inContext:context];
    
    return cart;
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
        cart.s_id = [NSString stringWithFormat:@"%d",[self getMaxId]];
        cart.s_start = [NSDate date];
        
    }else
    {
        cart.s_id = cart.s_id;
        cart.s_end = [NSDate date];
        cart.s_json = [data objectForKey:@"json"];
        cart.s_cal = [NSNumber numberWithInt:[[data objectForKey:@"cal"] integerValue]];
        cart.s_km = [NSNumber numberWithInt:[[data objectForKey:@"km"] integerValue]];
        cart.s_avgkm = [NSNumber numberWithInt:[[data objectForKey:@"avgkm"] integerValue]];
        cart.s_visible = [NSNumber numberWithInt:1];
        
        
    }
    
    [context MR_saveToPersistentStoreAndWait];
    
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

//+ (float)getGrandTotal
//{
//    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
//    NSArray *arrAllRecord = [Session MR_findAllInContext:context];
//    
//    float total = 0.0;
//    for (int i = 0; i < arrAllRecord.count; i ++)
//    {
//        Session *cart = (Session *)[arrAllRecord objectAtIndex:i];
//        Items *item = [Items getItemWithId:cart.c_item_id];
//        
//        if ([item.i_item_type_count intValue] > 0)
//        {
//            DebugLog(@"Sub id is %@", cart.c_item_subtype_id);
//            ItemSubType *subItem = [ItemSubType getItemWithId:cart.c_item_subtype_id];
//            total = total + ([cart.c_quantity integerValue] * [subItem.s_price floatValue]);
//            
//        }
//        else
//        {
//            DebugLog(@"item id is %@", cart.c_item_id);
//            total = total + ([cart.c_quantity integerValue] * [item.i_price floatValue]);
//            
//            
//        }
//        
//        
//    }
//    return total;
//}

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


@end
