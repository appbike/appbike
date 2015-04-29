//
//  MapViewViewController.m
//  com.zaptechsolutions.appbike
//
//  Created by  Zaptech Solutions on 16/01/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABMapVC.h"
#import "ABBatteryInformation.h"
#import "AppDelegate.h"
#import "AssistanceLevelView.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "GPSLocation.h"
#import "ConstantList.h"
#import <AddressBook/AddressBook.h>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ABMapVC ()
{
    ABBatteryInformation *statusBarView;
    IBOutlet UIView *topLocationView;
    IBOutlet AssistanceLevelView *assistantLevelView;
    BOOL isAssistantViewOpen;
    BOOL isElevationGraphViewOpen;
    BOOL isInProgress;
    NSMutableArray *arrLatLongs;
    int currentIndex;
    NSMutableArray *arrayElevations;
    
    int index, incrementIndex;
    UIView *popupView;
    MKRoute *routeDetails;
    CLLocation *oldLocation1;
    IBOutlet UIButton *btnAuto;
    IBOutlet UIButton *btnCity;
}
@property (weak, nonatomic) IBOutlet UIView *viewElevationChart;
@property (weak, nonatomic) IBOutlet UIButton *btnDownArrow;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *btnAssistantLevel;
@property (strong, nonatomic) IBOutlet UIView *viewBG;

//Locations
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocation *distanceLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *lblFromAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblToAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainingKM;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainingTime;

@property (weak, nonatomic) IBOutlet UIButton *btnStepTime;

@property (nonatomic, strong)  NSMutableArray* places;

@property (nonatomic, strong) FSLineChart* lineChart;

@property (nonatomic) BOOL isAviationCalled;

- (IBAction)showHideAltitudeGraph:(id)sender;

@end

@implementation ABMapVC


- (void) setSkinData
{
    assistantLevelView.backgroundColor = [appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"TopColor"]];
    topLocationView.backgroundColor = [appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"TopColor"]];
    
}

- (void)registerForNotifications
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(updateMyLocation:)
               name:LocationUpdateNotification object:nil];
}

- (void)unregisterFromNotifications
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:LocationUpdateNotification object:nil];
}
//------------------------------------------------------------------

#pragma mark
#pragma mark View Life Cycle Methods

