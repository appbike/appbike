//
//  ABFavoriteList.h
//  appbike
//
//  Created by Ashwin Jumani on 4/15/15.
//  Copyright (c) 2015 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import <CoreData/CoreData.h>

@interface ABFavoriteList : UIViewController

- (NSDictionary*)dataStructureFromManagedObject:(NSManagedObject*)managedObject;
@end
