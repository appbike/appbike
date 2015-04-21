//
//  Favorite.h
//  appbike
//
//  Created by Ashwin Jumani on 4/15/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSNumber * f_id;
@property (nonatomic, retain) NSString * f_title;
@property (nonatomic, retain) NSString * f_ishome;
@property (nonatomic, retain) NSString * f_latitude;
@property (nonatomic, retain) NSString * f_longitude;

@end
