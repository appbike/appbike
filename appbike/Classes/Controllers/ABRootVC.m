//
//  ABRootVC.m
//  appbike
//
//  Created by Ashwin Jumani on 4/11/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABRootVC.h"

@interface ABRootVC ()

@end

@implementation ABRootVC

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardNav"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenu"];
    
    
    self.liveBlur=NO;
    // self.blurTintColor=[UIColor blackColor];
    self.backgroundFadeAmount=0.1;
    
    // self.blurSaturationDeltaFactor=0.5;
    
    self.blurRadius=1.0;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
