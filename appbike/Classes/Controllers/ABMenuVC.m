//
//  MenuViewController.m
//  Apparound
//
//  Created by  Zaptech Solutions on 09/01/15.
//  Copyright (c) 2015 zaptech. All rights reserved.
//

#import "ABMenuVC.h"
#import "ABDashBoardVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ABBatteryInformation.h"
#import "SWRevealViewController.h"
#import "ConstantList.h"
#import "AppDelegate.h"


@interface ABMenuVC ()

@end

@implementation ABMenuVC


//------------------------------------------------------------------

#pragma mark
#pragma mark View Life Cycel Methods

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}
//------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
   // NSLog(@"User Image frame : %@", self.btnUserImg.frame);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLoginWithFB])
    {
        [self loadUserProfileImage];
    }
    
    NSLog(@"Skin Data : %@",appDelegate().dictSkinData);
    
  
    
    [self.btnDashBoard setImage:[UIImage imageNamed:@"dashbaord_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.btnDashBoard setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self.btnFitness setImage:[UIImage imageNamed:@"fitness_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.btnFitness setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self.btnMap setImage:[UIImage imageNamed:@"map_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.btnMap setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self.btnSafty setImage:[UIImage imageNamed:@"safety_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.btnSafty setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self.btnSocial setImage:[UIImage imageNamed:@"social_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.btnSocial setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self.btnUtility setImage:[UIImage imageNamed:@"utility_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.btnUtility setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self setSkinData];
    
    
    [self.btnUserName setFrame:CGRectMake(self.btnUserName.frame.origin.x-22, self.btnUserName.frame.origin.y, self.btnUserName.frame.size.width, self.btnUserName.frame.size.height)]; //-30
    [self.btnUserImg setFrame:CGRectMake(self.btnUserImg.frame.origin.x-22, self.btnUserImg.frame.origin.y, self.btnUserImg.frame.size.width, self.btnUserImg.frame.size.height)]; //-30

    if(IS_IPHONE_6_PLUS)
    {
        [self updateUIForiPhone6Plus];
    }
    else if(IS_IPHONE_5)
    {
        [self updateUIForiPhone5];
    }
}

//------------------------------------------------------------------

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SWRevealViewController *revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
   
}


- (void)setSkinData
{
    self.viewTopView.backgroundColor = [appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"TopColor"]];
    
    self.view.backgroundColor = [appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"BottomColor"]];
    /*
    self.viewCircleDashboard.clipsToBounds = YES;
    self.viewCircleDashboard.backgroundColor = [appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"TopColor"]];
    [self setRoundedView:self.viewCircleDashboard toDiameter:60];
    [self.btnDashBoard setTitleColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"menuTextColor"]] forState:UIControlStateNormal];
    [self.btnDashBoard setTitleColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"menuTextHighlightColor"]] forState:UIControlStateSelected|UIControlStateHighlighted];
 
    //Map
    self.viewCircleMap.clipsToBounds = YES;
    self.viewCircleMap.backgroundColor = [appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"TopColor"]];
    [self setRoundedView:self.viewCircleMap toDiameter:60];
    [self.btnMap setTitleColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"menuTextColor"]] forState:UIControlStateNormal];
    [self.btnMap setTitleColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"menuTextHighlightColor"]] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    //Fitness
    self.viewCircleFitness.clipsToBounds = YES;
    self.viewCircleFitness.backgroundColor = [appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"TopColor"]];
    [self setRoundedView:self.viewCircleFitness toDiameter:60];
    [self.btnFitness setTitleColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"menuTextColor"]] forState:UIControlStateNormal];
    [self.btnFitness setTitleColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"menuTextHighlightColor"]] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    //Utility
    self.viewCircleUtility.clipsToBounds = YES;
    self.viewCircleUtility.backgroundColor = [appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"TopColor"]];
    [self setRoundedView:self.viewCircleUtility toDiameter:60];
    [self.btnUtility setTitleColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"menuTextColor"]] forState:UIControlStateNormal];
    [self.btnUtility setTitleColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"menuTextHighlightColor"]] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    //Safty
    self.viewCircleSafty.clipsToBounds = YES;
    self.viewCircleSafty.backgroundColor = [appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"TopColor"]];
    [self setRoundedView:self.viewCircleSafty toDiameter:60];
    [self.btnSafty setTitleColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"menuTextColor"]] forState:UIControlStateNormal];
    [self.btnSafty setTitleColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"menuTextHighlightColor"]] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    //Social
    self.viewCircleSocial.clipsToBounds = YES;
    self.viewCircleSocial.backgroundColor = [appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"TopColor"]];
    [self setRoundedView:self.viewCircleSocial toDiameter:60];
    [self.btnSocial setTitleColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"menuTextColor"]] forState:UIControlStateNormal];
    [self.btnSocial setTitleColor:[appDelegate() toUIColor:[appDelegate().dictSkinData objectForKey:@"menuTextHighlightColor"]] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    */
}

