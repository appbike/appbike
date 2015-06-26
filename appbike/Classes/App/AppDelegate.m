//
//  AppDelegate.m
//  Apparound
//
//  Created by Anil on 09/01/15.
//  Copyright (c) 2015 zaptech. All rights reserved.
//

#import "AppDelegate.h"
#import "ABNavBGView.h"
#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"
#import "Session+Utils.h"

#import "SWRevealViewController.h"
#import "ABMenuVC.h"
#import "ABDashBoardVC.h"
#import "ABMapVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ABLocationAutoCompleteVC.h"
#import <MapKit/MapKit.h>
#import "BikesConnectionViewController.h"
#import "JSON.h"


@interface AppDelegate ()
{
    SWRevealViewController *menuSlider;
}

@end

static AppDelegate *myDelegate;

@implementation AppDelegate

@synthesize menuSlider;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[GPSLocation sharedManager] start];
    
    
    self.assitantLevelCount = 1;
    //=>     Setup MagicalRecord
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"AppBike.sqlite"];
    
    myDelegate = self;
    //
    
    
   // ABDashBoardVC *viewController = (ABDashBoardVC *)[storyBoard instantiateViewControllerWithIdentifier:@"ABDashBoardVC"];
//    ABMenuVC *menuViewVC = (ABMenuVC *)[storyBoard instantiateViewControllerWithIdentifier:@"MenuViewController"];
//    menuViewVC.delegate = self;
    
    self.arrayCoords = [[NSMutableArray alloc] init];
    
    
    
#warning remove following comment after design implementation done
    //Comment for Phase 2 development
    //Push Ble devices view controller to: read user licence, discover ble e bikes and connect with it
    
//    BikesConnectionViewController *bikesConnectionViewController = [[BikesConnectionViewController alloc] init];
//
//    UINavigationController *navigationController = [[UINavigationController alloc] init];
//    [navigationController.navigationBar setTranslucent:NO];
//    [navigationController pushViewController:bikesConnectionViewController animated:YES];
//    
//    self.menuSlider = [[SWRevealViewController alloc]initWithRearViewController:menuViewVC frontViewController:navigationController];
    
    
//
    
    // ############ Finally Uncomment this following code
    
    BikesConnectionViewController *bikesConnectionViewController = [[BikesConnectionViewController alloc] init];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = bikesConnectionViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
/// ### #### Uncomment above
    
  
    //Comment below new commen for design purpose - 17/6
    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"AppBike" bundle:nil];
