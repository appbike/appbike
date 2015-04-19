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

@property (strong, nonatomic) IBOutlet UIView  *viewNormalSpeed;
@property (unsafe_unretained, nonatomic) IBOutlet UICircularSlider *sliderDashboardSpeed;
@property (strong, nonatomic) IBOutlet UIImageView *imgBGDashboardSpeed;
@property (strong, nonatomic) IBOutlet UIImageView *imgBGLogoDashboardSpeed;
@property (strong, nonatomic) IBOutlet UIButton *btnStartStop;
@property (strong, nonatomic) IBOutlet UIButton *btnUpDown;

@property (strong, nonatomic) IBOutlet UIView  *viewEngineMode;
@property (strong, nonatomic) IBOutlet UIView  *viewSpeedStart;

@property (strong, nonatomic) IBOutlet UILabel  *lblRPMCount;
@property (strong, nonatomic) IBOutlet UILabel  *lblRPMText;
@property (strong, nonatomic) IBOutlet UILabel  *lblBPMCount;
@property (strong, nonatomic) IBOutlet UILabel  *lblBPMText;

@property (strong, nonatomic) IBOutlet UIView  *viewSelectionMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectPulse;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectAvgPulse;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectSpeed;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectAvgSpeed;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectCalories;

@property (strong, nonatomic) IBOutlet UIView  *viewSetSpeed;
@property (weak, nonatomic) IBOutlet SAMultisectorControl *multisectorControl;
@property (strong, nonatomic) IBOutlet UILabel *setSpeedlblDistance;
@property (strong, nonatomic) IBOutlet UIImageView *imgBgSetSpeed;

//Variable for Min Max Speed Slider on Dashboard

@property (weak, nonatomic) IBOutlet SAMultisectorControl *sliderDashboardMinMax;
@property (strong, nonatomic) IBOutlet UIView  *viewMinMaxSpeed;
@property (strong, nonatomic) IBOutlet UIImageView *bgMinMaxSpeed; //This image will be change when out of speed limit
@property (strong, nonatomic) IBOutlet UILabel *lblMinMaxSpeedValue;

@property (strong, nonatomic) IBOutlet UIView  *viewSetCalories;
@property (unsafe_unretained, nonatomic) IBOutlet UICircularSlider *sliderSetCalories;
@property (nonatomic, strong) IBOutlet UILabel *lblSetCaloriesValue;

@property (strong, nonatomic) IBOutlet UIView  *viewCalories;
@property (unsafe_unretained, nonatomic) IBOutlet UICircularSlider *sliderDashboardCalories;
@property (strong, nonatomic) IBOutlet UIImageView *imgBGCalories;
@property (strong, nonatomic) IBOutlet UIImageView *imgBGLogoCalories;
@property (strong, nonatomic) IBOutlet UIButton *btnMaxCalories;
@property (strong, nonatomic) IBOutlet UILabel *lblCaloriesPercentage;

@property (strong, nonatomic) IBOutlet UIView  *viewGoalCalories;
@property (strong, nonatomic) IBOutlet UILabel *lblGoalCalories;

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

//####
@property (weak, nonatomic) IBOutlet UIButton *btnAssistantlLevel;


@property (strong, nonatomic) IBOutlet AssistanceLevelView *assistantLevelView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *viewDashboardExternalView;
@property (strong, nonatomic) IBOutlet UIView *viewDashboardInternalView;

@property (nonatomic) BOOL isAssistantViewOpen;
@property (nonatomic) double distanceKM;

@property (nonatomic,strong) BleManager *bleManager;

@property (nonatomic,assign) BOOL isRegistered;


@end

@implementation ABDashBoardVC

