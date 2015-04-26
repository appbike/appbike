//
//  ABHistoryListVC.m
//  appbike
//
//  Created by Ashwin Jumani on 4/10/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABHistoryListVC.h"
#import "ABHistoryCell.h"
#import "ABBatteryInformation.h"
#import "Session+Utils.h"
#import <FacebookSDK/FacebookSDK.h>


@interface ABHistoryListVC ()
{
    IBOutlet ABBatteryInformation *statusBarView;
    int currentSelectedRow;
    float totalDistance, totalMin, totalCal;
    BOOL m_postingInProgress;
}

@property (nonatomic, strong) NSMutableArray *arrSession;
@property (nonatomic, strong) IBOutlet UITableView *tblHistory;
@property (nonatomic, strong) IBOutlet UIView *viewDetail;
@property (nonatomic, strong) IBOutlet UILabel *lblDateDetail;
@property (nonatomic, strong) IBOutlet UILabel *lblFromValue;
@property (nonatomic, strong) IBOutlet UILabel *lblToValue;
@property (nonatomic, strong) IBOutlet UILabel *lblMinValue;
@property (nonatomic, strong) IBOutlet UILabel *lblBPMValue;
@property (nonatomic, strong) IBOutlet UILabel *lblAvgSpeedValue;
@property (nonatomic, strong) IBOutlet UILabel *lblRPMValue;
@property (nonatomic, strong) IBOutlet UILabel *lblCalValue;
@property (nonatomic, strong) IBOutlet UILabel *lblDistanceValue;

@property (nonatomic, strong) IBOutlet UIButton *btnTotalDistance;
@property (nonatomic, strong) IBOutlet UIButton *btnTotalMins;
@property (nonatomic, strong) IBOutlet UIButton *btnTotalCal;

@end

@implementation ABHistoryListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Battery Info initialize
    statusBarView = [[ABBatteryInformation alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [statusBarView setBatteryLevel];
    [self.view addSubview:statusBarView];
    
    self.arrSession = [NSMutableArray arrayWithArray:[Session getAllSessionItems]];
    [self.tblHistory reloadData];
    
    //[self postWithText:@"Hello" ImageName:@"logo.png" URL:@"" Caption:@"AppBike" Name:@"AppBike" andDescription:@"Description"];
}

- (IBAction)selectFilter:(id)sender
{
    self.viewDetail.hidden = YES;
    
    [self.arrSession removeAllObjects];
    UIButton *btnPressed = (UIButton *)sender;
    switch (btnPressed.tag)
    {
        case 101:
        {
            //All
            self.arrSession = [NSMutableArray arrayWithArray:[Session getAllSessionItems]];
            
            
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:102];
            btn1.selected = NO;
            UIButton *btn2 = (UIButton *)[self.view viewWithTag:103];
            btn2.selected = NO;

            UIButton *btn3 = (UIButton *)[self.view viewWithTag:101];
            btn3.selected = YES;
            
        }
        break;
        case 102:
        {
            //Last Week
            self.arrSession = [NSMutableArray arrayWithArray:[Session findLastWeek]];
            
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
            btn1.selected = NO;
            UIButton *btn2 = (UIButton *)[self.view viewWithTag:103];
            btn2.selected = NO;
            
            UIButton *btn3 = (UIButton *)[self.view viewWithTag:102];
            btn3.selected = YES;
        }
        break;
        case 103:
        {
            //This Week
            self.arrSession = [NSMutableArray arrayWithArray:[Session findThisWeek]];
            
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:102];
            btn1.selected = NO;
            UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
            btn2.selected = NO;
            
            UIButton *btn3 = (UIButton *)[self.view viewWithTag:103];
            btn3.selected = YES;
        }
        break;
        default:
            break;
    }
    //btnPressed.selected = !btnPressed.selected;
    [self.tblHistory reloadData];
}

- (IBAction)backToHistoryList:(id)sender
{
    //Back to history list
    self.viewDetail.hidden = YES;
}

