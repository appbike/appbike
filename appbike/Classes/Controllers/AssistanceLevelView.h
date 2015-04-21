//
//  AssistanceLevelView.h
//  appbike
//
//  Created by  Zaptech Solutions on 13/01/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssistanceLevelView : UIView

@property (nonatomic, strong) IBOutlet UIButton *btnTop;
@property (nonatomic, strong) IBOutlet UIImageView *imgBottomView;

-(IBAction)btnPlusMinusClicked:(id)sender;

- (void)UpdateCurrentAssitanceLevel;


@end