- (void)loadDashboardData
{
    self.lblCalorieText.text = [appDelegate().dictDashboardData objectForKey:@"topLeft"];
    self.lblKiloMeterText.text = [appDelegate().dictDashboardData objectForKey:@"topRight"];
    self.lblRPMText.text = [appDelegate().dictDashboardData objectForKey:@"bottomLeft"];
    self.lblBPMText.text = [appDelegate().dictDashboardData objectForKey:@"bottomRight"];
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

//------------------------------------------------------------------

#pragma mark
#pragma mark View Life Cycle Methods

//------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(leftMenuPressed:)
               name:MenuItemNotification object:nil];
    
    
    indexLoc = 0;
    //[self registerForNotifications];
    [self loadDashboardData];
    [self setupMultiSelectorControl]; //For Set speed range
    
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
    self.sliderSetCalories.minimumValue = 0;
    self.sliderSetCalories.maximumValue = [[appDelegate().dictCaloriesData objectForKey:@"max"] floatValue];
    self.sliderSetCalories.continuous = YES;
    self.sliderSetCalories.isThumbnailEnabled = YES;
    
    self.sliderSetCalories.transform = CGAffineTransformMakeRotation(3.14);
    //self.sliderSetCalories.userInteractionEnabled = NO;
    [self.sliderSetCalories setThumbTintColor:[UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:1.0]];
    [self.sliderSetCalories setMaximumTrackTintColor:[UIColor lightGrayColor]];
    [self.sliderSetCalories setMinimumTrackTintColor:[UIColor colorWithRed:55/255.0 green:155/255.0 blue:233/255.0 alpha:1.0]];
    
    [self.btnMaxCalories setTitle:[NSString stringWithFormat:@"%@",[appDelegate().dictCaloriesData objectForKey:@"max"]] forState:UIControlStateNormal];
    
    
    self.locationManager = [GPSLocation sharedManager].locationManager;
    
    
    //Battery Info initialize
    statusBarView = [[ABBatteryInformation alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [statusBarView setBatteryLevel];
    [self.view addSubview:statusBarView];
    
    [self.view addSubview:self.viewCountdown];
    [self.view addSubview:self.viewSaveSession];
    
    counterTime = [[appDelegate().dictCounterData objectForKeyedSubscript:@"value"] intValue];
    
    [self.counterPicker selectRow:(counterTime-1) inComponent:0 animated:NO];
    //setup custom location mangaer
   // [GPSLocation sharedManager].delegate = self;
    
    //[[GPSLocation sharedManager] stop];
    //[[GPSLocation sharedManager] start];
    
    
    NSLog(@"Screen height : %f and width : %f",[[UIScreen mainScreen]bounds].size.height,[[UIScreen mainScreen]bounds].size.width);
    if(IS_IPHONE_6)
    {
        [self updateUIForiPhone6];
    
    }
    else if(IS_IPHONE_6_PLUS)
    {
        [self updateUIForiPhone6Plus];
       
    }
    else if(IS_IPHONE_5)
    {
        NSLog(@"iPhone5");
        self.imgBGCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x+5, self.sliderDashboardCalories.frame.origin.y, 195, 195);
    }
    else
    {
        
        self.assistantLevelView.frame = CGRectMake(self.assistantLevelView.frame.origin.x, self.assistantLevelView.frame.origin.y+20, self.assistantLevelView.frame.size.width, self.assistantLevelView.frame.size.height - 20);
        self.viewEngineMode.frame = CGRectMake(self.viewEngineMode.frame.origin.x, self.viewEngineMode.frame.origin.y+20, self.viewEngineMode.frame.size.width, self.viewEngineMode.frame.size.height);
        
//        self.viewNormalSpeed.frame = CGRectMake(self.viewNormalSpeed.frame.origin.x, self.viewNormalSpeed.frame.origin.y, self.viewNormalSpeed.frame.size.width, self.viewNormalSpeed.frame.size.height);
       
         self.viewSpeedStart.frame = CGRectMake(self.viewSpeedStart.frame.origin.x, self.viewSpeedStart.frame.origin.y, self.viewSpeedStart.frame.size.width, self.viewSpeedStart.frame.size.height+45);
        
        self.btnStartStop.frame = CGRectMake(101,283,112,35);
        
         self.btnUpDown.frame = CGRectMake(self.btnUpDown.frame.origin.x, self.btnUpDown.frame.origin.y+35, self.btnUpDown.frame.size.width, self.btnUpDown.frame.size.height);
        
        self.viewSetSpeed.frame = CGRectMake(self.viewSetSpeed.frame.origin.x, self.viewSetSpeed.frame.origin.y, self.viewSetSpeed.frame.size.width, self.viewSetSpeed.frame.size.height+45);
        
        self.viewSetCalories.frame = CGRectMake(self.viewSetCalories.frame.origin.x, self.viewSetCalories.frame.origin.y, self.viewSetCalories.frame.size.width, self.viewSetCalories.frame.size.height+55);
        
        
        self.imgBGCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x+5, self.sliderDashboardCalories.frame.origin.y, 195, 195);
        
    }
  
    
    self.bleManager = [[BleManager alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHeaderPacketWithNotification:) name:@"headerPacket" object:nil];

    //[self.bleManager getHeaderPacket];//Comment this after test
    
    self.sliderDashboardMinMax.isDisplayCurrentValue = YES;
    
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
    self.slices = [NSMutableArray arrayWithCapacity:1];
    
    NSNumber *one = [NSNumber numberWithInt:90];
    //NSNumber *two = [NSNumber numberWithInt:100];
    
    [_slices addObject:one];
   
    
    
    
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
                       [UIColor colorWithRed:23/255.0 green:138/255.0 blue:230/255.0 alpha:1],nil];
    

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
    if(self.searchDisplayController.isActive)
    {
        [UIView animateWithDuration:0.001 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }completion:nil];
    }
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{

    appDelegate().dashboardVC = self;
    [super viewDidAppear:animated];
    
    [self.pieChartLeft reloadData];
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

- (IBAction)btnStartPressed:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    
    if(!appDelegate().isSessionStart)
    {
        [self startCounter];
        
        self.dtStartSession = [NSDate date];
//        int newSessionID = [Session getMaxId];
//        NSDictionary *dictData = @{@"id":[NSString stringWithFormat:@"%d",newSessionID]};
//        [Session addItemToSession:dictData];
        
        
        [btnPressed setTitle:@"STOP" forState:UIControlStateNormal];
    }
    else
    {
        counterTime = [[appDelegate().dictCounterData objectForKeyedSubscript:@"value"] intValue];
        //Display Session save message here
        [self.bleManager stopSession];
        
        appDelegate().isSessionStart = NO;
        self.viewProgress.hidden = YES;
        [btnPressed setTitle:@"Start" forState:UIControlStateNormal];
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

- (IBAction)displaySelectionMenu:(id)sender
{
    //Display selection menu
    self.viewGoalCalories.hidden = YES;
    self.viewSelectionMenu.hidden = NO;
}

- (IBAction)hideSelectionMenu:(id)sender
{
    //Hide Selection menu
    self.viewSelectionMenu.hidden = YES;
}

- (IBAction)selectMenuItemPressed:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    switch (btnPressed.tag)
    {
        case 1101:
        {
            //Pulse
            //self.currentSelectedSensorType = SelectedSensorTypePulse;
            self.currentSelectedSensorType = SelectedSensorTypeSpeedNormal;
            self.viewMinMaxSpeed.hidden = YES;
            self.viewNormalSpeed.hidden = NO;
            self.viewCalories.hidden = YES;
        }
        break;
        case 1102:
        {
            //Avg Pulse
            //self.currentSelectedSensorType = SelectedSensorTypeAvgPulse;
            self.currentSelectedSensorType = SelectedSensorTypeSpeedNormal;
            self.viewMinMaxSpeed.hidden = YES;
            self.viewNormalSpeed.hidden = NO;
            self.viewCalories.hidden = YES;
        }
        break;
        case 1103:
        {
            //Speed
            self.currentSelectedSensorType = SelectedSensorTypeSpeedMinMax;
            self.viewSetSpeed.hidden = NO;
        }
        break;
        case 1104:
        {
            //Avg Speed
            self.currentSelectedSensorType = SelectedSensorTypeSpeedNormal;
            self.viewMinMaxSpeed.hidden = YES;
            self.viewNormalSpeed.hidden = NO;
            self.viewCalories.hidden = YES;
            
        }
        break;
        case 1105:
        {
            //Calories
            self.currentSelectedSensorType = SelectedSensorTypeCalories;
            //Check if calories values already set if not then display that view
            self.viewSetCalories.hidden = NO;
        }
        break;
        default:
            break;
    }
    
    [self hideSelectionMenu:nil];
}

#pragma mark - Set Speed View method
- (void)setupMultiSelectorControl
{
    
    [self.multisectorControl removeAllSectors];
    [self.multisectorControl addTarget:self action:@selector(multisectorValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    UIColor *greenColor = [UIColor colorWithRed:42.0/255.0 green:133.0/255.0 blue:202/255.0 alpha:1.0];
    
    
    SAMultisectorSector *sector3 = [SAMultisectorSector sectorWithColor:greenColor maxValue:100.0];
    
    sector3.tag = 2;
    
    sector3.startValue = [[appDelegate().dictKMHData objectForKey:@"min"] doubleValue];
    sector3.endValue = [[appDelegate().dictKMHData objectForKey:@"max"] doubleValue];;
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
        
        NSString *startValue = [NSString stringWithFormat:@"%.0f", sector.startValue];
        NSString *endValue = [NSString stringWithFormat:@"%.0f", sector.endValue];
        
        minValue = sector.startValue;
        maxValue = sector.endValue;
        self.setSpeedlblDistance.text = [NSString stringWithFormat:@"%@ / %@",startValue,endValue];
        
        [self.multisectorControl sendSubviewToBack:self.imgBgSetSpeed];
    }
}

- (void)updateCurrentValueAndCheckMinMax:(int)speed
{
    
    self.lblMinMaxSpeedValue.text = [NSString stringWithFormat:@"%d",speed];
    [self.sliderDashboardMinMax removeAllSectors];
    UIColor *greenColor = [UIColor colorWithRed:42.0/255.0 green:133.0/255.0 blue:202/255.0 alpha:1.0];
    
    SAMultisectorSector *sector3 = [SAMultisectorSector sectorWithColor:greenColor maxValue:100.0];
    
    sector3.tag = 1;
    
    
    sector3.startValue = minValue;
    sector3.endValue = maxValue;
    sector3.currValue = speed;
    
    if(speed < minValue || speed > maxValue)
    {
        self.bgMinMaxSpeed.image = [UIImage imageNamed:@"max_speed_ring.png"];
        self.lblMinMaxSpeedValue.textColor = [UIColor redColor];
    }
    else
    {
        self.bgMinMaxSpeed.image = [UIImage imageNamed:@"set_speed_ring.png"];
        self.lblMinMaxSpeedValue.textColor = [UIColor blackColor];
    }
    minValue = sector3.startValue;
    maxValue = sector3.endValue;
    
    
    [self.sliderDashboardMinMax sendSubviewToBack:self.bgMinMaxSpeed];
    [self.sliderDashboardMinMax addSector:sector3];
}

- (IBAction)skipOrSetSpeed:(id)sender
{
    UIButton *btnPressed = (UIButton *) sender;
    if(btnPressed.tag == 1201)
    {
        //Skip
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
        [self updateCurrentValueAndCheckMinMax:50];
        NSLog(@"Here is min and max value : %d and %d",minValue,maxValue);
        

    }
    self.viewSetSpeed.hidden = YES;
    self.viewMinMaxSpeed.hidden = NO;
    self.viewNormalSpeed.hidden = YES;
    self.viewCalories.hidden = YES;
}

#pragma mark - Set Calories View Method
- (IBAction)ColoriesValueChange:(id)sender
{
    self.lblSetCaloriesValue.text = [NSString stringWithFormat:@"%d",(int)self.sliderSetCalories.value+1];
    
    self.lblGoalCalories.text = [NSString stringWithFormat:@"%d",(int)self.sliderSetCalories.value+1];

}
- (IBAction)CaloriesSet:(id)sender
{
    NSLog(@"We have new updated calory value : %f",self.sliderSetCalories.value+1);
    self.viewSetCalories.hidden = YES;
    self.viewNormalSpeed.hidden = YES;
    self.viewMinMaxSpeed.hidden = YES;
    self.viewCalories.hidden = NO;
    
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

- (void)updateCounter
{
    if (counterTime < 1)
    {
        
        self.viewCountdown.hidden = YES;
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
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
    label.text = [NSString stringWithFormat:@" %d", row+1];
    return label;
}

// number Of Components
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// number Of Rows In Component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

#pragma mark - Save Session View Methods
- (IBAction)btnSaveSession:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    if(btnPressed.tag == 1301)
    {
        //Yes save session
        
        int newSessionID = [Session getMaxId];
        
        NSString *finalJson = [self convertDictToString:self.dictJsonSession];
        NSDictionary *dictData = @{@"id":[NSString stringWithFormat:@"%d",newSessionID],
                                   @"cal" : self.lblCalorieCount.text,
                                   @"km" : self.lblKilometerCount.text,
                                   @"json" : finalJson,
                                   @"start" : self.dtStartSession,
                                   @"avgkm" : @"0"
                                   };
        [Session addItemToSession:dictData];
    }
    else
    {
        //No need to save session in db
        
    }
    
    self.viewSaveSession.hidden = YES;
    
    
    NSArray *arrSessions = [NSArray arrayWithArray:[Session getAllSessionItems]];
    
    if(arrSessions.count > 0)
    {
        Session *thisSession = [arrSessions lastObject];
        NSLog(@"Session : %@",[thisSession description]);
    }
    NSLog(@"All Array : %@",[arrSessions description]);
}

#pragma mark - Progress bar methods
- (void)addProgressbar
{
    [self initRoundedFatProgressBar:self.progressBarRoundedFat];
    [self setProgress:0.43 animated:YES];
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
    //375 x 667
    self.sliderDashboardSpeed.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x, self.sliderDashboardSpeed.frame.origin.y, 300, 300);
    self.imgBGDashboardSpeed.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x-50, self.sliderDashboardSpeed.frame.origin.y-30, 300, 300);
    self.sliderDashboardSpeed.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x-40, self.sliderDashboardSpeed.frame.origin.y-15, 280, 280);
    self.imgBGLogoDashboardSpeed.frame = CGRectMake(self.imgBGLogoDashboardSpeed.frame.origin.x-12,self.imgBGLogoDashboardSpeed.frame.origin.y+55, 70, 46);
    
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
    
    
    //Set Calories
    self.sliderSetCalories.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x+75, self.sliderDashboardSpeed.frame.origin.y+99, 300, 300);
    
    
    //Calories Dashboard view UI
    self.sliderDashboardCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x, self.sliderDashboardCalories.frame.origin.y, 300, 300);
    self.imgBGCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x-45, self.sliderDashboardCalories.frame.origin.y-20, 290, 290);
    self.sliderDashboardCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x-40, self.sliderDashboardCalories.frame.origin.y-10, 280, 280);
    self.imgBGLogoCalories.frame = CGRectMake(self.imgBGLogoCalories.frame.origin.x-12,self.imgBGLogoCalories.frame.origin.y+55, 70, 46);
    self.btnMaxCalories.frame = CGRectMake(self.imgBGLogoCalories.frame.origin.x+self.imgBGLogoCalories.frame.size.width,self.imgBGLogoCalories.frame.origin.y-8, self.btnMaxCalories.frame.size.width, self.btnMaxCalories.frame.size.height);
    
   //[self.sliderDashboardCalories setValue:400];
}

