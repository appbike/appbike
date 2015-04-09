//
//  BikesConnectionViewController.m
//  appbike
//
//  Created by Sviluppatore Mobile on 11/03/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "BikesConnectionViewController.h"
#import "BleManager.h"
#import "ABDashBoardVC.h"
#import  "AppDelegate.h"


@interface BikesConnectionViewController () <UIWebViewDelegate, BleManagerDelegate, BleDeviceViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) BleManager *bleManager;

@property (nonatomic,strong) NSArray *bleSupportedDevicesFounded;

@property (nonatomic,strong) BleDevicesView *bikesView;

@property (nonatomic,strong) NSString *enableKeyCode;


@end


@implementation BikesConnectionViewController

@synthesize webView=_webView;
@synthesize piaggioLogo=_piaggioLogo;
@synthesize bleManager = _bleManager;
@synthesize bikesView=_bikesView;
@synthesize bikeIdSelected=_bikeIdSelected;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self.view setBackgroundColor:[BikesConnectionViewController getBackgroundColor]];
    }
    
    return self;
}

+(UIColor*)getBackgroundColor{
    CGFloat red = 20.0f / 255.0f;
    
    CGFloat green = 33.0f / 255.0f;
    
    CGFloat blue = 49.0f  / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:0.6f];
}


#pragma mark - web view getter


-(UIWebView*)webView{
    if(!_webView){
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
                
        [_webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
        [_webView setUserInteractionEnabled:YES];
        
        _webView.delegate = self;
    }
    
    return _webView;
}



#pragma mark - piaggio logo getter

-(UIImageView*)piaggioLogo{
    if(!_piaggioLogo){
        _piaggioLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BikesConnectionViewController_PIAGGIO_LOGO]];
        
        [_piaggioLogo setFrame:[self frameForLogo]];
    }
    
    return _piaggioLogo;
}


#pragma mark - help label getter

-(UILabel*)helpLabel{
    if(!_helpLabel){
        _helpLabel = [[UILabel alloc] initWithFrame:[self frameForHelpLabel]];
        
        [_helpLabel setTextColor:[UIColor whiteColor]];
        
        [_helpLabel setHighlighted:YES];
        
        [_helpLabel setText:BikesConnectionViewController_LABEL_TEXT];
    }
    
    return _helpLabel;
}


#pragma mark - ble manager getter


-(BleManager*)bleManager{
    if(!_bleManager){
        _bleManager = [[BleManager alloc] init];
        
        _bleManager.delegate = self;
    }
    
    return _bleManager;
}


#pragma mark - bikes view getter

-(BleDevicesView*)bikesView{
    if(!_bikesView){
        
        _bikesView = [[BleDevicesView alloc] init];
        
        [_bikesView setFrame:[self frameForBleDevicesView]];
        
        [_bikesView.layer setBorderWidth:1.0];
        
        //Register view controller as delegate of bikes view to get callbacks
        
        _bikesView.delegate = self;
        
        [_bikesView setBackgroundColor:[BleDevicesView getBluetoothBikesViewColor]];

    }
    
    return _bikesView;

}


#pragma mark - bike selected

-(NSString*)bikeIdSelected{
    if(!_bikeIdSelected){
        _bikeIdSelected = [[NSString alloc] init];
    }
    
    return _bikeIdSelected;
}


#pragma mark - frames


-(CGRect)frameForLogo{
    CGPoint origin;
    
    CGSize size = self.view.bounds.size;
    
    CGSize imageSize = [[UIImage imageNamed:BikesConnectionViewController_PIAGGIO_LOGO] size];
    
    origin.x = size.width - imageSize.width/2;
    origin.y = BikesConnectionViewController_PADDING_FROM_TOP;
    
    return CGRectMake(origin.x,origin.y,imageSize.width/2,imageSize.height/2);
}


