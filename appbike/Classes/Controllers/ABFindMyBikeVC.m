//
//  ABFindMyBikeVC.m
//  appbike
//
//  Created by Ashwin Jumani on 4/10/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABFindMyBikeVC.h"
#import <MapKit/MapKit.h>
#import "MapView.h"
#import "Place.h"
#import "AppDelegate.h"


@interface ABFindMyBikeVC ()

@property (nonatomic,strong) IBOutlet UILabel *lblBetterPer;
@property (nonatomic,strong) IBOutlet UILabel *lblBetterLifeKm;
@property (nonatomic,strong) IBOutlet UILabel *lblDistanceValue;
@property (nonatomic,strong) IBOutlet UILabel *lblUpdatedDate;
//@property (nonatomic,strong) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) IBOutlet MapView *mapView;



@end

@implementation ABFindMyBikeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.mapView = [[MapView alloc] initWithFrame:
                         CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.mapView.frame.size.height)];
    
    [self.view addSubview:self.mapView];
    
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
         
         
         Place* home = [[Place alloc] init];
         home.name = @"User";
         home.description = @"User Location";
         if(appDelegate().currentLocation)
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
         
         
         [self.mapView showRouteFrom:home to:office];
                 
         
     }];
    

}
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