- (void)updateUIForiPhone6Plus
{
    
     NSLog(@"iPhone 6+ Size Width : %f and Height : %f",self.view.frame.size.width, self.view.frame.size.height);
    //414x736
    
    self.sliderDashboardSpeed.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x, self.sliderDashboardSpeed.frame.origin.y, 300, 300);
    self.imgBGDashboardSpeed.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x-50, self.sliderDashboardSpeed.frame.origin.y-25, 300, 300);
    self.sliderDashboardSpeed.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x-40, self.sliderDashboardSpeed.frame.origin.y-15, 290, 290);
    self.imgBGLogoDashboardSpeed.frame = CGRectMake(self.imgBGLogoDashboardSpeed.frame.origin.x-10,self.imgBGLogoDashboardSpeed.frame.origin.y+70, 70, 46);
    
    //Top Progress
    self.lblEngineText.frame = CGRectMake(self.lblEngineText.frame.origin.x + 30, self.lblEngineText.frame.origin.y, self.lblEngineText.frame.size.width, self.lblEngineText.frame.size.height);
    self.lblMeText.frame = CGRectMake(self.lblMeText.frame.origin.x - 30, self.lblMeText.frame.origin.y, self.lblMeText.frame.size.width, self.lblMeText.frame.size.height);
    

    //Set Min Max Speed View UI
    NSLog(@"Multi sector control frame : x : %f, y : %f, width : %f, height : %f",self.multisectorControl.frame.origin.x, self.multisectorControl.frame.origin.y, self.multisectorControl.frame.size.width, self.multisectorControl.frame.size.height);
    
    //self.multisectorControl.frame = CGRectMake(self.multisectorControl.frame.origin.x+95, self.multisectorControl.frame.origin.y+119, 600, 600);
    //self.multisectorControl.frame = CGRectMake(self.multisectorControl.frame.origin.x, self.multisectorControl.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-150);
    
     NSLog(@"Multi sector control frame : x : %f, y : %f, width : %f, height : %f",self.multisectorControl.frame.origin.x, self.multisectorControl.frame.origin.y, self.multisectorControl.frame.size.width, self.multisectorControl.frame.size.height);
    //Selection Menu
    [self.btnSelectPulse setTitleEdgeInsets:UIEdgeInsetsMake(30,-42, 0, 0)];
    [self.btnSelectAvgPulse setTitleEdgeInsets:UIEdgeInsetsMake(30,-52, 0, 0)];
    [self.btnSelectSpeed setTitleEdgeInsets:UIEdgeInsetsMake(30,-42, 0, 0)];
    
    [self.btnSelectAvgSpeed setTitleEdgeInsets:UIEdgeInsetsMake(30,-12, 0, 0)];
    [self.btnSelectAvgSpeed setImageEdgeInsets:UIEdgeInsetsMake(0,50, 0, 0)];
    
    [self.btnSelectCalories setTitleEdgeInsets:UIEdgeInsetsMake(30,-42, 0, 0)];

    
    //Set Calories
    self.sliderSetCalories.frame = CGRectMake(self.sliderDashboardSpeed.frame.origin.x+95, self.sliderDashboardSpeed.frame.origin.y+119, 300, 300);
   
    
    //Calories on Dashboard UI
    self.sliderDashboardCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x, self.sliderDashboardCalories.frame.origin.y, 300, 300);
    self.imgBGCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x-50, self.sliderDashboardCalories.frame.origin.y-25, 300, 300);
    self.sliderDashboardCalories.frame = CGRectMake(self.sliderDashboardCalories.frame.origin.x-40, self.sliderDashboardCalories.frame.origin.y-12, 290, 290);
    self.imgBGLogoCalories.frame = CGRectMake(self.imgBGLogoCalories.frame.origin.x-10,self.imgBGLogoCalories.frame.origin.y+70, 70, 46);
    self.btnMaxCalories.frame = CGRectMake(self.imgBGLogoCalories.frame.origin.x+self.imgBGLogoCalories.frame.size.width,self.imgBGLogoCalories.frame.origin.y-15, self.btnMaxCalories.frame.size.width, self.btnMaxCalories.frame.size.height);
    
    //[self.sliderDashboardCalories setValue:400];
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
    int goalCalories = [self.lblGoalCalories.text intValue];
    if(goalCalories > 0)
    {
        if(goalCalories == cal)
        {
            self.viewGoalCalories.hidden = NO;
        }
    }
}

