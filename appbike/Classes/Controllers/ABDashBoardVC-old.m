//
//  DashBoardViewController.m
//  Apparound
//
//  Created by  Zaptech Solutions on 09/01/15.
//  Copyright (c) 2015 zaptech. All rights reserved.
//

#import "ABDashBoardVC.h"
#import "DKCircularSlider.h"
#import "ABBatteryInformation.h"
#import "AppDelegate.h"
#import "AssistanceLevelView.h"
#import "SWRevealViewController.h" 
#import "ConstantList.h"
#import "YLProgressBar.h"
#import "SAMultisectorControl.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "UICircularSlider.h"
#import "GPSLocation.h"
#import "Session+Utils.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "ABHistoryListVC.h"
#import "ABFavoriteList.h"
#import "ABFindMyBikeVC.h"
#import "ABNavigationVC.h"
#import "ABFBLoginVC.h"

#import "BleManager.h"


#define COMPONENTRECT CGRectMake(0,-5,188, 188)
#define iPhone6Rect  CGRectMake(115,20,150,150)
#define iPhone6PlusRect  CGRectMake(132,22,150,150)

@interface ABDashBoardVC ()
{
    IBOutlet ABBatteryInformation *statusBarView;
    int indexLoc;
    int counterTime;
    int minValue,maxValue; //For set speed
    MKRoute *routeDetails;
    BOOL m_postingInProgress;
    int iPositionTag;
    NSString *strIsShare;
    NSDate *oldDate;
}


@property (nonatomic,strong) IBOutlet DKCircularSlider *simpleCSlider;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic,strong) IBOutlet UIButton  *btnSlider;
@property (strong, nonatomic) IBOutlet UIButton *btnCalorie;
@property (strong, nonatomic) IBOutlet UIButton *btnDynamicMode;
@property (strong, nonatomic) IBOutlet UIButton *btnKilometer;
@property (strong, nonatomic) IBOutlet UIButton *btnHealth;
@property (strong, nonatomic) IBOutlet UIButton *btnCity;
@property (strong, nonatomic) IBOutlet UIButton *btnHills;
@property (strong, nonatomic) IBOutlet UIButton *btnGearMode;
@property (strong, nonatomic) IBOutlet UILabel  *lblGearMode;
@property (strong, nonatomic) IBOutlet UIButton *btnSettings;
@property (strong, nonatomic) IBOutlet UIButton *btnAuto;
@property (strong, nonatomic) IBOutlet UILabel *lblCityText;
@property (strong, nonatomic) IBOutlet UILabel *lblAutoText;
@property (strong, nonatomic) IBOutlet UIImageView *imgSettle;


@property (strong, nonatomic) IBOutlet UILabel  *lblCalorieCount;
@property (strong, nonatomic) IBOutlet UILabel  *lblCalorieText;
@property (strong, nonatomic) IBOutlet UILabel  *lblKmOrHour;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentSpeed;
@property (strong, nonatomic) IBOutlet UILabel  *lblKilometerCount;
@property (strong, nonatomic) IBOutlet UILabel  *lblKiloMeterText;
@property (strong, nonatomic) IBOutlet UILabel  *lblDynamicMode;

//Phase2

@property (strong, nonatomic) IBOutlet UILabel *lblSecText;
@property (strong, nonatomic) IBOutlet UIButton *btnTopCycle;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) IBOutlet UIButton *btnShareYes;
@property (strong, nonatomic) IBOutlet UIButton *btnShareNo;


@property (strong, nonatomic) IBOutlet UIView  *viewNormalSpeed;
@property (unsafe_unretained, nonatomic) IBOutlet UICircularSlider *sliderDashboardSpeed;
@property (strong, nonatomic) IBOutlet UIImageView *imgBGDashboardSpeed;
@property (strong, nonatomic) IBOutlet UIImageView *imgBGLogoDashboardSpeed;
@property (strong, nonatomic) IBOutlet UIButton *btnStartStop;
@property (strong, nonatomic) IBOutlet UIButton *btnUpDown;
@property (strong, nonatomic) IBOutlet UILabel *lblKMHText;
@property (strong, nonatomic) IBOutlet UIButton *btnCaloriesMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnKMMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnCenterMenu;



@property (strong, nonatomic) IBOutlet UIView  *viewEngineMode;
@property (strong, nonatomic) IBOutlet UIView  *viewSpeedStart;

@property (strong, nonatomic) IBOutlet UIButton *btnRPM;
@property (strong, nonatomic) IBOutlet UILabel  *lblRPMCount;
@property (strong, nonatomic) IBOutlet UILabel  *lblRPMText;

@property (strong, nonatomic) IBOutlet UIButton *btnBPM;
@property (strong, nonatomic) IBOutlet UILabel  *lblBPMCount;
@property (strong, nonatomic) IBOutlet UILabel  *lblBPMText;

@property (strong, nonatomic) IBOutlet UIView  *viewSelectionMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectPulse;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectAvgPulse;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectSpeed;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectAvgSpeed;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectCalories;
@property (strong, nonatomic) IBOutlet UIButton *btnBackground;


@property (strong, nonatomic) IBOutlet UIView  *viewSetSpeed;
@property (weak, nonatomic) IBOutlet SAMultisectorControl *multisectorControl;
@property (strong, nonatomic) IBOutlet UIImageView *imgBGMinMaxSet;
@property (strong, nonatomic) IBOutlet UILabel *setSpeedlblDistance;
@property (strong, nonatomic) IBOutlet UILabel *setSpeedlblKMH;
@property (strong, nonatomic) IBOutlet UIImageView *imgBgSetSpeed;
@property (strong, nonatomic) IBOutlet UIImageView *imgBgSetSpeedLogo;


@property (strong, nonatomic) IBOutlet UIImageView *goalStarMain;
@property (strong, nonatomic) IBOutlet UIImageView *goalStarSub;
@property (strong, nonatomic) IBOutlet UIImageView *goalStarSub1;
@property (strong, nonatomic) IBOutlet UIImageView *goalStarSub2;
@property (strong, nonatomic) IBOutlet UIImageView *goalStarSub3;

@property (strong, nonatomic) IBOutlet UIButton *btnSkipCalories;
@property (strong, nonatomic) IBOutlet UIButton *btnSkipSpeed;
@property (nonatomic) BOOL isSetCalories;
@property (nonatomic) BOOL isMinMaxSpeed;

//Variable for Min Max Speed Slider on Dashboard

@property (weak, nonatomic) IBOutlet SAMultisectorControl *sliderDashboardMinMax;
@property (strong, nonatomic) IBOutlet UIView  *viewMinMaxSpeed;
@property (strong, nonatomic) IBOutlet UIImageView *bgMinMaxSpeed; //This image will be change when out of speed limit
@property (strong, nonatomic) IBOutlet UILabel *lblMinMaxSpeedValue;

@property (strong, nonatomic) IBOutlet UIView  *viewSetCalories;
@property (strong, nonatomic) IBOutlet UIView  *viewBgLogoCal;
@property (unsafe_unretained, nonatomic) IBOutlet UICircularSlider *sliderSetCalories;
@property (nonatomic, strong) IBOutlet UILabel *lblSetCaloriesValue;
@property (strong, nonatomic) IBOutlet UIImageView *bgImgSetCaloris;

@property (strong, nonatomic) IBOutlet UIView  *viewCalories;
@property (unsafe_unretained, nonatomic) IBOutlet UICircularSlider *sliderDashboardCalories;
@property (strong, nonatomic) IBOutlet UIImageView *imgBGCalories;
@property (strong, nonatomic) IBOutlet UIImageView *imgBGLogoCalories;
@property (strong, nonatomic) IBOutlet UIButton *btnMaxCalories;
@property (strong, nonatomic) IBOutlet UILabel *lblCaloriesPercentage;

@property (strong, nonatomic) IBOutlet UIView  *viewGoalCalories;
@property (strong, nonatomic) IBOutlet UILabel *lblGoalCalories;
@property (strong, nonatomic) IBOutlet UIImageView *bgGoalImage;

@property (strong, nonatomic) IBOutlet UIView  *viewProgress;
@property (strong, nonatomic) IBOutlet UILabel *lblEngineText;
@property (strong, nonatomic) IBOutlet UILabel *lblMeText;


@property (strong, nonatomic) IBOutlet UIView  *viewCountdown;
@property (unsafe_unretained, nonatomic) IBOutlet UICircularSlider *circularSlider;
@property (strong, nonatomic) IBOutlet UILabel *lblCaloriesValueSlider;


@property (strong, nonatomic) IBOutlet UIView  *viewSaveSession;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UILabel *lblCounter;
@property (strong, nonatomic) IBOutlet UIPickerView *counterPicker;

@property (strong, nonatomic) IBOutlet YLProgressBar *progressBarRoundedFat;
@property (strong, nonatomic) IBOutlet UILabel *lblEngineCount;
@property (strong, nonatomic) IBOutlet UILabel *lblMeCount;
@property (strong, nonatomic) IBOutlet UILabel *lblWattCount;

@property (strong, nonatomic) NSDictionary *dictJsonSession;
@property (strong, nonatomic) NSDate *dtStartSession;
@property (strong, nonatomic) IBOutlet UILabel *lblStopSaveSession;

//Destination
@property (strong, nonatomic) IBOutlet UIView  *viewDestination;

@property (strong, nonatomic) IBOutlet XYPieChart *pieChartLeft;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

//Map View

@property (strong, nonatomic) IBOutlet UIView  *viewMapMain;
@property (strong, nonatomic) IBOutlet UIView  *viewMapTopFull;
@property (strong, nonatomic) IBOutlet UIView  *viewMapTopHalf;
@property (strong, nonatomic) IBOutlet MKMapView  *viewMap;
@property (strong, nonatomic) IBOutlet UIButton *btnShowDashboard;
@property (strong, nonatomic) IBOutlet UILabel *lblMapBPMText;
@property (strong, nonatomic) IBOutlet UILabel *lblMapRPMText;
@property (strong, nonatomic) IBOutlet UILabel *lblMapKMText;
@property (strong, nonatomic) IBOutlet UILabel *lblMapAvgSpeedText;

@property (strong, nonatomic) IBOutlet UILabel *lblMapBPMValue;
@property (strong, nonatomic) IBOutlet UILabel *lblMapRPMValue;
@property (strong, nonatomic) IBOutlet UILabel *lblMapKMValue;
@property (strong, nonatomic) IBOutlet UILabel *lblMapAvgSpeedValue;
@property (strong, nonatomic) IBOutlet UILabel *lblMapCalValue;
@property (strong, nonatomic) IBOutlet UILabel *lblMapMaxCalValue;
@property (strong, nonatomic) IBOutlet UIButton *btnMapStart;
@property (strong, nonatomic) IBOutlet UIImageView *imgTopLeft;
@property (strong, nonatomic) IBOutlet UIImageView *imgTopRight;
@property (strong, nonatomic) IBOutlet UIImageView *imgBottomLeft;
@property (strong, nonatomic) IBOutlet UIImageView *imgBottomRight;


@property (strong, nonatomic) IBOutlet UIView  *viewBatteryAlert;
@property (strong, nonatomic) IBOutlet UILabel *lblAlertPercentage;
@property (strong, nonatomic) IBOutlet UILabel *lblAlertKM;
@property (strong, nonatomic) IBOutlet UILabel *lblAlertMsg;

@property (strong, nonatomic) IBOutlet UILabel *lblCalTextSlider;
@property (strong, nonatomic) IBOutlet UIButton *btnSaveSessionYes;
@property (strong, nonatomic) IBOutlet UIButton *btnSaveSessionNo;

@property (strong, nonatomic) NSMutableDictionary *dictUpdatedDashboardData;
//####
@property (weak, nonatomic) IBOutlet UIButton *btnAssistantlLevel;


@property (strong, nonatomic) IBOutlet AssistanceLevelView *assistantLevelView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *viewDashboardExternalView;
@property (strong, nonatomic) IBOutlet UIView *viewDashboardInternalView;

@property (strong, nonatomic) IBOutlet UIView *viewCentralMap;
@property (strong, nonatomic) IBOutlet UILabel *lblCentralMapValue;
@property (strong, nonatomic) IBOutlet UILabel *lblCentralMapText;
@property (unsafe_unretained, nonatomic) IBOutlet UICircularSlider *sliderCentralMap;
@property (strong, nonatomic) IBOutlet UIImageView *imgMapCenter;

@property (nonatomic) BOOL isAssistantViewOpen;
@property (nonatomic) double distanceKM;

@property (nonatomic,strong) BleManager *bleManager;

@property (nonatomic,assign) BOOL isRegistered;


@property (nonatomic, assign) MKCoordinateRegion boundingRegion;

@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (strong, nonatomic) MKMapItem *destination;

@end

@implementation ABDashBoardVC

- (void)loadDashboardData
{
    self.dictUpdatedDashboardData = [[NSMutableDictionary alloc] initWithDictionary:appDelegate().dictDashboardData];
    self.lblCalorieText.text = [appDelegate().dictDashboardData objectForKey:@"topLeft"];
    self.lblMapAvgSpeedText.text = [appDelegate().dictDashboardData objectForKey:@"topLeft"];
    
    self.lblKiloMeterText.text = [appDelegate().dictDashboardData objectForKey:@"topRight"];
    self.lblMapKMText.text = [appDelegate().dictDashboardData objectForKey:@"topRight"];
    
    self.lblRPMText.text = [appDelegate().dictDashboardData objectForKey:@"bottomLeft"];
    self.lblMapRPMText.text = [appDelegate().dictDashboardData objectForKey:@"bottomLeft"];
    
    self.lblBPMText.text = [appDelegate().dictDashboardData objectForKey:@"bottomRight"];
    self.lblMapBPMText.text = [appDelegate().dictDashboardData objectForKey:@"bottomRight"];
    
    NSString *strTopLeft = [appDelegate().dictDashboardData valueForKey:@"topLeft"];
    NSString *strTopRight = [appDelegate().dictDashboardData valueForKey:@"topRight"];
    NSString *strBottomLeft = [appDelegate().dictDashboardData valueForKey:@"bottomLeft"];
    NSString *strBottomRight = [appDelegate().dictDashboardData valueForKey:@"bottomRight"];
    NSString *mainSensor = [appDelegate().dictDashboardData objectForKey:@"main"];
    
    self.viewCentralMap.hidden = NO;
    if([mainSensor isEqualToString:@"kmh"])
    {
        self.lblKMHText.text = @"km/h";
        self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"flow_ring_logo.png"];
        
        
    }
    else if([mainSensor isEqualToString:@"bpm"])
    {
        //TODO : Replace with bpm logo.
        self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
        self.lblKMHText.text = @"bpm";
    }
    else if([mainSensor isEqualToString:@"rpm"])
    {
        //TODO : Replace with rpm logo.
        self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
        self.lblKMHText.text = @"bpm";
    }
    else if([mainSensor isEqualToString:@"cal"])
    {
        self.viewCentralMap.hidden = YES;
    }
    
    if([strTopLeft isEqualToString:@"cal"])
    {
        [self.btnCaloriesMenu setBackgroundImage:[UIImage imageNamed:@"cal.png"] forState:UIControlStateNormal];
        self.imgTopLeft.image = [UIImage imageNamed:@"cal.png"];
        
    }
    if([strTopLeft isEqualToString:@"km"])
    {
        //[self.btnCaloriesMenu setImage:[UIImage imageNamed:@"kilometer.png"] forState:UIControlStateNormal];
        //self.imgTopLeft.image = [UIImage imageNamed:@"map_kilometer.png"];
        
        [self.btnCaloriesMenu setBackgroundImage:[UIImage imageNamed:@"avg_speed_selected.png"] forState:UIControlStateNormal];
        self.imgTopLeft.image = [UIImage imageNamed:@"map_speed.png"];
        
        self.lblCalorieText.text = @"km/h";
        self.lblMapAvgSpeedText.text = @"km/h";
        
    }
    if([strTopLeft isEqualToString:@"rpm"])
    {
        [self.btnCaloriesMenu setBackgroundImage:[UIImage imageNamed:@"rpm.png"] forState:UIControlStateNormal];
        self.imgTopLeft.image = [UIImage imageNamed:@"map_rpm.png"];
    }
    if([strTopLeft isEqualToString:@"bpm"])
    {
        [self.btnCaloriesMenu setBackgroundImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
        self.imgTopLeft.image = [UIImage imageNamed:@"map_bpm.png"];
    }
    
    //top right
    if([strTopRight isEqualToString:@"cal"])
    {
        [self.btnKMMenu setBackgroundImage:[UIImage imageNamed:@"cal.png"] forState:UIControlStateNormal];
        self.imgTopRight.image = [UIImage imageNamed:@"cal.png"];
    }
    if([strTopRight isEqualToString:@"km"])
    {
//        [self.btnKMMenu setImage:[UIImage imageNamed:@"kilometer.png"] forState:UIControlStateNormal];
//        self.imgTopRight.image = [UIImage imageNamed:@"map_kilometer.png"];
        
        [self.btnKMMenu setBackgroundImage:[UIImage imageNamed:@"avg_speed_selected.png"] forState:UIControlStateNormal];
        self.imgTopRight.image = [UIImage imageNamed:@"map_speed.png"];
        
        self.lblKiloMeterText.text = @"km/h";
        self.lblMapKMText.text = @"km/h";
    }
    if([strTopRight isEqualToString:@"rpm"])
    {
        [self.btnKMMenu setBackgroundImage:[UIImage imageNamed:@"rpm.png"] forState:UIControlStateNormal];
        self.imgTopRight.image = [UIImage imageNamed:@"map_rpm.png"];
    }
    if([strTopRight isEqualToString:@"bpm"])
    {
        [self.btnKMMenu setBackgroundImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
        self.imgTopRight.image = [UIImage imageNamed:@"map_bpm.png"];
    }

    //bottom left
    if([strBottomLeft isEqualToString:@"cal"])
    {
        [self.btnRPM setBackgroundImage:[UIImage imageNamed:@"cal.png"] forState:UIControlStateNormal];
        self.imgBottomLeft.image = [UIImage imageNamed:@"cal.png"];
    }
    if([strBottomLeft isEqualToString:@"km"])
    {
//        [self.btnRPM setImage:[UIImage imageNamed:@"kilometer.png"] forState:UIControlStateNormal];
//        self.imgBottomLeft.image = [UIImage imageNamed:@"map_kilometer.png"];
        
        [self.btnRPM setBackgroundImage:[UIImage imageNamed:@"avg_speed_selected.png"] forState:UIControlStateNormal];
        self.imgBottomLeft.image = [UIImage imageNamed:@"map_speed.png"];
        self.lblRPMText.text = @"km/h";
        self.lblMapRPMText.text = @"km/h";

    }
    if([strBottomLeft isEqualToString:@"rpm"])
    {
       [self.btnRPM setBackgroundImage:[UIImage imageNamed:@"rpm.png"] forState:UIControlStateNormal];
        self.imgBottomLeft.image = [UIImage imageNamed:@"map_rpm.png"];
    }
    if([strBottomLeft isEqualToString:@"bpm"])
    {
        [self.btnRPM setBackgroundImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
        self.imgBottomLeft.image = [UIImage imageNamed:@"map_bpm.png"];
    }

    //bottom Right
    if([strBottomRight isEqualToString:@"cal"])
    {
        [self.btnBPM setBackgroundImage:[UIImage imageNamed:@"cal.png"] forState:UIControlStateNormal];
        self.imgBottomRight.image = [UIImage imageNamed:@"cal.png"];
    }
    if([strBottomRight isEqualToString:@"km"])
    {
//        [self.btnBPM setImage:[UIImage imageNamed:@"kilometer.png"] forState:UIControlStateNormal];
//        self.imgBottomRight.image = [UIImage imageNamed:@"map_kilometer.png"];
        
        [self.btnBPM setBackgroundImage:[UIImage imageNamed:@"avg_speed_selected.png"] forState:UIControlStateNormal];
        self.imgBottomRight.image = [UIImage imageNamed:@"map_speed.png"];
        self.lblBPMText.text = @"km/h";
        self.lblMapBPMText.text = @"km/h";
    }
    if([strBottomRight isEqualToString:@"rpm"])
    {
        [self.btnBPM setBackgroundImage:[UIImage imageNamed:@"rpm.png"] forState:UIControlStateNormal];
        self.imgBottomRight.image = [UIImage imageNamed:@"map_rpm.png"];
    }
    if([strBottomRight isEqualToString:@"bpm"])
    {
         [self.btnBPM setBackgroundImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
        self.imgBottomRight.image = [UIImage imageNamed:@"map_bpm.png"];
    }
    
    //[self.btnRPM setImage:[UIImage imageNamed:@"rpm.png"] forState:UIControlStateNormal];
    //[self.btnBPM setImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
}

- (void)registerForNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(updateMyLocation:)
               name:LocationUpdateNotification object:nil];
}

- (void)unregisterFromNotifications
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:LocationUpdateNotification object:nil];
}


