//
//  ManualUserLocation.h
//  locations1
//
//  Created by Joe Zuntz on 05/07/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface ManualUserLocation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}
-(id) initWithCoordinate:(CLLocationCoordinate2D) initialCoordinate; //Start at a fake location
-(id) init; //Attemptes to use actual user location.

-(void) setCoordinate:(CLLocationCoordinate2D) newCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
