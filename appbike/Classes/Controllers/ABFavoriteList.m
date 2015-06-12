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
#import "SBJSON.h"
#import "Favorite+Utils.h"
#import "CoreData+MagicalRecord.h"
#import "NSArray+NullReplace.h"
#import "NSDictionary+NullReplace.h"

@interface ABFavoriteList ()
{
    IBOutlet ABBatteryInformation *statusBarView;
    int deleteIndex;
}

@property (nonatomic, strong) IBOutlet UITableView *tblFavorite;
@property (nonatomic, strong) NSMutableArray *arrFavorites;
@property (nonatomic, strong) IBOutlet UILabel *lblToAddress;
@property (nonatomic, strong) IBOutlet UILabel *lblHomeAddress;
@property (nonatomic, strong) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ABFavoriteList

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tblFavorite];
    
    NSIndexPath *indexPath = [self.tblFavorite indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        deleteIndex = indexPath.row;
        //add code here for when you hit delete
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AppAround"
                                                            message:@"Do you want to remove this favorite?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes",nil];
        alertView.tag = 1001;
        [alertView show];
        NSLog(@"long press on table view at row %d", indexPath.row);
    } else {
        NSLog(@"gestureRecognizer.state = %d", gestureRecognizer.state);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    lpgr.delegate = self;
    [self.tblFavorite addGestureRecognizer:lpgr];
    
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
    
    if(appDelegate().isSessionStart)
    {
        if(_timer)
            [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateBetteryData) userInfo:nil repeats:YES];
        [_timer fire];
    }
    
}

- (void)updateBetteryData
{
    
    NSLog(@"Updating bettery data");
    NSDictionary *dictParam = @{@"Autonomy" : [appDelegate().dictCurrentSessionData objectForKey:@"Autonomy"],
                                @"AutonomyDistance" : [appDelegate().dictCurrentSessionData objectForKey:@"AutonomyDistance"]};
    
    [statusBarView setBatteryLevel:appDelegate().dictCurrentSessionData];
}

- (void)saveJsonFile:(NSString *)strZone withDictionary:(NSDictionary *)dictZone
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, strZone];
    
    //NSString *filepath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",strZone] ofType:@""];
    
    
    //[[countValue JSONRepresentation] writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictZone
                                                       options:NSJSONWritingPrettyPrinted error:NULL];
    [jsonData writeToFile:filepath atomically:YES];
    
}


- (void)saveFavDataIntoJson
{
   
    
    
}



- (void)reloadFavoriteData
{
    NSMutableArray *arrHome = [NSMutableArray arrayWithArray:[Favorite getHomeFavorite]];
    //NSDictionary *dictHome = [[NSDictionary alloc] init];
    //NSDictionary *dictLocation = [[NSDictionary alloc] init];
    if(arrHome.count > 0)
    {
        Favorite *homeFavorite = [arrHome firstObject];
        self.lblHomeAddress.text = homeFavorite.f_title;
      //  dictLocation = @{@"latitude" : homeFavorite.f_latitude,
        //                 @"longitude" : homeFavorite.f_longitude
          //               };
    }
    else
    {
        self.lblHomeAddress.text = @"Not Added";
    }
    self.arrFavorites = [NSMutableArray arrayWithArray:[Favorite getOtherFavorite]];
    
    
    if(self.arrFavorites > 0)
    {
        NSArray *allFav = [NSArray arrayWithArray:[Favorite getAllFavoriteItems]];
        
        Favorite *thisFavorite;
        NSData *jsonData = [allFav MakeJsonStringFromArray:allFav Mangedobjectname:thisFavorite];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filepath = [NSString stringWithFormat:@"%@/favorites.json", documentsDirectory];
        
        [jsonData writeToFile:filepath atomically:YES];
        //NSMutableDictionary *jsonDictionary = [[NSMutableDictionary alloc] init];// = [NSMutableDictionary dictionaryWithObject:(NSArray *)allFav forKey:@"favorites"];
        
        
        
        //[self saveJsonFile:@"favorites.json" withDictionary:jsonDictionary];
        
      
    }
    
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
    
    Favorite *thisFavorite = [self.arrFavorites objectAtIndex:indexPath.row];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[thisFavorite.f_latitude floatValue] longitude:[thisFavorite.f_longitude floatValue]];
    appDelegate().toLocation = location;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DisplayNotification object:nil];
    NSLog(@"Set to location");
   
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return YES if you want the specified item to be editable.
//    return YES;
//}

- (void)deleteHistoryAtIndex:(int)index
{
    
    Favorite *thisSession = [self.arrFavorites objectAtIndex:index];
    //thisSession.
    [thisSession removeItemFromFavorite];
    [self.arrFavorites removeObjectAtIndex:index];
    [self.tblFavorite reloadData];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        deleteIndex = indexPath.row;
        //add code here for when you hit delete
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AppAround"
                                                            message:@"Do you want to remove this favorite?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes",nil];
        alertView.tag = 1001;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1 && alertView.tag == 1001)
    {
        [self deleteHistoryAtIndex:deleteIndex];
    }
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
