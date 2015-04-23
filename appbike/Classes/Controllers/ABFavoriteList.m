//
//  ABFavoriteList.m
//  appbike
//
//  Created by Ashwin Jumani on 4/15/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABFavoriteList.h"
#import "ABFavoriteCell.h"
#import "Favorite+Utils.h"
#import "ABBatteryInformation.h"
#import "AppDelegate.h"

@interface ABFavoriteList ()
{
    IBOutlet ABBatteryInformation *statusBarView;
}

@property (nonatomic, strong) IBOutlet UITableView *tblFavorite;
@property (nonatomic, strong) NSMutableArray *arrFavorites;
@property (nonatomic, strong) IBOutlet UILabel *lblToAddress;
@property (nonatomic, strong) IBOutlet UILabel *lblHomeAddress;
@property (nonatomic, strong) IBOutlet UITextField *txtAddress;
@end

@implementation ABFavoriteList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Battery Info initialize
    statusBarView = [[ABBatteryInformation alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [statusBarView setBatteryLevel];
    [self.view addSubview:statusBarView];
    
    if(!appDelegate().strToAddress)
    {
        self.lblToAddress.text = @"Not Selected";
    }
    else
    {
        self.lblToAddress.text = appDelegate().strToAddress;
    }
    
    [self reloadFavoriteData];
}

- (void)reloadFavoriteData
{
    NSMutableArray *arrHome = [NSMutableArray arrayWithArray:[Favorite getHomeFavorite]];
    if(arrHome.count > 0)
    {
        Favorite *homeFavorite = [arrHome firstObject];
        self.lblHomeAddress.text = homeFavorite.f_title;
    }
    else
    {
        self.lblHomeAddress.text = @"Not Added";
    }
    self.arrFavorites = [NSMutableArray arrayWithArray:[Favorite getOtherFavorite]];
    [self.tblFavorite reloadData];
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

- (IBAction)setCurrentDestinationAsFavorite:(id)sender
{
    
    if(!appDelegate().strToAddress)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AppBike"
                                                            message:@"Please select destination from left menu first."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Ok",nil];
        alertView.tag = 1001;
        [alertView show];
    }
    else
    {
        UIButton *btnPressed = (UIButton *)sender;
        NSDictionary *dictParam;
        
        if(btnPressed.tag == 101)
        {
            //Home
            dictParam = @{@"ishome" : @"yes",
                          @"latitude" : [NSString stringWithFormat:@"%f",appDelegate().toLocation.coordinate.latitude],
                          @"longitude" : [NSString stringWithFormat:@"%f",appDelegate().toLocation.coordinate.longitude],
                          @"title" : self.lblToAddress.text,
                          };
        }
        else
        {
            //other
            dictParam = @{@"ishome" : @"no",
                          @"latitude" : [NSString stringWithFormat:@"%f",appDelegate().toLocation.coordinate.latitude],
                          @"longitude" : [NSString stringWithFormat:@"%f",appDelegate().toLocation.coordinate.longitude],
                          @"title" : self.lblToAddress.text,
                          };
        }
        
        [Favorite addItemToFavorite:dictParam];
        [self reloadFavoriteData];
        if(btnPressed.tag == 101)
        {
            self.lblHomeAddress.text = self.lblToAddress.text;
        }
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.arrFavorites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ABFavoriteCell";
    
    ABFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ABFavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"star.png"];
    
    Favorite *thisFavorite = [self.arrFavorites objectAtIndex:indexPath.row];
    NSLog(@"Title : %@",thisFavorite.f_title);
    cell.lblTitle.text = thisFavorite.f_title;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tblFavorite deselectRowAtIndexPath:indexPath animated:YES];
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