- (void)leftMenuPressed:(NSNotification *)notify
{
    NSNumber *tag = notify.object;
    NSLog(@"Tag is : %@",tag);
    int mTag = [tag intValue];
    
}

- (IBAction)btnShowDashboard:(id)sender
{
    //CGRect fram = self.viewMapMain.frame;
    //fram.origin.y+=1000;
   // fram.size.height += 106;
    
    //self.isAssistantViewOpen=!self.isAssistantViewOpen;
    [UIView animateWithDuration:0.4 animations:^{
      //  [self.viewMap setFrame:fram];
        self.viewMapMain.hidden = YES;
        self.viewMapTopFull.hidden = NO;
        self.viewMapTopHalf.hidden = YES;
        
    }];

}
- (IBAction)btnMapUpDownArrow:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    if(btnPressed.tag == 1401)
    {
        //Up arrow
        CGRect fram = self.viewMap.frame;
        fram.origin.y-=106;
        fram.size.height += 106;
        
        //self.isAssistantViewOpen=!self.isAssistantViewOpen;
        [UIView animateWithDuration:0.4 animations:^{
            [self.viewMap setFrame:fram];
            self.viewMapTopFull.hidden = YES;
            self.viewMapTopHalf.hidden = NO;
            self.btnShowDashboard.hidden = YES;
        }];

    }
    else
    {
        //Down arrow
        CGRect fram = self.viewMap.frame;
        fram.origin.y+=106;
        fram.size.height -= 106;
        
        //self.isAssistantViewOpen=!self.isAssistantViewOpen;
        [UIView animateWithDuration:0.4 animations:^{
            [self.viewMap setFrame:fram];
            self.viewMapTopFull.hidden = NO;
            self.viewMapTopHalf.hidden = YES;
            self.btnShowDashboard.hidden = NO;
        }];

        
    }
}

- (IBAction)btnBackgroundTouch:(id)sender
{
    self.btnBackground.hidden = YES;
    self.viewSelectionMenu.hidden = YES;
}


//------------------------------------------------------------------

- (void) loadUserProfileImage
{
    //[self.btnUserImg setUserInteractionEnabled:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:kFBUserProfileImgURL]]];
        NSString *fbUserName=[[NSUserDefaults standardUserDefaults] valueForKey:kFBUserName];
        dispatch_async(dispatch_get_main_queue(), ^{
            //  [self.btnUserName setTitle:fbUserName forState:UIControlStateNormal];
            // [self.btnUserImg setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
            appDelegate().userProfileImage = imgData;
            
            if(!appDelegate().isSessionStart)
            {
                self.sliderDashboardSpeed.thumbImage = [UIImage imageWithData:imgData];
                [self.sliderDashboardSpeed addProfileImage];
                
                self.sliderDashboardCalories.thumbImage = [UIImage imageWithData:imgData];
                [self.sliderDashboardCalories addProfileImage];
                
                [self.sliderDashboardMinMax setProfileImage:[UIImage imageWithData:imgData]];
            }
           // [self dismissViewControllerAnimated:YES completion:^{
                
            //}];
        });
    });
}


#pragma mark
#pragma mark View Life Cycle Methods

//------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    oldDate = [NSDate date];
    
    strIsShare = @"0";
    if(self.isSecondTime)
        return;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(leftMenuPressed:)
               name:MenuItemNotification object:nil];
    
  
    if(appDelegate().isSessionStart)
    {
        [self.btnStartStop setTitle:@"STOP" forState:UIControlStateNormal];
        [self.btnMapStart setTitle:@"STOP" forState:UIControlStateNormal];
    }
    
    indexLoc = 0;
    
    [self registerForNotifications];
    [self loadDashboardData];
    //if(!self.isSecondTime)
        [self setupMultiSelectorControl]; //For Set speed range
    
    [self.assistantLevelView UpdateCurrentAssitanceLevel];
    
    self.sliderDashboardSpeed.minimumValue = 0;
    self.sliderDashboardSpeed.maximumValue = 100;
    self.sliderDashboardSpeed.continuous = NO;
    
    self.sliderDashboardSpeed.isThumbnailEnabled = YES;
    self.sliderDashboardSpeed.thumbImage = [UIImage imageNamed:@"noimage.png"];
    [self.sliderDashboardSpeed addProfileImage];
    self.sliderDashboardSpeed.transform = CGAffineTransformMakeRotation(3.14);
    self.sliderDashboardSpeed.userInteractionEnabled = NO;
    [self.sliderDashboardSpeed setThumbTintColor:[UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:1.0]];
    [self.sliderDashboardSpeed setMaximumTrackTintColor:[UIColor clearColor]];
    [self.sliderDashboardSpeed setMinimumTrackTintColor:[UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:1.0]];
    
    //Map Slider
    self.sliderCentralMap.minimumValue = 0;
    self.sliderCentralMap.maximumValue = 100;
    self.sliderCentralMap.continuous = NO;
    
    self.sliderCentralMap.isThumbnailEnabled = NO;
    self.sliderCentralMap.isMapCircle = YES;
    self.sliderCentralMap.transform = CGAffineTransformMakeRotation(3.14);
    self.sliderCentralMap.userInteractionEnabled = NO;
    [self.sliderCentralMap setThumbTintColor:[UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:1.0]];
    [self.sliderCentralMap setMaximumTrackTintColor:[UIColor grayColor]];
    [self.sliderCentralMap setMinimumTrackTintColor:[UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:1.0]];
    
    
    
    //Calories Dashboard
    self.sliderDashboardCalories.minimumValue = 0;
    self.sliderDashboardCalories.maximumValue = [[appDelegate().dictCaloriesData objectForKey:@"max"] floatValue];
    self.sliderDashboardCalories.continuous = NO;
    
    self.sliderDashboardCalories.isThumbnailEnabled = YES;
    self.sliderDashboardCalories.thumbImage = [UIImage imageNamed:@"noimage.png"];
    [self.sliderDashboardCalories addProfileImage];
    self.sliderDashboardCalories.transform = CGAffineTransformMakeRotation(3.14);
    self.sliderDashboardCalories.userInteractionEnabled = NO;
    [self.sliderDashboardCalories setThumbTintColor:[UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:1.0]];
    [self.sliderDashboardCalories setMaximumTrackTintColor:[UIColor clearColor]];
    [self.sliderDashboardCalories setMinimumTrackTintColor:[UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:1.0]];
    
    
    
    //Set counter variables
    self.circularSlider.minimumValue = 0;
    self.circularSlider.maximumValue = 100;
    self.circularSlider.continuous = NO;
    self.circularSlider.transform = CGAffineTransformMakeRotation(3.14);
    self.circularSlider.userInteractionEnabled = NO;
    [self.circularSlider setThumbTintColor:[UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:1.0]];
    [self.circularSlider setMaximumTrackTintColor:[UIColor colorWithRed:119/255.0 green:122/255.0 blue:130/255.0 alpha:1.0]];
    [self.circularSlider setMinimumTrackTintColor:[UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:1.0]];
    
    //Set Calories slider
    
    self.lblSetCaloriesValue.text = @"0";
    self.sliderSetCalories.originalvalue = 0;
    self.sliderSetCalories.value = 40;
    self.sliderSetCalories.minimumValue = 0;
    self.sliderSetCalories.maximumValue = [[appDelegate().dictCaloriesData objectForKey:@"max"] floatValue];
    self.sliderSetCalories.continuous = YES;
    self.sliderSetCalories.isThumbnailEnabled = YES;
    
    self.sliderSetCalories.transform = CGAffineTransformMakeRotation(3.14);
    //self.sliderSetCalories.userInteractionEnabled = NO;
    [self.sliderSetCalories setThumbTintColor:[UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:0.5]];
//    [self.sliderSetCalories setMaximumTrackTintColor:[UIColor lightGrayColor]];
    [self.sliderSetCalories setMinimumTrackTintColor:[UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:1.0]];
    [self.sliderSetCalories setMaximumTrackTintColor:[UIColor clearColor]];
//    [self.sliderSetCalories setMinimumTrackTintColor:[UIColor clearColor]];

    
    [self.btnMaxCalories setTitle:[NSString stringWithFormat:@"%@",[appDelegate().dictCaloriesData objectForKey:@"goal"]] forState:UIControlStateNormal];
    
    
    self.locationManager = [GPSLocation sharedManager].locationManager;
    
    
    //Battery Info initialize
    statusBarView = [[ABBatteryInformation alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [statusBarView setBatteryLevel];
    [self.view addSubview:statusBarView];
    
    [self.view addSubview:self.viewCountdown];
    [self.view addSubview:self.viewSaveSession];
    [self.view addSubview:self.viewBatteryAlert];
    
    
    counterTime = [[appDelegate().dictCounterData objectForKeyedSubscript:@"value"] intValue];
    

    [self.counterPicker selectRow:(counterTime-1) inComponent:0 animated:NO];
    
    NSString *strSavedCountr = [[NSUserDefaults standardUserDefaults] objectForKey:kCounterKey];
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"countdown.json" ofType:@""];
    
    if(strSavedCountr)
    {
        counterTime = [strSavedCountr intValue];
        [self.counterPicker selectRow:(counterTime-1) inComponent:0 animated:NO];
    }
    
    //setup custom location mangaer
    [GPSLocation sharedManager].delegate = self;
    
    [[GPSLocation sharedManager] stop];
    [[GPSLocation sharedManager] start];
    
    
    NSLog(@"Screen height : %f and width : %f",[[UIScreen mainScreen]bounds].size.height,[[UIScreen mainScreen]bounds].size.width);
    int yAxis = 0;
    if(IS_IPHONE_6)
    {
        [self updateUIForiPhone6];
        self.btnStartStop.frame = CGRectMake(self.btnStartStop.frame.origin.x, self.btnStartStop.frame.origin.y-20, self.btnStartStop.frame.size.width, self.btnStartStop.frame.size.height);
        self.viewSetCalories.frame = CGRectMake(self.viewSetCalories.frame.origin.x, self.viewSetCalories.frame.origin.y, self.viewSetCalories.frame.size.width, self.viewSetCalories.frame.size.height-12);
        yAxis = 30;
        
    
    }
    else if(IS_IPHONE_6_PLUS)
    {
        [self updateUIForiPhone6Plus];
        self.btnStartStop.frame = CGRectMake(self.btnStartStop.frame.origin.x, self.btnStartStop.frame.origin.y-20, self.btnStartStop.frame.size.width, self.btnStartStop.frame.size.height);
        
        self.viewSetCalories.frame = CGRectMake(self.viewSetCalories.frame.origin.x, self.viewSetCalories.frame.origin.y, self.viewSetCalories.frame.size.width, self.viewSetCalories.frame.size.height-17);
        
        
        self.btnUpDown.frame = CGRectMake(self.btnUpDown.frame.origin.x-5, self.btnUpDown.frame.origin.y, self.btnUpDown.frame.size.width, self.btnUpDown.frame.size.height);
        
         yAxis = 40;
       
    }
    else if(IS_IPHONE_5)
    {
        NSLog(@"iPhone5");
        self.imgBGCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x+5, self.sliderDashboardCalories.frame.origin.y, 195, 195);
        
        self.btnStartStop.frame = CGRectMake(101,315,112,35);
        
        
        yAxis = 30;
        
        self.lblCounter.frame = CGRectMake(self.lblCounter.frame.origin.x, self.lblCounter.frame.origin.y-25, self.lblCounter.frame.size.width, self.lblCounter.frame.size.height+30);
        self.lblCounter.font = [UIFont fontWithName:@"Roboto-Regular" size:62];
        
         self.bgImgSetCaloris.frame = CGRectMake(self.bgImgSetCaloris.frame.origin.x, self.bgImgSetCaloris.frame.origin.y+5, self.bgImgSetCaloris.frame.size.width, self.bgImgSetCaloris.frame.size.height-10);
        
        self.imgBgSetSpeedLogo.frame = CGRectMake(self.imgBgSetSpeedLogo.frame.origin.x, self.imgBgSetSpeedLogo.frame.origin.y+10, self.imgBgSetSpeedLogo.frame.size.width, self.imgBgSetSpeedLogo.frame.size.height);
        
        
         self.viewSetSpeed.frame = CGRectMake(self.viewSetSpeed.frame.origin.x, self.viewSetSpeed.frame.origin.y+41, self.viewSetSpeed.frame.size.width, self.viewSetSpeed.frame.size.height-43);
        
       self.viewSetCalories.frame = CGRectMake(self.viewSetCalories.frame.origin.x, self.viewSetCalories.frame.origin.y+41, self.viewSetCalories.frame.size.width, self.viewSetCalories.frame.size.height-43);
        
        self.viewBgLogoCal.frame = CGRectMake(self.viewBgLogoCal.frame.origin.x, self.viewBgLogoCal.frame.origin.y-2, self.viewBgLogoCal.frame.size.width, self.viewBgLogoCal.frame.size.height);
        self.viewBgLogoCal.layer.cornerRadius = 20;
        
        self.imgBGLogoDashboardSpeed.frame = CGRectMake(self.imgBGLogoDashboardSpeed.frame.origin.x,self.imgBGLogoDashboardSpeed.frame.origin.y-6, 46, 50);
//        self.viewBgLogoCal.backgroundColor = [UIColor darkGrayColor];
    }
    else
    {
        
        
        self.assistantLevelView.frame = CGRectMake(self.assistantLevelView.frame.origin.x, self.assistantLevelView.frame.origin.y+20, self.assistantLevelView.frame.size.width, self.assistantLevelView.frame.size.height - 20);
        
        self.assistantLevelView.imgRate.frame = CGRectMake(self.assistantLevelView.imgRate.frame.origin.x, self.assistantLevelView.imgRate.frame.origin.y+20, self.assistantLevelView.imgRate.frame.size.width, self.assistantLevelView.imgRate.frame.size.height - 20);
        
        
        self.viewEngineMode.frame = CGRectMake(self.viewEngineMode.frame.origin.x, self.viewEngineMode.frame.origin.y+30, self.viewEngineMode.frame.size.width, self.viewEngineMode.frame.size.height);
        
         yAxis = 30;
        
        
        
        
//        self.viewNormalSpeed.frame = CGRectMake(self.viewNormalSpeed.frame.origin.x, self.viewNormalSpeed.frame.origin.y, self.viewNormalSpeed.frame.size.width, self.viewNormalSpeed.frame.size.height);
       
        // self.viewSpeedStart.frame = CGRectMake(self.viewSpeedStart.frame.origin.x, self.viewSpeedStart.frame.origin.y, self.viewSpeedStart.frame.size.width, self.viewSpeedStart.frame.size.height+45);
        
         self.viewSpeedStart.frame = CGRectMake(self.viewSpeedStart.frame.origin.x, self.viewSpeedStart.frame.origin.y, self.viewSpeedStart.frame.size.width, self.viewSpeedStart.frame.size.height+45);
        
        self.btnStartStop.frame = CGRectMake(101,283,112,35); //283
        
         self.btnUpDown.frame = CGRectMake(self.btnUpDown.frame.origin.x, self.btnUpDown.frame.origin.y, self.btnUpDown.frame.size.width, self.btnUpDown.frame.size.height);
        
        self.viewSetSpeed.frame = CGRectMake(self.viewSetSpeed.frame.origin.x, self.viewSetSpeed.frame.origin.y, self.viewSetSpeed.frame.size.width, self.viewSetSpeed.frame.size.height+45);
        
        self.viewSetCalories.frame = CGRectMake(self.viewSetCalories.frame.origin.x, self.viewSetCalories.frame.origin.y, self.viewSetCalories.frame.size.width, self.viewSetCalories.frame.size.height+35);
        
        
        self.viewCalories.frame = CGRectMake(self.viewCalories.frame.origin.x, self.viewCalories.frame.origin.y-20, self.viewCalories.frame.size.width, self.viewCalories.frame.size.height);
       // self.imgBGCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x+5, self.sliderDashboardCalories.frame.origin.y-10, 195, 195);
         self.imgBGCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x+5, self.sliderDashboardCalories.frame.origin.y-10, 200, 200);
        
           self.lblSecText.frame = CGRectMake(self.lblSecText.frame.origin.x+20, self.lblSecText.frame.origin.y-10, self.lblSecText.frame.size.width, self.lblSecText.frame.size.height);
        self.sliderDashboardSpeed.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x, self.sliderDashboardSpeed.frame.origin.y+3, self.sliderDashboardSpeed.frame.size.width, self.sliderDashboardSpeed.frame.size.height);

        
    }
  
    self.lblBPMCount.frame = CGRectMake(self.lblBPMCount.frame.origin.x, self.lblBPMCount.frame.origin.y-yAxis, self.lblBPMCount.frame.size.width, self.lblBPMCount.frame.size.height);
    self.lblBPMText.frame = CGRectMake(self.lblBPMText.frame.origin.x, self.lblBPMText.frame.origin.y-yAxis, self.lblBPMText.frame.size.width, self.lblBPMText.frame.size.height);
    self.btnBPM.frame = CGRectMake(self.btnBPM.frame.origin.x, self.btnBPM.frame.origin.y-yAxis, self.btnBPM.frame.size.width, self.btnBPM.frame.size.height);
    
    self.lblRPMCount.frame = CGRectMake(self.lblRPMCount.frame.origin.x, self.lblRPMCount.frame.origin.y-yAxis, self.lblRPMCount.frame.size.width, self.lblRPMCount.frame.size.height);
    self.lblRPMText.frame = CGRectMake(self.lblRPMText.frame.origin.x, self.lblRPMText.frame.origin.y-yAxis, self.lblRPMText.frame.size.width, self.lblRPMText.frame.size.height);
    self.btnRPM.frame = CGRectMake(self.btnRPM.frame.origin.x, self.btnRPM.frame.origin.y-yAxis, self.btnRPM.frame.size.width, self.btnRPM.frame.size.height);
    
    
    self.bleManager = [[BleManager alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHeaderPacketWithNotification:) name:@"headerPacket" object:nil];

    //[self.bleManager getHeaderPacket];//Comment this after test
    
    self.sliderDashboardMinMax.isDisplayCurrentValue = YES;
    
    if(!self.isSecondTime)
        [self updateCurrentValueAndCheckMinMax:50];
    
    
    //Search Destination
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
    searchQuery.radius = 100.0;
    shouldBeginEditing = YES;
    self.searchDisplayController.searchBar.placeholder = @"Search or Address";
//    [[UISearchBar appearance] setTintColor:[UIColor blackColor]];
//    self.searchDisplayController.searchBar.tintColor = [UIColor blackColor];
//    UITextField *txfSearchField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
//    [txfSearchField setBackgroundColor:[UIColor blackColor]];
//    [txfSearchField setLeftView:UITextFieldViewModeNever];
//    [txfSearchField setBorderStyle:UITextBorderStyleRoundedRect];
//    txfSearchField.layer.borderWidth = 8.0f;
//    txfSearchField.layer.cornerRadius = 10.0f;
//    txfSearchField.layer.borderColor = [UIColor clearColor].CGColor;
    
    //Pie Chart for Map
    self.slices = [NSMutableArray arrayWithCapacity:2];
    
    NSNumber *one = [NSNumber numberWithInt:0];
    NSNumber *two = [NSNumber numberWithInt:500];
    
    [_slices addObject:one];
    [_slices addObject:two];
    
    
    
   // [self.pieChartLeft setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:138.0/255.0 blue:35.0/255.0 alpha:1]];
    [self.pieChartLeft setDataSource:self];
    [self.pieChartLeft setStartPieAngle:M_PI_2];
    [self.pieChartLeft setAnimationSpeed:1.0];
    //[self.pieChartLeft setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    //[self.pieChartLeft setLabelFont:[UIFont fontWithName:@"Roboto" size:24]];
    //[self.pieChartLeft setLabelRadius:160];
    [self.pieChartLeft setShowLabel:NO];
    [self.pieChartLeft setShowPercentage:NO];
    [self.pieChartLeft setPieBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:138.0/255.0 blue:35.0/255.0 alpha:1]];
    [self.pieChartLeft setPieCenter:CGPointMake(50,50)];
    [self.pieChartLeft setUserInteractionEnabled:YES];
    
    //[self.pieChartLeft setLabelShadowColor:[UIColor blackColor]];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:23/255.0 green:138/255.0 blue:230/255.0 alpha:1],[UIColor colorWithRed:245.0/255.0 green:138.0/255.0 blue:35.0/255.0 alpha:1],nil];
    

    //Display Destination based on menu selection
  //  NSLog(@"%@",self.isDisplayDestination);
    
    if(self.isDisplayDestination == YES)
    {
        self.viewMapMain.hidden = NO;
        self.viewDestination.hidden = NO;
    }
    else
    {
        self.viewDestination.hidden = YES;
        self.viewMapMain.hidden = YES;
    }

    if(appDelegate().isDisplayMap)
    {
        [self displayMap];
        appDelegate().isDisplayMap = NO;
    }
    
    //Testing
   // self.viewMapMain.hidden = NO;
   // [self.sliderDashboardSpeed setValue:100.0f];
}

