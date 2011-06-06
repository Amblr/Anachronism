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
#import "MediaListViewController.h"

@interface MainViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate> {
    
    IBOutlet MKMapView *primaryMapView;
//    IBOutlet UIPickerView *pathSelectionView;
    IBOutlet UIWebView *mediaView;
    IBOutlet UIWebView *streetView;
    IBOutlet UITableView *mediaSelectionView;
    IBOutlet L1MapViewController *mapViewController;
    IBOutlet MediaListViewController * mediaListViewController;
    
    CGRect bottomLeftRect;
    CGRect rightRect;

    L1ScenarioChooserViewController *chooserViewController;
    L1Scenario *scenario;
    NSString * baseURL;
    
    L1Node * activeNode;
    L1Path * activePath;
    
}
@property (retain) L1Node * activeNode;
@property (retain) L1Path * activePath;

@property (retain) NSString * baseURL;
@property (retain) L1Scenario *scenario;
@property (retain) L1ScenarioChooserViewController *chooserViewController;

-(IBAction) swapViews;
-(IBAction) overlay;

- (IBAction)walkPath:(id)sender;
-(void) presentChooserView;
-(void) didSelectNode:(L1Node*) node;
-(void) triggeredNode:(L1Node*) node;
-(void) setStreetViewLocationLat:(CLLocationDegrees) lat lon:(CLLocationDegrees) lon;
-(IBAction) previousButton;
-(IBAction) nextButton;


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
