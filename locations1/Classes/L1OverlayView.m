//
//  L1OverlayView.m
//  locations1
//
//  Created by Joe Zuntz on 06/06/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1OverlayView.h"


@implementation L1OverlayView

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context{
    L1Overlay * l1Overlay = (L1Overlay*) self.overlay;
    if (![l1Overlay isKindOfClass:[L1Overlay class]]) {
        NSLog(@"Bad overlay for L1OverlayView.");
        return;   
    }
    
    
    MKMapRect overlayMapRect = l1Overlay.boundingMapRect;
    if (!MKMapRectIntersectsRect(overlayMapRect, mapRect)) return;
    
    CGRect overlayRect = [self rectForMapRect:overlayMapRect];
    UIGraphicsPushContext(context);
    [l1Overlay.overlayImage drawInRect:overlayRect blendMode:kCGBlendModeNormal alpha:self.alpha];
    UIGraphicsPopContext();
    

    
}



@end