-(CGRect)frameForHelpLabel{
    
    CGPoint origin;
    
    CGSize size = self.view.bounds.size;
    
    origin.x+= BikesConnectionViewController_PADDING_HORIZONTAL;
    
    origin.y = self.piaggioLogo.frame.size.height;
    
    
    size.width -= (BikesConnectionViewController_PADDING_HORIZONTAL *2 );
    
    size.height = BikesConnectionViewController_LABEL_HEIGHT;

    return CGRectMake(origin.x,origin.y,size.width,size.height);
}


-(CGRect)frameForBleDevicesView{
    CGPoint origin;
    
    CGSize size;
    
    CGFloat distanceFromHelpLabel = 5.0f;
    
    origin.x = BleDevicesView_HORIZONTAL_PADDING;
    origin.y = self.helpLabel.frame.origin.y + self.helpLabel.frame.size.height + distanceFromHelpLabel; //Add a bit of padding
    
    size.height = self.view.frame.size.height - origin.y - BleDevicesView_PADDING_FROM_BOTTOM;

    size.width = self.view.frame.size.width - (BleDevicesView_HORIZONTAL_PADDING * 2);
    
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}



#pragma mark - web view delegate methods

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    //Check protocol registered
    
    if([request.URL.scheme isEqualToString:BikesConnectionViewController_LICENSE_PROTOCOL]){ 
        
        //Check which button has been tapped
        
        if([[request.URL host] isEqualToString:BikesConnectionViewController_LICENSE_ACCEPTED]){
            
                //Go to scan for device screen
            
            [self beginBluetoothBikesScan];
        }
        
        else{
            
            //Get the path and open license screeen directly in web view
            
            NSString *urlPath = [request.URL path];
            
            NSURL *licenseOnWebSiteURL = [NSURL URLWithString:urlPath];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:licenseOnWebSiteURL];
            
            [self.webView loadRequest:request];
    
        }
    
    }


    return TRUE;
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error during loading" message:@"An error has been occured during loading of web content"  delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    
    [errorView show];
}



#pragma mark - scan for device screen


-(void)beginBluetoothBikesScan{
    
    //Remove previous view added to controller's view
    
    [self.webView removeFromSuperview];
    
    self.webView.delegate = nil;
    
    
    [self.view addSubview:self.piaggioLogo];
    
    [self.view addSubview:self.helpLabel];
    
    
    //Create view for bluetooth devices scan status
    
    [self.view addSubview:self.bikesView];
    

    //Must perform following instructions on main thread
    
    if(![NSThread isMainThread]){
        
        [self.bleManager startScanForBleDevices];

    }
    
    else{
        
        [self.bleManager performSelectorInBackground:@selector(startScanForBleDevices) withObject:nil];
    }
    
    
}


#pragma mark - ble manager delegate methods


//Library returns array of bluetooth supported bikes founded during scan

-(void)BleManagerDelegate:(BleManager *)bleManager onSupportedBleDevicesFounded:(NSArray *)devices{
    
    if([devices count] == 0){
        
        [self.bikesView performSelectorOnMainThread:@selector(insertBikeWithId:) withObject:[BleDevicesView_SCAN_STATUS objectAtIndex:2] waitUntilDone:YES]; //One only row with custom message
        
    }
    
    else{
    
        self.bleSupportedDevicesFounded = [[NSArray alloc] initWithArray:devices];
        
        for(NSUInteger index = 0; index < [self.bleSupportedDevicesFounded count]; index++){
            
            //Insert every bluetooth bikes found in ble view and show it in a table
            
            [self.bikesView performSelectorOnMainThread:@selector(insertBikeWithId:) withObject:[self.bleSupportedDevicesFounded objectAtIndex:index] waitUntilDone:YES];
            
            sleep(2);
        }

    
    }
    
    //Stop animating and update progress label
    
    [self.bikesView stopDiscoveringAnimation];
    
    if(devices && [devices count] > 0){
    
        [self.bikesView updateProgressLabelWithValue:[BleDevicesView_SCAN_STATUS objectAtIndex:1]];
    }
    
    else{
    
        [self.bikesView updateProgressLabelWithValue:[BleDevicesView_SCAN_STATUS objectAtIndex:2]];
    }
    
    
}


