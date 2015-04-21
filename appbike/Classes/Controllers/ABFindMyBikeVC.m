//
//  ABFindMyBikeVC.m
//  appbike
//
//  Created by Ashwin Jumani on 4/10/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABFindMyBikeVC.h"

@interface ABFindMyBikeVC ()

@property (nonatomic,strong) IBOutlet UILabel *lblBetterPer;
@property (nonatomic,strong) IBOutlet UILabel *lblBetterLifeKm;
@property (nonatomic,strong) IBOutlet UILabel *lblDistanceValue;
@property (nonatomic,strong) IBOutlet UILabel *lblUpdatedDate;

@end

@implementation ABFindMyBikeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getMyBikeLocation];
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
