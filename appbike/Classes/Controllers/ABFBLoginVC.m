//
//  ABFBLoginVC.m
//  appbike
//
//  Created by Ashwin Jumani on 4/24/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABFBLoginVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ConstantList.h"
#import "AppDelegate.h"

@implementation ABFBLoginVC



- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void) loadUserProfileImage
{
    //[self.btnUserImg setUserInteractionEnabled:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:kFBUserProfileImgURL]]];
        NSString *fbUserName=[[NSUserDefaults standardUserDefaults] valueForKey:kFBUserName];
        dispatch_async(dispatch_get_main_queue(), ^{
          //  [self.btnUserName setTitle:fbUserName forState:UIControlStateNormal];
           // [self.btnUserImg setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
            appDelegate().userProfileImage = imgData;
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        });
    });
}


- (IBAction)btnFBLogin:(id)sender
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kIsLoginWithFB])
    {
        [FBSession openActiveSessionWithPublishPermissions:@[@"public_profile,publish_actions,publish_stream"] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [FBSession setActiveSession:session];
            [self sessionStateChanged:session state:status error:error];
        }];
    }
    else
    {
        [FBSession openActiveSessionWithPublishPermissions:@[@"public_profile,publish_actions,publish_stream"] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [FBSession setActiveSession:session];
            [self sessionStateChanged:session state:status error:error];
        }];

//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];

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
                       // [self.btnUserName setTitle:[result valueForKey:@"name"] forState:UIControlStateNormal];
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

@end
