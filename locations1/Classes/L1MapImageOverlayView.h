//
//  L1MapOverlay.h
//  locations1
//
//  Created by Joe Zuntz on 03/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>




@interface L1MapImageOverlayView : MKOverlayView {
	CGImageRef mapImage;
	MKMapPoint mapCornerBottomLeft;
	MKMapPoint mapCornerTopRight;
	MKMapRect overlayImageMapRect;
	float xPixelsPerMapUnit;
	float yPixelsPerMapUnit;

}

-(id) initWithOverlay:(id<MKOverlay>)overlay image:(CGImageRef)image;

@end
