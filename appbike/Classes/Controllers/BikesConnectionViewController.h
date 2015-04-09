//
//  BikesConnectionViewController.h
//  appbike
//
//  Created by Jacopo Pianigiani on 11/03/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BleManager.h"


//View controller constants

#define BikesConnectionViewController_LICENSE_PROTOCOL @"checklicense"

#define BikesConnectionViewController_LICENSE_ACCEPTED @"ConditionsAccepted"

#define BikesConnectionViewController_PIAGGIO_LOGO @"NewLogo.png"


#define BikesConnectionViewController_PADDING_FROM_TOP 20.0f;

#define BikesConnectionViewController_PADDING_HORIZONTAL 40.0f

#define BikesConnectionViewController_LABEL_HEIGHT 35.0f


#define BikesConnectionViewController_LABEL_TEXT @"Help"

#define BikesConnectionViewController_NO_BIKES_MESSAGE @"No bikes has been founded"


//Ble devices view constants

#define BleDevicesView_ACTIVITY_INDICATOR_HEIGHT 40.0f

#define BleDevicesView_ACITIVITY_INDICATOR_WIDTH 40.0f

#define BleDevicesView_HORIZONTAL_PADDING 20.0f

#define BleDevicesView_PROGRESS_LABEL_HEIGHT 20.0f

#define BleDevicesView_PROGRESS_LABEL_WIDTH 200.0f

#define BleDevicesView_SCAN_STATUS [NSArray arrayWithObjects:@"Discover Bluetooth Active...", @"Select your Piaggio Bike", @"No bike found", @"Verify your Bluetooth Connection", nil]

#define BleDevicesView_PADDING_FROM_BOTTOM 25.0f

#define BleDevicesView_PADDING_FROM_TOP 40.0f


#define BleDevicesView_SPACE_BETWEEEN_TABLE_ROWS 10.0f

#define BleDeviceView_CELL_ID @"bikeCell"

#define BleDevicesVew_CELLS_HEIGHT 40.0f;


#define BleDevicesView_CONNECT_STRING @"Connect"

#define BleDevicesView_CONNECTING_STRING @"Connecting..."

#define BleDevicesView_INSERT_CODE_STRING @"Insert here your Code"



//Responsible to: show user licence, discover ble supported devices and connect with one of they

@interface BikesConnectionViewController : UIViewController

@property (nonatomic,strong) UIImageView *piaggioLogo;

@property (nonatomic,strong) UILabel *helpLabel;

@property (nonatomic,strong) NSString *bikeIdSelected;

@end


@protocol BleDeviceViewDelegate;


@interface BleDevicesView : UIView

@property (nonatomic,strong) NSMutableArray *bikes; //It will contain devices once they are discovered

@property (nonatomic,assign) id<BleDeviceViewDelegate> delegate;

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;


-(void)insertBikeWithId:(NSString*)bikeId;
-(void)stopDiscoveringAnimation;

-(void)updateProgressLabelWithValue:(NSString*)value;

+(UIColor*)getBluetoothBikesViewColor;


@end


//Used to communicate between view and controller
@protocol BleDeviceViewDelegate <NSObject>

@optional
-(void)BleDevicesView:(BleDevicesView*)bleDevicesView onSelectedBluetoothBikeWithIndex:(NSUInteger)index; //Notify to delegate tap on a bike button

@optional
-(void)BleDeviceView:(BleDevicesView*) bleDevicesView onEnableKeyCodeInsertedWithValue:(NSString*)enableKeyValue;

@end