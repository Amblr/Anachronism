//
//  L1Circle.h
//  locations1
//
//  Created by Joe Zuntz on 09/08/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"
#import "L1Resource.h"



@interface L1Circle : NSObject<MKOverlay> {
    CLLocationCoordinate2D coordinate;
    CLLocationDistance radius;
    L1SoundType soundType;
}

@property (nonatomic,readonly)  CLLocationCoordinate2D coordinate;
@property (nonatomic,readonly)  CLLocationDistance radius;
@property (nonatomic,readonly)  L1SoundType soundType;


-(id) initWithCenter:(CLLocationCoordinate2D) center radius:(CLLocationDistance) radial soundType:(L1SoundType) type;

@end
