//
//  ApplicationData.m
//  StockModelSearch
//
//  Created by  Zaptech Solutions on 01/01/15.
//  Copyright (c) 2015 zaptech. All rights reserved.
//

#import "ApplicationData.h"
#import "MBProgressHUD.h"

static ApplicationData *applicationData = nil;

@implementation ApplicationData


- (id)init {
    if(self == [super init]) {
    }
    return self;
}

- (void)initialize {
    
}

+ (ApplicationData*)sharedInstance {
    if (applicationData == nil) {
        applicationData = [[super allocWithZone:NULL] init];
        [applicationData initialize];
    }
    return applicationData;
}

- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message{
    
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
}

@end
