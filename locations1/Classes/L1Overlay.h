//
//  L1Overlay.h
//  locations1
//
//  Created by Joe Zuntz on 06/06/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface L1Overlay : NSObject<MKOverlay> {
    MKMapRect boundingMapRect;
    CLLocationCoordinate2D coordinate;
    UIImage * overlayImage;
    CGFloat alpha;
    NSString * name;
}


- (id) initWithImage:(UIImage*) image withLowerLeftCoordinate:(CLLocationCoordinate2D)lowerLeftCoordinate withUpperRightCoordinate:(CLLocationCoordinate2D)upperRightCoordinate;

@property (retain) NSString * name;
@property (assign) CGFloat alpha;
@property (retain) UIImage * overlayImage;
@property (nonatomic,readonly) MKMapRect boundingMapRect;
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
//-(CGImageRef) imageChunkForMapRect:(MKMapRect) mapRect;


@end