- (void)showDestination
{
    self.viewDestination.hidden = NO;
    //self.viewMapMain.hidden = NO;
    //self.viewDestination.hidden = YES;
    //self.viewMapMain.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self unregisterFromNotifications];
    //[self.multisectorControl removeFromSuperview];
    //[self.sliderDashboardMinMax]
}

- (void)viewWillLayoutSubviews
{
    if(self.searchDisplayController.isActive)
    {
        [UIView animateWithDuration:0.001 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }completion:nil];
    }
    [super viewWillLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.sliderSetCalories setValue:40];
    if(self.searchDisplayController.isActive)
    {
        [UIView animateWithDuration:0.001 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }completion:nil];
    }
    [super viewWillAppear:animated];
    [self.view setNeedsDisplay];
    
}
-(void)viewDidAppear:(BOOL)animated
{

    if (!appDelegate().dashboardVC.isSecondTime)
    {
    
    
        //Uncoment this after testing complete
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kIsLoginWithFB])
        {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"AppBike" bundle:nil];
            
            ABFBLoginVC *loginVC =  (ABFBLoginVC *)[storyBoard instantiateViewControllerWithIdentifier:@"ABFBLoginVC"];
            
            [self.navigationController presentViewController:loginVC animated:YES completion:^{
                
            }];
        }
        else
        {
            

        if([FBSession activeSession].state == FBSessionStateClosed)
            {
                
                [FBSession openActiveSessionWithPublishPermissions:@[@"public_profile,publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                    [FBSession setActiveSession:session];
                    [self sessionStateChanged:session state:status error:error];
                }];
            }
            
            [self loadUserProfileImage];
            
           
        }
        
        
        
    //    if(IS_IPHONE_6)

        
        appDelegate().dashboardVC = self;
        [super viewDidAppear:animated];
        
        [self.pieChartLeft reloadData];
    }
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen)
    {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                // Success! Include your code to handle the results here
                NSLog(@"user info: %@", result);
                if (result)
                {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLoginWithFB];
                    if ([result valueForKey:@"name"])
                    {
                        NSString *userName = [result valueForKey:@"name"];
                        [[NSUserDefaults standardUserDefaults] setValue:userName forKey:kFBUserName];
                        //                       [self.btnUserNameName setText:[result valueForKey:@"name"]];
                        // [self.btnUserName setTitle:[result valueForKey:@"name"] forState:UIControlStateNormal];
                    }
                    if ([result valueForKey:@"id"])
                    {
                        NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [result valueForKey:@"id"]];
                        [[NSUserDefaults standardUserDefaults] setValue:userImageURL forKey:kFBUserProfileImgURL];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self loadUserProfileImage];
                        
                    }
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            else
            {
                
                
                [FBSession setActiveSession:nil];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLoginWithFB];
                [FBSession.activeSession closeAndClearTokenInformation];
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
            }
        }];
    }
    
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed)
    {
        // If the session is closed Log Out
        
        [FBSession.activeSession closeAndClearTokenInformation];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Facebook integration was canceled by user" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alert show];
        
        [FBSession setActiveSession:nil];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLoginWithFB];
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    
    // Handle errors
    if (error)
    {
        [FBSession setActiveSession:nil];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLoginWithFB];
        [FBSession.activeSession closeAndClearTokenInformation];
        // Fire Delegate
        
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
        {
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            
        }
        else
        {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
            {
            }
            else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
            {
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                
            }
            else
            {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
            }
        }
    }
}


#pragma mark - New Methods for Phase 2

- (IBAction)showLeftMenu:(id)sender
{
    //return;
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)btnUpArrowForMap:(id)sender
{
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:
     ^{
         self.viewProgress.hidden = NO;
         self.viewMapMain.hidden = NO;
    }completion:nil];

    
}

- (void)stopAnimationGoal
{
    NSString *strTopLeft = [self.dictUpdatedDashboardData valueForKey:@"topLeft"];
    NSString *strTopRight = [self.dictUpdatedDashboardData valueForKey:@"topRight"];
    NSString *strBottomRight = [self.dictUpdatedDashboardData valueForKey:@"bottomRight"];
    NSString *strBottomLeft = [self.dictUpdatedDashboardData valueForKey:@"bottomLeft"];
    [UIView animateWithDuration:0.12
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                        self.goalStarMain.alpha = 1.0f;
                        self.viewGoalCalories.hidden = YES;
                         if([strTopLeft isEqualToString:@"cal"])
                         {
                             self.goalStarSub.alpha = 1.0;
                             self.goalStarSub.hidden = YES;
                         }
                         if([strTopRight isEqualToString:@"cal"])
                         {
                             self.goalStarSub1.alpha = 1.0;
                             self.goalStarSub1.hidden = YES;
                         }
                         if([strBottomRight isEqualToString:@"cal"])
                         {
                             self.goalStarSub2.alpha = 1.0;
                             self.goalStarSub2.hidden = YES;
                         }
                         if([strBottomLeft isEqualToString:@"cal"])
                         {
                             self.goalStarSub3.alpha = 1.0;
                             self.goalStarSub3.hidden = YES;
                         }
                         
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                     }];
    
//     self.btnMaxCalories.frame = CGRectMake(self.imgBGLogoCalories.frame.origin.x+self.imgBGLogoCalories.frame.size.width,self.imgBGLogoCalories.frame.origin.y-35, self.btnMaxCalories.frame.size.width, self.btnMaxCalories.frame.size.height);
}

- (void)startAnimationGoal
{
    
    
    NSString *strTopLeft = [self.dictUpdatedDashboardData valueForKey:@"topLeft"];
    if([strTopLeft isEqualToString:@"cal"])
    {
            self.goalStarSub.hidden = NO;
        
    }
    
    NSString *strTopRight = [self.dictUpdatedDashboardData valueForKey:@"topRight"];
    if([strTopRight isEqualToString:@"cal"])
    {
        self.goalStarSub1.hidden = NO;
    }
   
    NSString *strBottomRight = [self.dictUpdatedDashboardData valueForKey:@"bottomRight"];
    if([strBottomRight isEqualToString:@"cal"])
    {
        self.goalStarSub2.hidden = NO;
    }
    NSString *strBottomLeft = [self.dictUpdatedDashboardData valueForKey:@"bottomLeft"];
    if([strBottomLeft isEqualToString:@"cal"])
    {
        self.goalStarSub3.hidden = NO;
    }

    NSString *mainSensor = [self.dictUpdatedDashboardData objectForKey:@"main"];
    
    if([mainSensor isEqualToString:@"cal"])
    {

        self.viewGoalCalories.hidden = NO;
    
        self.goalStarMain.alpha = 1.0f;
    }
    
    self.goalStarSub.alpha = 1.0;
    self.goalStarSub1.alpha = 1.0;
    self.goalStarSub2.alpha = 1.0;
    self.goalStarSub3.alpha = 1.0;
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionRepeat |
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         
                         if([mainSensor isEqualToString:@"cal"])
                         {

                             self.goalStarMain.alpha = 0.0f;
                         }
                         
                         if([strTopLeft isEqualToString:@"cal"])
                         {
                             self.goalStarSub.alpha = 0.0f;
                         }
                         if([strTopRight isEqualToString:@"cal"])
                         {
                             self.goalStarSub1.alpha = 0.0f;
                         }
                         if([strBottomRight isEqualToString:@"cal"])
                         {
                             self.goalStarSub2.alpha = 0.0f;
                         }
                         if([strBottomLeft isEqualToString:@"cal"])
                         {
                             self.goalStarSub3.alpha = 0.0f;
                         }
                         
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                         
                     }];
    
    [self performSelector:@selector(stopAnimationGoal) withObject:nil afterDelay:3.0f];
}
- (IBAction)btnStartPressed:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    
    
//    self.viewGoalCalories.layer.opacity = 0.0f;
//    [UIView transitionWithView:self.viewGoalCalories
//                      duration:0.7f
//                       options:UIViewAnimationOptionCurveEaseInOut
//                    animations:^{ self.viewGoalCalories.layer.opacity = 1.0f; }
//                    completion:NULL];
//    self.viewGoalCalories.hidden = NO;
//    [self.bleManager getHeaderPacket]; // Testing purpose only
//    return;
    if(appDelegate().strToAddress)
    {

        if(!appDelegate().isSessionStart)
        {
            
            if(!appDelegate().strFromAddress)
            {
                
                [[GPSLocation sharedManager] start];
            }
            [self startCounter];
            
            self.lblKMHText.hidden = NO;
            self.dtStartSession = [NSDate date];
    //        int newSessionID = [Session getMaxId];
    //        NSDictionary *dictData = @{@"id":[NSString stringWithFormat:@"%d",newSessionID]};
    //        [Session addItemToSession:dictData];
            
            
            appDelegate().fromLocation = [GPSLocation sharedManager].currentLocation;
            
            [btnPressed setTitle:@"STOP" forState:UIControlStateNormal];
            [self.btnMapStart setTitle:@"STOP" forState:UIControlStateNormal];
            [self.btnStartStop setTitle:@"STOP" forState:UIControlStateNormal];
            
            self.btnTopCycle.selected = YES;
        }
        else
        {
            //[btnPressed setTitle:@"START" forState:UIControlStateNormal];
            
            self.viewSaveSession.hidden = NO;
            
        }
        
        NSArray *arrSessions = [NSArray arrayWithArray:[Session getAllSessionItems]];
        
        if(arrSessions.count > 0)
        {
            Session *thisSession = [arrSessions lastObject];
            NSLog(@"Session : %@",[thisSession description]);
        }
        NSLog(@"All Array : %@",[arrSessions description]);
    }
    else
    {
        [[GPSLocation sharedManager] start];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AppBike"
                                                            message:@"Please select destination before start session"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Ok",nil];
        alertView.tag = 1001;
        [alertView show];
    }
    
}

#pragma mark Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1 && alertView.tag == 1001)
    {
        self.viewDestination.hidden = NO;
    }
}

- (IBAction)displaySelectionMenu:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    iPositionTag = btnPressed.tag;
    //Display selection menu
    self.viewGoalCalories.hidden = YES;
    self.viewSelectionMenu.hidden = NO;
    self.btnBackground.hidden = NO;
}

- (IBAction)hideSelectionMenu:(id)sender
{
    //Hide Selection menu
    self.viewSelectionMenu.hidden = YES;
}


