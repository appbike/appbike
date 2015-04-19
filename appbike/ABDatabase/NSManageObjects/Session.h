//
//  Session.h
//  appbike
//
//  Created by Ashwin Jumani on 4/6/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Session : NSManagedObject

@property (nonatomic, retain) NSNumber * s_id;
@property (nonatomic, retain) NSDate * s_start;
@property (nonatomic, retain) NSDate * s_end;
@property (nonatomic, retain) NSString * s_json;
@property (nonatomic, retain) NSNumber * s_cal;
@property (nonatomic, retain) NSNumber * s_km;
@property (nonatomic, retain) NSNumber * s_avgkm;
@property (nonatomic, retain) NSNumber * s_visible;
@property (nonatomic, retain) NSString * s_startlocation;
@property (nonatomic, retain) NSString * s_endlocation;

@end