//    UINavigationController *navigationController = [storyBoard instantiateViewControllerWithIdentifier:@"DashBoardNav"];
//    
//    //[self.menuSlider setFrontViewController:navigationController];
//    
//    [self.window setRootViewController:navigationController];
//    
//   // [navigationController pushViewController:viewController animated:YES];
//    
//     [self.window makeKeyAndVisible];
    // Comment above
    
    appDelegate().strLog = @"";
    self.incrementIndex = 0;
    
    self.dictSkinData = [self dictionaryLocalContentsOfJSONString:@"skin.json"];
    self.dictConstantData = [self dictionaryLocalContentsOfJSONString:@"constant.json"];
    //self.dictCaloriesData = [self dictionaryWithContentsOfJSONString:@"calories.json"];
    //self.dictDashboardData = [self dictionaryWithContentsOfJSONString:@"dashboard.json"];
    //self.dictKMHData = [self dictionaryWithContentsOfJSONString:@"kmh.json"];
    //self.dictCounterData = [self dictionaryWithContentsOfJSONString:@"countdown.json"];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"myData.json"];
   // NSLog(@"filePath %@", filePath);
    
    //Calories
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"calories.json"];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    if(fileExists)
    {
        self.dictCaloriesData = [self dictionaryWithContentsOfJSONString:@"calories.json"];
    }
    else
    {
        self.dictCaloriesData = @{@"max" : @"500",@"goal":@"0",@"enabled" : @"0" };
        [self saveJsonFile:@"calories.json" withDictionary:self.dictCaloriesData];
    }
    
    
    //Dashboard
    NSString *filepathDashboard = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"dashboard.json"];
   // NSString *filepathDashboard = [[NSBundle mainBundle] pathForResource:@"dashboard.json" ofType:@""];
    
    BOOL fileExistsDashboard = [[NSFileManager defaultManager] fileExistsAtPath:filepathDashboard];
    if(fileExistsDashboard)
    {
        self.dictDashboardData = [self dictionaryWithContentsOfJSONString:@"dashboard.json"];
    }
    else
    {
        self.dictDashboardData = @{@"topLeft": @"cal",
                                   @"topRight" : @"km",
                                   @"main" : @"kmh",
                                   @"bottomLeft" : @"rpm",
                                   @"bottomRight" : @"bpm" };
        [self saveJsonFile:@"dashboard.json" withDictionary:self.dictDashboardData];
    }
    
    //KMH
    NSString *filepathKMH = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"kmh.json"];
    //NSString *filepathKMH = [[NSBundle mainBundle] pathForResource:@"kmh.json" ofType:@""];
    
    BOOL fileExistsKMH = [[NSFileManager defaultManager] fileExistsAtPath:filepathKMH];
    if(fileExistsKMH)
    {
        self.dictKMHData = [self dictionaryWithContentsOfJSONString:@"kmh.json"];
    }
    else
    {
        self.dictKMHData = @{@"min": @"20",
                             @"max" : @"70",
                             @"enabled" : @"0" };
        
        [self saveJsonFile:@"kmh.json" withDictionary:self.dictKMHData];
    }

    //Countdown
    NSString *filepathCount = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"countdown.json"];
   // NSString *filepathCount = [[NSBundle mainBundle] pathForResource:@"countdown.json" ofType:@""];
    
    BOOL fileExistsCount = [[NSFileManager defaultManager] fileExistsAtPath:filepathCount];
    if(fileExistsCount)
    {
        self.dictCounterData = [self dictionaryWithContentsOfJSONString:@"countdown.json"];
    }
    else
    {
        self.dictCounterData = @{ @"value": @"5" };
        [self saveJsonFile:@"countdown.json" withDictionary:self.dictCounterData];
    }
    
    
    //Favorite
    NSString *filepathFavorite = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"favorites.json"];
   
    
    BOOL fileExistsFavorite = [[NSFileManager defaultManager] fileExistsAtPath:filepathFavorite];

    if(!fileExistsFavorite)
    {
        NSDictionary *dictFavorite = @{@"home" : @"" , @"favorites" : @""};
        [self saveJsonFile:@"favorites.json" withDictionary:dictFavorite];
    }
    
    [self initializeLocationManager];
    

    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // FBSample logic
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // FBSample logic
    // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
    [FBAppEvents activateApp];
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        NSLog(@"In fallback handler");
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([locations count] > 0)
    {
        CLLocation *locaiton = [locations firstObject];
        NSLog(@"Current Speed = %f", locaiton.speed);
        [appDelegate() addToLog:[NSString stringWithFormat:@"Speed on app delegate : %.2f",locaiton.speed]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Localization Error = %@", error.localizedDescription);
    [appDelegate() addToLog:[NSString stringWithFormat:@"Location service have error in app delagate Error : %@",error.localizedDescription]];
}

- (void) initializeLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    if([CLLocationManager locationServicesEnabled])
    {
        NSLog(@"Location Services Enabled");
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
                        [self.locationManager requestWhenInUseAuthorization];
        }
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                            message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [appDelegate() addToLog:@"Location service start updating"];
            [self.locationManager startUpdatingLocation];
        }
    }

}

//------------------------------------------------------------------------

+ (AppDelegate *)sharedInstance
{
    return myDelegate;
}

//------------------------------------------------------------------------

- (CLLocationSpeed) getCurrentSpeed
{
    NSLog(@"Current device speed : %f",self.locationManager.location.speed);
    return self.locationManager.location.speed;
}

