//
//  MapViewViewController.h
//  appbike
//
//  Created by  Zaptech Solutions on 16/01/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "GPSLocation.h"

@interface ABMapVC : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,GPSLocationDelegate,CLLocationManagerDelegate>

@end
