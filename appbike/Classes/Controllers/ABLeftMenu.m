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
#import "ABLeftMenuCell.h"

@interface ABLeftMenu ()<UITableViewDataSource,UITableViewDelegate>
{
    int lastIndex;
}
@property (nonatomic,strong)IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *arrMenu;

@end

@implementation ABLeftMenu

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lastIndex = 0;
    // Do any additional setup after loading the view.
    
    self.arrMenu = [[NSMutableArray alloc] init];
    
    NSDictionary *dictDashboard = @{@"title" : @"Dashboard", @"image" : @"dashboard_menu.png",@"selected_image" : @"dashboard_menu_selected.png"};
    NSDictionary *dictDashboard1 = @{@"title" : @"Destination", @"image" : @"destination.png",@"selected_image" : @"destination_selected.png"};
    NSDictionary *dictDashboard2 = @{@"title" : @"Favourite", @"image" : @"favourite.png",@"selected_image" : @"favourite_selected.png"};
    NSDictionary *dictDashboard3 = @{@"title" : @"History", @"image" : @"history.png",@"selected_image" : @"history_selected.png"};
    NSDictionary *dictDashboard4 = @{@"title" : @"Profile", @"image" : @"profile.png",@"selected_image" : @"profile_selected.png"};
    NSDictionary *dictDashboard5 = @{@"title" : @"Diagnostics", @"image" : @"diagnostic.png",@"selected_image" : @"diagnostic_selected.png"};
    
    NSDictionary *dictDashboard7 = @{@"title" : @"Search HR Monitor", @"image" : @"HR_monitor.png",@"selected_image" : @"HR_monitor.png_selected.png"};
    
    NSDictionary *dictDashboard6 = @{@"title" : @"Where is my bike", @"image" : @"bike.png",@"selected_image" : @"bike_selected.png"};
    
    [self.arrMenu addObject:dictDashboard];
    [self.arrMenu addObject:dictDashboard1];
    [self.arrMenu addObject:dictDashboard2];
    [self.arrMenu addObject:dictDashboard3];
    [self.arrMenu addObject:dictDashboard4];
    [self.arrMenu addObject:dictDashboard5];
    [self.arrMenu addObject:dictDashboard7];
    [self.arrMenu addObject:dictDashboard6];
    
    
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
            
//            ABDashBoardVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABDashBoardVC"];
//            secondViewController.isDisplayDestination = NO;
//            navigationController.viewControllers = @[secondViewController];
//            self.frostedViewController.contentViewController = navigationController;
            btnPressed.selected = !btnPressed.selected;
            
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
                secondViewController.isSecondTime = YES;
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
            
        case 108:
        {
            //Dashboard
                        ABDashBoardVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABDashBoardVC"];
                        secondViewController.isDisplayDestination = NO;
            secondViewController.isSecondTime = YES;
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

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.backgroundColor = [UIColor clearColor];
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
//{
//    if (sectionIndex == 0)
//        return nil;
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
//    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
//    label.text = @"Friends Online";
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [UIColor blackColor];
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    [view addSubview:label];
//    
//    return view;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
//{
//    if (sectionIndex == 0)
//        return 0;
//    
//    return 34;
//}


#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.arrMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ABLeftMenuCell";
    
    ABLeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ABLeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    

    NSDictionary *dictData = [self.arrMenu objectAtIndex:indexPath.row];
    
    cell.lblMenu.text = [dictData objectForKey:@"title"];
    cell.imgMenu.image = [UIImage imageNamed:[dictData objectForKey:@"image"]];
    cell.imgMenu.frame = CGRectMake(cell.imgMenu.frame.origin.x, cell.imgMenu.frame.origin.y, 40, 40);
    
    if(indexPath.row == lastIndex )
    {
        cell.imgMenu.image = [UIImage imageNamed:[dictData objectForKey:@"selected_image"]];
    }
//    NSArray *titles = @[@"Engine Off", @"Destination", @"Favorites",@"History",@"Profile",@"Diagnostic",@"Where is my bike"];
//    cell.textLabel.text = titles[indexPath.row];
//    
//    cell.imageView.image=[UIImage imageNamed:@"Camera.png"];
//    
//    cell.textLabel.textColor=[UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
    ABLeftMenuCell *Lastcell = (ABLeftMenuCell*)[tableView cellForRowAtIndexPath:lastIndexPath];
    NSDictionary *dictData1 = [self.arrMenu objectAtIndex:lastIndex];
    Lastcell.imgMenu.image =  [UIImage imageNamed:[dictData1 objectForKey:@"image"]];
    
    lastIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ABNavigationVC *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardNav"];
    
    NSDictionary *dictData = [self.arrMenu objectAtIndex:indexPath.row];
    
    ABLeftMenuCell *cell = (ABLeftMenuCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.imgMenu.image =  [UIImage imageNamed:[dictData objectForKey:@"selected_image"]];
    
    
    switch (indexPath.row)
    {
      
        case 0:
        {
            //Favorite
            //ABDashBoardVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABDashBoardVC"];
            //secondViewController.isDisplayDestination = NO;
            appDelegate().dashboardVC.isDisplayDestination = NO;
            navigationController.viewControllers = @[appDelegate().dashboardVC];
            self.frostedViewController.contentViewController = navigationController;
        }
            break;
        case 1:
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
        case 2:
        {
            //Favorite
            ABFavoriteList *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABFavoriteList"];
            navigationController.viewControllers = @[secondViewController];
            
            self.frostedViewController.contentViewController = navigationController;
        }
            break;
        case 3:
        {
            //History
            
            ABHistoryListVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABHistoryListVC"];
            navigationController.viewControllers = @[secondViewController];
            
            self.frostedViewController.contentViewController = navigationController;
            
            
        }
            break;
        case 4:
        {
            //Profile
        }
            break;
        case 5:
        {
            //Diagnostics
            ABDiagnosticVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABDiagnosticVC"];
            navigationController.viewControllers = @[secondViewController];
            
            self.frostedViewController.contentViewController = navigationController;
        }
            break;
        case 6:
        {
            //Where is my bike
            NSLog(@"Search HR Monitor");
//            ABFindMyBikeVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABFindMyBikeVC"];
//            navigationController.viewControllers = @[secondViewController];
//            
//            self.frostedViewController.contentViewController = navigationController;
        }
            break;
            
        case 7:
        {
            //Where is my bike
//            ABDashBoardVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ABDashBoardVC"];
//            secondViewController.isDisplayDestination = NO;
//            navigationController.viewControllers = @[secondViewController];
//            self.frostedViewController.contentViewController = navigationController;
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