- (void)displayLabelAsPerValue
{
    self.lblCalorieText.text = [self.dictUpdatedDashboardData objectForKey:@"topLeft"];
    self.lblKiloMeterText.text = [self.dictUpdatedDashboardData objectForKey:@"topRight"];
    self.lblBPMText.text = [self.dictUpdatedDashboardData objectForKey:@"bottomRight"];
    self.lblRPMText.text = [self.dictUpdatedDashboardData objectForKey:@"bottomLeft"];
    
    
   
    self.lblMapAvgSpeedText.text = [self.dictUpdatedDashboardData objectForKey:@"topLeft"];
    
   
    self.lblMapKMText.text = [self.dictUpdatedDashboardData objectForKey:@"topRight"];
    
    
    self.lblMapRPMText.text = [self.dictUpdatedDashboardData objectForKey:@"bottomLeft"];
    
    
    self.lblMapBPMText.text = [self.dictUpdatedDashboardData objectForKey:@"bottomRight"];
    
    
    if([self.lblCalorieText.text isEqualToString:@"km"] || [self.lblCalorieText.text isEqualToString:@"speed"])
    {
        self.lblCalorieText.text = @"km/h";
    }
    if([self.lblKiloMeterText.text isEqualToString:@"km"] || [self.lblKiloMeterText.text isEqualToString:@"speed"])
    {
        self.lblKiloMeterText.text = @"km/h";
    }
    if([self.lblBPMText.text isEqualToString:@"km"] || [self.lblBPMText.text isEqualToString:@"speed"])
    {
        self.lblBPMText.text = @"km/h";
    }
    if([self.lblRPMText.text isEqualToString:@"km"] || [self.lblRPMText.text isEqualToString:@"speed"])
    {
        self.lblRPMText.text = @"km/h";
    }
    if([self.lblMapAvgSpeedText.text isEqualToString:@"km"] || [self.lblMapAvgSpeedText.text isEqualToString:@"speed"])
    {
        self.lblMapAvgSpeedText.text = @"km/h";
    }
    if([self.lblMapKMText.text isEqualToString:@"km"] || [self.lblMapKMText.text isEqualToString:@"speed"])
    {
        self.lblMapKMText.text = @"km/h";
    }
    if([self.lblMapRPMText.text isEqualToString:@"km"] || [self.lblMapRPMText.text isEqualToString:@"speed"])
    {
        self.lblMapRPMText.text = @"km/h";
    }
    if([self.lblMapBPMText.text isEqualToString:@"km"] || [self.lblMapBPMText.text isEqualToString:@"km"])
    {
        self.lblMapBPMText.text = @"km/h";
    }
    
    
    
    appDelegate().dictDashboardData = self.dictUpdatedDashboardData;
    [self saveJsonFile:@"dashboard.json" withDictionary:self.dictUpdatedDashboardData];
}
- (void)updateDashboardData:(int)tag
{
    switch (tag)
    {
        case 1101:
        {
            
            //Pulse
            switch (iPositionTag)
            {
                case 5501:
                {
                    [self.dictUpdatedDashboardData setObject:@"bpm" forKey:@"topLeft"];
                    [self.btnCaloriesMenu setBackgroundImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
                    self.imgTopLeft.image = [UIImage imageNamed:@"map_bpm.png"];
                }
                    break;
                case 5502:
                {
                    [self.dictUpdatedDashboardData setObject:@"bpm" forKey:@"topRight"];
                    [self.btnKMMenu setBackgroundImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
                    self.imgTopRight.image = [UIImage imageNamed:@"map_bpm.png"];
                }
                    break;
                case 5503:
                {
                    [self.dictUpdatedDashboardData setObject:@"bpm" forKey:@"bottomRight"];
                    [self.btnBPM setBackgroundImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
                    self.imgBottomRight.image = [UIImage imageNamed:@"map_bpm.png"];
                }
                    break;
                case 5504:
                {
                    [self.dictUpdatedDashboardData setObject:@"bpm" forKey:@"bottomLeft"];
                    [self.btnRPM setBackgroundImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
                    self.imgBottomLeft.image = [UIImage imageNamed:@"map_bpm.png"];
                }
                    break;
                case 5505:
                {
                    [self.dictUpdatedDashboardData setObject:@"bpm" forKey:@"main"];
                    self.viewCentralMap.hidden = NO;
                    self.imgMapCenter.image = [UIImage imageNamed:@"map_bpm.png"];
                   // [self.btnRPM setImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }

        }
        break;
        case 1102:
        {
            
            //Avg Pulse
            switch (iPositionTag)
            {
                case 5501:
                {
                    [self.dictUpdatedDashboardData setObject:@"rpm" forKey:@"topLeft"];
                    [self.btnCaloriesMenu setBackgroundImage:[UIImage imageNamed:@"rpm.png"] forState:UIControlStateNormal];
                    self.imgTopLeft.image = [UIImage imageNamed:@"map_rpm.png"];
                }
                    break;
                case 5502:
                {
                    [self.dictUpdatedDashboardData setObject:@"rpm" forKey:@"topRight"];
                    [self.btnKMMenu setBackgroundImage:[UIImage imageNamed:@"rpm.png"] forState:UIControlStateNormal];
                    self.imgTopRight.image = [UIImage imageNamed:@"map_rpm.png"];
                }
                    break;
                case 5503:
                {
                    [self.dictUpdatedDashboardData setObject:@"rpm" forKey:@"bottomRight"];
                    [self.btnBPM setBackgroundImage:[UIImage imageNamed:@"rpm.png"] forState:UIControlStateNormal];
                    self.imgBottomRight.image = [UIImage imageNamed:@"map_rpm.png"];
                }
                    break;
                case 5504:
                {
                    [self.dictUpdatedDashboardData setObject:@"rpm" forKey:@"bottomLeft"];
                    [self.btnRPM setBackgroundImage:[UIImage imageNamed:@"rpm.png"] forState:UIControlStateNormal];
                    self.imgBottomLeft.image = [UIImage imageNamed:@"map_rpm.png"];
                }
                    break;
                case 5505:
                {
                    [self.dictUpdatedDashboardData setObject:@"rpm" forKey:@"main"];
                    self.viewCentralMap.hidden = NO;
                    self.imgMapCenter.image = [UIImage imageNamed:@"map_rpm.png"];
                    // [self.btnRPM setImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
                }
                    break;
                default:
                    break;
            }

        }
        break;
        case 1103:
        {
            
            //Speed
            switch (iPositionTag)
            {
                case 5501:
                {
                    [self.dictUpdatedDashboardData setObject:@"speed" forKey:@"topLeft"];
//                    [self.btnCaloriesMenu setImage:[UIImage imageNamed:@"kilometer.png"] forState:UIControlStateNormal];
//                    self.imgTopLeft.image = [UIImage imageNamed:@"map_bpm.png"];
                    [self.btnCaloriesMenu setBackgroundImage:[UIImage imageNamed:@"avg_speed_selected.png"] forState:UIControlStateNormal];
                    self.imgTopLeft.image = [UIImage imageNamed:@"map_speed.png"];
                }
                    break;
                case 5502:
                {
                    [self.dictUpdatedDashboardData setObject:@"speed" forKey:@"topRight"];
                    [self.btnKMMenu setBackgroundImage:[UIImage imageNamed:@"avg_speed_selected.png"] forState:UIControlStateNormal];
                    self.imgTopRight.image = [UIImage imageNamed:@"map_speed.png"];
                }
                    break;
                case 5503:
                {
                    [self.dictUpdatedDashboardData setObject:@"speed" forKey:@"bottomRight"];
                    [self.btnBPM setBackgroundImage:[UIImage imageNamed:@"avg_speed_selected.png"] forState:UIControlStateNormal];
                    self.imgBottomRight.image = [UIImage imageNamed:@"map_speed.png"];
                }
                    break;
                case 5504:
                {
                    [self.dictUpdatedDashboardData setObject:@"speed" forKey:@"bottomLeft"];
                    [self.btnRPM setBackgroundImage:[UIImage imageNamed:@"avg_speed_selected.png"] forState:UIControlStateNormal];
                    self.imgBottomLeft.image = [UIImage imageNamed:@"map_speed.png"];
                }
                    break;
                case 5505:
                {
                    [self.dictUpdatedDashboardData setObject:@"speed" forKey:@"main"];
                    self.viewCentralMap.hidden = NO;
                    self.imgMapCenter.image = [UIImage imageNamed:@"map_speed.png"];
                    // [self.btnRPM setImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
                  //  self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"flow_ring_logo.png"] ;
                }
                    break;
                default:
                    break;
            }

            
        }
        break;
        case 1104:
        {
            
            //Avg Speed
            switch (iPositionTag)
            {
                case 5501:
                {
                    [self.dictUpdatedDashboardData setObject:@"km" forKey:@"topLeft"];
                    [self.btnCaloriesMenu setBackgroundImage:[UIImage imageNamed:@"avg_speed_selected.png"] forState:UIControlStateNormal];
                    self.imgTopLeft.image = [UIImage imageNamed:@"map_speed.png"];
                }
                    break;
                case 5502:
                {
                    [self.dictUpdatedDashboardData setObject:@"km" forKey:@"topRight"];
                    [self.btnKMMenu setBackgroundImage:[UIImage imageNamed:@"avg_speed_selected.png"] forState:UIControlStateNormal];
                    self.imgTopRight.image = [UIImage imageNamed:@"map_speed.png"];
                }
                    break;
                case 5503:
                {
                    [self.dictUpdatedDashboardData setObject:@"km" forKey:@"bottomRight"];
                    [self.btnBPM setBackgroundImage:[UIImage imageNamed:@"avg_speed_selected.png"] forState:UIControlStateNormal];
                    self.imgBottomRight.image = [UIImage imageNamed:@"map_speed.png"];
                }
                    break;
                case 5504:
                {
                    [self.dictUpdatedDashboardData setObject:@"km" forKey:@"bottomLeft"];
                    [self.btnRPM setBackgroundImage:[UIImage imageNamed:@"avg_speed_selected.png"] forState:UIControlStateNormal];
                    self.imgBottomLeft.image = [UIImage imageNamed:@"map_speed.png"];
                }
                    break;
                case 5505:
                {
                    [self.dictUpdatedDashboardData setObject:@"kmh" forKey:@"main"];
                    
                    self.viewCentralMap.hidden = NO;
                    
                    self.imgMapCenter.image = [UIImage imageNamed:@"map_kilometer.png"];
                   // self.imgBGLogoDashboardSpeed.frame = CGRectMake(self.imgBGLogoDashboardSpeed.frame.origin.x,self.imgBGLogoDashboardSpeed.frame.origin.y, 46, 50);
                    
                    // [self.btnRPM setImage:[UIImage imageNamed:@"bpm.png"] forState:UIControlStateNormal];
                    // self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"white_bg_logo.png"] ;
                }
                    break;
                default:
                    break;
            }
        }
        break;
        case 1105:
        {
            
            //Caloris
            switch (iPositionTag)
            {
                case 5501:
                {
                    [self.dictUpdatedDashboardData setObject:@"cal" forKey:@"topLeft"];
                    [self.btnCaloriesMenu setBackgroundImage:[UIImage imageNamed:@"cal.png"] forState:UIControlStateNormal];
                    self.imgTopLeft.image = [UIImage imageNamed:@"cal.png"];
                }
                break;
                case 5502:
                {
                    [self.dictUpdatedDashboardData setObject:@"cal" forKey:@"topRight"];
                    [self.btnKMMenu setBackgroundImage:[UIImage imageNamed:@"cal.png"] forState:UIControlStateNormal];
                    self.imgTopRight.image = [UIImage imageNamed:@"cal.png"];
                }
                break;
                case 5503:
                {
                    [self.dictUpdatedDashboardData setObject:@"cal" forKey:@"bottomRight"];
                    [self.btnBPM setBackgroundImage:[UIImage imageNamed:@"cal.png"] forState:UIControlStateNormal];
                    self.imgBottomRight.image = [UIImage imageNamed:@"cal.png"];
                }
                break;
                case 5504:
                {
                    [self.dictUpdatedDashboardData setObject:@"cal" forKey:@"bottomLeft"];
                    [self.btnRPM setBackgroundImage:[UIImage imageNamed:@"cal.png"] forState:UIControlStateNormal];
                    self.imgBottomLeft.image = [UIImage imageNamed:@"cal.png"];
                }
                break;
                case 5505:
                {
                    [self.dictUpdatedDashboardData setObject:@"cal" forKey:@"main"];
                    self.viewCentralMap.hidden = YES;
                    self.imgMapCenter.image = [UIImage imageNamed:@"map_calories.png"];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    [self displayLabelAsPerValue];
}

- (IBAction)selectMenuItemPressed:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    
    //self.btnCaloriesMenu.selected= NO;
    //self.lblCalorieText.text = @"cal";
    
      [self updateDashboardData:btnPressed.tag];
    
    NSString *mainSensor = [self.dictUpdatedDashboardData objectForKey:@"main"];
    switch (btnPressed.tag)
    {
        case 1101:
        {
            //Pulse
            self.currentSelectedSensorType = SelectedSensorTypePulse;
            
            //self.currentSelectedSensorType = SelectedSensorTypeSpeedNormal;
            
            
            if([mainSensor isEqualToString:@"kmh"])
            {
                self.viewMinMaxSpeed.hidden = YES;
                self.viewNormalSpeed.hidden = NO;
                self.viewCalories.hidden = YES;
                self.lblKMHText.text = @"km/h";
                self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"flow_ring_logo.png"];
                self.imgMapCenter.image = [UIImage imageNamed:@"map_speed.png"];
                
            }
            else if([mainSensor isEqualToString:@"bpm"])
            {
                //TODO : Replace with bpm logo.
                self.viewMinMaxSpeed.hidden = YES;
                self.viewNormalSpeed.hidden = NO;
                self.viewCalories.hidden = YES;
                self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
                self.lblKMHText.text = @"bpm";
                self.imgMapCenter.image = [UIImage imageNamed:@"map_bpm.png"];
            }
            else if([mainSensor isEqualToString:@"rpm"])
            {
                //TODO : Replace with rpm logo.
                self.viewMinMaxSpeed.hidden = YES;
                self.viewNormalSpeed.hidden = NO;
                self.viewCalories.hidden = YES;
                self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
                self.lblKMHText.text = @"bpm";
                self.imgMapCenter.image = [UIImage imageNamed:@"map_bpm.png"];
            }
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:1102];
            btn1.selected = NO;
            
            UIButton *btn2 = (UIButton *)[self.view viewWithTag:1103];
            btn2.selected = NO;
            
            UIButton *btn3 = (UIButton *)[self.view viewWithTag:1104];
            btn3.selected = NO;
            
            UIButton *btn4 = (UIButton *)[self.view viewWithTag:1105];
            btn4.selected = NO;
            
        }
        break;
        case 1102:
        {
            //Avg Pulse
            self.currentSelectedSensorType = SelectedSensorTypeAvgPulse;
            //self.currentSelectedSensorType = SelectedSensorTypeSpeedNormal;
            
            if([mainSensor isEqualToString:@"kmh"])
            {
                self.viewMinMaxSpeed.hidden = YES;
                self.viewNormalSpeed.hidden = NO;
                self.viewCalories.hidden = YES;
                self.lblKMHText.text = @"km/h";
                self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"flow_ring_logo.png"];
                self.imgMapCenter.image = [UIImage imageNamed:@"map_speed.png"];
            }
            else if([mainSensor isEqualToString:@"bpm"])
            {
                //TODO : Replace with bpm logo.
                self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
                self.lblKMHText.text = @"bpm";
                self.viewMinMaxSpeed.hidden = YES;
                self.viewNormalSpeed.hidden = NO;
                self.viewCalories.hidden = YES;
                self.imgMapCenter.image = [UIImage imageNamed:@"map_bpm.png"];
            }
            else if([mainSensor isEqualToString:@"rpm"])
            {
                //TODO : Replace with rpm logo.
                self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
                self.lblKMHText.text = @"bpm";
                self.viewMinMaxSpeed.hidden = YES;
                self.viewNormalSpeed.hidden = NO;
                self.viewCalories.hidden = YES;
                self.imgMapCenter.image = [UIImage imageNamed:@"map_rpm.png"];
            }
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:1101];
            btn1.selected = NO;
            
            UIButton *btn2 = (UIButton *)[self.view viewWithTag:1103];
            btn2.selected = NO;
            
            UIButton *btn3 = (UIButton *)[self.view viewWithTag:1104];
            btn3.selected = NO;
            
            UIButton *btn4 = (UIButton *)[self.view viewWithTag:1105];
            btn4.selected = NO;

        }
        break;
        case 1103:
        {
            //Speed
            self.currentSelectedSensorType = SelectedSensorTypeSpeedMinMax;
            self.viewSetSpeed.hidden = NO;
             self.lblKMHText.text = @"km/h";
            
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:1102];
            btn1.selected = NO;
            
            UIButton *btn2 = (UIButton *)[self.view viewWithTag:1101];
            btn2.selected = NO;
            
            UIButton *btn3 = (UIButton *)[self.view viewWithTag:1104];
            btn3.selected = NO;
            
            UIButton *btn4 = (UIButton *)[self.view viewWithTag:1105];
            btn4.selected = NO;

        }
        break;
        case 1104:
        {
            //Avg Speed
            self.currentSelectedSensorType = SelectedSensorTypeSpeedNormal;
//            if([mainSensor isEqualToString:@"kmh"])
//            {
//                self.viewMinMaxSpeed.hidden = YES;
//                self.viewNormalSpeed.hidden = NO;
//                self.viewCalories.hidden = YES;
//            }
            if([mainSensor isEqualToString:@"kmh"])
            {
                self.viewMinMaxSpeed.hidden = YES;
                self.viewNormalSpeed.hidden = NO;
                self.viewCalories.hidden = YES;
                self.lblKMHText.text = @"km/h";
                self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"white_bg_logo.png"];
                
                self.imgMapCenter.image = [UIImage imageNamed:@"map_kilometer.png"];
                //self.imgBGLogoDashboardSpeed.frame = CGRectMake(self.imgBGLogoDashboardSpeed.frame.origin.x,self.imgBGLogoDashboardSpeed.frame.origin.y, 46, 50);
                
            }
            else if([mainSensor isEqualToString:@"bpm"])
            {
                //TODO : Replace with bpm logo.
                self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
                self.lblKMHText.text = @"bpm";
                self.viewMinMaxSpeed.hidden = YES;
                self.viewNormalSpeed.hidden = NO;
                self.viewCalories.hidden = YES;
                self.imgMapCenter.image = [UIImage imageNamed:@"map_bpm.png"];
            }
            else if([mainSensor isEqualToString:@"rpm"])
            {
                //TODO : Replace with rpm logo.
                self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
                self.lblKMHText.text = @"bpm";
                self.viewMinMaxSpeed.hidden = YES;
                self.viewNormalSpeed.hidden = NO;
                self.viewCalories.hidden = YES;
                self.imgMapCenter.image = [UIImage imageNamed:@"map_rpm.png"];
            }
            
            //self.lblKMHText.text = @"km/h";
            //self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"flow_ring_logo.png"];
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:1102];
            btn1.selected = NO;
            
            UIButton *btn2 = (UIButton *)[self.view viewWithTag:1103];
            btn2.selected = NO;
            
            UIButton *btn3 = (UIButton *)[self.view viewWithTag:1101];
            btn3.selected = NO;
            
            UIButton *btn4 = (UIButton *)[self.view viewWithTag:1105];
            btn4.selected = NO;

        }
        break;
        case 1105:
        {
            //Calories
            self.currentSelectedSensorType = SelectedSensorTypeCalories;
            //Check if calories values already set if not then display that view
            
            
            if([mainSensor isEqualToString:@"kmh"])
            {
                self.viewMinMaxSpeed.hidden = YES;
                self.viewNormalSpeed.hidden = NO;
                self.viewCalories.hidden = YES;
                self.lblKMHText.text = @"km/h";
                self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"flow_ring_logo.png"];
                self.imgMapCenter.image = [UIImage imageNamed:@"map_kilometer.png"];
                
            }
            else if([mainSensor isEqualToString:@"bpm"])
            {
                //TODO : Replace with bpm logo.
                self.viewMinMaxSpeed.hidden = YES;
                self.viewNormalSpeed.hidden = NO;
                self.viewCalories.hidden = YES;
                self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
                self.lblKMHText.text = @"bpm";
                self.imgMapCenter.image = [UIImage imageNamed:@"map_bpm.png"];
            }
            else if([mainSensor isEqualToString:@"rpm"])
            {
                //TODO : Replace with rpm logo.
                self.viewMinMaxSpeed.hidden = YES;
                self.viewNormalSpeed.hidden = NO;
                self.viewCalories.hidden = YES;
                self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
                self.lblKMHText.text = @"bpm";
                self.imgMapCenter.image = [UIImage imageNamed:@"map_rpm.png"];
            }

            self.viewSetCalories.hidden = NO;
            
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:1102];
            btn1.selected = NO;
            
            UIButton *btn2 = (UIButton *)[self.view viewWithTag:1103];
            btn2.selected = NO;
            
            UIButton *btn3 = (UIButton *)[self.view viewWithTag:1104];
            btn3.selected = NO;
            
            UIButton *btn4 = (UIButton *)[self.view viewWithTag:1101];
            btn4.selected = NO;
            
           // self.btnCaloriesMenu.selected= YES;
            
            //self.lblCalorieText.text = @"Km/h";

        }
        break;
        default:
            break;
    }
    
    btnPressed.selected = !btnPressed.selected;
  
    [self hideSelectionMenu:nil];
}

#pragma mark - Set Speed View method
- (void)setupMultiSelectorControl
{
    
    //Remove it from parent view
    //self.multisectorControl = nil;
    [self.multisectorControl removeAllSectors];
    [self.multisectorControl addTarget:self action:@selector(multisectorValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    UIColor *greenColor = [UIColor colorWithRed:42.0/255.0 green:133.0/255.0 blue:202/255.0 alpha:1.0];
    
    
    SAMultisectorSector *sector3 = [SAMultisectorSector sectorWithColor:greenColor maxValue:100.0];
    
    sector3.tag = 2;
    
    sector3.startValue = [[appDelegate().dictKMHData objectForKey:@"min"] doubleValue] - 8;
    sector3.endValue = [[appDelegate().dictKMHData objectForKey:@"max"] doubleValue] - 8;
    sector3.currValue = 50.0;
    
    minValue = sector3.startValue;
    maxValue = sector3.endValue;
    
    
    self.setSpeedlblDistance.text = [NSString stringWithFormat:@"%.0f / %.0f",sector3.startValue,sector3.endValue];
    
    [self.multisectorControl addSubview:self.imgBgSetSpeed];
    [self.multisectorControl addSector:sector3];
}

- (void)multisectorValueChanged:(id)sender{
    [self updateDataView];
}

- (void)updateDataView
{
    for(SAMultisectorSector *sector in self.multisectorControl.sectors){
        
        NSString *startValue = [NSString stringWithFormat:@"%.0f", sector.startOriginalValue];
        NSString *endValue = [NSString stringWithFormat:@"%.0f", sector.endOriginalValue];
//        NSString *startValue = [NSString stringWithFormat:@"%.0f", sector.minValue];
 //       NSString *endValue = [NSString stringWithFormat:@"%.0f", sector.maxValue];
        
        minValue = sector.startOriginalValue - 8;
        maxValue = sector.endOriginalValue - 8;
//        minValue = sector.minValue;
  //      maxValue = sector.maxValue;
        self.setSpeedlblDistance.text = [NSString stringWithFormat:@"%@ / %@",startValue,endValue];
        
        [self.multisectorControl sendSubviewToBack:self.imgBgSetSpeed];
    }
}

- (void)updateCurrentValueAndCheckMinMax:(int)speed
{
    
    [self.sliderCentralMap setValue:speed];
    self.lblCentralMapValue.text = [NSString stringWithFormat:@"%d",speed];
    self.lblCentralMapText.text = @"km/h";
    
    self.lblMinMaxSpeedValue.text = [NSString stringWithFormat:@"%d",speed];
    //self.sliderDashboardMinMax = nil;
    [self.sliderDashboardMinMax removeAllSectors];
    UIColor *greenColor = [UIColor colorWithRed:42.0/255.0 green:133.0/255.0 blue:202/255.0 alpha:1.0];
    
    SAMultisectorSector *sector3 = [SAMultisectorSector sectorWithColor:greenColor maxValue:100.0];
    
    sector3.tag = 1;
    
    
    sector3.startValue = minValue;
    sector3.endValue = maxValue;
    
    NSLog(@"MIN : %d and MAX : %d",minValue,maxValue);
    sector3.startOriginalValue = minValue + 8;
    sector3.endOriginalValue = maxValue + 8;
    
    
    sector3.currValue = speed;
    NSString *mainSensor = [self.dictUpdatedDashboardData objectForKey:@"main"];
    
    
        
    if(speed < minValue || speed > maxValue)
    {
        self.bgMinMaxSpeed.image = [UIImage imageNamed:@"max_speed_ring.png"];
        self.lblMinMaxSpeedValue.textColor = [UIColor redColor];
    
        if([mainSensor isEqualToString:@"speed"])
            self.lblCentralMapValue.textColor = [UIColor redColor];
    }
    else
    {
        self.bgMinMaxSpeed.image = [UIImage imageNamed:@"set_speed_ring_blue.png"];
        self.lblMinMaxSpeedValue.textColor = [UIColor colorWithRed:29/255.0f green:188/255.0 blue:88/255.0f alpha:1.0];
        
        if([mainSensor isEqualToString:@"speed"])
            self.lblCentralMapValue.textColor = [UIColor colorWithRed:29/255.0f green:188/255.0 blue:88/255.0f alpha:1.0];
    }
    

    //minValue = sector3.startOriginalValue;
    //maxValue = sector3.endOriginalValue;
 //   minValue = sector3.startValue ;
  //  maxValue = sector3.endValue ;
    
    
    [self.sliderDashboardMinMax sendSubviewToBack:self.bgMinMaxSpeed];
    [self.sliderDashboardMinMax addSector:sector3];
}

- (IBAction)skipOrSetSpeed:(id)sender
{
    UIButton *btnPressed = (UIButton *) sender;
    
    NSString *mainSensor = [self.dictUpdatedDashboardData objectForKey:@"main"];
    
    if([mainSensor isEqualToString:@"kmh"])
    {
        self.viewNormalSpeed.hidden = YES;
        self.viewCalories.hidden = YES;
        self.viewMinMaxSpeed.hidden = NO;
    }
    
    if([mainSensor isEqualToString:@"kmh"] || [mainSensor isEqualToString:@"speed"])
    {
        
        self.viewNormalSpeed.hidden = YES;
        self.viewCalories.hidden = YES;
        self.viewMinMaxSpeed.hidden = NO;
        self.lblKMHText.text = @"km/h";
        self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"white_bg_logo.png"]; //flow_ring_logo.png
        
    }
    else if([mainSensor isEqualToString:@"bpm"])
    {
        //TODO : Replace with bpm logo.
        self.viewNormalSpeed.hidden = NO;
        self.viewCalories.hidden = YES;
        self.viewMinMaxSpeed.hidden = YES;
        self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
        self.lblKMHText.text = @"bpm";
    }
    else if([mainSensor isEqualToString:@"rpm"])
    {
        //TODO : Replace with rpm logo.
        self.viewNormalSpeed.hidden = NO;
        self.viewCalories.hidden = YES;
        self.viewMinMaxSpeed.hidden = YES;
        self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
        self.lblKMHText.text = @"bpm";
    }

    
    if(btnPressed.tag == 1201)
    {
        //Skip
        
        if([mainSensor isEqualToString:@"kmh"] || [mainSensor isEqualToString:@"speed"])
        {
            self.viewMinMaxSpeed.hidden = YES;
            self.viewCalories.hidden = YES;
            self.viewNormalSpeed.hidden = NO;
            self.lblKMHText.text = @"km/h";
            //self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"flow_ring_logo.png"];//flow_ring_logo.png
            self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"white_bg_logo.png"]; //
//            if(IS_IPHONE_5)
//            {
//                self.imgBGLogoDashboardSpeed.frame = CGRectMake(self.imgBGLogoDashboardSpeed.frame.origin.x - 5, self.imgBGLogoDashboardSpeed.frame.origin.y-13, self.imgBGLogoDashboardSpeed.frame.size.width+3, self.imgBGLogoDashboardSpeed.frame.size.height + 28);
//            }
            
        }
        else if([mainSensor isEqualToString:@"bpm"])
        {
            //TODO : Replace with bpm logo.
            self.viewMinMaxSpeed.hidden = YES;
            self.viewCalories.hidden = YES;
            self.viewNormalSpeed.hidden = NO;

            self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
            self.lblKMHText.text = @"bpm";
        }
        else if([mainSensor isEqualToString:@"rpm"])
        {
            //TODO : Replace with rpm logo.
            self.viewMinMaxSpeed.hidden = YES;
            self.viewCalories.hidden = YES;
            self.viewNormalSpeed.hidden = NO;
            self.imgBGLogoDashboardSpeed.image = [UIImage imageNamed:@"avg-pulse-logo.png"];
            self.lblKMHText.text = @"bpm";
        }
        

        
        NSDictionary *countValue = @{@"max" : [NSString stringWithFormat:@"%d",maxValue],
                                     @"min" : [NSString stringWithFormat:@"%d",minValue],
                                     @"enable" : @"0",
                                     };
        [self saveJsonFile:@"kmh.json" withDictionary:countValue];
     
    }
    else
    {
        //Set speed and change the
        //We can get latest value for min and max speeed from following local variable
        //minValue
        //maxValue
        
//        CGRect frame = self.bgMinMaxSpeed.frame;
//        [self.bgMinMaxSpeed removeFromSuperview];
//        self.bgMinMaxSpeed = [[UIImageView alloc] initWithFrame:frame];
//        self.bgMinMaxSpeed.image = [UIImage imageNamed:@"set_speed_ring.png"];
//        
        self.sliderDashboardMinMax.isDisplayCurrentValue = YES;
        self.currentSelectedSensorType = SelectedSensorTypeSpeedMinMax;
        //[self.sliderDashboardMinMax addSubview:self.bgMinMaxSpeed];
        if(!appDelegate().isSessionStart)
            [self updateCurrentValueAndCheckMinMax:50];
        
        NSLog(@"Here is min and max value : %d and %d",minValue,maxValue);
        NSDictionary *countValue = @{@"max" : [NSString stringWithFormat:@"%d",maxValue],
                                     @"min" : [NSString stringWithFormat:@"%d",minValue],
                                     @"enable" : @"1",
                                     };
        [self saveJsonFile:@"kmh.json" withDictionary:countValue];

    }
    self.viewSetSpeed.hidden = YES;
   
    
    self.btnSkipSpeed.hidden = NO;
    self.isMinMaxSpeed = YES;
}

