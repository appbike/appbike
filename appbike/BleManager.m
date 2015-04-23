//
//  BleManager.m
//  appbike
//
//  Created by Jacopo Pianigiani on 11/03/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "BleManager.h"
#import "Session+Utils.h"

@interface BleManager ()

@property (nonatomic,strong) NSArray *bleDevicesFounded;

@property (nonatomic,strong) NSString *selectedDevice; //Will contain id of selected item

@property (nonatomic,strong) NSTimer *timer;

@end


@implementation BleManager

@synthesize timer = _timer;


-(NSTimer*)timer{
    if(!_timer){
        
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(sendBroadcastHeaderMessage) userInfo:nil repeats:YES];
         _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendBroadcastHeaderMessage) userInfo:nil repeats:YES];
    
    }
    
    return _timer;

}


#pragma mark - instance methods

-(void)startScanForBleDevices{
    
    self.bleDevicesFounded = [[NSArray alloc] initWithArray:
    [NSArray arrayWithObjects:BleManager_DEVICES_ID[0], BleManager_DEVICES_ID[1], BleManager_DEVICES_ID[2], BleManager_DEVICES_ID[3], nil]];
    
    
    sleep(2); //Simulate device scanning
    
    
    //Notify to delegate if it responds to selector
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(BleManagerDelegate:onSupportedBleDevicesFounded:)]){
        
        [self.delegate BleManagerDelegate:self onSupportedBleDevicesFounded:self.bleDevicesFounded];
    }

}



-(void)connectToDeviceWithId:(NSString *)deviceId andEnableKeyCode:(NSString*)enableKey{
    
    //First check if device has been founded
    
    BOOL deviceFounded = false;
    
    for(NSString *id in self.bleDevicesFounded){
        if([id isEqualToString:deviceId]){
            
            deviceFounded = true;
            break;
        
        }
    
    }
    
    //sleep(1); //Simulate connection to device delay
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(BleManagerDelegate:onBleDeviceConnectedWithStatus:andCode:)]){
        
        [self.delegate BleManagerDelegate:self onBleDeviceConnectedWithStatus:YES andCode:enableKey]; //Notify to delegate estabilished connection between two devices and enable key
        
    }

}

//Get every 2 seconds update for speed and power
-(void)getHeaderPacket{

    //[self sendBroadcastHeaderMessage];
    [self.timer fire];
    
}


//New method added for stop current session - Added by Phase2
- (void)stopSession
{
    [self.timer invalidate];
    self.timer = nil;
    //Set timer for next iteration
    //_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendBroadcastHeaderMessage) userInfo:nil repeats:YES];
}

//New method added - Phase 2
- (void)saveSession:(NSDictionary *)finalDictionary
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if(error)
    {
        NSLog(@"save data error : %@",error.description);
    }
    else
    {
        int newId = [Session getMaxId];
        Session *thisSession = [Session findOrCreateById:[NSString stringWithFormat:@"%d",newId]];
        
    }
    
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}

#pragma mark - messaege header broadcast

-(void)sendBroadcastHeaderMessage{
    
    NSNotification *notification = [[NSNotification alloc] initWithName:@"headerPacket" object:[BleManager generateHeaderPacket] userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}


+(NSMutableDictionary*)generateHeaderPacket{
    NSMutableDictionary *headerPacket = [[NSMutableDictionary alloc] init];
    
    NSInteger speed = arc4random() % 100;
    //NSInteger power = arc4random() % 100;

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:speed] forKey:@"Speed"];
    
    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"Distance"];
    
    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"DistanceSession"];
    
    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"Calories"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"AvgSpeed"];
    
    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"HB"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"Autonomy"];
    
    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"AutonomyDistance"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"Life"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"Soc"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%10] forKey:@"Torque"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"Frequency"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"Voltage"];

    
    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"Current"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"Energy"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"Dsb"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"Errors"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"Light"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"M2M"];

    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%100] forKey:@"GearBox"];
    
    [headerPacket setObject:[NSNumber numberWithUnsignedInteger:arc4random()%1000] forKey:@"ActivityDurationSeconds"];
    
    return headerPacket;
    
}


@end