-(void)getHeaderPacketWithNotification:(NSNotification*)notification{

    
    if([[notification name] isEqualToString:@"headerPacket"]){
    
        NSDictionary *dictionary = (NSDictionary*)[notification object];
        
        
        NSInteger actualCalories = [self.lblCalorieCount.text integerValue];
        
        actualCalories++;
        
        NSNumber *cal = [NSNumber numberWithInteger:actualCalories++];
        
        [self.lblCalorieCount setText:[cal stringValue]];
        
        [self.lblCaloriesValueSlider setText:[cal stringValue]];
        [self.sliderDashboardCalories setValue:[cal floatValue]]; //update calories
        
        NSString *speed = [NSString stringWithFormat:@"%ld",(long)[[dictionary objectForKey:@"Speed"] integerValue] ];
        
        [self.lblCurrentSpeed setText:speed];
        
    
        NSInteger actualKm = [self.lblKilometerCount.text integerValue];
        
        actualKm++;
        
        NSNumber *km = [NSNumber numberWithInteger:actualKm];
        
        [self.simpleCSlider movehandleToValue:[speed intValue]];
        
        
        
        
        switch (self.currentSelectedSensorType)
        {
            case SelectedSensorTypePulse:
            {
                //Pulse Sensor goes here
            }
            break;
            case SelectedSensorTypeAvgPulse:
            {
                //Avg Sensor method
            }
            break;
            case SelectedSensorTypeSpeedNormal:
            {
                //Normal
                [self.sliderDashboardSpeed setValue:[speed floatValue]];
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
                float totalPer = ([cal floatValue] / self.sliderSetCalories.maximumValue) * 100;
                self.lblCaloriesPercentage.text = [NSString stringWithFormat:@"%.0f%%",totalPer];
            }
            break;
            default:
            break;
        }
        
      

        
        //Better Parameters
        NSDictionary *dictParam = @{@"Autonomy" : [dictionary objectForKey:@"Autonomy"],
                                    @"AutonomyDistance" : [dictionary objectForKey:@"AutonomyDistance"]};
        
        [statusBarView setBatteryLevel:dictionary];
        
        [self.lblKilometerCount setText:[km stringValue]];
        
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
    return [searchResultPlaces count];
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath
{
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SPGooglePlacesAutocompleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto" size:16.0];
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
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
    SPGooglePlacesAutocompletePlace *place = [self placeAtIndexPath:indexPath];
    [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error)
     {
         if (error)
         {
             SPPresentAlertViewWithErrorAndTitle(error, @"Could not map selected Place");
         }
         else if (placemark)
         {
             appDelegate().ToLocation = placemark.location;
             appDelegate().strToAddress = addressString;
             [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
             
             [self dismissSearchControllerWhileStayingActive];
            
             NSLog(@"We are done here now display map");
//             UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//             ABMapVC *mapVC = (ABMapVC *)[storyBoard instantiateViewControllerWithIdentifier:@"MapViewViewController"];
//             [self.navigationController pushViewController:mapVC animated:YES];
         }
     }];
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
    [self handleSearchForSearchString:searchString];
    
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
