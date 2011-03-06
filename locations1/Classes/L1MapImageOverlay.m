//
//  L1MapImageOverlay.m
//  locations1
//
//  Created by Joe Zuntz on 03/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "L1MapImageOverlay.h"


@implementation L1MapImageOverlay

-(void) setMapRect:(MKMapRect) rect
{
	boundingMapRect=rect;
	
}

-(void) setCoordinate:(CLLocationCoordinate2D) coord
{
	coordinate=coord;
}

@synthesize boundingMapRect;
@synthesize coordinate;
@end
