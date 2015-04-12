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
#import "ConstantList.h"
#import "REFrostedViewController.h"

@interface ABDashBoardVC : UIViewController<UIGestureRecognizerDelegate,GPSLocationDelegate,UIPageViewControllerDelegate,CLLocationManagerDelegate,BleManagerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic) SelectedSensorType currentSelectedSensorType;

- (IBAction)showLeftMenu:(id)sender;

@end
