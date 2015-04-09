//
//  TopStatusBar.h
//  appbike
//
//  Created by  Zaptech Solutions on 1/12/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABBatteryInformation : UIView

@property (nonatomic, strong) UIButton *btnBatterStatus;
@property (nonatomic, strong) UIButton *btnMenu;

@property (nonatomic, strong) UILabel  *lblMenu;
@property (nonatomic, strong) UILabel  *lblBatterMeter;
@property (nonatomic, strong) UILabel  *lblBatterKM;


//Method declaration
- (void) setMenuName:(NSString *)strMenuName;
- (void) setBatteryLevel;
- (void) setBatteryLevel:(NSDictionary *)parameter;
- (void) updateBetterToZero;
@end
