//
//  L1Circle.m
//  locations1
//
//  Created by Joe Zuntz on 09/08/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1Circle.h"


@implementation L1Circle
@synthesize coordinate, radius, soundType;


-(id) initWithCenter:(CLLocationCoordinate2D) center radius:(CLLocationDistance) radial soundType:(L1SoundType) type
{
    self = [super init];
    if (self){
        coordinate=center;
        radius=radial;
        soundType=type;
    }
    return self;
}


-(MKMapRect) boundingMapRect
{
    MKMapRect mapRect;
    mapRect.origin=MKMapPointForCoordinate(coordinate);
    mapRect.size.height=radius;
    mapRect.size.width=radius;
    return mapRect;
    
}

@end
