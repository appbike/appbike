//
//  DashBoardViewController.h
//  Apparound
//
//  Created by  Zaptech Solutions on 09/01/15.
//  Copyright (c) 2015 zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GPSLocation.h"
#import "BleManager.h"

@interface ABDashBoardVC : UIViewController<UIGestureRecognizerDelegate,GPSLocationDelegate,UIPageViewControllerDelegate,CLLocationManagerDelegate,BleManagerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end