//------------------------------------------------------------------

-(void)openCloseMenu
{
    [(SWRevealViewController *)self.window.rootViewController revealToggle:nil];
}

//------------------------------------------------------------------

- (void)pushToSelectedButton:(NSInteger)btnTag
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if(btnTag==1){
        ABDashBoardVC *dashBoardVC = (ABDashBoardVC *)[storyBoard instantiateViewControllerWithIdentifier:@"DashBoardViewController"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dashBoardVC];
        [menuSlider setFrontViewController:navigationController];
        [menuSlider revealToggle:nil];
    }
    else if (btnTag==2)
    {
        
        if(self.strToAddress)
        {
            self.distanceLocation = self.fromLocation;
            
            ABMapVC *mapVC = (ABMapVC *)[storyBoard instantiateViewControllerWithIdentifier:@"MapViewViewController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapVC];
            [menuSlider setFrontViewController:navigationController];
            [menuSlider revealToggle:nil];
            
        }
        else
        {
            if([CLLocationManager locationServicesEnabled])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AppAround"
                                                                message:@"Tap to select destination"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Ok",nil];
                alertView.tag = 1001;
                [alertView show];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AppAround"
                                                                    message:@"Please enable Location Services from your settings."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:@"Ok",nil];
                
                [alertView show];

            }
            
            //Search
        }
    }
}

- (void)gotoMap
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ABMapVC *mapVC = (ABMapVC *)[storyBoard instantiateViewControllerWithIdentifier:@"MapViewViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapVC];
    [menuSlider setFrontViewController:navigationController];
    [menuSlider revealToggle:nil];
    [self.window makeKeyAndVisible];
}
#pragma mark Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1 && alertView.tag == 1001)
    {
        if(self.strToAddress)
        {
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ABMapVC *mapVC = (ABMapVC * )[storyBoard instantiateViewControllerWithIdentifier:@"MapViewViewController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapVC];
            [menuSlider setFrontViewController:navigationController];
            [menuSlider revealToggle:nil];
            
        }
        else
        {
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ABLocationAutoCompleteVC *mapVC = (ABLocationAutoCompleteVC * )[storyBoard instantiateViewControllerWithIdentifier:@"GLPlacesAutoCompleteVC"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapVC];
            [menuSlider setFrontViewController:navigationController];
            [menuSlider revealToggle:nil];
        }
    }
}

- (void)addToLog:(NSString *)string
{
    //appDelegate().strLog = [appDelegate().strLog stringByAppendingString:@"\n"];
    //appDelegate().strLog = [appDelegate().strLog stringByAppendingString:string];
}

- (UIColor *)toUIColor:(NSString *)ColorStr
{
    unsigned int c;
    if ([ColorStr characterAtIndex:0] =='#')
    {
        [[NSScanner scannerWithString:[ColorStr substringFromIndex:1]] scanHexInt:&c];
    }
    else
    {
        [[NSScanner scannerWithString:ColorStr] scanHexInt:&c];
    }
    return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0 green:((c & 0xff00) >> 8)/255.0 blue:(c & 0xff)/255.0 alpha:1.0];
}

-(NSDictionary*)dictionaryLocalContentsOfJSONString:(NSString*)fileLocation
{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:[fileLocation pathExtension]];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    // Be careful here. You add this as a category to NSDictionary
    // but you get an id back, which means that result
    // might be an NSArray as well!
    if (error != nil) return nil;
    return result;
}
-(NSDictionary*)dictionaryWithContentsOfJSONString:(NSString*)fileLocation
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileLocation];
    
   // NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:[fileLocation pathExtension]];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    // Be careful here. You add this as a category to NSDictionary
    // but you get an id back, which means that result
    // might be an NSArray as well!
    if (error != nil) return nil;
    return result;
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
#pragma mark - Convenience Constructors

AppDelegate *appDelegate(void)
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
@end