//------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isAviationCalled = NO;
    [self registerForNotifications];
    
    //[self setSkinData];
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    //setup custom location mangaer

    
//    [[GPSLocation sharedManager] stop];
//    [GPSLocation sharedManager].delegate = self;
//    [[GPSLocation sharedManager] start];
    
    self.locationManager = [GPSLocation sharedManager].locationManager;
    
    //Battery Info
    statusBarView = [[ABBatteryInformation alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [statusBarView setMenuName:@"Map"];
    [statusBarView.btnMenu addTarget:self action:@selector(openSlider) forControlEvents:UIControlEventTouchUpInside];
    [statusBarView setBatteryLevel];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    //Top Location View
    [topLocationView setFrame:CGRectMake(0,statusBarView.frame.size.height+statusBarView.frame.origin.y+5,statusBarView.frame.size.width,80)];
    
    [assistantLevelView.btnTop addTarget:self action:@selector(showHideAssistantView) forControlEvents:UIControlEventTouchUpInside];
    isAssistantViewOpen = NO;
    isElevationGraphViewOpen =YES;
    
    appDelegate().arrRoutes = [[NSMutableArray alloc] init];
    appDelegate().arrayCoords = [[NSMutableArray alloc] init];
    [self.btnAssistantLevel addTarget:self action:@selector(showHideAssistantView) forControlEvents:UIControlEventTouchUpInside];
    
    
    isInProgress = YES;
   // #warning by vishal commented below function calling uncomment if you need this
    
    //[self mapInitialize];
    //Initialize Lat Long for Elevation chart
    arrLatLongs = [[NSMutableArray alloc ] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
    
    self.lblFromAddress.text = appDelegate().strFromAddress;
    
    self.lblToAddress.text = appDelegate().strToAddress;
    
}


#pragma mark - Custom Methods for Calculation
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

- (NSString *)getHoursMinutesFromSeconds:(long)seconds
{
    
    int hours = 0, minutes = 0;
    minutes = seconds/60;
    
    if ((seconds/60) > 60) {
        hours = minutes / 60;
        minutes = minutes % 60;
    }
    
    if (hours == 0) return [NSString stringWithFormat:@"%i mins",minutes];
    else return [NSString stringWithFormat:@"%i hrs %i mins",hours,minutes];
}

-(float)metersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to
{
    
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest]/1000;
    
    NSString *distance = [NSString stringWithFormat:@"%f",dist];
    
    return [distance floatValue]/1000;
}
//Update User Profile Image on Chart as per current co-ordinate
- (void)updateProfileImage
{
    NSLog(@"Currnt Index is : %d",appDelegate().incrementIndex);
    
    if(appDelegate().incrementIndex < appDelegate().arrayCoords.count)
    {
        if(appDelegate().incrementIndex >9)
            appDelegate().incrementIndex = 9;
        
        NSMutableDictionary *dictionary = [appDelegate().arrayCoords objectAtIndex:appDelegate().incrementIndex];
        
        [popupView removeFromSuperview];
        
        UIImageView *imageviewBG;
        UIImageView *imageview;
        float yValue = [[dictionary valueForKey:@"y"] floatValue];
       // NSLog(@"")
        if(yValue > (self.viewElevationChart.frame.size.height - 50))
        {
            yValue -= 20;
            NSLog(@"Out of bound bottom");
        }
        else if(yValue < 30)
        {
            yValue = 30;
            NSLog(@"Out of bound top");
        }
        
        if(appDelegate().incrementIndex == 0)
        {
            popupView = [[UIView alloc ] initWithFrame:CGRectMake(-12, yValue-20, 50, 50)];
            imageviewBG = [[UIImageView alloc] initWithFrame:CGRectMake(8, yValue-26, 27, 27)];
            imageview = [[UIImageView alloc] initWithFrame:CGRectMake(imageviewBG.frame.origin.x+2, imageviewBG.frame.origin.y, 23, 23)];
        }
        else
        {
            popupView = [[UIView alloc ] initWithFrame:CGRectMake([[dictionary valueForKey:@"x"] floatValue]-(25 * appDelegate().incrementIndex), yValue-20, 50, 50)];
            imageviewBG = [[UIImageView alloc] initWithFrame:CGRectMake([[dictionary valueForKey:@"x"] floatValue]-50, yValue-27, 27, 27)];
            imageview = [[UIImageView alloc] initWithFrame:CGRectMake(imageviewBG.frame.origin.x+2, imageviewBG.frame.origin.y, 24, 24)];
        }
        
        imageviewBG.image = [UIImage imageNamed:@"mask_circular"]; //Change image name here....
        imageviewBG.clipsToBounds = YES;
        
        if(appDelegate().userProfileImage)
        {
            imageview.image = [UIImage imageWithData:appDelegate().userProfileImage];
        }
        else
        {
            imageview.image = [UIImage imageNamed:@"userPicture"]; //Change image name here....
        }
        
        imageview.layer.cornerRadius = imageview.frame.size.width/2;
        imageview.clipsToBounds = YES;
        imageview.layer.borderWidth = 1.0f;
        imageview.layer.borderColor = [UIColor colorWithRed:47/255.0 green:128/255.0 blue:216/255.0 alpha:1].CGColor;
        [popupView addSubview:imageview];
        [popupView addSubview:imageviewBG];
        
        popupView.backgroundColor = [UIColor clearColor];
        [self.viewElevationChart addSubview:popupView];
    }
    else
    {
        [popupView removeFromSuperview];
        
        popupView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0 , 50, 50)];
        UIImageView *imageviewBG = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 27, 27)];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageviewBG.frame.origin.y, 23, 23)];
        if(appDelegate().userProfileImage)
        {
            imageview.image = [UIImage imageWithData:appDelegate().userProfileImage];
        }
        else
        {
            imageview.image = [UIImage imageNamed:@"userPicture"]; //Change image name here....
        }
        
        imageview.layer.cornerRadius = imageview.frame.size.width/2;
        imageview.clipsToBounds = YES;
        imageview.layer.borderWidth = 1.0f;
        imageview.layer.borderColor = [UIColor colorWithRed:47/255.0 green:128/255.0 blue:216/255.0 alpha:1].CGColor;
        [popupView addSubview:imageview];
        
        imageviewBG.image = [UIImage imageNamed:@"mask_circular"]; //Change image name here....
        imageviewBG.clipsToBounds = YES;
        
        [popupView addSubview:imageviewBG];
        
        popupView.backgroundColor = [UIColor clearColor];
        [self.viewElevationChart addSubview:popupView];

    }
}

