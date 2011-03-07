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

@class AmblrViewController;
@interface MapViewController : UIViewController {
	IBOutlet MKMapView * mapView;
	AmblrViewController * delegate;
	NSMutableArray * nodes;
	float date;
	
	BOOL inSelectionProcess;
}
-(void) zoomToOxford;
-(AmblrNode*) nodeWithKey:(NSString*) key name:(NSString*)name description:(NSString*)description latitude:(float) latitude longitude:(float)longitude radius:(float)radius;
-(void) setupNodes;
-(void) addNodeAnnotation:(int) n;
-(void) changeNodeColors:(int) color;

@property (assign) float date;
@property (retain) NSMutableArray * nodes;
@property (readonly) MKMapView * mapView;
@property (retain) id delegate;
@end
