//
//  TopStatusBar.m
//  appbike
//
//  Created by Zaptech Solutions 1/12/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABBatteryInformation.h"
#import "AppDelegate.h"
#import "ApplicationData.h"
#import "ConstantList.h"

@implementation ABBatteryInformation

//------------------------------------------------------------------------

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.backgroundColor = [UIColor colorWithRed:232/255.0f green:236/255.0f blue:245/255.0f alpha:1.0f];
//        _btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.btnMenu setFrame:CGRectMake(0, 2, 40, 38)];
//        [self.btnMenu setImage:[UIImage imageNamed:@"navigation_bar_menu_icon.png"] forState:UIControlStateNormal];
//        [self addSubview:self.btnMenu];
        
//        _lblMenu = [[UILabel alloc] initWithFrame:CGRectMake(50, 2, 150, 38)];
//        //[self.lblMenu setTextColor:kBlueThemeColor];
//        [self.lblMenu setTextColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"titleWindowColor"]]];
//        [self addSubview:self.lblMenu];
 
        CGRect screen = [[UIScreen mainScreen]bounds];
    
        _lblBatterMeter = [[UILabel alloc] initWithFrame:CGRectMake(215, 5, 75, 38)];//CGRectMake(215, 10, 75, 38)
        
        [self.lblBatterMeter setTextAlignment:NSTextAlignmentRight];
        [self.lblBatterMeter setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        //[self.lblBatterMeter setFont:[UIFont systemFontOfSize:22]];
        [self.lblBatterMeter setFont:[UIFont fontWithName:@"Roboto-Bold" size:22]];
        [self.lblBatterMeter setAdjustsFontSizeToFitWidth:YES];
        [self.lblBatterMeter setMinimumScaleFactor:0.5];
        [self.lblBatterMeter setTextColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"titleWindowColor"]]];
        [self addSubview:self.lblBatterMeter];
        
        _btnBatterStatus = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnBatterStatus setUserInteractionEnabled:NO];
               //[self.btnBatterStatus setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        //[self.btnBatterStatus setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        //[self.btnBatterStatus setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.btnBatterStatus];
        
        _lblBatterKM = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 75, 38)];
        [self.lblBatterKM setTextAlignment:NSTextAlignmentRight];
        [self.lblBatterKM setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [self.lblBatterKM setFont:[UIFont fontWithName:@"Roboto-Bold" size:22]];
        [self.lblBatterKM setAdjustsFontSizeToFitWidth:YES];
        [self.lblBatterKM setMinimumScaleFactor:0.5];
        [self.lblBatterKM setTextColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"titleWindowColor"]]];
        [self addSubview:self.lblBatterKM];
        
        if(IS_IPHONE_6_PLUS)
        {
            [self.btnBatterStatus setFrame:CGRectMake(150, 5, 115, 41)];
            _lblBatterMeter.frame = CGRectMake(280, 5, 80, 38);
            _lblBatterKM.frame = CGRectMake(50, 5, 75, 38);
        }
        else if(IS_IPHONE_6)
        {
            [self.btnBatterStatus setFrame:CGRectMake(125, 5, 115, 41)];
            _lblBatterMeter.frame = CGRectMake(260, 5, 80, 38); //Need to test
            _lblBatterKM.frame = CGRectMake(35, 5, 75, 38);
        }
        else
        {
            [self.btnBatterStatus setFrame:CGRectMake(100, 5, 115, 41)];
        }


    }
    return self;
}

//------------------------------------------------------------------------

- (void) setMenuName:(NSString *)strMenuName
{
    [self.lblMenu setText:strMenuName];
}

//------------------------------------------------------------------------