#pragma mark - Direction methods
- (void)getDirections
{
    
//    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true", appDelegate().strFromAddress, appDelegate().strToAddress ];
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@,%@&destination=%@,%@&sensor=true", [NSString stringWithFormat:@"%f",appDelegate().fromLocation.coordinate.latitude],[NSString stringWithFormat:@"%f",appDelegate().fromLocation.coordinate.longitude], [NSString stringWithFormat:@"%f",appDelegate().toLocation.coordinate.latitude],[NSString stringWithFormat:@"%f",appDelegate().toLocation.coordinate.longitude]];
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSLog(@"Data : %@",[result description]);
        NSArray *routes = [result objectForKey:@"routes"];
        
        NSDictionary *firstRoute = [routes lastObject];
        
        NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
        
        //CLLocationDistance distanceChange = [appDelegate().toLocation getDistanceFrom:self.locationManager.location];
        //double mDistance = distanceChange/1000;
        //self.lblRemainingKM.text = [NSString stringWithFormat:@"%.1f km",mDistance];
        self.lblRemainingKM.text = [[leg objectForKey:@"distance"] valueForKey:@"text"];
        double mDistance = [[[leg objectForKey:@"distance"] valueForKey:@"value"] doubleValue];
        mDistance = mDistance / 1000;
        appDelegate().iRemainingKM = mDistance;
        
        if(appDelegate().distanceKM >= 0.2)//self.currentLocation != appDelegate().fromLocation)
        {
            CLLocationDistance distanceChange = [appDelegate().toLocation getDistanceFrom:self.locationManager.location];
            mDistance = distanceChange/1000;
            appDelegate().iRemainingKM = mDistance;
            self.lblRemainingKM.text = [NSString stringWithFormat:@"%.1f km",mDistance];
        }
        
        NSLog(@"Testing : %ld",appDelegate().iRemainingKM);
        self.lblRemainingTime.text = @"--";
       
        long  timeInSecond = [[[leg objectForKey:@"duration"] valueForKey:@"value"] longValue];
        NSString *strTime = [self fetchTimeByAddingMicroSeconds:timeInSecond];
        [self.btnStepTime setTitle:strTime forState:UIControlStateNormal];
        
        
        NSDictionary *end_location = [leg objectForKey:@"end_location"];
        
        double latitude = [[end_location objectForKey:@"lat"] doubleValue];
        double longitude = [[end_location objectForKey:@"lng"] doubleValue];
        
       CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        appDelegate().arrRoutes = [[NSMutableArray alloc] initWithArray:routes];
        
        NSArray *steps = [leg objectForKey:@"steps"];
        appDelegate().arrRoutes = [[NSMutableArray alloc] initWithArray:steps];
        
        self.mapView.mapType = MKMapTypeStandard;
        self.mapView.pitchEnabled = YES;
        self.mapView.showsBuildings = YES;
        self.mapView.showsPointsOfInterest = YES;
        self.mapView.zoomEnabled = YES;
        self.mapView.scrollEnabled = YES;
        self.mapView.zoomEnabled = YES;
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = NO;
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:appDelegate().fromLocation.coordinate addressDictionary:nil];
       
        MKPlacemark *placemarkDest = [[MKPlacemark alloc] initWithCoordinate:appDelegate().toLocation.coordinate addressDictionary:nil];
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:placemarkDest];
        
        [self performSelector:@selector(polymarkInMap) withObject:nil afterDelay:2.0];
        
    }];
}

