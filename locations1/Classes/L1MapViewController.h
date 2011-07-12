//
//  L1MapViewController.h
//  locations1
//
//  Created by Joe Zuntz on 16/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "L1NodeContentViewController.h"
#import "L1Scenario.h"
#import "SimulatedUserLocation.h"
#import "L1Path.h"
#import "L1Overlay.h"
#import "L1OverlayView.h"
#import "ManualUserLocation.h"

@interface L1MapViewController : UIViewController<MKMapViewDelegate> {
	L1Scenario * scenario;
	IBOutlet MKMapView * primaryMapView;
    NSObject * delegate;
    SimulatedUserLocation * fakeUserLocation;
    L1OverlayView * singleOverlayView;
    ManualUserLocation * manualUserLocation;
	
}

@property (retain) ManualUserLocation * manualUserLocation;
@property (retain) L1OverlayView * singleOverlayView;
@property (retain) NSObject * delegate;
@property (retain) L1Scenario * scenario;
@property (retain) L1NodeContentViewController * nodeContentViewController;

-(void) nodeSource:(id) nodeManager didReceiveNodes:(NSDictionary*) nodes;
-(void) pathSource:(id) pathManager didReceivePaths:(NSDictionary*) paths;

-(void) removeOverlay;

-(void) zoomToNode:(L1Node*) node;
-(void) zoomToCoordinate:(CLLocationCoordinate2D) coordinate;
-(void) zoomInToNode:(L1Node*) node;

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;
-(void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray*) annotationViews;

-(void) addManualUserLocationAt:(CLLocationCoordinate2D)coordinate;

-(L1Overlay*) addOverlayImage:(UIImage*)image bottomLeft:(CLLocationCoordinate2D)bottomLeft topRight:(CLLocationCoordinate2D) topRight;
-(void) addPath:(L1Path*)path;
-(void) addNode:(L1Node*) node;
-(void) addImageOverlay:(L1Overlay*) overlay;
-(void) addOverlay:(id<MKOverlay>) overlay;
-(void) setColor:(UIColor*)color forCircle:(MKCircle*) circle;
@end
