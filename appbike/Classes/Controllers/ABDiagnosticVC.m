//
//  ABDiagnosticVC.m
//  appbike
//
//  Created by Ashwin Jumani on 4/10/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABDiagnosticVC.h"
#import "SAMultisectorControl.h"
#import "AppDelegate.h"
@interface ABDiagnosticVC ()

@property (nonatomic,strong) IBOutlet UIImageView *imgBike;
@property (nonatomic,strong) IBOutlet UIButton *btn1;
@property (nonatomic,strong) IBOutlet UIButton *btn2;
@property (nonatomic,strong) IBOutlet UIButton *btn3;
@property (nonatomic,strong) IBOutlet UIButton *btn4;

@property (nonatomic,strong) IBOutlet UIButton *btnc1;
@property (nonatomic,strong) IBOutlet UIButton *btnc2;
@property (nonatomic,strong) IBOutlet UIButton *btnc3;
@property (nonatomic,strong) IBOutlet UIButton *btnc4;

@property (nonatomic,strong) IBOutlet UILabel *lblTitle;
@property (nonatomic,strong) IBOutlet UITextView *tvDescription;
@property (weak, nonatomic) IBOutlet SAMultisectorControl *multisectorControl;

@end

@implementation ABDiagnosticVC


- (void)setupMultiSelectorControl
{
    
    [self.multisectorControl removeAllSectors];
    
    [self.multisectorControl addTarget:self action:@selector(multisectorValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    UIColor *greenColor = [UIColor colorWithRed:42.0/255.0 green:133.0/255.0 blue:202/255.0 alpha:1.0];
    
    
    SAMultisectorSector *sector3 = [SAMultisectorSector sectorWithColor:greenColor maxValue:100.0];
    
    sector3.tag = 2;
    
    sector3.startValue = [[appDelegate().dictKMHData objectForKey:@"min"] doubleValue];
    sector3.endValue = [[appDelegate().dictKMHData objectForKey:@"max"] doubleValue];;
    sector3.currValue = 50.0;
    
   // minValue = sector3.startValue;
    //maxValue = sector3.endValue;
    
    
    //self.setSpeedlblDistance.text = [NSString stringWithFormat:@"%.0f / %.0f",sector3.startValue,sector3.endValue];
    
    //[self.multisectorControl addSubview:self.imgBgSetSpeed];
    [self.multisectorControl addSector:sector3];
}

- (void)multisectorValueChanged:(id)sender
{
    [self updateDataView];
}

- (void)updateDataView
{
    for(SAMultisectorSector *sector in self.multisectorControl.sectors){
        
        NSString *startValue = [NSString stringWithFormat:@"%.0f", sector.startValue];
        NSString *endValue = [NSString stringWithFormat:@"%.0f", sector.endValue];
        
       // minValue = sector.startValue;
        //maxValue = sector.endValue;
        //self.setSpeedlblDistance.text = [NSString stringWithFormat:@"%@ / %@",startValue,endValue];
        
        //[self.multisectorControl sendSubviewToBack:self.imgBgSetSpeed];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self setupMultiSelectorControl];
    
    if(IS_IPHONE_6_PLUS)
    {
        self.imgBike.frame = CGRectMake(self.imgBike.frame.origin.x, self.imgBike.frame.origin.y, 400, self.imgBike.frame.size.height);
        
        self.btnc1.frame = CGRectMake(self.btnc1.frame.origin.x+30, self.btnc1.frame.origin.y, self.btnc1.frame.size.width, self.btnc1.frame.size.height);
        self.btnc2.frame = CGRectMake(self.btnc2.frame.origin.x+40, self.btnc2.frame.origin.y, self.btnc2.frame.size.width, self.btnc2.frame.size.height);
        self.btnc3.frame = CGRectMake(self.btnc3.frame.origin.x+60, self.btnc3.frame.origin.y, self.btnc3.frame.size.width, self.btnc3.frame.size.height);
        self.btnc4.frame = CGRectMake(self.btnc4.frame.origin.x+70, self.btnc4.frame.origin.y, self.btnc4.frame.size.width, self.btnc4.frame.size.height);
    }
    else if(IS_IPHONE_6)
    {
        self.imgBike.frame = CGRectMake(self.imgBike.frame.origin.x, self.imgBike.frame.origin.y, 365, self.imgBike.frame.size.height);
        self.btnc2.frame = CGRectMake(self.btnc2.frame.origin.x+30, self.btnc2.frame.origin.y, self.btnc2.frame.size.width, self.btnc2.frame.size.height);
        self.btnc3.frame = CGRectMake(self.btnc3.frame.origin.x+40, self.btnc3.frame.origin.y, self.btnc3.frame.size.width, self.btnc3.frame.size.height);
        self.btnc4.frame = CGRectMake(self.btnc4.frame.origin.x+50, self.btnc4.frame.origin.y, self.btnc4.frame.size.width, self.btnc4.frame.size.height);
        
    }
    
//    self.btnc1.backgroundColor = [UIColor redColor];
//    self.btnc2.backgroundColor = [UIColor redColor];
//    self.btnc3.backgroundColor = [UIColor redColor];
//    self.btnc4.backgroundColor = [UIColor redColor];
    
}

- (IBAction)displayPartDetail:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    self.imgBike.image = [UIImage imageNamed:[NSString stringWithFormat:@"bike_selected%d.png",btnPressed.tag]];
    switch (btnPressed.tag)
    {
        case 1:
        {
            self.btn1.selected = YES;
            self.btn2.selected = NO;
            self.btn3.selected = NO;
            self.btn4.selected = NO;
            self.lblTitle.text = self.btn1.titleLabel.text;
            
        }
            break;
        case 2:
        {
            self.btn1.selected = NO;
            self.btn2.selected = YES;
            self.btn3.selected = NO;
            self.btn4.selected = NO;
            self.lblTitle.text = self.btn2.titleLabel.text;
        }
            break;
        case 3:
        {
            self.btn1.selected = NO;
            self.btn2.selected = NO;
            self.btn3.selected = YES;
            self.btn4.selected = NO;
            self.lblTitle.text = self.btn3.titleLabel.text;
        }
            break;
        case 4:
        {
            self.btn1.selected = NO;
            self.btn2.selected = NO;
            self.btn3.selected = NO;
            self.btn4.selected = YES;
            self.lblTitle.text = self.btn4.titleLabel.text;
        }
            break;
            
        default:
            break;
    }
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