- (void)polymarkInMap
{
    [appDelegate() addToLog:@"add Poly mark on map"];
    currentIndex = 0;
    int stepIndex = 0;
    CLLocationCoordinate2D stepCoordinates[1  + [appDelegate().arrRoutes count] + 1];
    
    stepCoordinates[stepIndex] = appDelegate().fromLocation.coordinate;
    [arrLatLongs removeAllObjects];
    
    NSLog(@"%@",appDelegate().arrRoutes);
    NSLog(@"%d",appDelegate().arrRoutes.count);

    
    
    
    //edited by vishal
    //start
    int totalRouets = appDelegate().arrRoutes.count;
    
    
    int incrementValue = (totalRouets / 10);
    
    
#warning read below comments
    if (totalRouets%10 >= 5) {
        incrementValue ++;
    }
    
    
    //new 10 routes will be stored in arrFileterdRoutes
    NSMutableArray *arrFilterdRoutes = [[NSMutableArray alloc]init];
    for (int cntrRoutes = 0; cntrRoutes < totalRouets; cntrRoutes+=incrementValue) {
        NSDictionary *dictSingleRoute = appDelegate().arrRoutes[cntrRoutes];
        [arrFilterdRoutes addObject:dictSingleRoute];
        NSLog(@"--->>>>>: %d",cntrRoutes);
        if (arrFilterdRoutes.count == 10)
            break;
    }
    
    //Aa logic 1dum perfect nthi bcs jyre total count routes no 5 na mulitiple(ex: 15,25,35,45) thi vdhse tyre pachdana igonre krse bcs already 10 thai gya hse, es an ex 27 count hse to a index 0,2,4,6,8,10,12,14,16,18 aatla lese
    
    // Biju soln ae che ke total count 5 na multiple thi vdhare hoy to incremnetValue +1 kri daiye that is  int incrementValue = (totalRouets / 10) + 1; to pachi total 10 nai thay. Jo 8-9 thi kam chale evu hoy to aa better rese. khali upar ni condition uncommnet kri dejo aa implemnt krvu hoy to.

    
    // end
    //for (NSDictionary *step in appDelegate().arrRoutes)
    for (NSDictionary *step in arrFilterdRoutes)
    {
        
        NSDictionary *start_location = [step objectForKey:@"start_location"];
        stepCoordinates[++stepIndex] = [self coordinateWithLocation:start_location];
#warning remove following condition for all elevation
        if(stepIndex < 10)
            [arrLatLongs addObject:start_location];
        
        if ([appDelegate().arrRoutes count] == stepIndex)
        {
            NSDictionary *end_location = [step objectForKey:@"end_location"];
            stepCoordinates[++stepIndex] = [self coordinateWithLocation:end_location];
          //  [arrLatLongs addObject:end_location];
        }
    }
    
    NSLog(@"Total Steps : %lu",(unsigned long)arrLatLongs.count);
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    //self.mapView.camera = mapCamera;
    
    float spanX = 0.58;
    float spanY = 0.58;
    MKCoordinateRegion region;
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];

    [self createRoute];

}

//Create route  - This method draw route from address to To address

- (void)createRoute
{
    [appDelegate() addToLog:@"Create Route"];
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:appDelegate().fromLocation.coordinate addressDictionary:nil];
    MKPlacemark *placemarkDest = [[MKPlacemark alloc] initWithCoordinate:appDelegate().toLocation.coordinate addressDictionary:nil];
    
    //placemark.coordinate
    [directionsRequest setSource:[[MKMapItem alloc] initWithPlacemark:placemark]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemarkDest]];
    
    [self.mapView addAnnotation:placemark];
    
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error)
        {
            NSLog(@"Error %@", error.description);
            isInProgress = NO;
            self.lblToAddress.text = appDelegate().strToAddress;
        }
        else
        {
            routeDetails = response.routes.lastObject;
            [self.mapView addOverlay:routeDetails.polyline];
    
            for (int i = 0; i < routeDetails.steps.count; i++)
            {
                MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
                NSString *newStep = step.instructions;
                NSLog(@"Steps : %@",newStep);
            }
        }
    }];
    
    NSLog(@"Total Steps : %lu",(unsigned long)arrLatLongs.count);
    
    if(arrLatLongs.count > 0)
    {
        [self drawChartForElevations:arrLatLongs];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Route"
                                                        message:@"There are no route exist with this path."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.lblToAddress.text = appDelegate().strToAddress;
    }
    [self.locationManager startUpdatingLocation];
}