//Invoked when a bluetooth device has been connected
-(void)BleManagerDelegate:(BleManager *)bleManager onBleDeviceConnectedWithStatus:(BOOL)status andCode:(NSString *)enableKey{
    
    if(status){
        
        //Go to dashboard
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"AppBike" bundle:nil];
        
        ABDashBoardVC *viewController = (ABDashBoardVC *)[storyBoard instantiateViewControllerWithIdentifier:@"DashBoardViewController"];
        
        
        self.bleManager.delegate = nil;
        
        self.bleManager.delegate = viewController;
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] init];
        
        SWRevealViewController *menuSlider = [[AppDelegate sharedInstance] menuSlider];
        
        [menuSlider setFrontViewController:navigationController];
        
        [[[AppDelegate sharedInstance] window] setRootViewController:menuSlider];
        
        [navigationController pushViewController:viewController animated:YES];
        
    }
    
}



#pragma mark - ble devices view delegate


-(void)BleDevicesView:(BleDevicesView*)bleDevicesView onSelectedBluetoothBikeWithIndex:(NSUInteger)index{
    
    NSString *bikeId = [self.bleSupportedDevicesFounded objectAtIndex:index];

    self.bikeIdSelected = bikeId; //Save for future uses
}


-(void)BleDeviceView:(BleDevicesView *)bleDevicesView onEnableKeyCodeInsertedWithValue:(NSString *)enableKeyValue{
    
    [self.bikesView updateProgressLabelWithValue:@"Connecting"];
    
    [self.bikesView.activityIndicator startAnimating];
    
    sleep(2);
    
    [self.bleManager connectToDeviceWithId:self.bikeIdSelected andEnableKeyCode:enableKeyValue];
    
}


#pragma mark - view management

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   [self.view addSubview:self.webView];
    
    //Load html content inside web view to show terms and condition first time
    
    NSURL *htmlURL = [NSURL fileURLWithPath:
                      [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
    
    NSURLRequest *ContentRequest = [NSURLRequest requestWithURL:htmlURL];
    
    [self.webView loadRequest:ContentRequest];
    
}


@end



@interface BleDevicesView () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@property (nonatomic,strong) UILabel *progressLabel;

@property (nonatomic,strong) UITableView *bikesTableView;

@property (nonatomic,strong) UITextField *codeField;

@property (nonatomic,strong) UIButton *connectButton;


@end


@implementation BleDevicesView

@synthesize activityIndicator=_activityIndicator;
@synthesize bikes=_bikes;
@synthesize progressLabel=_progressLabel;
@synthesize bikesTableView=_bikesTableView;
@synthesize codeField=_codeField;
@synthesize connectButton=_connectButton;


#pragma mark - activity indicator


-(UIActivityIndicatorView*)activityIndicator{
    if(!_activityIndicator){
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [_activityIndicator startAnimating];
    
    }
    
    return _activityIndicator;
}


#pragma mark - progress label setter

-(UILabel*)progressLabel{
    if(!_progressLabel){
        _progressLabel=[[UILabel alloc] init];
        
        [_progressLabel setTextColor:[UIColor whiteColor]];
        
        [_progressLabel setText:[BleDevicesView_SCAN_STATUS objectAtIndex:0]];
    }

    return _progressLabel;
}


#pragma mark - devices table view

//Will contain discovered bluetooth devices

-(UITableView*)bikesTableView{
    if(!_bikesTableView){
        _bikesTableView = [[UITableView alloc] initWithFrame:[self frameForBikesTableView] style:UITableViewStylePlain];
        
        _bikesTableView.delegate = self;
        _bikesTableView.dataSource = self;
        
        [_bikesTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        //First time start activity indicator
    
        [self.activityIndicator startAnimating];
        
        [_bikesTableView setBackgroundColor:[UIColor clearColor]];
        
        [_bikesTableView setSeparatorInset:UIEdgeInsetsZero];
        
        
        [_bikesTableView setSeparatorColor:[UIColor clearColor]];
        
        
    }
    
    return _bikesTableView;
}


#pragma mark - bikes array getter

-(NSMutableArray*)bikes{
    if(!_bikes){
        _bikes = [[NSMutableArray alloc] init];
    }
    
    return _bikes;
}


#pragma mark - code field getter


-(UITextField*)codeField{

    if(!_codeField){
        
        _codeField = [[UITextField alloc] initWithFrame:[self frameForCodeField]];
        [_codeField setPlaceholder:NSLocalizedString(BleDevicesView_INSERT_CODE_STRING,@"")];
        [_codeField setTextAlignment:NSTextAlignmentCenter];

        [_codeField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(BleDevicesView_INSERT_CODE_STRING,@"") attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} ]];
        
        [_codeField setTextColor:[UIColor whiteColor]];
        
        [_codeField setBackgroundColor:[UIColor clearColor]];
        [_codeField.layer setBorderWidth:1.0f];
        [_codeField.layer setBorderColor:[BleDevicesView getBackgroundCellColor].CGColor];
        
        //Set delegate to dismiss keyboard
        [_codeField setDelegate:self];

    }
    
    return _codeField;
}