#pragma mark - Set Calories View Method
- (IBAction)ColoriesValueChange:(id)sender
{
//    self.lblSetCaloriesValue.text = [NSString stringWithFormat:@"%d",(int)self.sliderSetCalories.value];
//    
//    self.lblGoalCalories.text = [NSString stringWithFormat:@"%d",(int)self.sliderSetCalories.value];
    self.lblSetCaloriesValue.text = [NSString stringWithFormat:@"%d",(int)self.sliderSetCalories.originalvalue];
    
    self.lblGoalCalories.text = [NSString stringWithFormat:@"%d",(int)self.sliderSetCalories.originalvalue];

}

- (IBAction)CaloriesSet:(id)sender
{
    

    NSString *mainSensor = [self.dictUpdatedDashboardData objectForKey:@"main"];
    
    if([mainSensor isEqualToString:@"cal"])
    {
        self.viewNormalSpeed.hidden = YES;
        self.viewMinMaxSpeed.hidden = YES;
        self.viewCalories.hidden = NO;
    }

    UIButton *btnPressed = (UIButton *) sender;
    if(btnPressed.tag == 4401)
    {
        //Set
        //NSLog(@"Value is ")
        self.sliderDashboardCalories.isSkipGoal = NO;
        [self.sliderDashboardCalories setMaximumValue:self.sliderSetCalories.originalvalue];
        
        [self.btnMaxCalories setTitle:[NSString stringWithFormat:@"%d",(int)self.sliderSetCalories.originalvalue] forState:UIControlStateNormal];
        
        NSDictionary *countValue = @{@"max" : @"500",@"goal" :[NSString stringWithFormat:@"%.0f",self.sliderSetCalories.originalvalue],@"enabled" : @"1" };
        [self saveJsonFile:@"calories.json" withDictionary:countValue];
    }
    else
    {
        [self.btnMaxCalories setTitle:@"--" forState:UIControlStateNormal];
        //[self.sliderDashboardCalories setMaximumValue:1];
        self.sliderDashboardCalories.isSkipGoal = YES;
        //[self.sliderDashboardCalories setNeedsDisplay];
        //Skip
        if([mainSensor isEqualToString:@"cal"])
        {
            self.viewNormalSpeed.hidden = YES;
            self.viewMinMaxSpeed.hidden = YES;
            self.viewCalories.hidden = NO;
        }
//        self.viewMinMaxSpeed.hidden = YES;
//        self.viewCalories.hidden = NO;
//        self.viewNormalSpeed.hidden = YES;
        NSDictionary *countValue = @{@"goal": @"--",@"max" : @"500",@"enabled" : @"0" };
        [self saveJsonFile:@"calories.json" withDictionary:countValue];
    }
    NSLog(@"We have new updated calory value : %d",self.sliderSetCalories.originalvalue);
    self.viewSetCalories.hidden = YES;
    self.btnSkipCalories.hidden = NO;
    self.isSetCalories = YES;
}

- (IBAction)hideGoalView:(id)sender
{
    self.viewGoalCalories.hidden = YES;
}

#pragma mark - Counter View Methods

- (void)startCounter
{
    self.viewCountdown.hidden = NO;
    self.circularSlider.maximumValue = counterTime;
    if(_timer)
        [_timer invalidate];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)saveJsonFile:(NSString *)strZone withDictionary:(NSDictionary *)dictZone
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, strZone];
    
    //NSString *filepath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",strZone] ofType:@""];
    
    
    //[[countValue JSONRepresentation] writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictZone
                                                       options:NSJSONWritingPrettyPrinted error:NULL];
    [jsonData writeToFile:filepath atomically:YES];

}
- (void)updateCounter
{
    if (counterTime < 1)
    {
        
        self.viewCountdown.hidden = YES;
        int index = [self.counterPicker selectedRowInComponent:0];
        index = index + 1 ;
        NSLog(@"Final value to save :%d",index);
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",index] forKey:kCounterKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSDictionary *dictcounter = @{ @"value": [NSString stringWithFormat:@"%d",index] };
        
        [self saveJsonFile:@"countdown.json" withDictionary:dictcounter];
        
        
        
        [self.bleManager getHeaderPacket]; //Uncomment this
        self.viewProgress.hidden = NO;
        [self addProgressbar];
        appDelegate().isSessionStart = YES;
        [_timer invalidate];
    }
    else
    {
        int maxCircleValue = [[appDelegate().dictCounterData objectForKeyedSubscript:@"value"] intValue];
        float initialValue = maxCircleValue - counterTime;
        [self.circularSlider setValue:initialValue];
        self.lblCounter.text = [NSString stringWithFormat:@"%d",counterTime];
        counterTime--;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Roboto-Regular" size:33];
    label.text = [NSString stringWithFormat:@" %ld", row+1];
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

// number Of Components
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Did select row in picker");
    int value = row + 1;
    NSLog(@"Save this value : %d",value);
}
// number Of Rows In Component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

#pragma mark - Save Session & Share session View Methods

-(void) postWithText: (NSString*) message
           ImageName: (NSString*) image
                 URL: (NSString*) url
             Caption: (NSString*) caption
                Name: (NSString*) name
      andDescription: (NSString*) description
{
    
    //    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
    //                                   url, @"link",
    //                                   name, @"name",
    //                                   caption, @"caption",
    //                                   description, @"description",
    //                                   message, @"message",
    //                                   UIImagePNGRepresentation([UIImage imageNamed: image]), @"picture",
    //                                   nil];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   
                                   name, @"name",
                                   caption, @"caption",
                                   description, @"description",
                                   message, @"message",
                                   nil];
    
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound)
    {
        // No permissions found in session, ask for it
        [FBSession.activeSession requestNewPublishPermissions: [NSArray arrayWithObject:@"publish_actions"]
                                              defaultAudience: FBSessionDefaultAudienceEveryone
                                            completionHandler: ^(FBSession *session, NSError *error)
         {
             if (!error)
             {
                 // If permissions granted and not already posting then publish the story
                 if (!m_postingInProgress)
                 {
                     [self postToWall: params];
                 }
             }
         }];
    }
    else
    {
        // If permissions present and not already posting then publish the story
        if (!m_postingInProgress)
        {
            [self postToWall: params];
        }
    }
}

-(void) postToWall: (NSMutableDictionary*) params
{
    m_postingInProgress = YES; //for not allowing multiple hits
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         if (error)
         {
             
             UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"AppBike" bundle:nil];
             
             ABFBLoginVC *loginVC =  (ABFBLoginVC *)[storyBoard instantiateViewControllerWithIdentifier:@"ABFBLoginVC"];
             
             [self.navigationController presentViewController:loginVC animated:YES completion:^{
                 
             }];
             
//             //showing an alert for failure
//             UIAlertView *alertView = [[UIAlertView alloc]
//                                       initWithTitle:@"Post Failed"
//                                       message:error.localizedDescription
//                                       delegate:nil
//                                       cancelButtonTitle:@"OK"
//                                       otherButtonTitles:nil];
//             [alertView show];
             
         }
         else
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Shared Sucessfull"
                                                                              message:@"We post your statistics on facebook."
                                                                              delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil];
                                                    [alertView show];
             
             appDelegate().strFromAddress = nil;
             
             self.viewSaveSession.hidden = YES;
             appDelegate().strToAddress = nil;
             appDelegate().toLocation = nil;
             
         }
         m_postingInProgress = NO;
         
     }];
}



- (IBAction)btnSharePressed:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    if(btnPressed.tag == 2201)
    {
        NSString *finalJson = [self convertDictToString:self.dictJsonSession];
        
        NSString *strMessage = [NSString stringWithFormat:@"Check out my statistics : %@",finalJson];
        [self postWithText:strMessage ImageName:@"logo.png" URL:@"" Caption:@"AppBike" Name:@"AppBike" andDescription:@"Description"];
        strIsShare = @"1";
        
    }
    else
    {
        //No
        strIsShare = @"0";
        // What to Do here? :)
        appDelegate().strFromAddress = nil;
        
        self.viewSaveSession.hidden = YES;
        appDelegate().strToAddress = nil;
        appDelegate().toLocation = nil;
        
    }
    
    if (self.isSessionSave)
    {
        //int newSessionID = [Session getMaxId];
        
        //NSString *finalJson = [self convertDictToString:self.dictJsonSession];
        NSDictionary *newDict = @{@"id":[self.dictSessionTemp objectForKey:@"id"],
                                 @"cal" : [self.dictSessionTemp objectForKey:@"cal"],
                                 @"km" : [self.dictSessionTemp objectForKey:@"km"],
                                 @"json" : [self.dictSessionTemp objectForKey:@"json"],
                                 @"start" : [self.dictSessionTemp objectForKey:@"start"],
                                 @"avgkm" : [self.dictSessionTemp objectForKey:@"avgkm"],
                                @"fromadr" : [self.dictSessionTemp objectForKey:@"fromadr"],
                                @"toadr" : [self.dictSessionTemp objectForKey:@"toadr"],
                                  @"is_share" : strIsShare
                                 };
        [Session addItemToSession:newDict];
    }
    
    
    //Mew code
    self.lblStopSaveSession.text = @"Stop Session?";
    
    self.lblKMHText.hidden = YES;
    counterTime = [[appDelegate().dictCounterData objectForKeyedSubscript:@"value"] intValue];
    //Display Session save message here
    [self.bleManager stopSession];
    
    appDelegate().isSessionStart = NO;
    self.viewProgress.hidden = YES;
    
    [self.btnMapStart setTitle:@"START" forState:UIControlStateNormal];
    [self.btnStartStop setTitle:@"START" forState:UIControlStateNormal];
    
    self.btnTopCycle.selected = NO;
    //New code end
   
    
    self.btnShare.hidden = YES;
    self.btnShareYes.hidden = YES;
    self.btnShareNo.hidden = YES;
    appDelegate().strFromAddress = nil;
    
    self.viewSaveSession.hidden = YES;
    appDelegate().strToAddress = nil;
    appDelegate().toLocation = nil;
    
    self.lblCalorieCount.text = @"0";
    self.lblKilometerCount.text = @"0";
    self.lblRPMCount.text = @"0";
    self.lblBPMCount.text = @"0";
    self.lblKmOrHour.text = @"0";
    
    self.viewMinMaxSpeed.hidden = YES;
    self.viewCalories.hidden = YES;
    self.viewNormalSpeed.hidden = NO;
    
    
    //self.btnSkipSpeed.hidden = YES;
    //self.btnSkipCalories.hidden = YES;
    self.isSetCalories = NO;
    self.isMinMaxSpeed = NO;
}
- (IBAction)btnSaveSession:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    if(btnPressed.tag == 1301)
    {
        
        if(![self.lblStopSaveSession.text isEqualToString:@"Stop Session?"])
        {
           
            
            //Yes save session
            self.isSessionSave = YES;
            int newSessionID = [Session getMaxId];
            
            NSString *finalJson = [self convertDictToString:self.dictJsonSession];
            self.dictSessionTemp = @{@"id":[NSString stringWithFormat:@"%d",newSessionID],
                                       @"cal" : self.lblCalorieCount.text ? self.lblCalorieCount.text : @"0",
                                       @"km" : self.lblKilometerCount.text ? self.lblKilometerCount.text : @"0",
                                       @"json" : finalJson,
                                       @"start" : self.dtStartSession ? self.dtStartSession : [NSDate date],
                                       @"avgkm" : self.lblKilometerCount.text ? self.lblKilometerCount.text : @"0",
                                       @"fromadr" : appDelegate().strFromAddress ? appDelegate().strFromAddress  : @"",
                                      @"toadr" : appDelegate().strToAddress ? appDelegate().strToAddress  : @"",
                                       };
            //[Session addItemToSession:self.dictSessionTemp];
            
            self.btnShare.hidden = NO;
            self.btnShareYes.hidden = NO;
            self.btnShareNo.hidden = NO;
            appDelegate().strFromAddress = nil;
            
           // self.viewSaveSession.hidden = YES;
            appDelegate().strToAddress = nil;
            appDelegate().toLocation = nil;
            
            self.lblCalorieCount.text = @"0";
            self.lblKilometerCount.text = @"0";
            self.lblRPMCount.text = @"0";
            self.lblBPMCount.text = @"0";
            self.lblKmOrHour.text = @"0";
            
            self.lblMapBPMValue.text = @"0";
            self.lblMapCalValue.text = @"0";
            self.lblMapKMValue.text = @"0";
            self.lblMapRPMValue.text = @"0";
            self.lblMapAvgSpeedValue.text = @"0";
            
            self.lblCaloriesValueSlider.text = @"0";
            self.lblCaloriesPercentage.text = @"0%";
            
            self.sliderDashboardCalories.isSkipGoal = NO;
            
            
            [self.viewMap removeOverlay:routeDetails.polyline]; //Remove overlays
            [self.viewMap setNeedsDisplay];
            
            [self.slices removeAllObjects];
            self.slices = [NSMutableArray arrayWithCapacity:2];
            
            NSNumber *one = [NSNumber numberWithInt:0];;
            NSNumber *two = [NSNumber numberWithInt:500];
            
            [_slices addObject:one];
            [_slices addObject:two];
            [self.pieChartLeft reloadData];
            
            self.viewMinMaxSpeed.hidden = YES;
            self.viewCalories.hidden = YES;
            self.viewNormalSpeed.hidden = NO;
            
            
            //self.btnSkipSpeed.hidden = YES;
            //self.btnSkipCalories.hidden = YES;
            self.isSetCalories = NO;
            self.isMinMaxSpeed = NO;
            
            
            NSString *strCTime = [[NSUserDefaults standardUserDefaults] objectForKey:kCounterKey];
            if(strCTime == nil)
            {
                strCTime = @"5";
            }
            
            counterTime = [strCTime intValue];
            
        }
        else
        {
            self.lblStopSaveSession.text = @"Save Session?";
            
            self.lblKMHText.hidden = YES;
            counterTime = [[appDelegate().dictCounterData objectForKeyedSubscript:@"value"] intValue];
            //Display Session save message here
            [self.bleManager stopSession];
            
            appDelegate().isSessionStart = NO;
            self.viewProgress.hidden = YES;
            
            [self.btnMapStart setTitle:@"START" forState:UIControlStateNormal];
            [self.btnStartStop setTitle:@"START" forState:UIControlStateNormal];
            
            self.btnTopCycle.selected = NO;
        }
       
    }
    else
    {
        //No need to save session in db
        if([self.lblStopSaveSession.text isEqualToString:@"Stop Session?"])
        {
            self.viewSaveSession.hidden = YES;
        }
        else
        {
            //Not Save but reset session
            self.isSessionSave = NO;
            self.viewSaveSession.hidden = YES;
            
            self.lblStopSaveSession.text = @"Stop Session?";
            self.lblKMHText.hidden = YES;
            counterTime = [[appDelegate().dictCounterData objectForKeyedSubscript:@"value"] intValue];
            //Display Session save message here
            [self.bleManager stopSession];
            
            appDelegate().isSessionStart = NO;
            self.viewProgress.hidden = YES;
            
            [self.btnMapStart setTitle:@"START" forState:UIControlStateNormal];
            [self.btnStartStop setTitle:@"START" forState:UIControlStateNormal];
            
            self.btnTopCycle.selected = NO;
            //self.btnShare.hidden = NO;
            //self.btnShareYes.hidden = NO;
            //self.btnShareNo.hidden = NO;
            appDelegate().strFromAddress = nil;
            
            // self.viewSaveSession.hidden = YES;
            appDelegate().strToAddress = nil;
            appDelegate().toLocation = nil;
            
            
            [self.slices removeAllObjects];
            self.slices = [NSMutableArray arrayWithCapacity:2];
            
            NSNumber *one = [NSNumber numberWithInt:0];;
            NSNumber *two = [NSNumber numberWithInt:500];
            
            [_slices addObject:one];
            [_slices addObject:two];
            [self.pieChartLeft reloadData];
            
            self.lblCalorieCount.text = @"0";
            self.lblKilometerCount.text = @"0";
            self.lblRPMCount.text = @"0";
            self.lblBPMCount.text = @"0";
            self.lblKmOrHour.text = @"0";
            
            self.lblMapBPMValue.text = @"0";
            self.lblMapCalValue.text = @"0";
            self.lblMapKMValue.text = @"0";
            self.lblMapRPMValue.text = @"0";
            self.lblMapAvgSpeedValue.text = @"0";
            
            self.lblCaloriesValueSlider.text = @"0";
            self.lblCaloriesPercentage.text = @"0%";
            
            self.viewMinMaxSpeed.hidden = YES;
            self.viewCalories.hidden = YES;
            self.viewNormalSpeed.hidden = NO;
            
            self.sliderDashboardCalories.isSkipGoal = NO;
            
            //self.btnSkipSpeed.hidden = YES;
            //self.btnSkipCalories.hidden = YES;
            self.isSetCalories = NO;
            self.isMinMaxSpeed = NO;
            
            
            NSString *strCTime = [[NSUserDefaults standardUserDefaults] objectForKey:kCounterKey];
            if(strCTime == nil)
            {
                strCTime = @"5";
            }
            
            counterTime = [strCTime intValue];
        }
    }
    
}

#pragma mark - Progress bar methods
- (void)addProgressbar
{
    [self initRoundedFatProgressBar:self.progressBarRoundedFat];
    [self setProgress:0.0 animated:YES];
}

#pragma mark YLViewController Private Methods

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [_progressBarRoundedFat setProgress:progress animated:animated];
    self.lblEngineCount.text = [NSString stringWithFormat:@"%d%%",(int)(progress * 100)];
    int remaining = 100 - (progress * 100);
    self.lblMeCount.text = [NSString stringWithFormat:@"%d%%",remaining];
}

- (void)initRoundedFatProgressBar:(YLProgressBar*)progressBarRounderFat
{

    NSArray *tintColors = @[[UIColor colorWithRed:38/255.0f green:133/255.0f blue:220/255.0f alpha:1.0f]];
    
    progressBarRounderFat.progressTintColors       = tintColors;
    progressBarRounderFat.type               = YLProgressBarTypeRounded;
    progressBarRounderFat.stripesOrientation       = YLProgressBarStripesOrientationLeft;
    progressBarRounderFat.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeNone;
    progressBarRounderFat.stripesAnimated = NO;
    progressBarRounderFat.indicatorTextLabel.font  = [UIFont fontWithName:@"Arial-BoldMT" size:20];
}


#pragma mark - UI Methods