- (CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location
{
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (void)mapInitialize
{
    self.currentLocation            = [[CLLocation alloc] init];
    self.locationManager            = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//kCLLocationAccuracyBest;//kCLLocationAccuracyBestForNavigation;//;
    self.locationManager.distanceFilter=kCLDistanceFilterNone;
    //[self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    self.locationManager.delegate   = self;
    
    if([CLLocationManager locationServicesEnabled])
    {
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [alert show];
        }
        else
        {
             //[self.locationManager startUpdatingLocation];
        }
       [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - Location Service delegate & Methods
- (BOOL)locationServiceEnabled
{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized))
    {
        return YES;
    }
    
    return NO;
}

//- (void)locationManager:(CLLocationManager *)manager
 //    didUpdateLocations:(NSArray *)locations
//-(void)didUpdateToLocations:(NSArray *)locations
- (void)updateMyLocation:(NSNotification*) notify
{
    
    NSLog(@"<<<<<< MAP didUpdateLocations >>>>>>");
    //CLLocation *newLocation = [locations firstObject];
     CLLocation *newLocation = (CLLocation *)notify.object;
    double gpsSpeed = newLocation.speed;
    
    double calculatedSpeed = 0;
    double mDistance = 0;
    if(oldLocation1 != nil)
    {
        CLLocationDistance distanceChange = [appDelegate().toLocation getDistanceFrom:newLocation];
        NSTimeInterval sinceLastUpdate = [newLocation.timestamp timeIntervalSinceDate:appDelegate().fromLocation.timestamp];
        calculatedSpeed = distanceChange / sinceLastUpdate;
        calculatedSpeed = newLocation.speed * 3.6f; //For KM

        NSLog(@"Speed ----->>>>>>>>>>>>>> %.2f",calculatedSpeed);
        oldLocation1 = newLocation;
        self.currentLocation = newLocation;
    }
    else
    {
        oldLocation1 = newLocation;
        self.currentLocation = newLocation;
        CLLocationDistance distanceChange = [appDelegate().toLocation getDistanceFrom:newLocation];
        NSTimeInterval sinceLastUpdate = [newLocation.timestamp timeIntervalSinceDate:appDelegate().fromLocation.timestamp];
        calculatedSpeed = distanceChange / sinceLastUpdate;
        calculatedSpeed = newLocation.speed * 3.6f;
    }
    
    NSLog(@"new speed is : %.2f",calculatedSpeed);
    
    self.currentLocation = newLocation;
    NSLog(@"From Address : %@ ",appDelegate().strFromAddress);

    if(self.isAviationCalled == NO && appDelegate().strFromAddress == nil)
    {
        self.isAviationCalled = YES;
        appDelegate().fromLocation = newLocation;
        
        self.lblSpeed.text = [NSString stringWithFormat:@"%.0f",calculatedSpeed];
        // this creates a MKReverseGeocoder to find a placemark using the found coordinates
        MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
        geoCoder.delegate = self;
        [geoCoder start];
    }
    if(self.isAviationCalled == NO && appDelegate().strFromAddress != nil)
    {
        appDelegate().fromLocation = newLocation;
        self.isAviationCalled = YES;
        [self getDirections];
    }
    if(appDelegate().incrementIndex < arrLatLongs.count)
    {
        
        NSDictionary *end_location = [arrLatLongs objectAtIndex:appDelegate().incrementIndex];
        
        double latitude = [[end_location objectForKey:@"lat"] doubleValue];
        double longitude = [[end_location objectForKey:@"lng"] doubleValue];
        
        CLLocation *nextLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        
        CLLocationDistance distance = [newLocation distanceFromLocation:nextLocation];
        mDistance = distance/1000;
        if(mDistance < 2.0f && newLocation.speed > 1) //2
        {
            
            if(appDelegate().incrementIndex < appDelegate().arrRoutes.count)
            {
                NSDictionary *firstRoute = [appDelegate().arrRoutes objectAtIndex:appDelegate().incrementIndex];
                
                [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
                if(appDelegate().incrementIndex != 0)
                    [self updateProfileImage];
                
                NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
                
                if(leg == nil)
                    leg = firstRoute;
            
                
                self.lblSpeed.text = [NSString stringWithFormat:@"%.0f",calculatedSpeed];
                long timeInSecond = [[[firstRoute objectForKey:@"duration"] valueForKey:@"value"] longValue];
                NSString *strTime = [self fetchTimeByAddingMicroSeconds:timeInSecond];
                [self.btnStepTime setTitle:strTime forState:UIControlStateNormal];
                
            }
        }
    }
    
    if(newLocation.speed <= 1)
    {
        self.lblSpeed.text = @"0";
        //[statusBarView setBatteryLevel];
        [self.btnStepTime setTitle:@"--" forState:UIControlStateNormal];
        [statusBarView updateBetterToZero];
        self.lblRemainingTime.text = @"--";
    }
    else
    {
        
        CLLocationDistance distanceChange = [appDelegate().toLocation getDistanceFrom:self.locationManager.location];
        mDistance = distanceChange/1000;
        
        self.lblSpeed.text = [NSString stringWithFormat:@"%.0f",calculatedSpeed];
        self.lblRemainingKM.text = [NSString stringWithFormat:@"%.1f km",mDistance];
        
        long timeInSecond1 = (mDistance * 3600)/calculatedSpeed;
        long timeInMinute = timeInSecond1/60;
        NSString *finalTime = [self getHoursMinutesFromSeconds:timeInSecond1];
        
        self.lblRemainingTime.text = [NSString stringWithFormat:@"%@",finalTime];
       
        NSString *strTime = [self fetchTimeByAddingMicroSeconds:timeInSecond1];
        [self.btnStepTime setTitle:strTime forState:UIControlStateNormal];
        [statusBarView setBatteryLevel];
        
        
        
       // CLLocationDistance distanceChange1 = [newLocation getDistanceFrom:appDelegate().fromLocation];
        //double myDistance = distanceChange1 / 1000;
       
        //appDelegate().incrementIndex = (int)myDistance;
        //if(myDistance == 0)
        //{
            //appDelegate().distanceLocation = newLocation;
            //appDelegate().incrementIndex++; //Remove comment for next step
            //[self updateProfileImage];
        //}
    }


}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location ----->>>>>>>>>>>>>>");

}
-(void)didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location ----->>>>>>>>>>>>>>");
   
}

//- (void)didFailToUpdateLocation:(NSError *)error
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error : %@",[error description]);
    
}

