//
//  L1MapViewController.h
//  locations1
//
//  Created by Joe Zuntz on 16/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "L1NodeContentViewController.h"
#import "L1Scenario.h"

@interface L1MapViewController : UIViewController<MKMapViewDelegate> {
	NSMutableDictionary * annotationImages;
	IBOutlet MKMapView * primaryMapView;
	IBOutlet L1NodeContentViewController * nodeContentViewController;
	L1Scenario * scenario;
	
}

@property (retain) L1Scenario * scenario;
@property (retain) L1NodeContentViewController * nodeContentViewController;
-(IBAction) testPolygon:(id) sender;
-(void) testMap:(id) sender;
-(void) nodeSource:(id) nodeManager didReceiveNodes:(NSArray*) nodes;
-(IBAction) fakeNodeTest:(id) sender;


-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;
-(void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray*) annotationViews;

@property (retain) NSMutableDictionary * annotationImages;

@end