-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
    
    
}
- (void)updateUIForiPhone6
{
    
    NSLog(@"iPhone 6 Size Width : %f and Height : %f",self.view.frame.size.width, self.view.frame.size.height);
    
//    self.viewCentralMap.frame = CGRectMake(self.viewCentralMap.frame.origin.x, self.viewCentralMap.frame.origin.y-6, self.viewCentralMap.frame.size.width+6, self.viewCentralMap.frame.size.height-20);
//    
//     self.sliderCentralMap.frame = CGRectMake(self.sliderCentralMap.frame.origin.x, self.sliderCentralMap.frame.origin.y-10, self.sliderCentralMap.frame.size.width, self.sliderCentralMap.frame.size.height);
////    self.viewCentralMap.backgroundColor = [UIColor redColor];
    self.lblCentralMapText.frame = CGRectMake(self.lblCentralMapText.frame.origin.x, self.lblCentralMapText.frame.origin.y-5, self.lblCentralMapText.frame.size.width, self.lblCentralMapText.frame.size.height);
    
    self.multisectorControl.sectorsRadius = 120.0;//130
    self.multisectorControl.frame = CGRectMake(self.multisectorControl.frame.origin.x-40, self.multisectorControl.frame.origin.y-72, 300, 300);
    
    
    self.imgBGMinMaxSet.frame = CGRectMake(self.imgBGMinMaxSet.frame.origin.x-40, self.imgBGMinMaxSet.frame.origin.y-78, 290, 290);
    
    self.setSpeedlblDistance.frame =  CGRectMake(self.setSpeedlblDistance.frame.origin.x+50, self.setSpeedlblDistance.frame.origin.y+30, self.setSpeedlblDistance.frame.size.width, self.setSpeedlblDistance.frame.size.height);
    
    
    self.setSpeedlblKMH.frame =  CGRectMake(self.setSpeedlblKMH.frame.origin.x+50, self.setSpeedlblKMH.frame.origin.y+30, self.setSpeedlblKMH.frame.size.width, self.setSpeedlblKMH.frame.size.height);
    
    
    
     self.viewSetSpeed.frame = CGRectMake(self.viewSetSpeed.frame.origin.x, self.viewSetSpeed.frame.origin.y+41, self.viewSetSpeed.frame.size.width, self.viewSetSpeed.frame.size.height-52);
    
    
   
//    self.bgImgSetCaloris.frame = CGRectMake(self.bgImgSetCaloris.frame.origin.x-23, self.bgImgSetCaloris.frame.origin.y+3, self.bgImgSetCaloris.frame.size.width+50, self.bgImgSetCaloris.frame.size.height);
    
//    self.imgBgSetSpeedLogo.frame = CGRectMake(self.imgBgSetSpeedLogo.frame.origin.x+3, self.imgBgSetSpeedLogo.frame.origin.y+10, self.imgBgSetSpeedLogo.frame.size.width, self.imgBgSetSpeedLogo.frame.size.height);
    
    //Set Calories
//    self.sliderSetCalories.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x+75, self.sliderDashboardSpeed.frame.origin.y+99, 300, 300);
    
    self.viewSetCalories.frame = CGRectMake(self.viewSetCalories.frame.origin.x, self.viewSetCalories.frame.origin.y+41, self.viewSetCalories.frame.size.width, self.viewSetCalories.frame.size.height-41);
  self.sliderSetCalories.frame = CGRectMake(self.sliderSetCalories.frame.origin.x-50, self.sliderSetCalories.frame.origin.y-50, 300, 300);
    self.bgImgSetCaloris.frame = CGRectMake(self.bgImgSetCaloris.frame.origin.x-50, self.bgImgSetCaloris.frame.origin.y-50, 300,300);
    self.imgBgSetSpeedLogo.frame = CGRectMake(self.imgBgSetSpeedLogo.frame.origin.x+15, self.imgBgSetSpeedLogo.frame.origin.y+85, self.imgBgSetSpeedLogo.frame.size.width+10, self.imgBgSetSpeedLogo.frame.size.height+10);
      self.viewBgLogoCal.frame = CGRectMake(self.viewBgLogoCal.frame.origin.x+1, self.viewBgLogoCal.frame.origin.y+75, self.viewBgLogoCal.frame.size.width+20, self.viewBgLogoCal.frame.size.height);
    self.viewBgLogoCal.layer.cornerRadius = 20;
    //self.viewBgLogoCal.backgroundColor = [UIColor darkGrayColor];
    
    
    self.lblSecText.frame = CGRectMake(self.lblSecText.frame.origin.x-23, self.lblSecText.frame.origin.y+20, self.lblSecText.frame.size.width, self.lblSecText.frame.size.height);
    
   
    
    self.lblCounter.frame = CGRectMake(self.lblCounter.frame.origin.x, self.lblCounter.frame.origin.y-25, self.lblCounter.frame.size.width, self.lblCounter.frame.size.height+40);
    self.lblCounter.font = [UIFont fontWithName:@"Roboto-Regular" size:80];
    
    self.lblMinMaxSpeedValue.frame = CGRectMake(self.lblMinMaxSpeedValue.frame.origin.x-25, self.lblMinMaxSpeedValue.frame.origin.y-10, self.lblMinMaxSpeedValue.frame.size.width+40, self.lblMinMaxSpeedValue.frame.size.height+30);
    self.lblMinMaxSpeedValue.font = [UIFont fontWithName:@"Roboto-Bold" size:110];
    
    self.lblCurrentSpeed.frame = CGRectMake(self.lblCurrentSpeed.frame.origin.x-20, self.lblCurrentSpeed.frame.origin.y, self.lblCurrentSpeed.frame.size.width+40, self.lblCurrentSpeed.frame.size.height+50);
    self.lblCurrentSpeed.font = [UIFont fontWithName:@"Roboto-Bold" size:90];
    
    self.lblKMHText.frame = CGRectMake(self.lblKMHText.frame.origin.x, self.lblKMHText.frame.origin.y+30, self.lblKMHText.frame.size.width, self.lblKMHText.frame.size.height);
    
    
    self.lblCalTextSlider.frame = CGRectMake(self.lblCalTextSlider.frame.origin.x, self.lblCalTextSlider.frame.origin.y+30, self.lblCalTextSlider.frame.size.width, self.lblCalTextSlider.frame.size.height);
    self.lblCalTextSlider.font = [UIFont fontWithName:@"Roboto-Regular" size:32];
    
    // self.lblCaloriesValueSlider.backgroundColor = [UIColor redColor];
    self.lblCaloriesValueSlider.frame = CGRectMake(self.lblCaloriesValueSlider.frame.origin.x-50, self.lblCaloriesValueSlider.frame.origin.y, self.lblCaloriesValueSlider.frame.size.width+100, self.lblCaloriesValueSlider.frame.size.height+40);
    self.lblCaloriesValueSlider.font = [UIFont fontWithName:@"Roboto-Bold" size:80];
    
    //self.lblCaloriesPercentage.backgroundColor = [UIColor redColor];
    self.lblCaloriesPercentage.frame = CGRectMake(self.lblCaloriesPercentage.frame.origin.x-30, self.lblCaloriesPercentage.frame.origin.y+20, self.lblCaloriesPercentage.frame.size.width+60, self.lblCaloriesPercentage.frame.size.height+40);
    self.lblCaloriesPercentage.font = [UIFont fontWithName:@"Roboto-Bold" size:60];
    
    self.btnCaloriesMenu.frame = CGRectMake(self.btnCaloriesMenu.frame.origin.x, self.btnCaloriesMenu.frame.origin.y, 40,40);
    
    self.btnKMMenu.frame = CGRectMake(self.btnKMMenu.frame.origin.x, self.btnKMMenu.frame.origin.y, 40,40);
    self.btnBPM.frame = CGRectMake(self.btnBPM.frame.origin.x, self.btnBPM.frame.origin.y, 40,40);
    
    self.btnRPM.frame = CGRectMake(self.btnRPM.frame.origin.x, self.btnRPM.frame.origin.y, 40,40);
    
    
    //375 x 667
    self.sliderDashboardSpeed.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x, self.sliderDashboardSpeed.frame.origin.y, 300, 300);
    self.imgBGDashboardSpeed.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x-50, self.sliderDashboardSpeed.frame.origin.y-30, 300, 300);
    self.sliderDashboardSpeed.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x-40, self.sliderDashboardSpeed.frame.origin.y-15, 280, 280);
    self.imgBGLogoDashboardSpeed.frame = CGRectMake(self.imgBGLogoDashboardSpeed.frame.origin.x-12,self.imgBGLogoDashboardSpeed.frame.origin.y+58, 70, 50);//46
    
   // self.viewSpeedStart.frame = CGRectMake(self.viewSpeedStart.frame.origin.x, self.viewSpeedStart.frame.origin.y, self.viewSpeedStart.frame.size.width, self.viewSpeedStart.frame.size.height-30);
    
    self.btnUpDown.frame = CGRectMake(self.btnUpDown.frame.origin.x-5, self.btnUpDown.frame.origin.y, self.btnUpDown.frame.size.width, self.btnUpDown.frame.size.height);
    
    //Top Progress
    self.lblEngineText.frame = CGRectMake(self.lblEngineText.frame.origin.x + 20, self.lblEngineText.frame.origin.y, self.lblEngineText.frame.size.width, self.lblEngineText.frame.size.height);
    self.lblMeText.frame = CGRectMake(self.lblMeText.frame.origin.x - 20, self.lblMeText.frame.origin.y, self.lblMeText.frame.size.width, self.lblMeText.frame.size.height);
    
    //Selection Menu
    [self.btnSelectPulse setTitleEdgeInsets:UIEdgeInsetsMake(30,-42, 0, 0)];
    [self.btnSelectAvgPulse setTitleEdgeInsets:UIEdgeInsetsMake(30,-52, 0, 0)];
    [self.btnSelectSpeed setTitleEdgeInsets:UIEdgeInsetsMake(30,-42, 0, 0)];
    
    [self.btnSelectAvgSpeed setTitleEdgeInsets:UIEdgeInsetsMake(30,-12, 0, 0)];
    [self.btnSelectAvgSpeed setImageEdgeInsets:UIEdgeInsetsMake(0,50, 0, 0)];
    
    [self.btnSelectCalories setTitleEdgeInsets:UIEdgeInsetsMake(30,-42, 0, 0)];
    
    
  
    
    
    //Calories Dashboard view UI
    self.sliderDashboardCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x, self.sliderDashboardCalories.frame.origin.y, 300, 300);
    self.imgBGCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x-45, self.sliderDashboardCalories.frame.origin.y-20, 290, 290);
    self.sliderDashboardCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x-40, self.sliderDashboardCalories.frame.origin.y-10, 280, 280);
    self.imgBGLogoCalories.frame = CGRectMake(self.imgBGLogoCalories.frame.origin.x-12,self.imgBGLogoCalories.frame.origin.y+55, 70, 46);
    
//    self.btnMaxCalories.frame = CGRectMake(self.imgBGLogoCalories.frame.origin.x+self.imgBGLogoCalories.frame.size.width,self.imgBGLogoCalories.frame.origin.y-8, self.btnMaxCalories.frame.size.width, self.btnMaxCalories.frame.size.height);
    
    
      self.btnMaxCalories.frame = CGRectMake(self.imgBGLogoCalories.frame.origin.x+self.imgBGLogoCalories.frame.size.width-25,self.imgBGLogoCalories.frame.origin.y, self.btnMaxCalories.frame.size.width, self.btnMaxCalories.frame.size.height);
    //self.sliderDashboardCalories.value = 100;
    
    
      self.viewCalories.frame = CGRectMake(self.viewCalories.frame.origin.x, self.viewCalories.frame.origin.y-50, self.viewCalories.frame.size.width, self.viewCalories.frame.size.height);
  
//      self.viewGoalCalories.frame = CGRectMake(self.viewGoalCalories.frame.origin.x-40, self.viewGoalCalories.frame.origin.y-40, self.viewGoalCalories.frame.size.width+80, self.viewGoalCalories.frame.size.height+80);
    
    self.viewGoalCalories.frame = CGRectMake(self.viewGoalCalories.frame.origin.x-40, self.viewGoalCalories.frame.origin.y-40, 280, 290); //280 280
    self.bgGoalImage.frame = CGRectMake(self.bgGoalImage.frame.origin.x-50, self.sliderDashboardSpeed.frame.origin.y, 300, 300);
    //self.bgGoalImage.frame = CGRectMake(self.bgGoalImage.frame.origin.x, self.bgGoalImage.frame.origin.y, self.bgGoalImage.frame.size.width+50, self.bgGoalImage.frame.size.height+50);
    
    NSLog(@"Assistant level frame : x : %f, y : %d, width : %f, height : %f",self.assistantLevelView.frame.origin.x, self.viewGoalCalories.frame.origin.y, self.assistantLevelView.frame.size.width, self.assistantLevelView.frame.size.height);
    self.assistantLevelView.frame = CGRectMake(self.assistantLevelView.frame.origin.x, self.view.frame.size.height - self.assistantLevelView.frame.size.height, self.assistantLevelView.frame.size.width, self.assistantLevelView.frame.size.height);
    
  
    
//    self.sliderDashboardMinMax.sectorsRadius = 130.0;
//    self.sliderDashboardMinMax.frame = CGRectMake(self.sliderDashboardMinMax.frame.origin.x-80, self.sliderDashboardMinMax.frame.origin.y, 320, 320);
//
//     self.viewMinMaxSpeed.frame = CGRectMake(self.viewMinMaxSpeed.frame.origin.x-30, self.viewMinMaxSpeed.frame.origin.y, 300, 300);
//    //self.sliderDashboardMinMax.frame = CGRectMake(0, 0, 300, 200);
//    self.bgMinMaxSpeed.frame = CGRectMake(0, 0, 290, 290);
    
    self.sliderDashboardMinMax.sectorsRadius = 120.0;//130
    self.sliderDashboardMinMax.frame = CGRectMake(self.sliderDashboardMinMax.frame.origin.x-60, self.sliderDashboardMinMax.frame.origin.y, 300, 300);
    //    self.sliderDashboardMinMax.frame = CGRectMake(self.sliderDashboardMinMax.frame.origin.x-80, self.sliderDashboardMinMax.frame.origin.y, 300, 300); //320 320
    
    self.viewMinMaxSpeed.frame = CGRectMake(self.viewMinMaxSpeed.frame.origin.x-20, self.viewMinMaxSpeed.frame.origin.y, 280, 280);
    //    self.viewMinMaxSpeed.frame = CGRectMake(self.viewMinMaxSpeed.frame.origin.x-30, self.viewMinMaxSpeed.frame.origin.y, 280, 280);//300 300
    //self.sliderDashboardMinMax.frame = CGRectMake(0, 0, 300, 200);
    self.bgMinMaxSpeed.frame = CGRectMake(0, 0, 270, 270);//290 290

   
    
    self.circularSlider.frame = CGRectMake(self.circularSlider.frame.origin.x-30, self.circularSlider.frame.origin.y-10, self.circularSlider.frame.size.width + 60, self.circularSlider.frame.size.height + 60);
    
    self.btnShareYes.frame = CGRectMake(self.btnShareYes.frame.origin.x+8, self.btnShareYes.frame.origin.y, self.btnShareYes.frame.size.width, self.btnShareYes.frame.size.height);
    self.btnShareNo.frame = CGRectMake(self.btnShareNo.frame.origin.x-8, self.btnShareNo.frame.origin.y, self.btnShareNo.frame.size.width, self.btnShareNo.frame.size.height);
    
    self.btnSaveSessionYes.frame = CGRectMake(self.btnSaveSessionYes.frame.origin.x+7, self.btnSaveSessionYes.frame.origin.y, self.btnSaveSessionYes.frame.size.width, self.btnSaveSessionYes.frame.size.height);
    self.btnSaveSessionNo.frame = CGRectMake(self.btnSaveSessionNo.frame.origin.x-7, self.btnSaveSessionNo.frame.origin.y, self.btnSaveSessionNo.frame.size.width, self.btnSaveSessionNo.frame.size.height);
}

