//
//  AppDelegate.h
//  appbike
//com.zaptechsolutions.appbike
//  Created by  Zaptech Solutions on 1/9/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABMenuVC.h"
#import <MessageUI/MessageUI.h>
#import "SWRevealViewController.h"
#import "BleManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,SwrevealDegate,CLLocationManagerDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

//Location Shared Data (Routes, Addresses and Coordinates)
@property (strong, nonatomic) NSString *strDestination;
@property (nonatomic, strong) NSString *strFromAddress;
@property (nonatomic, strong) NSString *strToAddress;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* fromLocation;
@property (nonatomic, strong) CLLocation* toLocation;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) CLLocation* distanceLocation;
@property (nonatomic, strong) NSMutableArray *arrRoutes;
@property (nonatomic, retain) NSMutableArray *arrayCoords;
@property (nonatomic, strong) NSData *userProfileImage;
@property (nonatomic, strong) NSString *strLog;
@property (nonatomic, strong) NSDictionary *dictSkinData;
@property (nonatomic, strong) NSDictionary *dictConstantData;
@property (nonatomic, strong) NSDictionary *dictCounterData;
@property (nonatomic, strong) NSDictionary *dictDashboardData;
@property (nonatomic, strong) NSDictionary *dictKMHData;
@property (nonatomic, strong) NSDictionary *dictCaloriesData;

@property (nonatomic) long iRemainingKM;
@property (nonatomic) int totalCalory;
@property (nonatomic) double distanceKM;
@property (nonatomic) int incrementIndex;

@property (nonatomic) BOOL isSessionStart;

@property (nonatomic,strong) SWRevealViewController *menuSlider;

+ (AppDelegate *)sharedInstance;
- (void)openCloseMenu;
- (CLLocationSpeed) getCurrentSpeed;
- (void)gotoMap;
- (void)addToLog:(NSString *)string;
- (UIColor *)toUIColor:(NSString *)ColorStr;

@end

// Convience Constructor for App Delegate
AppDelegate *appDelegate(void);