#pragma mark - connect button

-(UIButton*)connectButton{
    if(!_connectButton){
        _connectButton = [[UIButton alloc] initWithFrame:[self frameForConnectButton]];
        
        [_connectButton setBackgroundColor:[BleDevicesView getBackgroundCellColor]];
        
        [_connectButton setTitle:NSLocalizedString(BleDevicesView_CONNECT_STRING, @"") forState:UIControlStateNormal];
        
        [_connectButton setTitleColor:[BleDevicesView getCellTextColor] forState:UIControlStateNormal];
     
        [_connectButton addTarget:self action:@selector(tapOnConnectButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_connectButton setUserInteractionEnabled:YES];
    }
    
    
    return _connectButton;
}


-(void)tapOnConnectButton{
    
    //Get code inserted by user and send it to piaggio bike
    
    NSString *enableKeyCode = [self.codeField text];
    
    if(enableKeyCode && [enableKeyCode length] > 1){
        
        [self updateFrameForProgressLabelAndActivityIndicator];
        
        //Notify to delegate tap on button
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(BleDeviceView:onEnableKeyCodeInsertedWithValue:)]){
            
            [self.delegate BleDeviceView:self onEnableKeyCodeInsertedWithValue:enableKeyCode];
        }
        
    }
}


#pragma mark - frames


-(CGRect)frameForActivityIndicator{
    
    CGPoint origin;
    
    origin.y = self.progressLabel.frame.origin.y - BleDevicesView_ACTIVITY_INDICATOR_HEIGHT - 5.0;
    
    origin.x = self.frame.size.width/2 - BleDevicesView_ACITIVITY_INDICATOR_WIDTH/2;
    
    return CGRectMake(origin.x, origin.y, BleDevicesView_ACITIVITY_INDICATOR_WIDTH, BleDevicesView_ACTIVITY_INDICATOR_HEIGHT);
}


-(CGRect)frameForProgressLabel{
    CGPoint origin;
    
    origin.x = self.frame.origin.x + BleDevicesView_HORIZONTAL_PADDING;
    origin.y = self.frame.size.height - BleDevicesView_PROGRESS_LABEL_HEIGHT - BleDevicesView_PADDING_FROM_BOTTOM;
    
    CGFloat width = self.frame.size.width - (BleDevicesView_HORIZONTAL_PADDING * 2);
    
    return CGRectMake(origin.x, origin.y, width, BleDevicesView_PROGRESS_LABEL_HEIGHT);
}


-(CGRect)frameForBikesTableView{
    
    CGSize size;
    
    size.width = self.bounds.size.width - (BleDevicesView_HORIZONTAL_PADDING *2);
    size.height = self.frame.size.height - BleDevicesView_PADDING_FROM_BOTTOM - BleDevicesView_PROGRESS_LABEL_HEIGHT - BleDevicesView_ACTIVITY_INDICATOR_HEIGHT - 10.0;

    CGPoint origin = self.bounds.origin;
    
    origin.x = self.bounds.origin.x + self.bounds.size.width / 2 - size.width/2 ;
    origin.y +=  BleDevicesView_PADDING_FROM_TOP;
    
    
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}


