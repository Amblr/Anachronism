//
//  Hackney_Hear_ViewController.h
//  Hackney Hear 
//
//  Created by Joe Zuntz on 05/07/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "L1Scenario.h"
#import "L1MapViewController.h"
#import "SimpleAudioEngine.h"
#import "L1BigBrother.h"


@interface Hackney_Hear_ViewController : UIViewController<CLLocationManagerDelegate> {
    L1Scenario * scenario;
    IBOutlet L1MapViewController * mapViewController;
    SimpleAudioEngine *audioEngine;
    NSMutableDictionary *audioSamples;
    CLLocationManager *locationManager;
    NSMutableDictionary *circles;
//    IBOutlet UISwitch *realGPSControl;
    
    // Tracking the user's path
    BOOL pathTracingEnabled;
    L1BigBrother * realLocationTracker;
    L1BigBrother * fakeLocationTracker;
}
@property (retain) L1Scenario * scenario;


// Location awareness
-(void) locationUpdate:(CLLocationCoordinate2D) location;
-(void) manualLocationUpdate:(CLLocation*)location;

// Story contents
-(void) setupScenario;
-(void) pathSource:(id) pathManager didReceivePaths:(NSDictionary*) paths;
-(void) nodeSource:(id) nodeManager didReceiveNodes:(NSDictionary*) nodes;
-(void) nodeDownloadFailedForScenario:(L1Scenario*) scenario;
// Sound
-(NSString*) filenameForNodeSound:(L1Node*) node;
-(void) nodeSoundOff:(L1Node*) node;
-(void) nodeSoundOn:(L1Node*) node;
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

@end
