//
//  L1MapImageOverlay.h
//  locations1
//
//  Created by Joe Zuntz on 03/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface L1MapImageOverlay : NSObject<MKOverlay> {
	MKMapRect boundingMapRect;
	CLLocationCoordinate2D coordinate;
}

-(void) setMapRect:(MKMapRect) rect;
-(void) setCoordinate:(CLLocationCoordinate2D) coord;

@end
