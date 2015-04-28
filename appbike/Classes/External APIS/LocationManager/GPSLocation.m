//
//  MLDLocationManager.m
//  MyLimoTime
//
//  Created by Zaptech Solutions on 18/02/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "GPSLocation.h"
#import "AppDelegate.h"
#import "ConstantList.h"
#import <AddressBook/AddressBook.h>

@implementation GPSLocation

static GPSLocation *sharedManager;

+ (GPSLocation *)sharedManager
{
    @synchronized(self)
    {
        if (!sharedManager)
            sharedManager = [[GPSLocation alloc] init];
    }
    return sharedManager;
}

+(id)alloc
{
    @synchronized(self)
    {
        NSAssert(sharedManager == nil, @"Attempted to allocate a second instance of a singleton LocationController.");
        sharedManager = [super alloc];
    }
    return sharedManager;
}

- (id)init
{
    if (self = [super init])
    {
    
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=kCLDistanceFilterNone;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        if([CLLocationManager locationServicesEnabled] == NO){
            NSLog(@"service Disable");
        }
        [self.locationManager startUpdatingLocation];
        
        //self.locationManager.purpose    = kLocationManagerPurposeString;
        [self start];
    }
    return self;
}

- (void)start
{
    
    [self.locationManager startUpdatingLocation];
}

- (void)stop
{
    [self.locationManager stopUpdatingLocation];
}

- (BOOL)locationKnown
{
    if (round(currentLocation.speed) == -1)
        return NO;
    else
        return YES;
}

/**
 **     Return wether locationServices are enabled
 **/
- (BOOL)locationServiceEnabled
{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized))
    {
        return YES;
    }
    
    return NO;
}

/**
 **     Update current user's with the new location data
 **/
- (void)updateCurrentLocationToServer
{
    //#warning TODO : Call API for Update current location of current user if newlocation != currentlocation
    
    //NSArray *arrAllReservation = [Reservation getAllReservation];
    //if(arrAllReservation.count > 0)
    //{
      //  [self callAPIUpdateLocation];
    //}
}

- (void)getCaloryValue:(int)speed1
{
    
    double speed = speed1;
    // double user_age = 40;---- Currently static
    double user_weight = UserWeight;//------ Currently static
    double constant_cycle = ConstantCycle;//------ Currently static
    double constant_treadmill = ConstantTreadmill;//------ Currently static
    
    // Runtime Values
    double user_hr = 60.0 + speed * 1.2;
    // KM
    double user_elapsed = appDelegate().distanceKM;
    int total_distance = (int) (user_elapsed * speed);
    //
    double fitness_factor = user_hr * 0.1;
    
    // Joule=
    double joule = (((0.05 * constant_cycle) + 0.95) * user_weight + constant_treadmill)
				* total_distance * fitness_factor;
    // Calories=
    double Kcal = joule / 4186.8;
    
    if (Kcal < 0.0f)
        Kcal = 0;
    
    appDelegate().totalCalory = appDelegate().totalCalory + Kcal;
  
    self.sessionCalory = appDelegate().totalCalory;
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"Here new location update ");
    //if the time interval returned from core location is more than two minutes we ignore it because it might be from an old session
    //if ( abs([newLocation.timestamp timeIntervalSinceDate: [NSDate date]]) < 120)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateToLocation:fromLocation:)])
        {
            [self.delegate didUpdateToLocation:newLocation fromLocation:oldLocation];
        }
        self.currentLocation = newLocation;
        //CLLocationCoordinate2D testLocation = CLLocationCoordinate2DMake(23.83116508, 90.4218539);
        
        //self.currentLocation = [[CLLocation alloc] initWithLatitude:23.83116508 longitude:90.4218539];
        //[self updateCurrentLocationToServer];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations");
    CLLocation *newLocation = [locations firstObject];
    
    
    CLLocationDistance distanceChange = [newLocation getDistanceFrom:self.currentLocation];
    
    self.sessionDistance = self.sessionDistance + (distanceChange/1000);
    
    NSLog(@"Session Distance : %f",self.sessionDistance);
    
    self.currentLocation = newLocation;
    
    appDelegate().currentLocation = newLocation;
    if(appDelegate().strFromAddress == nil)
    {
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        appDelegate().fromLocation = newLocation;
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark * placemark in placemarks)
            {
                //.... = [placemark locality];
                
                appDelegate().strFromAddress = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressStreetKey];
                if(appDelegate().strFromAddress == nil)
                    appDelegate().strFromAddress = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressCityKey];
                NSLog(@"We have start address now : %@",appDelegate().strFromAddress);
                //self.lblFromAddress.text = appDelegate().strFromAddress;
            }
        }];
    }

    if(newLocation.speed > 1)
    {
        int speedCalc = newLocation.speed * 3.6f;
        [self getCaloryValue:speedCalc];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdateNotification object:newLocation];
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateToLocations:)])
//    {
//        [self.delegate didUpdateToLocations:locations];
//    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error in GPS Location");
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFailToUpdateLocation:)])
    {
        [self.delegate didFailToUpdateLocation:error];
    }

}



@end
