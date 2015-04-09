//
//  GLPlacesAutoCompleteVC.h
//  GPS Latino
//
//  Created by Created by  Zaptech Solutions on 10/9/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import "SPGooglePlacesAutocompleteQuery.h"

@class SPGooglePlacesAutocompleteQuery;

@interface ABLocationAutoCompleteVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
    
    BOOL shouldBeginEditing;
}

//@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) BOOL isFrom;

@end
