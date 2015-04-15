//
//  BleManager.h
//  appbike
//
//  Created by Jacopo Pianigiani on 11/03/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

//Constants

#define BleManager_DEVICES_ID  [NSArray arrayWithObjects: @"Piaggio Bike 3827", @"Piaggio Bike 7357", @"Piaggio Bike 8356", @"Piaggio Bike 2413", nil]



@protocol  BleManagerDelegate;

@interface BleManager : NSObject

@property (nonatomic,assign) id<BleManagerDelegate> delegate;



-(void)startScanForBleDevices;

-(void)connectToDeviceWithId:(NSString *)deviceId andEnableKeyCode:(NSString*)enableKey;

-(void)getHeaderPacket;

- (void)stopSession;

- (void)saveSession;

@end



//Callback for delegate object to notify list of bluetooth devices founded and success for device connection

@protocol BleManagerDelegate <NSObject>

@optional
-(void)BleManagerDelegate:(BleManager*)bleManager onSupportedBleDevicesFounded:(NSArray*)devices;

@optional
-(void)BleManagerDelegate:(BleManager *)bleManager onBleDeviceConnectedWithStatus:(BOOL)status andCode:(NSString*)enableKey;

@optional
-(void)BleManagerDelegate:(BleManager *)bleManager sendSpeedValue:(NSInteger)speed andPower:(NSInteger)power;



@end