- (void)updateUIForiPhone6Plus
{
    
    
     NSLog(@"iPhone 6+ Size Width : %f and Height : %f",self.view.frame.size.width, self.view.frame.size.height);
    //414x736
    
      self.lblCentralMapText.frame = CGRectMake(self.lblCentralMapText.frame.origin.x, self.lblCentralMapText.frame.origin.y-5, self.lblCentralMapText.frame.size.width, self.lblCentralMapText.frame.size.height);
    
    self.viewSetSpeed.frame = CGRectMake(self.viewSetSpeed.frame.origin.x, self.viewSetSpeed.frame.origin.y+41, self.viewSetSpeed.frame.size.width, self.viewSetSpeed.frame.size.height-52);
    
//    self.viewSetCalories.frame = CGRectMake(self.viewSetCalories.frame.origin.x, self.viewSetCalories.frame.origin.y+41, self.viewSetCalories.frame.size.width, self.viewSetCalories.frame.size.height-51);
    
    self.viewSetCalories.frame = CGRectMake(self.viewSetCalories.frame.origin.x, self.viewSetCalories.frame.origin.y+41, self.viewSetCalories.frame.size.width, self.viewSetCalories.frame.size.height-41);
    self.sliderSetCalories.frame = CGRectMake(self.sliderSetCalories.frame.origin.x-50, self.sliderSetCalories.frame.origin.y-50, 300, 300);
    self.bgImgSetCaloris.frame = CGRectMake(self.bgImgSetCaloris.frame.origin.x-50, self.bgImgSetCaloris.frame.origin.y-50, 300,300);
//    self.imgBgSetSpeedLogo.frame = CGRectMake(self.imgBgSetSpeedLogo.frame.origin.x-12, self.imgBgSetSpeedLogo.frame.origin.y-18, self.imgBgSetSpeedLogo.frame.size.width+10, self.imgBgSetSpeedLogo.frame.size.height+10);
    
    self.imgBgSetSpeedLogo.frame = CGRectMake(self.imgBgSetSpeedLogo.frame.origin.x+35, self.imgBgSetSpeedLogo.frame.origin.y+105, self.imgBgSetSpeedLogo.frame.size.width+10, self.imgBgSetSpeedLogo.frame.size.height+10);
    //self.viewBgLogoCal.frame = CGRectMake(self.viewBgLogoCal.frame.origin.x+35, self.viewBgLogoCal.frame.origin.y+105, self.viewBgLogoCal.frame.size.width, self.viewBgLogoCal.frame.size.height);
    
    self.viewBgLogoCal.frame = CGRectMake(self.viewBgLogoCal.frame.origin.x+19, self.viewBgLogoCal.frame.origin.y+105, self.viewBgLogoCal.frame.size.width+20, self.viewBgLogoCal.frame.size.height);
    self.viewBgLogoCal.layer.cornerRadius = 20;
    //self.viewBgLogoCal.backgroundColor = [UIColor darkGrayColor];
    
    
    self.lblSecText.frame = CGRectMake(self.lblSecText.frame.origin.x-38, self.lblSecText.frame.origin.y+30, self.lblSecText.frame.size.width, self.lblSecText.frame.size.height);
    
    //self.bgImgSetCaloris.frame = CGRectMake(self.bgImgSetCaloris.frame.origin.x+10, self.bgImgSetCaloris.frame.origin.y+27, self.bgImgSetCaloris.frame.size.width-5, self.bgImgSetCaloris.frame.size.height-70);
    
    //self.imgBgSetSpeedLogo.frame = CGRectMake(self.imgBgSetSpeedLogo.frame.origin.x+3, self.imgBgSetSpeedLogo.frame.origin.y-35, self.imgBgSetSpeedLogo.frame.size.width, self.imgBgSetSpeedLogo.frame.size.height);

    self.lblCounter.frame = CGRectMake(self.lblCounter.frame.origin.x, self.lblCounter.frame.origin.y-25, self.lblCounter.frame.size.width, self.lblCounter.frame.size.height+40);
    self.lblCounter.font = [UIFont fontWithName:@"Roboto-Regular" size:80];

    
    //self.lblMinMaxSpeedValue.backgroundColor = [UIColor redColor];
    self.lblMinMaxSpeedValue.frame = CGRectMake(self.lblMinMaxSpeedValue.frame.origin.x-25, self.lblMinMaxSpeedValue.frame.origin.y-10, self.lblMinMaxSpeedValue.frame.size.width+40, self.lblMinMaxSpeedValue.frame.size.height+30);
    self.lblMinMaxSpeedValue.font = [UIFont fontWithName:@"Roboto-Bold" size:110];

    
    self.lblCurrentSpeed.frame = CGRectMake(self.lblCurrentSpeed.frame.origin.x-20, self.lblCurrentSpeed.frame.origin.y, self.lblCurrentSpeed.frame.size.width+40, self.lblCurrentSpeed.frame.size.height+50);
    self.lblCurrentSpeed.font = [UIFont fontWithName:@"Roboto-Bold" size:90];
    
    self.lblKMHText.frame = CGRectMake(self.lblKMHText.frame.origin.x, self.lblKMHText.frame.origin.y+30, self.lblKMHText.frame.size.width, self.lblKMHText.frame.size.height);
    
    
    self.lblCalTextSlider.frame = CGRectMake(self.lblCalTextSlider.frame.origin.x, self.lblCalTextSlider.frame.origin.y+30, self.lblCalTextSlider.frame.size.width, self.lblCalTextSlider.frame.size.height);
    self.lblCalTextSlider.font = [UIFont fontWithName:@"Roboto-Regular" size:32];
    
   // self.lblCaloriesValueSlider.backgroundColor = [UIColor redColor];
    self.lblCaloriesValueSlider.frame = CGRectMake(self.lblCaloriesValueSlider.frame.origin.x-50, self.lblCaloriesValueSlider.frame.origin.y, self.lblCaloriesValueSlider.frame.size.width+100, self.lblCaloriesValueSlider.frame.size.height+40);
    self.lblCaloriesValueSlider.font = [UIFont fontWithName:@"Roboto-Bold" size:80];
    
     //self.lblCaloriesPercentage.backgroundColor = [UIColor redColor];
    self.lblCaloriesPercentage.frame = CGRectMake(self.lblCaloriesPercentage.frame.origin.x-30, self.lblCaloriesPercentage.frame.origin.y+30, self.lblCaloriesPercentage.frame.size.width+60, self.lblCaloriesPercentage.frame.size.height+40);
    self.lblCaloriesPercentage.font = [UIFont fontWithName:@"Roboto-Bold" size:60];
    

    self.btnCaloriesMenu.frame = CGRectMake(self.btnCaloriesMenu.frame.origin.x, self.btnCaloriesMenu.frame.origin.y, 40,40);
    
    self.btnKMMenu.frame = CGRectMake(self.btnKMMenu.frame.origin.x, self.btnKMMenu.frame.origin.y, 40,40);
    self.btnBPM.frame = CGRectMake(self.btnBPM.frame.origin.x, self.btnBPM.frame.origin.y, 40,40);
    
    self.btnRPM.frame = CGRectMake(self.btnRPM.frame.origin.x, self.btnRPM.frame.origin.y, 40,40);
    
    
    
    self.sliderDashboardSpeed.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x-2, self.sliderDashboardSpeed.frame.origin.y-5, 305, 305);
    self.imgBGDashboardSpeed.frame = CGRectMake(self.imgBGDashboardSpeed.frame.origin.x-42, self.imgBGDashboardSpeed.frame.origin.y-22, 298, 298);
    self.sliderDashboardSpeed.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x-40, self.sliderDashboardSpeed.frame.origin.y-15, 290, 290);
    self.imgBGLogoDashboardSpeed.frame = CGRectMake(self.imgBGLogoDashboardSpeed.frame.origin.x-10,self.imgBGLogoDashboardSpeed.frame.origin.y+70, 70, 46);
    
    self.btnUpDown.frame = CGRectMake(self.btnUpDown.frame.origin.x, self.btnUpDown.frame.origin.y - 5, self.btnUpDown.frame.size.width, self.btnUpDown.frame.size.height);
    
    //Top Progress
    self.lblEngineText.frame = CGRectMake(self.lblEngineText.frame.origin.x + 30, self.lblEngineText.frame.origin.y, self.lblEngineText.frame.size.width, self.lblEngineText.frame.size.height);
    self.lblMeText.frame = CGRectMake(self.lblMeText.frame.origin.x - 30, self.lblMeText.frame.origin.y, self.lblMeText.frame.size.width, self.lblMeText.frame.size.height);
    

    //Set Min Max Speed View UI
    NSLog(@"Multi sector control frame : x : %f, y : %f, width : %f, height : %f",self.multisectorControl.frame.origin.x, self.multisectorControl.frame.origin.y, self.multisectorControl.frame.size.width, self.multisectorControl.frame.size.height);
    
   
    
    
    
     NSLog(@"Multi sector control frame : x : %f, y : %f, width : %f, height : %f",self.multisectorControl.frame.origin.x, self.multisectorControl.frame.origin.y, self.multisectorControl.frame.size.width, self.multisectorControl.frame.size.height);
    //Selection Menu
    [self.btnSelectPulse setTitleEdgeInsets:UIEdgeInsetsMake(30,-42, 0, 0)];
    [self.btnSelectAvgPulse setTitleEdgeInsets:UIEdgeInsetsMake(30,-52, 0, 0)];
    [self.btnSelectSpeed setTitleEdgeInsets:UIEdgeInsetsMake(30,-42, 0, 0)];
    
    [self.btnSelectAvgSpeed setTitleEdgeInsets:UIEdgeInsetsMake(30,-12, 0, 0)];
    [self.btnSelectAvgSpeed setImageEdgeInsets:UIEdgeInsetsMake(0,50, 0, 0)];
    
    [self.btnSelectCalories setTitleEdgeInsets:UIEdgeInsetsMake(30,-42, 0, 0)];

    
    //Set Calories
    //self.sliderSetCalories.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x+95, self.sliderDashboardSpeed.frame.origin.y+119, 300, 300);
   
    
    //Calories on Dashboard UI
    self.sliderDashboardCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x, self.sliderDashboardCalories.frame.origin.y, 300, 300);
    self.imgBGCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x-50, self.sliderDashboardCalories.frame.origin.y-25, 300, 300);
    self.sliderDashboardCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x-40, self.sliderDashboardCalories.frame.origin.y-12, 290, 290);
    self.imgBGLogoCalories.frame = CGRectMake(self.imgBGLogoCalories.frame.origin.x-10,self.imgBGLogoCalories.frame.origin.y+70, 70, 46);
    
    self.btnMaxCalories.frame = CGRectMake(self.imgBGLogoCalories.frame.origin.x+self.imgBGLogoCalories.frame.size.width-25,self.imgBGLogoCalories.frame.origin.y-5, self.btnMaxCalories.frame.size.width, self.btnMaxCalories.frame.size.height);
    
    
    self.viewCalories.frame = CGRectMake(self.viewCalories.frame.origin.x, self.viewCalories.frame.origin.y-50, self.viewCalories.frame.size.width, self.viewCalories.frame.size.height);

    self.viewGoalCalories.frame = CGRectMake(self.viewGoalCalories.frame.origin.x-40, self.viewGoalCalories.frame.origin.y-40, 290, 300);//280 280
    self.bgGoalImage.frame = CGRectMake(self.bgGoalImage.frame.origin.x-50, self.sliderDashboardSpeed.frame.origin.y, 300, 300);
    
    
    self.sliderDashboardMinMax.sectorsRadius = 120.0;//130
     self.sliderDashboardMinMax.frame = CGRectMake(self.sliderDashboardMinMax.frame.origin.x-60, self.sliderDashboardMinMax.frame.origin.y, 300, 300);
//    self.sliderDashboardMinMax.frame = CGRectMake(self.sliderDashboardMinMax.frame.origin.x-80, self.sliderDashboardMinMax.frame.origin.y, 300, 300); //320 320

     self.viewMinMaxSpeed.frame = CGRectMake(self.viewMinMaxSpeed.frame.origin.x-20, self.viewMinMaxSpeed.frame.origin.y, 280, 280);
//    self.viewMinMaxSpeed.frame = CGRectMake(self.viewMinMaxSpeed.frame.origin.x-30, self.viewMinMaxSpeed.frame.origin.y, 280, 280);//300 300
    //self.sliderDashboardMinMax.frame = CGRectMake(0, 0, 300, 200);
    self.bgMinMaxSpeed.frame = CGRectMake(0, 0, 270, 270);//290 290
    
    
    
    //New code
    
    self.multisectorControl.sectorsRadius = 120.0;//130
    self.multisectorControl.frame = CGRectMake(self.multisectorControl.frame.origin.x-40, self.multisectorControl.frame.origin.y-72, 300, 300);
    
    
    
    self.imgBGMinMaxSet.frame = CGRectMake(self.imgBGMinMaxSet.frame.origin.x-40, self.imgBGMinMaxSet.frame.origin.y-78, 290, 290);
    
    self.setSpeedlblDistance.frame =  CGRectMake(self.setSpeedlblDistance.frame.origin.x+50, self.setSpeedlblDistance.frame.origin.y+30, self.setSpeedlblDistance.frame.size.width, self.setSpeedlblDistance.frame.size.height);
    
    
    
    self.setSpeedlblKMH.frame =  CGRectMake(self.setSpeedlblKMH.frame.origin.x+50, self.setSpeedlblKMH.frame.origin.y+30, self.setSpeedlblKMH.frame.size.width, self.setSpeedlblKMH.frame.size.height);
  
    
    
    self.circularSlider.frame = CGRectMake(self.circularSlider.frame.origin.x-30, self.circularSlider.frame.origin.y-10, self.circularSlider.frame.size.width + 60, self.circularSlider.frame.size.height + 60);
    
    self.btnShareYes.frame = CGRectMake(self.btnShareYes.frame.origin.x+15, self.btnShareYes.frame.origin.y, self.btnShareYes.frame.size.width, self.btnShareYes.frame.size.height);
    self.btnShareNo.frame = CGRectMake(self.btnShareNo.frame.origin.x-15, self.btnShareNo.frame.origin.y, self.btnShareNo.frame.size.width, self.btnShareNo.frame.size.height);
    
    self.btnSaveSessionYes.frame = CGRectMake(self.btnSaveSessionYes.frame.origin.x+13, self.btnSaveSessionYes.frame.origin.y, self.btnSaveSessionYes.frame.size.width, self.btnSaveSessionYes.frame.size.height);
    self.btnSaveSessionNo.frame = CGRectMake(self.btnSaveSessionNo.frame.origin.x-13, self.btnSaveSessionNo.frame.origin.y, self.btnSaveSessionNo.frame.size.width, self.btnSaveSessionNo.frame.size.height);
    
    //[self.sliderDashboardCalories setValue:500];
}

- (NSString *)fetchTimeByAddingMicroSeconds:(long)microseconds
{
    NSDate *now = [NSDate new];
    NSDate *newDate = [now dateByAddingTimeInterval:microseconds];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:newDate];
    return currentTime;
}

- (IBAction)sendLog
{
    //int r = arc4random() % 100;
    //[self.simpleCSlider movehandleToValue:r];
    //appDelegate().strLog = @"Here is new log \n";
    //[appDelegate() logIt:appDelegate().strLog];
    //[self logIt:appDelegate().strLog];
}
# pragma  mark - Log generation
- (void)logIt:(NSString *)string
{
    // First send the string to NSLog
    NSLog(@"%@", string);
    
    // Setup date stuff
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-dd-MM"];
    NSDate *date = [NSDate date];
    
    // Paths - We're saving the data based on the day.
    NSString *path = [NSString stringWithFormat:@"%@-logFile.txt", [formatter stringFromDate:date]];
    NSString *writePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:path];
    
    // We're going to want to append new data, so get the previous data.
    NSString *fileContents = [NSString stringWithContentsOfFile:writePath encoding:NSUTF8StringEncoding error:nil];
    
    // Write it to the string
    string = [NSString stringWithFormat:@"%@\n%@ - %@", fileContents, [formatter stringFromDate:date], string];
    
   
    [string writeToFile:writePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"App Bike Log"];
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"ashwin.jumani@gmail.com"];
    [mailComposer setToRecipients:toRecipients];
    // Attach the Crash Log..
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:path];
    NSData *myData = [NSData dataWithContentsOfFile:logPath];
    [mailComposer addAttachmentData:myData mimeType:@"Text/XML" fileName:@"Console.log"];
    // Fill out the email body text
    NSString *emailBody = @"App Bike Log";
    [mailComposer setMessageBody:emailBody isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:controller completion:nil];
}



//------------------------------------------------------------------

#pragma mark
#pragma mark Custom Methods

//------------------------------------------------------------------

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//------------------------------------------------------------------

#pragma mark
#pragma mark Action Methods

//------------------------------------------------------------------

- (void) showHideAssistantView
{
    CGRect fram = self.assistantLevelView.frame;
    CGRect buttonFram = self.btnAssistantlLevel.frame;
    if (self.isAssistantViewOpen)
    {
        buttonFram.origin.y +=75;
        fram.origin.y+=75;
    } else
    {
        buttonFram.origin.y-=75;
        fram.origin.y-=75;
    }
    self.isAssistantViewOpen=!self.isAssistantViewOpen;
    [UIView animateWithDuration:0.4 animations:^{
        [self.assistantLevelView setFrame:fram];
        [self.btnAssistantlLevel setFrame:buttonFram];;
    }];
}

//------------------------------------------------------------------------


#pragma mark - Location Methods
- (void)locationInitialize
{
     [appDelegate() addToLog:@"Dashboard Location Initialization"];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    if([CLLocationManager locationServicesEnabled])
    {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                            message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        [self.locationManager startUpdatingLocation];
    }
    
   

}


#pragma mark - Location Service delegate
-(void)didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"new speed is : %.2f",newLocation.speed);
    
    //[appDelegate() addToLog:[NSString stringWithFormat:@"new speed is : %.2f",newLocation.speed]];
  
}

//-(void)didUpdateToLocations:(NSArray *)locations
//- (void)locationManager:(CLLocationManager *)manager
  //   didUpdateLocations:(NSArray *)locations
- (void)updateMyLocation:(NSNotification*) notify
{
    NSLog(@"We have current location");
    appDelegate().currentLocation =  (CLLocation *)notify.object;
    return; ///No need for now
    NSLog(@"Dashboard didUpdateLocations");
    CLLocation *newLocation = (CLLocation *)notify.object;
    //CLLocation *newLocation = [locations firstObject];
    double speedCalc = 0.0f;
    if(newLocation.speed > 1.0f )
    {
        
        if(appDelegate().fromLocation != nil)
        {
             CLLocationDistance distanceChange = [newLocation getDistanceFrom:appDelegate().currentLocation];
          
            appDelegate().distanceKM = appDelegate().distanceKM + (distanceChange/1000);
          
            NSTimeInterval sinceLastUpdate = [newLocation.timestamp timeIntervalSinceDate:appDelegate().fromLocation.timestamp];
            speedCalc = distanceChange / sinceLastUpdate;
            //speedCalc = speedCalc * 3.6f;
            speedCalc = newLocation.speed * 3.6f;
            
            appDelegate().currentLocation = newLocation;
            
            if(speedCalc > 1)
            {
                self.lblCurrentSpeed.text = [NSString stringWithFormat:@"%.0f",speedCalc];
                
                [self.simpleCSlider movehandleToValue:speedCalc];
                
                //[self getCaloryValue:speedCalc];
                [statusBarView setBatteryLevel];
                
                CLLocationDistance distanceChange = [appDelegate().distanceLocation getDistanceFrom:appDelegate().fromLocation];
                double myDistance = distanceChange / 1000;
                int devider = appDelegate().incrementIndex;//* 10;
                myDistance = (int)myDistance % (int)devider;
                
                if(myDistance == 0)
                {
                    appDelegate().distanceLocation = newLocation;
                    //appDelegate().incrementIndex++; //Remove comment for next step
                }

            }
            else
            {
                self.lblCurrentSpeed.text = @"0";
                [self.simpleCSlider movehandleToValue:0];
                [statusBarView updateBetterToZero];
            }
            if(appDelegate().distanceKM > 0)
            {
                self.lblKilometerCount.text = [NSString stringWithFormat:@"%.2f",appDelegate().distanceKM];
            }
        }
        else
        {
            appDelegate().fromLocation = self.locationManager.location;
            appDelegate().currentLocation = self.locationManager.location;
        }
    }
    else
    {
        self.lblCurrentSpeed.text = @"0";
        [self.simpleCSlider movehandleToValue:0];
        [statusBarView updateBetterToZero];
    }
    
    NSLog(@"new speed is : %.2f",speedCalc);
   
}
- (void)didFailToUpdateLocation:(NSError *)error
{
    NSLog(@"Erro : %@",error.description);
}

// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    //MKPlacemark * myPlacemark = placemark;
    //if(appDelegate().strFromAddress == nil)
    //{
        // with the placemark you can now retrieve the Address name
        appDelegate().strFromAddress = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressStreetKey];
    
    if(appDelegate().strFromAddress == nil)
        appDelegate().strFromAddress = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressCityKey];
    
        appDelegate().fromLocation = placemark.location;
       
    //}
    
    NSLog(@"Placemark : %@",[placemark description]);
}

- (void)checkIfCaloriesGoalAchieve:(int)cal
{
    if(self.sliderDashboardCalories.isSkipGoal == NO)
    {
        int goalCalories = [self.lblGoalCalories.text intValue];
        if(goalCalories > 0)
        {
            if(goalCalories == cal)
            {
                //self.viewGoalCalories.hidden = NO;
                [self startAnimationGoal];
            }
        }
    }
}

