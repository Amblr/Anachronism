//
//  ManualUserLocation.m
//  locations1
//
//  Created by Joe Zuntz on 05/07/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "ManualUserLocation.h"


@implementation ManualUserLocation


-(id) init{
    self = [super init];
    if (self){
        CLLocationManager *manager = [[CLLocationManager alloc] init];
        CLLocation *location = [manager location];
        if (location){
            coordinate = [location coordinate];
        }
        else{
            coordinate.latitude = 0.0;
            coordinate.longitude = 0.0;
        }
        [manager release];
    }
    return self;
    
}

-(id) initWithCoordinate:(CLLocationCoordinate2D) initialCoordinate; //Start at a fake location
{
    self = [super init];
    if (self){
        coordinate = initialCoordinate;
    }
    return self;
}

-(void) setCoordinate:(CLLocationCoordinate2D) newCoordinate
{
    coordinate = newCoordinate;
    
}

@synthesize coordinate;
@end
