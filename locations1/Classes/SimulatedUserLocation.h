//
//  SimulatedUserLocation.h
//  locations1
//
//  Created by Joe Zuntz on 22/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SimulatedLocationManager.h"


@interface SimulatedUserLocation : NSObject<MKAnnotation> {
    SimulatedLocationManager * locationManager;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
-(MKAnnotationView*) viewForSimulatedLocationWithIdentifier:(NSString*) identifier;

@end
