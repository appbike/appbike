//
//  ABHistoryCell.h
//  appbike
//
//  Created by Ashwin Jumani on 4/18/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABHistoryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIButton *btnKM;
@property (nonatomic, strong) IBOutlet UIButton *btnMin;
@property (nonatomic, strong) IBOutlet UIButton *btnCal;
@property (nonatomic, strong) IBOutlet UIButton *btnShare;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;

@end