- (void)updateUIForiPhone5
{
    [self.btnMap setFrame:CGRectMake(self.btnMap.frame.origin.x-40, self.btnMap.frame.origin.y, self.btnMap.frame.size.width, self.btnMap.frame.size.height)];
    self.viewCircleMap.frame = CGRectMake(self.btnMap.frame.origin.x + 20, self.viewCircleMap.frame.origin.y, self.viewCircleMap.frame.size.width, self.viewCircleMap.frame.size.height);
    
    [self.btnUtility setFrame:CGRectMake(self.btnUtility.frame.origin.x-40, self.btnUtility.frame.origin.y, self.btnUtility.frame.size.width, self.btnUtility.frame.size.height)];
    
    self.viewCircleUtility.frame = CGRectMake(self.btnUtility.frame.origin.x + 20, self.viewCircleUtility.frame.origin.y, self.viewCircleUtility.frame.size.width, self.viewCircleUtility.frame.size.height);
    
    [self.btnSocial setFrame:CGRectMake(self.btnSocial.frame.origin.x-40, self.btnSocial.frame.origin.y, self.btnSocial.frame.size.width, self.btnSocial.frame.size.height)];
    self.viewCircleSocial.frame = CGRectMake(self.btnSocial.frame.origin.x + 20, self.viewCircleSocial.frame.origin.y, self.viewCircleSocial.frame.size.width, self.viewCircleSocial.frame.size.height);
    

    
}
- (void)updateUIForiPhone6Plus
{
    CGRect size = [[ UIScreen mainScreen ] bounds ];
    [self.btnDashBoard setFrame:CGRectMake(self.btnDashBoard.frame.origin.x+30, self.btnDashBoard.frame.origin.y, self.btnDashBoard.frame.size.width, self.btnDashBoard.frame.size.height)];
    self.viewCircleDashboard.frame = CGRectMake(self.btnDashBoard.frame.origin.x + 20, self.viewCircleDashboard.frame.origin.y, self.viewCircleDashboard.frame.size.width, self.viewCircleDashboard.frame.size.height);

    
    [self.btnFitness setFrame:CGRectMake(self.btnFitness.frame.origin.x+30, self.btnFitness.frame.origin.y, self.btnFitness.frame.size.width, self.btnFitness.frame.size.height)];
    self.viewCircleFitness.frame = CGRectMake(self.btnFitness.frame.origin.x + 20, self.viewCircleFitness.frame.origin.y, self.viewCircleFitness.frame.size.width, self.viewCircleFitness.frame.size.height);
    
    
    [self.btnSafty setFrame:CGRectMake(self.btnSafty.frame.origin.x+30, self.btnSafty.frame.origin.y+4, self.btnSafty.frame.size.width, self.btnSafty.frame.size.height)];
    self.viewCircleSafty.frame = CGRectMake(self.btnSafty.frame.origin.x + 20, self.viewCircleSafty.frame.origin.y, self.viewCircleSafty.frame.size.width, self.viewCircleSafty.frame.size.height);
    
    [self.btnSocial setFrame:CGRectMake(self.btnSocial.frame.origin.x, self.btnSocial.frame.origin.y+4, self.btnSocial.frame.size.width, self.btnSafty.frame.size.height)];
    self.viewCircleSocial.frame = CGRectMake(self.btnSocial.frame.origin.x + 20, self.viewCircleSocial.frame.origin.y, self.viewCircleSocial.frame.size.width, self.viewCircleSocial.frame.size.height);
    
    [self.btnDashBoard setTitleEdgeInsets:UIEdgeInsetsMake((size.size.width * 60) / 320, (size.size.width * -57) / 320, 0, 0)];
    
    [self.btnMap setTitleEdgeInsets:UIEdgeInsetsMake((size.size.width * 60) / 320, (size.size.width * -62) / 320, 0, 0)];
    
    [self.btnFitness setTitleEdgeInsets:UIEdgeInsetsMake((size.size.width * 60) / 320, (size.size.width * -57) / 320, 0, 0)];
    
    [self.btnUtility setTitleEdgeInsets:UIEdgeInsetsMake((size.size.width * 60) / 320, (size.size.width * -53) / 320, 0, 0)];
    
    [self.btnSafty setTitleEdgeInsets:UIEdgeInsetsMake((size.size.width * 60) / 320, (size.size.width * -57) / 320, 0, 0)];
    
    [self.btnSocial setTitleEdgeInsets:UIEdgeInsetsMake((size.size.width * 60) / 320, (size.size.width * -53) / 320, 0, 0)];

}
//------------------------------------------------------------------

#pragma mark
#pragma mark Custom Methods

//------------------------------------------------------------------