-(void)getHeaderPacketWithNotification:(NSNotification*)notification{

    
    NSDate *newDate = [NSDate date];
    //Check if 1 sec
    NSTimeInterval secondsBetween = [newDate timeIntervalSinceDate:oldDate];
    
    if(secondsBetween < 0.9)
    {
        self.btnTopCycle.selected = YES;//!self.btnTopCycle.selected;
    }
    else
    {
        self.btnTopCycle.selected = NO;
    }
    oldDate = newDate;
    
    if([[notification name] isEqualToString:@"headerPacket"]){
    
        NSDictionary *dictionary = (NSDictionary*)[notification object];
        
        
        NSInteger actualCalories = [self.lblCaloriesValueSlider.text integerValue];
        
        actualCalories++;
        
        NSNumber *cal = [NSNumber numberWithInteger:actualCalories++];
        
        if(self.btnCaloriesMenu.selected)
        {
            //Avg Speed
            float avgSpeed = [[dictionary objectForKey:@"AvgSpeed"] floatValue];
            
            [self.lblCalorieCount setText:[NSString stringWithFormat:@"%.0f",avgSpeed]];
        }
        else
        {
            [self.lblCalorieCount setText:[cal stringValue]];
        }
        
        [self.lblCaloriesValueSlider setText:[cal stringValue]];
        [self.sliderDashboardCalories setValue:[cal floatValue]]; //update calories
        
        NSString *speed = [NSString stringWithFormat:@"%ld",(long)[[dictionary objectForKey:@"Speed"] integerValue] ];
        
        [self.lblCurrentSpeed setText:speed];
        
    
//        NSInteger actualKm = [self.lblKilometerCount.text integerValue];
//        
//        actualKm++;
        float actualKm = [self.lblKilometerCount.text floatValue];
        
        actualKm+=0.1;

        
        //NSNumber *km = [NSNumber numberWithInteger:actualKm];
        
        
        [self.simpleCSlider movehandleToValue:[speed intValue]];
        
        
        
        
        switch (self.currentSelectedSensorType)
        {
            case SelectedSensorTypePulse:
            {
                //Pulse Sensor goes here
                float hb = [[dictionary objectForKey:@"HB"] floatValue];
                [self.sliderDashboardSpeed setValue:hb];
                self.lblCurrentSpeed.text = [NSString stringWithFormat:@"%.0f",hb];
                
                [self.sliderCentralMap setValue:hb];
                self.lblCentralMapValue.text = [NSString stringWithFormat:@"%.0f",hb];
                self.lblCentralMapText.text = @"BPM";
            }
            break;
            case SelectedSensorTypeAvgPulse:
            {
                //Avg Sensor method
                float avghb = [[dictionary objectForKey:@"AvgHB"] floatValue];
                [self.sliderDashboardSpeed setValue:avghb];
                self.lblCurrentSpeed.text = [NSString stringWithFormat:@"%.0f",avghb];
                
                [self.sliderCentralMap setValue:avghb];
                self.lblCentralMapValue.text = [NSString stringWithFormat:@"%.0f",avghb];
                self.lblCentralMapText.text = @"RPM";
                
            }
            break;
            case SelectedSensorTypeSpeedNormal:
            {
                //Normal
                //[self.sliderDashboardSpeed setValue:[speed floatValue]];
                float avgSpeed;
                
                 NSString *mainv = [self.dictUpdatedDashboardData valueForKey:@"main"];
                if([mainv isEqualToString:@"speed"])
                {
                    avgSpeed = [speed floatValue];
                }
                else
                {
                    avgSpeed = [[dictionary objectForKey:@"AvgSpeed"] floatValue];
                }
                [self.sliderDashboardSpeed setValue:avgSpeed ];
                
                 [self.lblCurrentSpeed setText:[NSString stringWithFormat:@"%.0f",avgSpeed]];
               
                [self.sliderCentralMap setValue:avgSpeed];
                self.lblCentralMapValue.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
                self.lblCentralMapText.text = @"km/h";
            }
            break;
            case SelectedSensorTypeSpeedMinMax:
            {
                //Min Max Speed
                [self updateCurrentValueAndCheckMinMax:[speed intValue]];
                
                
            }
            break;
            case SelectedSensorTypeCalories:
            {
                //Calories Sensor goes here
                [self.lblCaloriesValueSlider setText:[cal stringValue]];
                [self.sliderDashboardCalories setValue:[cal floatValue]];
                [self checkIfCaloriesGoalAchieve:[cal intValue]];
                
                
                //float totalPer = ([cal floatValue] / self.sliderSetCalories.maximumValue) * 100;
                float totalPer = ([cal floatValue] / self.sliderSetCalories.originalvalue) * 100;
                if(totalPer < 100.0f)
                    self.lblCaloriesPercentage.text = [NSString stringWithFormat:@"%.0f%%",totalPer];
                else
                    self.lblCaloriesPercentage.text = @"100%";
            }
            break;
            default:
            break;
        }
        
      [self checkIfCaloriesGoalAchieve:[cal intValue]];

        
        //Battery Parameters
        NSDictionary *dictParam = @{@"Autonomy" : [dictionary objectForKey:@"Autonomy"],
                                    @"AutonomyDistance" : [dictionary objectForKey:@"AutonomyDistance"]};
        
        [statusBarView setBatteryLevel:dictionary];
        
        //[self.lblKilometerCount setText:[km stringValue]];
        [self.lblKilometerCount setText:[NSString stringWithFormat:@"%.1f",actualKm]];
        
        self.lblRPMCount.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"Autonomy"] intValue]];
        self.lblBPMCount.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"HB"] intValue]];
        
        NSString *life = [NSString stringWithFormat:@"%ld",(long)[[dictionary objectForKey:@"Life"] integerValue] ];
        self.lblMeCount.text = life;
        
        NSString *energy = [NSString stringWithFormat:@"%ld",(long)[[dictionary objectForKey:@"Energy"] integerValue] ];
        
        self.lblEngineCount.text = energy;
        float energyProgress = [[dictionary objectForKey:@"Energy"] floatValue] / 100;
        [self setProgress:energyProgress animated:YES];
        
        NSString *voltage = [NSString stringWithFormat:@"%ld",(long)[[dictionary objectForKey:@"Voltage"] integerValue] ];
        
        self.lblWattCount.text = voltage;

        self.dictJsonSession = dictionary;
        appDelegate().dictCurrentSessionData  = dictionary;
        
        //Map value change
        self.lblMapRPMValue.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"AvgHB"] intValue]];
        self.lblMapBPMValue.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"HB"] intValue]];
        
        self.lblMapKMValue.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"AutonomyDistance"] intValue] ];
        
        
        [self.lblMapAvgSpeedValue setText:speed];
        
        //float totalPer = ([cal floatValue] / self.sliderSetCalories.maximumValue) * 100;
        self.lblMapCalValue.text = [NSString stringWithFormat:@"%d",[cal intValue]];
        self.lblMapMaxCalValue.text = [NSString stringWithFormat:@"%.0f cal",self.sliderSetCalories.maximumValue];

        
        //Here is new code
        //Display values as per label position set
        //top left
        NSString *strTopLeft = [self.dictUpdatedDashboardData valueForKey:@"topLeft"];
        if([strTopLeft isEqualToString:@"cal"])
        {
            self.lblCalorieCount.text = [cal stringValue];
            self.lblMapAvgSpeedValue.text = [cal stringValue];
        }
        else if([strTopLeft isEqualToString:@"km"])
        {
            float avgSpeed = [[dictionary objectForKey:@"AvgSpeed"] floatValue];
            self.lblCalorieCount.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
            self.lblMapAvgSpeedValue.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
        }
        else if([strTopLeft isEqualToString:@"rpm"])
        {
            self.lblCalorieCount.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"AvgHB"] intValue]];
            
            self.lblMapAvgSpeedValue.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"AvgHB"] intValue]];//Autonomy
        }
        else if([strTopLeft isEqualToString:@"bpm"])
        {
            self.lblCalorieCount.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"HB"] intValue]];
            self.lblMapAvgSpeedValue.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"HB"] intValue]];
        }
        else if([strTopLeft isEqualToString:@"speed"])
        {
            float avgSpeed = [[dictionary objectForKey:@"Speed"] floatValue];
            self.lblCalorieCount.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
            self.lblMapAvgSpeedValue.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
        }

        
        //Top Right
        NSString *strTopRight = [self.dictUpdatedDashboardData valueForKey:@"topRight"];
        if([strTopRight isEqualToString:@"cal"])
        {
            self.lblKilometerCount.text = [cal stringValue];
            self.lblMapKMValue.text = [cal stringValue];
        }
        else if([strTopRight isEqualToString:@"km"])
        {
            float avgSpeed = [[dictionary objectForKey:@"AvgSpeed"] floatValue];
            self.lblKilometerCount.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
            self.lblMapKMValue.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
        }
        else if([strTopRight isEqualToString:@"rpm"])
        {
            self.lblKilometerCount.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"AvgHB"] intValue]];
            self.lblMapKMValue.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"AvgHB"] intValue]];
        }
        else if([strTopRight isEqualToString:@"bpm"])
        {
            self.lblKilometerCount.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"HB"] intValue]];
            self.lblMapKMValue.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"HB"] intValue]];
        }
        else if([strTopRight isEqualToString:@"speed"])
        {
            float avgSpeed = [[dictionary objectForKey:@"Speed"] floatValue];
            self.lblKilometerCount.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
            self.lblMapKMValue.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
        }
        
        //Bottom Left
        NSString *strBottomLeft = [self.dictUpdatedDashboardData valueForKey:@"bottomLeft"];
        if([strBottomLeft isEqualToString:@"cal"])
        {
            self.lblRPMCount.text = [cal stringValue];
            self.lblMapRPMValue.text = [cal stringValue];
        }
        else if([strBottomLeft isEqualToString:@"km"])
        {
            float avgSpeed = [[dictionary objectForKey:@"AvgSpeed"] floatValue];
            self.lblRPMCount.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
            self.lblMapRPMValue.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
        }
        else if([strBottomLeft isEqualToString:@"rpm"])
        {
            self.lblRPMCount.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"AvgHB"] intValue]];
            self.lblMapRPMValue.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"AvgHB"] intValue]];
        }
        else if([strBottomLeft isEqualToString:@"bpm"])
        {
            self.lblRPMCount.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"HB"] intValue]];
            self.lblMapRPMValue.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"HB"] intValue]];
        }
        else if([strBottomLeft isEqualToString:@"speed"])
        {
            float avgSpeed = [[dictionary objectForKey:@"Speed"] floatValue];
            self.lblRPMCount.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
            self.lblMapRPMValue.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
        }
        
        //Bottom Right
        NSString *strBottomRight = [self.dictUpdatedDashboardData valueForKey:@"bottomRight"];
        if([strBottomRight isEqualToString:@"cal"])
        {
            self.lblBPMCount.text = [cal stringValue];
            self.lblMapBPMValue.text = [cal stringValue];
        }
        else if([strBottomRight isEqualToString:@"km"])
        {
            float avgSpeed = [[dictionary objectForKey:@"AvgSpeed"] floatValue];
            self.lblBPMCount.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
            self.lblMapBPMValue.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
        }
        else if([strBottomRight isEqualToString:@"rpm"])
        {
            self.lblBPMCount.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"AvgHB"] intValue]];
            
            self.lblMapBPMValue.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"AvgHB"] intValue]];
        }
        else if([strBottomRight isEqualToString:@"bpm"])
        {
            self.lblBPMCount.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"HB"] intValue]];
            self.lblMapBPMValue.text = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"HB"] intValue]];
        }
        else if([strBottomRight isEqualToString:@"speed"])
        {
            float avgSpeed = [[dictionary objectForKey:@"Speed"] floatValue];
            self.lblBPMCount.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
            self.lblMapBPMValue.text = [NSString stringWithFormat:@"%.0f",avgSpeed];
        }

        
        
        
        [self.slices removeAllObjects];
        self.slices = [NSMutableArray arrayWithCapacity:2];
        
        NSNumber *one = cal;
        NSNumber *two = [NSNumber numberWithInt:500];
        
        [_slices addObject:one];
        [_slices addObject:two];
        [self.pieChartLeft reloadData];
        
//#warning TESTING - Remove
        [self checkLowBettaryAlert:[[dictionary objectForKey:@"Autonomy"] intValue]];
        
        
        
        self.lblAlertPercentage.text = [NSString stringWithFormat:@"%dkm",[[dictionary objectForKey:@"AutonomyDistance"] intValue]];
        
        
        
    }

}

#pragma mark - Low Battery
- (IBAction)btnIgnore:(id)sender
{
    self.viewBatteryAlert.hidden = YES;
}

- (void)checkLowBettaryAlert:(int)betteryLevel
{
    if(betteryLevel <= 25)
    {
        self.viewBatteryAlert.hidden = NO;
        self.lblAlertKM.text = [NSString stringWithFormat:@"%d%%",betteryLevel];
        self.lblAlertMsg.text = [NSString stringWithFormat:@"You can't back home with %d%%.",betteryLevel];
    }
}
- (NSString *)convertDictToString:(NSDictionary *)finalDictionary
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if(error)
    {
        NSLog(@"save data error : %@",error.description);
        return @"";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}



#pragma mark - Destination view

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [searchResultPlaces count];
    return [self.places count];
}

//- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [searchResultPlaces objectAtIndex:indexPath.row];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SPGooglePlacesAutocompleteCell";
    //static NSString *kCellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto" size:16.0];
    //cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    
   
    
    MKMapItem *mapItem = [self.places objectAtIndex:indexPath.row];
    cell.textLabel.text = mapItem.name;
    
    return cell;
   // return cell;
}

- (void)dismissSearchControllerWhileStayingActive
{
    // Animate out the table view.
    NSTimeInterval animationDuration = 0.1;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.searchDisplayController.searchResultsTableView.alpha = 0.0;
    [UIView commitAnimations];
    
    [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchDisplayController.searchBar resignFirstResponder];
    [self.searchDisplayController setActive:NO];
   
    //[self.viewDestination removeFromSuperview];
    
    
    //[self.viewMapMain sendSubviewToBack:self.assistantLevelView];
    //self.viewMapMain.hidden = NO;
    //CGRect frame = self.viewMapMain.frame;
    //frame.origin.y = 90;
    
    //[self.viewMapMain removeFromSuperview];
    //[self.view addSubview:self.viewMapMain];
    //self.viewMapMain.frame = frame;
//    [appDelegate().window endEditing:YES];
//    [self.view endEditing:YES];
//    [self.viewMapMain endEditing:YES];
//    [self.view setNeedsDisplay];
//    self.viewDestination.hidden = YES;
//    self.viewMapMain.hidden = NO;
    [self displayMap];
    
}


- (void)displayMap
{
    self.viewDestination.hidden = YES;
    self.viewProgress.hidden  = NO;
    self.viewMapMain.hidden = NO;
    
    
    self.viewMap.mapType = MKMapTypeStandard;
    self.viewMap.pitchEnabled = YES;
    self.viewMap.showsBuildings = YES;
    self.viewMap.showsPointsOfInterest = YES;
    self.viewMap.zoomEnabled = YES;
    self.viewMap.scrollEnabled = YES;
    self.viewMap.zoomEnabled = YES;
    self.viewMap.delegate = self;
    self.viewMap.showsUserLocation = NO;
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:appDelegate().fromLocation.coordinate addressDictionary:nil];
    
     [self.viewMap removeAnnotations:self.viewMap.annotations];
    [self.viewMap addAnnotation:placemark];
    
    [self.viewMap setCenterCoordinate:self.viewMap.userLocation.location.coordinate animated:YES];
    self.viewMap.userTrackingMode = MKUserTrackingModeFollow;
    //self.mapView.camera = mapCamera;
    
    float spanX = 0.58;
    float spanY = 0.58;
    MKCoordinateRegion region;
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.viewMap setRegion:region animated:YES];
    
    
    if(appDelegate().strToAddress)
    {
        MKPlacemark *placemarkDest = [[MKPlacemark alloc] initWithCoordinate:appDelegate().toLocation.coordinate addressDictionary:nil];
       
        [self.viewMap addAnnotation:placemarkDest];
        
        [self createRoute];
    }
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    NSLog(@"End search");
    //[controller.searchBar resignFirstResponder];
}
- (void)correctSearchDisplayFrames
{
    // Update search bar frame.
    CGRect superviewFrame = self.searchDisplayController.searchBar.superview.frame;
    superviewFrame.origin.y = 90.f;
    self.searchDisplayController.searchBar.superview.frame = superviewFrame;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    //[self correctSearchDisplayFrames];
}
-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
   // self.viewDestination.frame = CGRectMake(0, , <#CGFloat width#>, <#CGFloat height#>)
    //controller.searchResultsTableView.frame =  CGRectMake(0, 90, tableView.frame.size.width, tableView.frame.size.height);

    tableView.frame = CGRectMake(0, 90, tableView.frame.size.width, tableView.frame.size.height);
    //self.searchDisplayController.searchBar.frame = CGRectMake(0, 50, 320, self.searchDisplayController.searchBar.frame.size.height);
    
//    CGRect f = CGRectMake(0, 90, tableView.frame.size.width, tableView.frame.size.height);
//  // The tableView the search replaces
//    CGRect s = self.searchDisplayController.searchBar.frame;
//    CGRect newFrame = CGRectMake(f.origin.x,
//                                 f.origin.y + s.size.height,
//                                 f.size.width,
//                                 f.size.height - s.size.height);
//    
//    tableView.frame = newFrame;
    //controller.searchResultsTableView.contentInset = UIEdgeInsetsMake(self.searchDisplayController.searchBar.frame.size.height, 0.f, 0.f, 0.f);

    [tableView setBackgroundColor:[UIColor clearColor]];
}

//- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
//{
//    tableView.frame = CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height);
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *selectedItem = [tableView indexPathForSelectedRow];
    
    NSArray *mapItemList = [NSArray arrayWithObject:[self.places objectAtIndex:selectedItem.row]];
    
    NSLog(@"Map : %@",[mapItemList description]);
    MKMapItem *place = [mapItemList firstObject];
    appDelegate().toLocation = place.placemark.location;
    appDelegate().strToAddress = place.placemark.title;
    self.destination = place;
    
     [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
    [self dismissSearchControllerWhileStayingActive];
//    SPGooglePlacesAutocompletePlace *place = [self placeAtIndexPath:indexPath];
//    [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error)
//     {
//         if (error)
//         {
//             SPPresentAlertViewWithErrorAndTitle(error, @"Could not map selected Place");
//         }
//         else if (placemark)
//         {
//             appDelegate().ToLocation = placemark.location;
//             appDelegate().strToAddress = addressString;
//             [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
//             
//             [self dismissSearchControllerWhileStayingActive];
//            
//             NSLog(@"We are done here now display map");
//
//         }
//     }];
}

- (void)recenterMapToPlacemark:(CLPlacemark *)placemark
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    
    region.span = span;
    region.center = placemark.location.coordinate;
    
    //  [self.mapView setRegion:region];
}

- (void)addPlacemarkAnnotationToMap:(CLPlacemark *)placemark addressString:(NSString *)address
{
    //[self.mapView removeAnnotation:selectedPlaceAnnotation];
    // [selectedPlaceAnnotation release];
    
    selectedPlaceAnnotation = [[MKPointAnnotation alloc] init];
    selectedPlaceAnnotation.coordinate = placemark.location.coordinate;
    selectedPlaceAnnotation.title = address;
    //[self.mapView addAnnotation:selectedPlaceAnnotation];
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString
{
    //    searchQuery.location = self.mapView.userLocation.coordinate;
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            SPPresentAlertViewWithErrorAndTitle(error, @"Could not fetch Places");
        } else {
            //[searchResultPlaces release];
            //searchResultPlaces = [places retain];
            searchResultPlaces = places;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
   // [self handleSearchForSearchString:searchString];
    [self startSearch:searchString];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar isFirstResponder]) {
        // User tapped the 'clear' button.
        shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (shouldBeginEditing) {
        // Animate in the table view.
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        self.searchDisplayController.searchResultsTableView.alpha = 1.0;
        [UIView commitAnimations];
        
        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    }
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}

#pragma New Methods for Apple API
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)startSearch:(NSString *)searchString
{
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    // confine the map search area to the user's current location
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.userLocation.latitude;
    newRegion.center.longitude = self.userLocation.longitude;
    
    // setup the area spanned by the map region:
    // we use the delta values to indicate the desired zoom level of the map,
    //      (smaller delta values corresponding to a higher zoom level)
    //
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
    {
        if (error != nil)
        {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            self.places = [response mapItems];
            
            // used for later when setting the map's region in "prepareForSegue"
            self.boundingRegion = response.boundingRegion;
            
           // self.viewAllButton.enabled = self.places != nil ? YES : NO;
            
            //[self.tableView reloadData];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    if (self.localSearch != nil)
    {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    // check to see if Location Services is enabled, there are two state possibilities:
    // 1) disabled for entire device, 2) disabled just for this app
    //
    NSString *causeStr = nil;
    
    // check whether location services are enabled on the device
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        causeStr = @"device";
    }
    // check the application’s explicit authorization status:
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        causeStr = @"app";
    }
    else
    {
        // we are good to go, start the search
        [self startSearch:searchBar.text];
    }
    
    if (causeStr != nil)
    {
        NSString *alertMessage = [NSString stringWithFormat:@"You currently have location services disabled for this %@. Please refer to \"Settings\" app to turn on Location Services.", causeStr];
        
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                        message:alertMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
}

#pragma mark - Map View Drawing and Route
//Create route  - This method draw route from address to To address

- (void)createRoute
{
   
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    directionsRequest.requestsAlternateRoutes=YES;
    
#warning TODO : From address issue while drawin map from to to location
    appDelegate().fromLocation = [GPSLocation sharedManager].currentLocation;
    
    NSLog(@"From Location : lat : %f, long : %f",appDelegate().fromLocation.coordinate.latitude,appDelegate().fromLocation.coordinate.longitude);
    
    NSLog(@"Destination Location : lat : %f, long : %f",appDelegate().toLocation.coordinate.latitude,appDelegate().toLocation.coordinate.longitude);
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:appDelegate().fromLocation.coordinate addressDictionary:nil];
    MKPlacemark *placemarkDest = [[MKPlacemark alloc] initWithCoordinate:appDelegate().toLocation.coordinate addressDictionary:nil];
    
    //placemark.coordinate
    [directionsRequest setSource:[[MKMapItem alloc] initWithPlacemark:placemark]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemarkDest]];
    
    [self.viewMap addAnnotation:placemark];
    
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error)
        {
            NSLog(@"Error %@", error.description);
           // isInProgress = NO;
            //self.lblToAddress.text = appDelegate().strToAddress;
        }
        else
        {
            routeDetails = response.routes.lastObject;
            //[self.viewMap removeOverlays:<#(NSArray *)#>]
            [self.viewMap addOverlay:routeDetails.polyline];
            
            for (int i = 0; i < routeDetails.steps.count; i++)
            {
                MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
                NSString *newStep = step.instructions;
                NSLog(@"Steps : %@",newStep);
            }
        }
    }];
    
    [self.locationManager startUpdatingLocation];
}

- (CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location
{
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}


- (void)addAnnotation:(CLPlacemark *)placemark
{
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
    point.title = [placemark.addressDictionary objectForKey:@"Street"];
    point.subtitle = [placemark.addressDictionary objectForKey:@"City"];
    [self.viewMap addAnnotation:point];
}


#pragma mark Map View Delegates

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:42.0/255.0 green:133.0/255.0 blue:202/255.0 alpha:1.0];
    //[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"mapLinePathColor"]];
    
    //polylineView.strokeColor = [UIColor colorWithRed:204/255. green:45/255. blue:70/255. alpha:1.0];
    polylineView.lineWidth = 10.0;
    
    return polylineView;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.viewMap dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
        } else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}


#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
}


@end
