//
//  DashBoardViewController.h
//  Apparound
//
//  Created by  Zaptech Solutions on 09/01/15.
//  Copyright (c) 2015 zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "GPSLocation.h"
#import "BleManager.h"
#import "ConstantList.h"
#import "REFrostedViewController.h"
#import "XYPieChart.h"

@class SPGooglePlacesAutocompleteQuery;

@interface ABDashBoardVC : UIViewController<UIGestureRecognizerDelegate,GPSLocationDelegate,UIPageViewControllerDelegate,CLLocationManagerDelegate,BleManagerDelegate,UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate,XYPieChartDelegate, XYPieChartDataSource>
{
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
    
    BOOL shouldBeginEditing;
}

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic) SelectedSensorType currentSelectedSensorType;
@property (nonatomic) BOOL isDisplayDestination;

- (IBAction)showLeftMenu:(id)sender;
- (void)showDestination;


@end
