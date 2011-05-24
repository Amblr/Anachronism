//
//  SimulatedUserLocation.m
//  locations1
//
//  Created by Joe Zuntz on 22/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "SimulatedUserLocation.h"


@implementation SimulatedUserLocation

-(id) init
{
    self = [super init];
    if (self){
        locationManager=[SimulatedLocationManager sharedSimulatedLocationManager];
        [locationManager.delegates addObject:self];
        NSLog(@"Created fake user location at %@",locationManager.location);
    }
    return self;
}

-(CLLocationCoordinate2D) coordinate
{
    return locationManager.location.coordinate;
}

-(MKAnnotationView*) viewForSimulatedLocationWithIdentifier:(NSString*) identifier
{
//    NSLog(@"Created fake pin.");
    MKAnnotationView * view = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:identifier];
    view.image = [UIImage imageNamed:@"mapIcon.png"];

//    MKAnnotationView * pin = [[MKPinAnnotationView alloc] initWithAnnotation:self reuseIdentifier:identifier];
//    return [view autorelease];
    return [view autorelease];
}


@end