-(CGRect)frameForCodeField{
    
    CGPoint origin;
    CGSize size;
    
    origin.x = self.bikesTableView.frame.origin.x;
    origin.y = self.bikesTableView.frame.origin.y + self.bikesTableView.frame.size.height + 15.0f; //Padding from table view
    
    size.width = self.bikesTableView.frame.size.width;
    size.height = BleDevicesVew_CELLS_HEIGHT;
    
    return CGRectMake(origin.x, origin.y, size.width, size.height);

}

-(CGRect)frameForConnectButton{
    CGPoint origin;
    CGSize size;

    
    origin.x = self.codeField.frame.origin.x;

    origin.y = self.codeField.frame.origin.y + self.codeField.frame.size.height + 20.0f; //Padding from code field
    
    size.width = self.codeField.frame.size.width;
    size.height = self.codeField.frame.size.height;
    
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

#pragma mark - DELEGATES

#pragma mark - delegate table view implementation


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return BleDevicesVew_CELLS_HEIGHT;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:NO animated:YES];
        
    
    //Delete unselected rows
    
    NSUInteger selectedRow = [indexPath row];
    
    for(NSInteger index = self.bikes.count-1; index >= 0 ; index--){
        if(index != selectedRow)
            [self.bikes removeObjectAtIndex:index];
    }
    
    [tableView reloadData];
    

    //Check if activity indicator is in progress, if yes stop it
    
    if([self.activityIndicator isAnimating]){
        [self.activityIndicator stopAnimating];
    }
    
    //Change aspect of cell
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    
    [self updateViewAfterTapOnBike];
    
    
    //Notify selection to delegate
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(BleDevicesView:onSelectedBluetoothBikeWithIndex:)]){
    
        [self.delegate BleDevicesView:self onSelectedBluetoothBikeWithIndex:selectedRow];
    }
}


#pragma mark - datasource table view implementation


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BleDeviceView_CELL_ID ];
    
    if(! cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BleDeviceView_CELL_ID];
    }
    
    NSInteger index = indexPath.row;
    
    if([self.bikes count] > index){
    
        [cell.textLabel setText:[self.bikes objectAtIndex:index]];
        
        [cell.textLabel setTextColor:[BleDevicesView getCellTextColor]];

    }
    
    [cell setBackgroundColor:[BleDevicesView getBackgroundCellColor]];

    
    //Check if bikes array contain message for no bikes found
    
    if([self.bikes count] == 1 && [[self.bikes objectAtIndex:0] isEqualToString:[BleDevicesView_SCAN_STATUS objectAtIndex:2]]){
        
        [cell.textLabel setText:[BleDevicesView_SCAN_STATUS objectAtIndex:2]];
        [cell.textLabel setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:14.0f]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        
        [cell.detailTextLabel setText:[BleDevicesView_SCAN_STATUS objectAtIndex:3]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:10.0f]];
        [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    }
    

    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([self.bikes count] > 0){
        return [self.bikes count];
    }
    
    else{
        return 0; //Begin with empty bikes table view
    }
}



#pragma mark - interface methods


