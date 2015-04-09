//
//  SessionManager.h
//  appbike
//
//  Created by Ashwin Jumani on 4/9/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SessionManager : NSObject
{

}

//Public Variable for Session
@property (nonatomic) BOOL sessionActive;
@property (nonatomic) float activityDurationSeconds;
@property (nonatomic) float totalDistance;
@property (nonatomic) float totalCalories;
@property (nonatomic) float sessionDurationSeconds;
@property (nonatomic,strong) NSMutableDictionary *Monitors;


+ (SessionManager *)sharedManager;


@end