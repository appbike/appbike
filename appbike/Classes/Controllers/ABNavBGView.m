//
//  ViewController.m
//  appbike
//
//  Created by  Zaptech Solutions on 1/9/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABNavBGView.h"
#import "AppDelegate.h"
#import "ABBatteryInformation.h"
#import "SWRevealViewController.h"

@interface ABNavBGView ()
{
    ABBatteryInformation *statusBarView;
}

@end

@implementation ABNavBGView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];

    //Init Battery Information
    statusBarView = [[ABBatteryInformation alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [statusBarView setMenuName:@"Dashboard"];
    [statusBarView.btnMenu addTarget:self action:@selector(openSlider) forControlEvents:UIControlEventTouchUpInside];
    [statusBarView setBatteryLevel];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    //Setup Tap Gesture
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.revealViewController action:@selector(rightRevealToggle:)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer.enabled = NO;
    SWRevealViewController *revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
}


//------------------------------------------------------------------

#pragma mark
#pragma mark SWReveal controller view methods

//------------------------------------------------------------------

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionRight)
    {
        self.tapGestureRecognizer.enabled = YES;
        [self.view setUserInteractionEnabled:NO];
    }
    else if (position == FrontViewPositionLeft)
    {
        self.tapGestureRecognizer.enabled = NO;
        [self.view setUserInteractionEnabled:YES];
    }
}

//------------------------------------------------------------------

- (void) openSlider
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app openCloseMenu];
}

//------------------------------------------------------------------


- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
