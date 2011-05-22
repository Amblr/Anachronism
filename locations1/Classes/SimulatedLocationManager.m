//
//  SimulatedLocationManager.m
//  locations1
//
//  Created by Joe Zuntz on 22/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "SimulatedLocationManager.h"


@implementation SimulatedLocationManager
@synthesize speed;
@synthesize pathElements;
@synthesize delegate;

-(id) init
{
    self = [super init];
    if (self){
        self.pathElements = [NSMutableArray arrayWithCapacity:0];
        monitoredRegions = [[NSMutableArray alloc] initWithCapacity:0];
        regionAccuracies = [[NSMutableArray alloc] initWithCapacity:0];
        lastUpdate = nil;
        previousElement=nil;
        nextElement=nil;
    }
    return self;
}


-(void) startPath;
{
    if (self.pathElements==nil || [self.pathElements count]<2){
        NSLog(@"NOT starting journey - not enough elements or no path set");
        return;
    }
    [lastUpdate release];
    lastUpdate = [NSDate date];
    segmentProgress=0.0;
    previousElement=[self.pathElements objectAtIndex:0];
    nextElement=[self.pathElements objectAtIndex:1];
    NSLog(@"Started moving along fake path (%d nodes) at speed %@",[self.pathElements count],self.speed);
}

-(void) updateLocation
{
    NSTimeInterval deltaTime = -[lastUpdate timeIntervalSinceNow];
    segmentProgress += deltaTime*self.speed;
    CLLocationDistance currentSegmentLength = [nextElement distanceFromLocation:previousElement];

    if (segmentProgress>=currentSegmentLength){
        if (nextElement==[self.pathElements lastObject]){
            //We have finished the journey.
            //Let's just stop here.
            currentLocation=[self.pathElements lastObject];
            return;
        }
        previousElement=nextElement;
        int index = [self.pathElements indexOfObject:nextElement];
        nextElement=[self.pathElements objectAtIndex:index+1];
        segmentProgress-=currentSegmentLength;
        currentSegmentLength = [nextElement distanceFromLocation:previousElement];

    }
    
    float segmentFraction = segmentProgress/currentSegmentLength;

    MKMapPoint previousPoint = MKMapPointForCoordinate(previousElement.coordinate);
    MKMapPoint nextPoint = MKMapPointForCoordinate(nextElement.coordinate);
    
#warning THIS MIGHT GO WRONG IF YOU LIVE IN THE ALEUTIAN ISLANDS
    
    MKMapPoint currentPoint;
    currentPoint.x=previousPoint.x+segmentFraction*(nextPoint.x-previousPoint.x);
    currentPoint.y=previousPoint.y+segmentFraction*(nextPoint.y-previousPoint.y);
    
    CLLocationCoordinate2D currentCoordinate = MKCoordinateForMapPoint(currentPoint);
    
    [currentLocation autorelease];
    currentLocation = [[CLLocation alloc] initWithLatitude:currentCoordinate.latitude longitude:currentCoordinate.longitude];
            
    lastUpdate=[NSDate date];
    
    [self checkMonitoring];
}

-(void) checkMonitoring
{
    for (CLRegion * region in monitoredRegions){
        if ([region containsCoordinate:self.location.coordinate]){
            SEL selector = @selector(locationManager:didEnterRegion:);
            [delegate performSelector:selector withObject:self withObject:region];
        }
        
    }
    
}

-(CLLocation*) location
{
    return currentLocation;
}


- (void)startMonitoringForRegion:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy
{
    [monitoredRegions addObject:region];
//    [regionAccuracies addObject:[NSNumber numberWithDouble:accuracy]];
    
}

@end