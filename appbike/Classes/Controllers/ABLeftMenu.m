//
//  ABLeftMenu.m
//  appbike
//
//  Created by Ashwin Jumani on 4/11/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABLeftMenu.h"
#import "ABNavigationVC.h"
#import "ABDashBoardVC.h"
#import "ABNavigationVC.h"
#import "ABHistoryListVC.h"
#import "ABFindMyBikeVC.h"
#import "ABFavoriteList.h"
#import "ABDiagnosticVC.h"
#import "AppDelegate.h"

@interface ABLeftMenu ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)IBOutlet UITableView *tableView;


@end

@implementation ABLeftMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView reloadData];
    
}

- (IBAction)btnMenuItemSelected:(id)sender
{
    
    UIButton *btnPressed = (UIButton *)sender;
    NSNumber *tag = [NSNumber numberWithInteger:btnPressed.tag] ;
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:MenuItemNotification object:tag];
    
////     ABNavigationVC *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardNav"];
////    self.frostedViewController.contentViewController = navigationController;
//    [self.frostedViewController hideMenuViewController];
    
    ABNavigationVC *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardNav"];
   
    
    int mTag = [tag intValue];
    switch (mTag) {
        case 101:
        {
            //Engine Off
           // ABNavigationVC *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardNav"];
            //self.frostedViewController.contentViewController = navigationController;
            //[self.frostedViewController hideMenuViewController];
            
            ABDashBoardVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABDashBoardVC"];
            secondViewController.isDisplayDestination = NO;
            navigationController.viewControllers = @[secondViewController];
            self.frostedViewController.contentViewController = navigationController;
            
        }
            break;
        case 102:
        {
            //Destination
            
            if(appDelegate().isSessionStart)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AppBike"
                                                                    message:@"Please stop current session before set new destination"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:@"Ok",nil];
                //alertView.tag = 1001;
                [alertView show];
            }
            else
            {
                ABDashBoardVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABDashBoardVC"];
                secondViewController.isDisplayDestination = YES;
                navigationController.viewControllers = @[secondViewController];
                
    //            appDelegate().dashboardVC.isDisplayDestination = YES;
      //          navigationController.viewControllers = @[appDelegate().dashboardVC];
                self.frostedViewController.contentViewController = navigationController;
            }
    //        [appDelegate().dashboardVC showDestination];
            //[self.frostedViewController hideMenuViewController];
           // [[NSNotificationCenter defaultCenter] postNotificationName:MenuItemNotification object:tag];
        }
            break;
        case 103:
        {
            //Favorite
            ABFavoriteList *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABFavoriteList"];
            navigationController.viewControllers = @[secondViewController];
            
            self.frostedViewController.contentViewController = navigationController;
        }
            break;
        case 104:
        {
            //History
            
            ABHistoryListVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABHistoryListVC"];
            navigationController.viewControllers = @[secondViewController];
            
            self.frostedViewController.contentViewController = navigationController;
            
            
        }
            break;
        case 105:
        {
            //Profile
        }
            break;
        case 106:
        {
            //Diagnostics
            ABDiagnosticVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABDiagnosticVC"];
            navigationController.viewControllers = @[secondViewController];
            
            self.frostedViewController.contentViewController = navigationController;
        }
            break;
        case 107:
        {
            //Where is my bike
            ABFindMyBikeVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABFindMyBikeVC"];
            navigationController.viewControllers = @[secondViewController];
            
            self.frostedViewController.contentViewController = navigationController;
        }
            break;
        default:
            break;
    }

    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ABNavigationVC *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardNav"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        ABDashBoardVC *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardViewController"];
        navigationController.viewControllers = @[homeViewController];
    } else {
//        DEMOSecondViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondController"];
//        navigationController.viewControllers = @[secondViewController];
    }
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    NSArray *titles = @[@"Engine Off", @"Destination", @"Favorites",@"History",@"Profile",@"Diagnostic",@"Where is my bike"];
    cell.textLabel.text = titles[indexPath.row];
    
    cell.imageView.image=[UIImage imageNamed:@"Camera.png"];
    
    cell.textLabel.textColor=[UIColor whiteColor];
    
    return cell;
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
