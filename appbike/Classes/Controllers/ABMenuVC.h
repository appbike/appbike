//
//  MenuViewController.h
//  Apparound
//
//  Created by  Zaptech Solutions on 09/01/15.
//  Copyright (c) 2015 zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol SwrevealDegate <NSObject>

-(void) pushToSelectedButton:(NSInteger)rowNum;

@end

@interface ABMenuVC : UIViewController<FBLoginViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnDashBoard;
@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet UIButton *btnFitness;
@property (strong, nonatomic) IBOutlet UIButton *btnUtility;
@property (strong, nonatomic) IBOutlet UIButton *btnSafty;
@property (strong, nonatomic) IBOutlet UIButton *btnSocial;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UIButton *btnUserName;
@property (strong, nonatomic) IBOutlet UIView *viewTopView;

@property (strong, nonatomic) IBOutlet UIView *viewCircleDashboard;
@property (strong, nonatomic) IBOutlet UIView *viewCircleMap;
@property (strong, nonatomic) IBOutlet UIView *viewCircleFitness;
@property (strong, nonatomic) IBOutlet UIView *viewCircleUtility;
@property (strong, nonatomic) IBOutlet UIView *viewCircleSafty;
@property (strong, nonatomic) IBOutlet UIView *viewCircleSocial;


@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic,unsafe_unretained) id <SwrevealDegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *btnUserImg;


- (IBAction)btnUserImgClicked:(id)sender;
- (IBAction)btnSelected:(id)sender;

@end
