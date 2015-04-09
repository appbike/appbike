//
//  ApplicationData.h
//  StockModelSearch
//
//  Created by  Zaptech Solutions on 01/01/15.
//  Copyright (c) 2015 zaptech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGB(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kBlueThemeColor RGB(79,166,240) //Hex code : 4FA6F0

@interface ApplicationData : NSObject

+ (ApplicationData *)sharedInstance;

- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message;

@end
