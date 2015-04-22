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

@interface ABHistoryListVC ()
{
    IBOutlet ABBatteryInformation *statusBarView;
    int currentSelectedRow;
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
        }
        break;
        case 102:
        {
            //Last Week
            self.arrSession = [NSMutableArray arrayWithArray:[Session findLastWeek]];
        }
        break;
        case 103:
        {
            //This Week
            self.arrSession = [NSMutableArray arrayWithArray:[Session findThisWeek]];
        }
        break;
        default:
            break;
    }
    btnPressed.selected = !btnPressed.selected;
    [self.tblHistory reloadData];
}

- (IBAction)backToHistoryList:(id)sender
{
    //Back to history list
    self.viewDetail.hidden = YES;
}
- (IBAction)deleteThisHistory:(id)sender
{
    NSLog(@"Delete History");
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
    
    [cell.btnKM setTitle:[NSString stringWithFormat:@"%@",thisSession.s_km] forState:UIControlStateNormal];
    
    [cell.btnCal setTitle:[NSString stringWithFormat:@"%@",thisSession.s_cal] forState:UIControlStateNormal];
    
    [cell.btnMin setTitle:[NSString stringWithFormat:@"%@",thisSession.s_avgkm] forState:UIControlStateNormal];
    
    //cell.lblDate.text = @"TEXT";
    cell.btnDelete.tag = indexPath.row;
    cell.btnShare.tag = indexPath.row;
    
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
    self.lblCalValue.text = [NSString stringWithFormat:@"%@ cal",thisSession.s_cal];
    self.lblAvgSpeedValue.text = [NSString stringWithFormat:@"%@ cal",thisSession.s_avgkm];
    
    
    self.viewDetail.hidden = NO;
}

- (IBAction)deleteFromCell:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    NSLog(@"Delete : %d",btnPressed.tag);
}
- (IBAction)shareFromCell:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    NSLog(@"Share : %d",btnPressed.tag);
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
