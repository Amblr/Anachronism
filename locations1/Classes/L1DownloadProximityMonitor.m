//
//  L1DownloadProximityMonitor.m
//  locations1
//
//  Created by Joe Zuntz on 10/08/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1DownloadProximityMonitor.h"
#define DEFAULT_PROXIMITY_TRIGGER 150

@implementation L1DownloadProximityMonitor
@synthesize proximityTrigger;

-(id) init
{
    self = [super init];
    if (self){
        nodes = [[NSMutableArray alloc] initWithCapacity:0];
        proximityTrigger = DEFAULT_PROXIMITY_TRIGGER;
    }
    return self;
}


-(void) addNodes:(NSArray*) newNodes
{
    [nodes addObjectsFromArray:newNodes];
}

-(void) updateLocation:(CLLocationCoordinate2D)location
{
    CLLocation * updatedLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    for (L1Node * node in nodes){
        if ((!node.resources) || [node.resources count]==0) continue;
        CLLocation * nodeLocation = nil;

        for (L1Resource * resource in node.resources){
            if (!resource.local) {
                if (!nodeLocation) nodeLocation = [[CLLocation alloc] initWithLatitude:[node.latitude doubleValue] 
                                                                             longitude:[node.longitude doubleValue]];
                if ([nodeLocation distanceFromLocation:updatedLocation]-[node.radius doubleValue]<proximityTrigger) [resource downloadResourceData];   
            }
        }
        [nodeLocation release];
    }
    [updatedLocation release];
}

-(void) downloadAll
{
    for (L1Node * node in nodes){
        for (L1Resource * resource in node.resources){
            if (!resource.local) {
                [resource downloadResourceData];   
            }
        }
    }
}

-(void) dealloc
{
    [nodes release];
    [super dealloc];
}

@end
