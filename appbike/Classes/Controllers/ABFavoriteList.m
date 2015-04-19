//
//  ABFavoriteList.m
//  appbike
//
//  Created by Ashwin Jumani on 4/15/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABFavoriteList.h"
#import "ABBatteryInformation.h"

@interface ABFavoriteList ()
{
    IBOutlet ABBatteryInformation *statusBarView;
}
@end

@implementation ABFavoriteList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Battery Info initialize
    statusBarView = [[ABBatteryInformation alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [statusBarView setBatteryLevel];
    [self.view addSubview:statusBarView];
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