- (void) loadUserProfileImage
{
    [self.btnUserImg setUserInteractionEnabled:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:kFBUserProfileImgURL]]];
        NSString *fbUserName=[[NSUserDefaults standardUserDefaults] valueForKey:kFBUserName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.btnUserName setTitle:fbUserName forState:UIControlStateNormal];
            [self.btnUserImg setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
            appDelegate().userProfileImage = imgData;
        });
    });
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//------------------------------------------------------------------

- (UIBezierPath *)roundedPolygonPathWithRect:(CGRect)square
                                   lineWidth:(CGFloat)lineWidth
                                       sides:(NSInteger)sides
                                cornerRadius:(CGFloat)cornerRadius
{
    UIBezierPath *path  = [UIBezierPath bezierPath];
    
    CGFloat theta       = 2.0 * M_PI / sides;                           // how much to turn at every corner
    CGFloat offset      = cornerRadius * tanf(theta / 2.0);             // offset from which to start rounding corners
    CGFloat squareWidth = MIN(square.size.width, square.size.height);   // width of the square
    
    // calculate the length of the sides of the polygon
    
    CGFloat length      = squareWidth - lineWidth;
    if (sides % 4 != 0)
    {                                               // if not dealing with polygon which will be square with all sides ...
        length = length * cosf(theta / 2.0) + offset/2.0;               // ... offset it inside a circle inside the square
    }
    CGFloat sideLength = length * tanf(theta / 2.0);
    
    // start drawing at `point` in lower right corner
    
    CGPoint point = CGPointMake(squareWidth / 2.0 + sideLength / 2.0 - offset, squareWidth - (squareWidth - length) / 2.0);
    CGFloat angle = M_PI;
    [path moveToPoint:point];
    
    // draw the sides and rounded corners of the polygon
    
    for (NSInteger side = 0; side < sides; side++)
    {
        point = CGPointMake(point.x + (sideLength - offset * 2.0) * cosf(angle), point.y + (sideLength - offset * 2.0) * sinf(angle));
        [path addLineToPoint:point];
        
        CGPoint center = CGPointMake(point.x + cornerRadius * cosf(angle + M_PI_2), point.y + cornerRadius * sinf(angle + M_PI_2));
        [path addArcWithCenter:center radius:cornerRadius startAngle:angle - M_PI_2 endAngle:angle + theta - M_PI_2 clockwise:YES];
        
        point = path.currentPoint; // we don't have to calculate where the arc ended ... UIBezierPath did that for us
        angle += theta;
    }
    
    [path closePath];
    
    return path;
}

//------------------------------------------------------------------

#pragma mark
#pragma mark Action Methods

//------------------------------------------------------------------

- (IBAction)btnUserImgClicked:(id)sender
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kIsLoginWithFB])
    {
        [FBSession openActiveSessionWithPublishPermissions:@[@"public_profile,publish_actions,publish_stream"] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [FBSession setActiveSession:session];
            [self sessionStateChanged:session state:status error:error];
        }];
    }
}

//------------------------------------------------------------------------

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen)
    {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                // Success! Include your code to handle the results here
                NSLog(@"user info: %@", result);
                if (result)
                {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLoginWithFB];
                    if ([result valueForKey:@"name"])
                    {
                        NSString *userName = [result valueForKey:@"name"];
                        [[NSUserDefaults standardUserDefaults] setValue:userName forKey:kFBUserName];
//                       [self.btnUserNameName setText:[result valueForKey:@"name"]];
                        [self.btnUserName setTitle:[result valueForKey:@"name"] forState:UIControlStateNormal];
                    }
                    if ([result valueForKey:@"id"])
                    {
                        NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [result valueForKey:@"id"]];
                        [[NSUserDefaults standardUserDefaults] setValue:userImageURL forKey:kFBUserProfileImgURL];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self loadUserProfileImage];
                        
                    }
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            else
            {
                
                
                [FBSession setActiveSession:nil];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLoginWithFB];
                [FBSession.activeSession closeAndClearTokenInformation];
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
            }
        }];
    }
    
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed)
    {
        // If the session is closed Log Out
        
        [FBSession.activeSession closeAndClearTokenInformation];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Facebook integration was canceled by user" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [alert show];

        [FBSession setActiveSession:nil];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLoginWithFB];
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    
    // Handle errors
    if (error)
    {
        [FBSession setActiveSession:nil];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLoginWithFB];
        [FBSession.activeSession closeAndClearTokenInformation];
        // Fire Delegate
        
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
        {
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            
        }
        else
        {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
            {
            }
            else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
            {
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                
            }
            else
            {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
            }
        }
    }
}

//------------------------------------------------------------------

#pragma mark
#pragma mark Action Methods

//------------------------------------------------------------------

- (IBAction)btnSelected:(id)sender
{
    
    UIButton *btn = sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(pushToSelectedButton:)]){
        [self.delegate pushToSelectedButton:btn.tag];
    }
}

@end