#pragma mark - Reverse Geocoder
// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    if(self.isAviationCalled == YES)
    {
        // with the placemark you can now retrieve the Address name
        appDelegate().strFromAddress = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressStreetKey];
        if(appDelegate().strFromAddress == nil)
            appDelegate().strFromAddress = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressCityKey];
        self.lblFromAddress.text = appDelegate().strFromAddress;
        NSLog(@"From Address in reverse geocoder : %@",appDelegate().strFromAddress);
       // [appDelegate() addToLog:[NSString stringWithFormat:@"From Address : %@",appDelegate().strFromAddress]];
        appDelegate().fromLocation = placemark.location;
       // [self.locationManager stopUpdatingLocation];
        [self getDirections];
    }

    NSLog(@"Placemark : %@",[placemark description]);
}

- (void)addAnnotation:(CLPlacemark *)placemark
{
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
    point.title = [placemark.addressDictionary objectForKey:@"Street"];
    point.subtitle = [placemark.addressDictionary objectForKey:@"City"];
    [self.mapView addAnnotation:point];
}


#pragma mark Map View Delegates

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"mapLinePathColor"]];
    
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
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
        } else
        {
            pinView.annotation = annotation;
        }
        pinView.image = [UIImage imageNamed:@"loc_user.png"];
        return pinView;
    }
    return nil;
}

