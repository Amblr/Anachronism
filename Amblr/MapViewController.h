//
//  mapViewController.h
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AmblrNode.h"
#import "NVPolylineAnnotation.h"

@class AmblrViewController;
@interface MapViewController : UIViewController {
	IBOutlet MKMapView * mapView;
	AmblrViewController * delegate;
	NSMutableArray * nodes;
	float date,minDate, maxDate;
	UIImage * pinImage1;
	UIImage * pinImage2;
	NSMutableArray * pathNodes;
	BOOL inSelectionProcess;
	NVPolylineAnnotation * polyline;
}

-(void) setupCollegeNodes;
@property (retain) NVPolylineAnnotation * polyline;
-(void) randomDateNode:(NSString*)name latitude:(float)latitude longitude:(float)longitude;
@property (retain) NSMutableArray * pathNodes;
-(void) zoomToOxford;
-(AmblrNode*) nodeWithKey:(NSString*) key name:(NSString*)name description:(NSString*)description latitude:(float) latitude longitude:(float)longitude radius:(float)radius;
-(void) setupNodes;
-(void) addNodeAnnotation:(int) n;
//-(void) changeNodeColors:(int) color;
-(UIImageOrientation) randomOrientation;
-(NSString*) randomName;
-(NSString*)  randomEvent;
-(MKAnnotationView *)annotationViewFor:(MKMapView *)theMapView forNode:(AmblrNode*)node;
-(void) generateRandomNode:(int) i;
@property (assign) float date;
@property (retain) NSMutableArray * nodes;
@property (readonly) MKMapView * mapView;
@property (retain) id delegate;
-(void) addNewRandomAnnotation;
-(void) clickNodeButton:(id)sender;
-(void) addTextToNode:(AmblrNode*)node;
-(void) addSelectedNodeToPath:(AmblrNode*) node;
@end