- (IBAction)shareThisHistory:(id)sender
{
    [self shareThisAtIndex:currentSelectedRow];
}
- (IBAction)deleteThisHistory:(id)sender
{
    NSLog(@"Delete History");
    [self deleteHistoryAtIndex:currentSelectedRow];
    self.viewDetail.hidden = YES;
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


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 10;
    return [self.arrSession count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ABHistoryCell";
    ABHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[ABHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Session *thisSession = [self.arrSession objectAtIndex:indexPath.row];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *dateString = [format stringFromDate:thisSession.s_start];
    
    cell.lblDate.text = dateString;
    
    NSDictionary *jsonDict = [self stringToJsonDiction:thisSession.s_json];
    
    
    int seconds = [[jsonDict objectForKey:@"ActivityDurationSeconds"] intValue];
    int min = seconds / 60;
    
    totalDistance += [[jsonDict objectForKey:@"Distance"] intValue];
    totalCal += [[jsonDict objectForKey:@"Calories"] intValue];
    totalMin += min;
    
    [cell.btnKM setTitle:[NSString stringWithFormat:@"%@ km",[jsonDict objectForKey:@"Distance"]] forState:UIControlStateNormal];
    
    [cell.btnCal setTitle:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@ cal",[jsonDict objectForKey:@"Calories"]]] forState:UIControlStateNormal];
    
    [cell.btnMin setTitle:[NSString stringWithFormat:@"%d",min] forState:UIControlStateNormal];
    
    //cell.lblDate.text = @"TEXT";
    cell.btnDelete.tag = indexPath.row;
    cell.btnShare.tag = indexPath.row;
    
    if(indexPath.row == (self.arrSession.count-1))
    {
        //self.lblTotalCal.text = [NSString stringWithFormat:@""]
        [self.btnTotalCal setTitle:[NSString stringWithFormat:@"%.0f",totalCal] forState:UIControlStateNormal];
        [self.btnTotalDistance setTitle:[NSString stringWithFormat:@"%.0f",totalDistance] forState:UIControlStateNormal];
        [self.btnTotalMins setTitle:[NSString stringWithFormat:@"%.0f",totalMin] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tblHistory deselectRowAtIndexPath:indexPath animated:YES];
    
    Session *thisSession = [self.arrSession objectAtIndex:indexPath.row];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *dateString = [format stringFromDate:thisSession.s_start];
    
    self.lblDateDetail.text = dateString;
    self.lblFromValue.text = thisSession.s_startlocation;
    self.lblToValue.text = thisSession.s_endlocation;
    
   // self.lblAvgSpeedValue.text = [NSString stringWithFormat:@"%@ km",thisSession.s_avgkm];
    
    NSDictionary *jsonDict = [self stringToJsonDiction:thisSession.s_json];
    
    
    self.lblCalValue.text =  [NSString stringWithFormat:@"%@ cal",[jsonDict objectForKey:@"Calories"]];
    self.lblDistanceValue.text = [NSString stringWithFormat:@"%@ km",[jsonDict objectForKey:@"Distance"]];
    self.lblAvgSpeedValue.text = [NSString stringWithFormat:@"%@ km/h",[jsonDict objectForKey:@"AvgSpeed"]];
    self.lblBPMValue.text = [NSString stringWithFormat:@"%@ bpm",[jsonDict objectForKey:@"HB"]];
    self.lblRPMValue.text = [NSString stringWithFormat:@"%@ rpm",[jsonDict objectForKey:@"Dsb"]];
    int seconds = [[jsonDict objectForKey:@"ActivityDurationSeconds"] intValue];
    int min = seconds / 60;
    
    self.lblMinValue.text = [NSString stringWithFormat:@"%d min",min];
//    {
//        Autonomy = 84;
//        AutonomyDistance = 71;
//        AvgSpeed = 62;
//        Calories = 75;
//        Current = 80;
//        Distance = 95;
//        DistanceSession = 62;
//        Dsb = 71;
//        Energy = 10;
//        Errors = 73;
//        Frequency = 64;
//        GearBox = 73;
//        HB = 46;
//        Life = 85;
//        Light = 10;
//        M2M = 48;
//        Soc = 61;
//        Speed = 67;
//        Torque = 7;
//        Voltage = 34;
//    }

    NSLog(@"Jsond Dict : %@",jsonDict);
    
    self.viewDetail.hidden = NO;
    
    currentSelectedRow = indexPath.row;
}

- (NSDictionary *)stringToJsonDiction:(NSString *)jsonString
{
    NSData *webData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    return jsonDict;
}

- (IBAction)deleteFromCell:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    NSLog(@"Delete : %d",btnPressed.tag);
    [self deleteHistoryAtIndex:btnPressed.tag];
    

}

- (void)deleteHistoryAtIndex:(int)index
{
    totalCal = 0;
    totalDistance = 0;
    totalMin = 0;
    Session *thisSession = [self.arrSession objectAtIndex:index];
    [thisSession removeItemFromSession];
    [self.arrSession removeObjectAtIndex:index];
    [self.tblHistory reloadData];
}


- (IBAction)shareFromCell:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    NSLog(@"Share : %d",btnPressed.tag);
    
    [self shareThisAtIndex:btnPressed.tag];
   
    
}

- (void)shareThisAtIndex:(int)index
{
    Session *thisSession = [self.arrSession objectAtIndex:index];
    NSString *strMessage = [NSString stringWithFormat:@"My App Bike Static is : %@",thisSession.s_json];
    [self postWithText:strMessage ImageName:@"logo.png" URL:@"" Caption:@"AppBike" Name:@"AppBike" andDescription:@"Description"];
}

-(void) postWithText: (NSString*) message
           ImageName: (NSString*) image
                 URL: (NSString*) url
             Caption: (NSString*) caption
                Name: (NSString*) name
      andDescription: (NSString*) description
{
    
//    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                   url, @"link",
//                                   name, @"name",
//                                   caption, @"caption",
//                                   description, @"description",
//                                   message, @"message",
//                                   UIImagePNGRepresentation([UIImage imageNamed: image]), @"picture",
//                                   nil];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  
                                   name, @"name",
                                   caption, @"caption",
                                   description, @"description",
                                   message, @"message",
                                   nil];
    
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound)
    {
        // No permissions found in session, ask for it
        [FBSession.activeSession requestNewPublishPermissions: [NSArray arrayWithObject:@"publish_actions"]
                                              defaultAudience: FBSessionDefaultAudienceEveryone
                                            completionHandler: ^(FBSession *session, NSError *error)
         {
             if (!error)
             {
                 // If permissions granted and not already posting then publish the story
                 if (!m_postingInProgress)
                 {
                     [self postToWall: params];
                 }
             }
         }];
    }
    else
    {
        // If permissions present and not already posting then publish the story
        if (!m_postingInProgress)
        {
            [self postToWall: params];
        }
    }
}

-(void) postToWall: (NSMutableDictionary*) params
{
    m_postingInProgress = YES; //for not allowing multiple hits
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         if (error)
         {
             //showing an alert for failure
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:@"Post Failed"
                                       message:error.localizedDescription
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
             [alertView show];
         }
         m_postingInProgress = NO;
     }];
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