#pragma mark - Draw chart Elevations & Elevation APIs
-(void) drawChartForElevations:(NSMutableArray *)arrLatLngs
{
    NSString *strLatLngs = [[NSString alloc] init];
    for (NSDictionary *dictionary in arrLatLongs)
    {
        
        strLatLngs = [strLatLngs stringByAppendingString:[NSString stringWithFormat:@"%@,%@|",[dictionary valueForKey:@"lat"],[dictionary valueForKey:@"lng"]]];
    }
    
    strLatLngs = [strLatLngs substringWithRange:NSMakeRange(0, [strLatLngs length]-1)];
    
    NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/elevation/json?locations=%@&sensor=true",strLatLngs];
    
    strURL  = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *googleRequestURL=[NSURL URLWithString:strURL];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

#pragma mark -- Fetch data from Elevation Google API
- (void)fetchedData:(NSData *)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    //NSMutableArray* places = [[NSMutableArray alloc]init];
    self.places = [[NSMutableArray alloc]init];
    [self.places setArray:[json objectForKey:@"results"]];
    
    if([self.places count] == 0)
    {
        isInProgress = NO;
        return;
    }
    else
    {
        /* output
         {
         elevation = "1608.637939453125";
         location =     {
         lat = "39.7391536";
         lng = "-104.9847034";
         };
         resolution = "4.771975994110107";
         },
         {
         elevation = "-50.78903579711914";
         location =     {
         lat = "36.455556";
         lng = "-116.866667";
         };
         resolution = "19.08790397644043";
         }
         
         */
        
        arrayElevations = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dictionary in self.places) {
            int elevation = [[dictionary valueForKey:@"elevation"] intValue];
            if(elevation < 0)
                elevation = 0;
            
            NSString *strElevation = [NSString stringWithFormat:@"%d",elevation];
            //[arrayElevations addObject:[dictionary valueForKey:@"elevation"]];
            [arrayElevations addObject:strElevation];
        }
        
        NSLog(@"Elevations : %@",[arrayElevations description]);
        
        [self.viewElevationChart addSubview:[self chart1:arrayElevations]];
        isInProgress = NO;
        [self updateProfileImage];
        
         [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(updateImageViewLocation:) userInfo:nil repeats:YES];
    }
}

- (IBAction)updateImageViewLocation:(id)sender
{
    
    NSString *strLatLngs = [NSString stringWithFormat:@"%f,%f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];

    NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/elevation/json?locations=%@&sensor=true",strLatLngs];
    strURL  = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *googleRequestURL=[NSURL URLWithString:strURL];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedDataCurrentLocation:) withObject:data waitUntilDone:YES];
    });
    
    
}

- (void)fetchedDataCurrentLocation:(NSData *)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSMutableArray* mplaces = [[NSMutableArray alloc]init];
    //self.places = [[NSMutableArray alloc]init];
    [mplaces setArray:[json objectForKey:@"results"]];
    
    if([mplaces count] == 0)
    {
        isInProgress = NO;
        return;
    }
    else
    {
        /* output
         {
         elevation = "1608.637939453125";
         location =     {
         lat = "39.7391536";
         lng = "-104.9847034";
         };
         resolution = "4.771975994110107";
         },
         {
         elevation = "-50.78903579711914";
         location =     {
         lat = "36.455556";
         lng = "-116.866667";
         };
         resolution = "19.08790397644043";
         }
         
         */
        
        
        NSString *currentElevationValue = [arrayElevations objectAtIndex:0];
        for (NSDictionary *dictionary in mplaces)
        {
            currentElevationValue = [NSString stringWithFormat:@"%d",[[dictionary valueForKey:@"elevation"] intValue]];
        }
        appDelegate().incrementIndex = [self.lineChart getChartIndexFromData:currentElevationValue withLocation:self.locationManager.location];
        [self updateProfileImage]; //## ASH : Test later on
    }
}

