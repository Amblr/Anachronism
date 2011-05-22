//
//  SimulatedLocationManager.m
//  locations1
//
//  Created by Joe Zuntz on 22/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "SimulatedLocationManager.h"
#import "SynthesizeSingleton.h"


@implementation SimulatedLocationManager

SYNTHESIZE_SINGLETON_FOR_CLASS(SimulatedLocationManager);


@synthesize speed;
@synthesize pathElements;
@synthesize updateInterval;
@synthesize  delegates;
@synthesize lastUpdate;

-(id) init
{
    self = [super init];
    if (self){
        self.pathElements = [NSMutableArray arrayWithCapacity:0];
        self.updateInterval = 0.5;
        self.speed = 100.0; //meters per second, I think.
        self.delegates = [NSMutableSet setWithCapacity:0];
        monitoredRegions = [[NSMutableArray alloc] initWithCapacity:0];
        self.lastUpdate = nil;
        previousElement=nil;
        nextElement=nil;
        currentLocation=[[CLLocation alloc] initWithLatitude:51.5 longitude:0.0]; //Greenwich  //This leaks.
    }
    return self;
}


-(void) startPath;
{
    if (self.pathElements==nil || [self.pathElements count]<2){
        NSLog(@"NOT starting journey - not enough elements or no path set");
        return;
    }
    self.lastUpdate = [NSDate date];
    segmentProgress=0.0;
    previousElement=[self.pathElements objectAtIndex:0];
    nextElement=[self.pathElements objectAtIndex:1];
    currentLocation=previousElement;
    NSLog(@"Began @ %@",self.lastUpdate);
    NSLog(@"Started moving along fake path (%d nodes) at speed %f",[self.pathElements count],self.speed);
    SEL selector = @selector(updateLocationWrapper:);
    [self performSelector:selector withObject:nil afterDelay:self.updateInterval];
}

-(void) updateLocationWrapper:(NSObject*) dummy
{
    [self updateLocation];
    SEL selector = @selector(updateLocationWrapper:);
    [self performSelector:selector withObject:nil afterDelay:self.updateInterval];

}

-(void) updateLocation
{
    NSLog(@"Running update location %@",self);
    NSLog(@"Last update %@",self.lastUpdate);
    
    NSTimeInterval deltaTime = -[self.lastUpdate timeIntervalSinceNow];
    
    segmentProgress += deltaTime*self.speed;
    CLLocationDistance currentSegmentLength = [nextElement distanceFromLocation:previousElement];

    if (segmentProgress>=currentSegmentLength){
        if (nextElement==[self.pathElements lastObject]){
            //We have finished the journey.
            //Let's just stop here.
            currentLocation=[self.pathElements lastObject];
            NSLog(@"Fake path reached end.");
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
    
    CLLocation * previousLocation = currentLocation;
    currentLocation = [[CLLocation alloc] initWithLatitude:currentCoordinate.latitude longitude:currentCoordinate.longitude];
            
    self.lastUpdate=[NSDate date];
    NSLog(@"Fake path reached %@",currentLocation);
    
    [self checkMonitoring];
    [self reportLocationChangedFrom:previousLocation];
//    [currentLocation autorelease];
    
}

-(void) reportLocationChangedFrom:(CLLocation*)previous
{
    

    SEL selector = @selector(locationManager:didUpdateToLocation:fromLocation:);
    for (id delegate in delegates){
        if ([delegate respondsToSelector:selector]){
            [delegate locationManager:self didUpdateToLocation:self.location fromLocation:previous];
        }
    }
    
}

-(void) checkMonitoring
{
    for (CLRegion * region in monitoredRegions){
        NSLog(@"Checking for hitting region:%@ vs (%f,%f)",region,self.location.coordinate.latitude,self.location.coordinate.longitude);
        if ([region containsCoordinate:self.location.coordinate]){
            SEL selector = @selector(locationManager:didEnterRegion:);
            for (id delegate in delegates){
                if ([delegate respondsToSelector:selector]) [delegate performSelector:selector withObject:self withObject:region];
            }
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
    
}


@end
