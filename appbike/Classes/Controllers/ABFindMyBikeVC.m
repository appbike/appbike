//
//  ABFindMyBikeVC.m
//  appbike
//
//  Created by Ashwin Jumani on 4/10/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABFindMyBikeVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapView.h"
#import "Place.h"
#import "AppDelegate.h"


@interface ABFindMyBikeVC ()

@property (nonatomic,strong) IBOutlet UILabel *lblBetterPer;
@property (nonatomic,strong) IBOutlet UILabel *lblBetterLifeKm;
@property (nonatomic,strong) IBOutlet UILabel *lblDistanceValue;
@property (nonatomic,strong) IBOutlet UILabel *lblUpdatedDate;
@property (nonatomic,strong) IBOutlet MKMapView *mapView;
//@property (nonatomic,strong) IBOutlet MapView *mapView;
@property (nonatomic,strong) IBOutlet UIButton *btnLock;
@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView;


@end

@implementation ABFindMyBikeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *dateString = [format stringFromDate:[NSDate date]];
    self.lblUpdatedDate.text = dateString;
    
//    self.mapView = [[MapView alloc] initWithFrame:
//                         CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.mapView.frame.size.height)];
//    
//    [self.view addSubview:self.mapView];
    
    [self getMyBikeLocation];
}

- (void)updateMyLocation:(NSNotification*) notify
{
    
    NSLog(@"Dashboard didUpdateLocations");
    CLLocation *newLocation = (CLLocation *)notify.object;
}

- (void)getMyBikeLocation
{
    //https://dl.dropboxusercontent.com/u/7409975/findmybike.json
    
//    {
//        "location": {
//            "latitude": "44.016521",
//            "longitude": "10.132141"
//        },
//        "battery": {
//            "charge": "63%",
//            "distance": "142000"
//        },
//        "datetime": "20120212T112130",
//        "alarm": {
//            "warning": 1,
//            "active": 1
//        }
//    }
    
    NSString *baseUrl = @"https://dl.dropboxusercontent.com/u/7409975/findmybike.json";
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
         NSError *error = nil;
         NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         
         NSLog(@"Data : %@",[result description]);
         self.lblBetterPer.text = [[result objectForKey:@"battery"] objectForKey:@"charge"];
         float batDistance = [[[result objectForKey:@"battery"] objectForKey:@"distance"] floatValue];
         batDistance = batDistance/1000.0f;
         self.lblBetterLifeKm.text = [NSString stringWithFormat:@"%.0f km",batDistance];
         
         int iAlaramWarning = [[[result objectForKey:@"alarm"] objectForKey:@"warning"] intValue];
         
         if(iAlaramWarning == 1)
         {
             self.btnLock.selected = YES;
         }
         else
         {
             self.btnLock.selected = NO;
         }
         
         Place* home = [[Place alloc] init];
         home.name = @"User";
         home.description = @"User Location";
         //if(appDelegate().currentLocation)
#warning Remove above comment and following if (NO) that is for testing purpose because we can't draw in Asian countries in map
         if(NO)
         {
             home.latitude = appDelegate().currentLocation.coordinate.latitude;
             home.longitude = appDelegate().currentLocation.coordinate.longitude;
         }
         else
         {
             //For simulator
             home.latitude = 44.016523;
             home.longitude = 10.133232;

         }
         
         
         double bikeLatitude = [[[result objectForKey:@"location"] objectForKey:@"latitude"] doubleValue];
         double bikeLongitude = [[[result objectForKey:@"location"] objectForKey:@"longitude"] doubleValue];
         
         Place* office = [[Place alloc] init];
         office.name = @"Bike";
         office.description = @"Bike Location";
         office.latitude = bikeLatitude;
         office.longitude = bikeLongitude;
         
         
         CLLocation *homeLocation = [[CLLocation alloc] initWithLatitude:home.latitude longitude:home.longitude];

         CLLocation *bikeLocation = [[CLLocation alloc] initWithLatitude:office.latitude longitude:office.longitude];
         
         //CLLocationCoordinate2D homeLocation = CLLocationCoordinate2DMake(home.latitude, home.longitude);
         
         // CLLocationCoordinate2D bikeLocation = CLLocationCoordinate2DMake(office.latitude, office.longitude);
         
         CLLocationDistance distanceChange = [homeLocation getDistanceFrom:bikeLocation];
         
         double distance = distanceChange / 1000;
         self.lblDistanceValue.text = [NSString stringWithFormat:@"%.2f",distance];
         
         
         //new code
         CLLocationCoordinate2D coordinateArray[2];
         coordinateArray[0] = CLLocationCoordinate2DMake(home.latitude, home.longitude);
         coordinateArray[1] = CLLocationCoordinate2DMake(office.latitude, office.longitude);
//         
//         
//         self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
//         [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
//         
//         [self.mapView addOverlay:self.routeLine];
         
         MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
         directionsRequest.requestsAlternateRoutes=YES;
         MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinateArray[0] addressDictionary:nil];
         MKPlacemark *placemarkDest = [[MKPlacemark alloc] initWithCoordinate:coordinateArray[1] addressDictionary:nil];
         
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
                 // isInProgress = NO;
                 //self.lblToAddress.text = appDelegate().strToAddress;
             }
             else
             {
                 MKRoute *routeDetails = response.routes.lastObject;
                 //[self.viewMap removeOverlays:<#(NSArray *)#>]
                 [self.mapView addOverlay:routeDetails.polyline];
                 
                 for (int i = 0; i < routeDetails.steps.count; i++)
                 {
                     MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
                     NSString *newStep = step.instructions;
                     NSLog(@"Steps : %@",newStep);
                 }
             }
         }];

         //end new code
        // [self.mapView showRouteFrom:home to:office];
        
         NSDateFormatter *format = [[NSDateFormatter alloc] init];
         [format setDateFormat:@"dd.MM.yyyy HH:mm"];
         NSString *dateString = [format stringFromDate:[NSDate date]];
         self.lblUpdatedDate.text = dateString;
         
     }];
    

}

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
    
    [self.mapView addAnnotation:placemark];
    [self.mapView addAnnotation:placemarkDest];
    
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
           MKRoute *routeDetails = response.routes.lastObject;
            //[self.viewMap removeOverlays:<#(NSArray *)#>]
            [self.mapView addOverlay:routeDetails.polyline];
            
            for (int i = 0; i < routeDetails.steps.count; i++)
            {
                MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
                NSString *newStep = step.instructions;
                NSLog(@"Steps : %@",newStep);
            }
        }
    }];
    
   // [self.locationManager startUpdatingLocation];
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
    polylineView.strokeColor = [UIColor colorWithRed:42.0/255.0 green:133.0/255.0 blue:202/255.0 alpha:1.0];
    //[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"mapLinePathColor"]];
    
    //polylineView.strokeColor = [UIColor colorWithRed:204/255. green:45/255. blue:70/255. alpha:1.0];
    polylineView.lineWidth = 10.0;
    
    return polylineView;
}


//-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
//{
//    if(overlay == self.routeLine)
//    {
//        if(nil == self.routeLineView)
//        {
//            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
//            self.routeLineView.fillColor = [UIColor redColor];
//            self.routeLineView.strokeColor = [UIColor redColor];
//            self.routeLineView.lineWidth = 5;
//            
//        }
//        
//        return self.routeLineView;
//    }
//    
//    return nil;
//}
- (IBAction)refreshGetLocation:(id)sender
{
    [self getMyBikeLocation];
}
- (IBAction)showLeftMenu:(id)sender
{
    //return;
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