#pragma mark - Creating the charts

-(FSLineChart*)chart1:(NSMutableArray *)arrElevations
{
    
    NSMutableArray* chartData = [NSMutableArray arrayWithCapacity:arrElevations.count];
    
    NSLog(@"ArrElevation  : %@",[arrElevations description]);
    for(int i=0;i<arrElevations.count;i++)
    {
        
        chartData[i] = [NSNumber numberWithInt:[[arrElevations objectAtIndex:i] intValue]];
    }
    
    // Creating the line chart
    self.lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(0, 0, self.viewElevationChart.frame.size.width, self.viewElevationChart.frame.size.height)];
    
    self.lineChart.gridStep = 3;
    
    self.lineChart.labelForIndex = ^(NSUInteger item)
    {
       return [NSString stringWithFormat:@"%lu",(unsigned long)item];
    };
    
    self.lineChart.labelForValue = ^(CGFloat value)
    {
        return [NSString stringWithFormat:@"%.f", value];
    };
    
    [self.lineChart setChartData:chartData];
    
    [self.lineChart setLocations:self.places];
    
    return self.lineChart;
}


//------------------------------------------------------------------

#pragma mark
#pragma mark Action Methods

//------------------------------------------------------------------

- (void) showHideAssistantView
{
    CGRect fram = assistantLevelView.frame;
    CGRect buttonFram = self.btnAssistantLevel.frame;
    CGRect buttonAutoFrame = btnAuto.frame;
    CGRect buttonCityFrame = btnCity.frame;
    
    if (isAssistantViewOpen)
    {
        fram.origin.y+=75;
        buttonFram.origin.y += 75;
        buttonAutoFrame.origin.y +=75;
        buttonCityFrame.origin.y +=75;
        
    } else
    {
        fram.origin.y-=75;
        buttonFram.origin.y-=75;
        buttonAutoFrame.origin.y -=75;
        buttonCityFrame.origin.y -=75;
        
    }
    isAssistantViewOpen=!isAssistantViewOpen;
    [UIView animateWithDuration:0.4 animations:^{
        [assistantLevelView setFrame:fram];
        [self.btnAssistantLevel setFrame:buttonFram];
        [btnAuto setFrame:buttonAutoFrame];
        [btnCity setFrame:buttonCityFrame];
    }];
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

- (void) openSlider
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app openCloseMenu];
}

//------------------------------------------------------------------------

- (IBAction)showHideAltitudeGraph:(id)sender
{
    
    if(isInProgress )
        return;
    
    CGRect fram = self.viewElevationChart.frame;
    if (isElevationGraphViewOpen)
    {
        fram.size.height-=80;
        self.viewBG.hidden = YES;
        [UIView animateWithDuration:0.4 animations:^{
            [self.viewElevationChart setFrame:fram];
            [self.viewElevationChart setHidden:YES];
            
        }];
        
        self.btnDownArrow.frame = CGRectMake(self.btnDownArrow.frame.origin.x,self.viewElevationChart.frame.origin.y+fram.size.height-13,self.btnDownArrow.frame.size.width, self.btnDownArrow.frame.size.height);
        
        [self.btnDownArrow setImage:[UIImage imageNamed:@"map_down_arrow"] forState:UIControlStateNormal];
        
    }
    else
    {
        self.viewBG.hidden = NO;
        fram.size.height+=80;
        [UIView animateWithDuration:0.4 animations:^{
            [self.viewElevationChart setFrame:fram];
            [self.viewElevationChart setHidden:NO];
            [self.viewElevationChart setNeedsDisplay];
            
        }];
        self.btnDownArrow.frame = CGRectMake(self.btnDownArrow.frame.origin.x,self.viewElevationChart.frame.origin.y+fram.size.height,self.btnDownArrow.frame.size.width, self.btnDownArrow.frame.size.height);
        [self.btnDownArrow setImage:[UIImage imageNamed:@"map_up_arrow"] forState:UIControlStateNormal];
        
    }
    isElevationGraphViewOpen=!isElevationGraphViewOpen;
}
@end