//Insert a new bike element in table view
-(void)insertBikeWithId:(NSString *)bikeId{
    
    NSInteger newSectionIndex = [self.bikes count];
    
    [self.bikes insertObject:bikeId atIndex:newSectionIndex];
    
    NSIndexPath *newRowIndexPath = [NSIndexPath indexPathForRow:newSectionIndex inSection:0];
    
    [self.bikesTableView beginUpdates];
    
    [self.bikesTableView insertRowsAtIndexPaths:@[newRowIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.bikesTableView endUpdates];
    
}

#pragma mark - text field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - instance methods


-(void)stopDiscoveringAnimation{

    [self.activityIndicator stopAnimating];
}


-(void)updateProgressLabelWithValue:(NSString *)value{
    [self.progressLabel setText:value];
}



#pragma mark - update frames depending by user interaction


-(void)updateViewAfterTapOnBike{
    
    NSArray *indexPaths = [self.bikesTableView indexPathsForVisibleRows];
    
    UITableViewCell *cell = [self.bikesTableView cellForRowAtIndexPath:[indexPaths objectAtIndex:0] ];
    
    [cell setUserInteractionEnabled:NO];
    
    CGRect cellFrame = [cell frame];
    
    CGRect tableViewNewFrame;
    
    tableViewNewFrame.origin.x = self.bounds.origin.x + BleDevicesView_HORIZONTAL_PADDING;
    tableViewNewFrame.origin.y = self.bounds.origin.y + BleDevicesView_PADDING_FROM_TOP;

    tableViewNewFrame.size.width = cellFrame.size.width;
    tableViewNewFrame.size.height = cellFrame.size.height;
    
    [self.bikesTableView setFrame:tableViewNewFrame];
    
    
    //Add text field for enable key code and relative button
    
    [self addSubview:self.codeField];
    
    [self addSubview:self.connectButton];

    //Temporarily hide progress label and progress indicator
    [self.progressLabel setHidden:YES];
    
}

-(void)updateFrameForProgressLabelAndActivityIndicator{

    if(![[NSThread currentThread] isMainThread]){
        
        return [self performSelectorOnMainThread:@selector(updateFrameForProgressLabelAndActivityIndicator) withObject:nil waitUntilDone:YES];
    }
    

    [self.connectButton removeFromSuperview];
    
    
    [self.progressLabel setHidden:NO];
    [self.activityIndicator setHidden:NO];
    
    CGPoint origin;
    CGSize size;
    
    origin.x = self.bounds.size.width/2 - BleDevicesView_ACITIVITY_INDICATOR_WIDTH/2;
    origin.y = self.bounds.origin.y + self.codeField.frame.origin.y + self.codeField.frame.size.height; //Padding between activity indicator and
    
    size.width = BleDevicesView_ACITIVITY_INDICATOR_WIDTH;
    size.height = BleDevicesView_ACTIVITY_INDICATOR_HEIGHT;
    
    CGRect activityIndicatorFrame = CGRectMake(origin.x, origin.y, size.width, size.height);
    
    [self.activityIndicator setFrame:activityIndicatorFrame];
    
    
    //Update frame also for progress label
    
    origin.x = self.bounds.size.width/2 - BleDevicesView_PROGRESS_LABEL_WIDTH/2;
    origin.y = self.activityIndicator.frame.origin.y + self.activityIndicator.frame.size.height;
    
    size.width = BleDevicesView_PROGRESS_LABEL_WIDTH;
    size.height = BleDevicesView_PROGRESS_LABEL_HEIGHT;
    
    CGRect frameForProgressLabel = CGRectMake(origin.x, origin.y, size.width, size.height);
    
    [self.progressLabel setFrame:frameForProgressLabel];
}


#pragma mark - manage subviews

-(void)layoutSubviews{

    [super layoutSubviews];
    
    //Indicators for progress
    
    
    [self addSubview:self.progressLabel];
    
    [self.progressLabel setFrame:[self frameForProgressLabel]];
    
    
    [self addSubview:self.activityIndicator];
    
    [self.activityIndicator setFrame:[self frameForActivityIndicator]];
    
    
    //In table view ble bike will be shown
    
    [self addSubview:self.bikesTableView];
}


#pragma mark - colors


+(UIColor*)getBluetoothBikesViewColor{
    CGFloat red = 74.0f / 255.0f;
    CGFloat green = 86.0f / 255.0f;
    CGFloat blue = 100.0f / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:0.5f];
}


+(UIColor*)getBackgroundCellColor{
    
    CGFloat red = 63.0f / 255.0f;
    CGFloat green = 121.0f / 255.0f;
    CGFloat blue = 190.0f / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}


+(UIColor*)getCellTextColor{
    
    return [UIColor colorWithRed:37.0f/255.0f green:67.0f/255.0f blue:104.0f/255.0f alpha:1.0f];

}

@end