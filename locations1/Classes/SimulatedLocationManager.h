//
//  SimulatedLocationManager.h
//  locations1
//
//  Created by Joe Zuntz on 22/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SimulatedLocationManager : NSObject {
    NSMutableArray * pathElements;
    NSMutableArray * monitoredRegions;
    
    id delegate;

    //Internal stuff for keeping track of location
    CLLocation * currentLocation;
    CLLocation * previousElement;
    CLLocation * nextElement;
    CLLocationDistance segmentProgress;
    NSDate * lastUpdate;
    
    double speed;
    double totalPathLength;
    double updateInterval;
}

@property (assign) double updateInterval;
@property (retain) NSMutableArray * pathElements;
@property (assign) double speed;
@property (retain) id delegate;
-(void) checkMonitoring;


// Our fake location
@property(readonly, nonatomic) CLLocation *location;

-(void) startPath;
-(void) updateLocation;
@end
