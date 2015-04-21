//
//  ABDiagnosticVC.m
//  appbike
//
//  Created by Ashwin Jumani on 4/10/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "ABDiagnosticVC.h"

@interface ABDiagnosticVC ()

@property (nonatomic,strong) IBOutlet UIImageView *imgBike;
@property (nonatomic,strong) IBOutlet UIButton *btn1;
@property (nonatomic,strong) IBOutlet UIButton *btn2;
@property (nonatomic,strong) IBOutlet UIButton *btn3;
@property (nonatomic,strong) IBOutlet UIButton *btn4;
@property (nonatomic,strong) IBOutlet UILabel *lblTitle;
@property (nonatomic,strong) IBOutlet UITextView *tvDescription;

@end

@implementation ABDiagnosticVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
