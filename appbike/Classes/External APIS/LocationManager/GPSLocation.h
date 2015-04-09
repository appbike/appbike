//
//  MLDLocationManager.h
//  MyLimoTime
//
//  Created by Zaptech Solutions on 18/02/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class GPSLocation;

@protocol GPSLocationDelegate <NSObject>

@optional
- (void)didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation*)oldLocation;
- (void)didFailToUpdateLocation :(NSError *)error;
- (void)didUpdateToLocations:(NSArray *)locations;
@end

@interface GPSLocation : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

+ (GPSLocation *)sharedManager;

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) id<GPSLocationDelegate> delegate;

@property (nonatomic) BOOL isAviationCalled;
@property (nonatomic) double sessionDistance;
@property (nonatomic) double sessionCalory;

- (void)start;
- (void)stop;
- (BOOL)locationKnown;
- (BOOL)locationServiceEnabled;

@end
