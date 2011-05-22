//
//  MainViewController.h
//  locations1
//
//  Created by Joe Zuntz on 12/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "L1MapViewController.h"
#import "L1Scenario.h"
#import "L1ScenarioChooserViewController.h"


@interface MainViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate> {
    
    IBOutlet MKMapView *primaryMapView;
    IBOutlet UIPickerView *pathSelectionView;
    IBOutlet UIWebView *mediaView;
    IBOutlet L1MapViewController *mapViewController;
    L1ScenarioChooserViewController *chooserViewController;
    L1Scenario *scenario;
    NSString * baseURL;
    IBOutlet UITextView *titleText;
    IBOutlet UITextView *descriptionText;
    
}

@property (retain) NSString * baseURL;
@property (retain) L1Scenario *scenario;
@property (retain) L1ScenarioChooserViewController *chooserViewController;

-(void) presentChooserView;
@end
