//
//  AssistanceLevelView.m
//  appbike
//
//  Created by  Zaptech Solutions on 13/01/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import "AssistanceLevelView.h"
#import "AppDelegate.h"

@interface AssistanceLevelView ()

@property (nonatomic, strong) IBOutlet UIButton *btnPlus;
@property (nonatomic, strong) IBOutlet UIButton *btnMinus;
@property (nonatomic, strong) IBOutlet UILabel *lblAssistanceLevel;
@property (nonatomic, strong) IBOutlet UIImageView *imgRate;

@end

@implementation AssistanceLevelView
{
    NSInteger count;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        count = appDelegate().assitantLevelCount;
    }
    return self;
}

//------------------------------------------------------------------

#pragma mark
#pragma mark Action Methods

//------------------------------------------------------------------

-(IBAction)btnPlusMinusClicked:(id)sender{
    
    if([sender tag]==2)
    {
        if (count < 10)
        {
            count++;
        }
    }
    else
    {
        if (count > 1)
        {
            count--;
        }
    }
    appDelegate().assitantLevelCount = count;
    NSString *strImage = [NSString stringWithFormat:@"aasistance_level_%d",count];
    NSLog(@"Image name is  :%@",strImage);
    
   // [self.imgRate setImage:[UIImage imageNamed:[NSString stringWithFormat:@"￼aasistance_level_%ld.png",(long)count]]];
    [self.imgRate setImage:[UIImage imageNamed:strImage]];
}

- (void)UpdateCurrentAssitanceLevel
{
    count = appDelegate().assitantLevelCount;
    NSString *strImage = [NSString stringWithFormat:@"aasistance_level_%d",count];
    NSLog(@"Image name is  :%@",strImage);
    
    // [self.imgRate setImage:[UIImage imageNamed:[NSString stringWithFormat:@"￼aasistance_level_%ld.png",(long)count]]];
    [self.imgRate setImage:[UIImage imageNamed:strImage]];
}

@end