- (void) setBatteryLevel:(NSDictionary *)parameter
{
    
   // [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    //float batteryLevel = [[UIDevice currentDevice] batteryLevel];
    
    //batteryLevel *= 100;
    float batteryLevel = [[parameter objectForKey:@"Autonomy"] floatValue];
    
    if(batteryLevel < 0)
        batteryLevel = 100; //for simulator
    
    // double speedCalc = 0.0;
    NSString *strBatteryimage = @"battery3";
    
    if(batteryLevel >=85)
    {
        strBatteryimage = @"battery6";
    }
    else if(batteryLevel>=70 && batteryLevel<=84)
    {
        strBatteryimage = @"battery5";
    }
    else if (batteryLevel>=55 && batteryLevel<=69)
    {
        strBatteryimage = @"battery4";
    }
    else if (batteryLevel >= 40 && batteryLevel <=54)
    {
        strBatteryimage = @"battery3";
    }
    else if (batteryLevel >= 25 && batteryLevel <=39)
    {
        strBatteryimage = @"battery2";
    }
    else if (batteryLevel >= 10 && batteryLevel <=24)
    {
        strBatteryimage = @"battery1";
    }
    else if (batteryLevel >= 0 && batteryLevel <=9)
    {
        strBatteryimage = @"battery0";
    }
  
    
    int strBattery = [[parameter objectForKey:@"AutonomyDistance"] intValue];
    strBattery = strBattery * 1000;
    [self.lblBatterKM setText:[NSString stringWithFormat:@"%.0f%%",batteryLevel]];
    NSString *strBatteryMeter = [NSString stringWithFormat:@"%d km",strBattery];
    [self.lblBatterMeter setText:strBatteryMeter];
    
    //[self.btnBatterStatus setImage:[UIImage imageNamed:strBatteryimage] forState:UIControlStateNormal];
    [self.btnBatterStatus setBackgroundImage:[UIImage imageNamed:strBatteryimage] forState:UIControlStateNormal];
    
    NSString *strBatteryNew = [NSString stringWithFormat:@"%d",strBattery];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.lblBatterMeter.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.lblBatterMeter.font.pointSize]} range:[self.lblBatterMeter.text rangeOfString:strBatteryNew]];
    self.lblBatterMeter.attributedText = attributedText;
    
    NSMutableAttributedString *attributedText1 = [[NSMutableAttributedString alloc] initWithString:self.lblBatterKM.text];
    [attributedText1 setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.lblBatterMeter.font.pointSize]} range:[self.lblBatterKM.text rangeOfString:[NSString stringWithFormat:@"%.0f %%",batteryLevel]]];
    self.lblBatterKM.attributedText = attributedText1;
}


- (void) setBatteryLevel
{
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    float batteryLevel = [[UIDevice currentDevice] batteryLevel];
    batteryLevel *= 100;
    
   // double speedCalc = 0.0;
    NSString *strBatteryimage = @"battery3";
    
    if(batteryLevel >=85)
    {
        strBatteryimage = @"battery6";
    }
    else if(batteryLevel>=70 && batteryLevel<=84)
    {
        strBatteryimage = @"battery5";
    }
    else if (batteryLevel>=55 && batteryLevel<=69)
    {
        strBatteryimage = @"battery4";
    }
    else if (batteryLevel >= 40 && batteryLevel <=54)
    {
        strBatteryimage = @"battery3";
    }
    else if (batteryLevel >= 25 && batteryLevel <=39)
    {
        strBatteryimage = @"battery2";
    }
    else if (batteryLevel >= 10 && batteryLevel <=24)
    {
        strBatteryimage = @"battery1";
    }
    else if (batteryLevel >= 0 && batteryLevel <=9)
    {
        strBatteryimage = @"battery0";
    }
    float totalKM = 0;
    float speed = [[AppDelegate sharedInstance] getCurrentSpeed];
    
    if (speed > 0)
    {
  
        float totalHrs = (batteryLevel * 5.0) / 100;
        totalKM = totalHrs * (speed * 3.6);
    }
    else
    {
        [self.lblBatterMeter setText:@"--"];
        [self.lblBatterKM setText:@"--"];
        //[self.lblBatterKM setText:[NSString stringWithFormat:@"%.0f%%",batteryLevel]];
        
//        [self.lblBatterMeter setText:@"160 km"];
//        [self.lblBatterKM setText:@"80%"];
       
    }
   
    strBatteryimage = @"battery6"; //Fixed for Phase2
    //[self.btnBatterStatus setImage:[UIImage imageNamed:strBatteryimage] forState:UIControlStateNormal];
    [self.btnBatterStatus setBackgroundImage:[UIImage imageNamed:strBatteryimage] forState:UIControlStateNormal];
    NSString *strBattery = [NSString stringWithFormat:@"%.0f",totalKM];
    if([strBattery isEqualToString:@"0"])
    {
        [self.lblBatterMeter setText:@"--"];
        [self.lblBatterKM setText:@"--"];
        
//        [self.lblBatterMeter setText:@"160 km"];
//        [self.lblBatterKM setText:@"80%"];
    }
    else
    {
        NSString *strBatteryMeter = [NSString stringWithFormat:@"%@ km",strBattery];
        [self.lblBatterMeter setText:strBatteryMeter];
        
        //[self.lblBatterKM setText:[NSString stringWithFormat:@"%.0f %%",batteryLevel]];
    }
    
     NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.lblBatterMeter.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.lblBatterMeter.font.pointSize]} range:[self.lblBatterMeter.text rangeOfString:strBattery]];
    self.lblBatterMeter.attributedText = attributedText;
    
    NSMutableAttributedString *attributedText1 = [[NSMutableAttributedString alloc] initWithString:self.lblBatterKM.text];
    [attributedText1 setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.lblBatterKM.font.pointSize]} range:[self.lblBatterKM.text rangeOfString:[NSString stringWithFormat:@"%.0f %%",batteryLevel]]];
    self.lblBatterKM.attributedText = attributedText1;
}
- (void) updateBetterToZero
{
    [self.lblBatterMeter setText:@"--"];
}
//------------------------------------------------------------------------

@end
