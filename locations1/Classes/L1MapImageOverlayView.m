//
//  L1MapOverlay.m
//  locations1
//
//  Created by Joe Zuntz on 03/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "L1MapImageOverlayView.h"
#import <MapKit/MKGeometry.h>

@implementation L1MapImageOverlayView

-(id) initWithOverlay:(id<MKOverlay>)overlay image:(CGImageRef)image;
{
	self = [super initWithOverlay:overlay];
	if (self){
		mapImage=image;
		overlayImageMapRect=overlay.boundingMapRect;
		mapCornerTopRight=MKMapPointMake(MKMapRectGetMinX(overlayImageMapRect),MKMapRectGetMinY(overlayImageMapRect));
		mapCornerTopRight=MKMapPointMake(MKMapRectGetMaxX(overlayImageMapRect),MKMapRectGetMaxY(overlayImageMapRect));

		NSLog(@" overlay map rect = %@",MKStringFromMapRect(overlayImageMapRect));
		xPixelsPerMapUnit=CGImageGetWidth(image)/overlayImageMapRect.size.width;
		yPixelsPerMapUnit=CGImageGetHeight(image)/overlayImageMapRect.size.height;
	}
	return self;
}



- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{
	MKMapRect updatedMapRect = MKMapRectIntersection(mapRect,overlayImageMapRect);
	if (MKMapRectIsNull(updatedMapRect)){
		return;
	};
	if (MKMapRectIsEmpty(updatedMapRect)) return;
	
	//This is called for the whole map rectangle, not just the segment of the overlay image.
	// mapRect is in 2D projected coordinates (probably meters, or something).

	
//	CGContextSaveGState(context);

	//Extract appropriate sub-image from main mapImage.

	
	
	
	CGRect subRect; //pixel space in overlaid image.
	
	
	
	subRect.origin.x = -(updatedMapRect.origin.x-mapCornerTopRight.x)*xPixelsPerMapUnit;
	subRect.origin.y = -(updatedMapRect.origin.y-mapCornerTopRight.y)*yPixelsPerMapUnit;

	subRect.size.width = updatedMapRect.size.width*xPixelsPerMapUnit;
	subRect.size.height = updatedMapRect.size.height*yPixelsPerMapUnit;

	CGImageRef subImage = CGImageCreateWithImageInRect(mapImage, subRect);
	NSLog(@"map region origin = (%f,%f)",updatedMapRect.origin.x-overlayImageMapRect.origin.x,updatedMapRect.origin.y-overlayImageMapRect.origin.y);
	NSLog(@"map region size = (%f,%f)",updatedMapRect.size.width,updatedMapRect.size.height);
	NSLog(@"sub-image size = (%ld,%ld)",CGImageGetWidth(subImage),CGImageGetHeight(subImage));

	
	CGRect viewRect = [self rectForMapRect:updatedMapRect];
	
    CGContextSetAlpha(context, 1.0);
	CGContextDrawImage(context,viewRect,subImage);

	CGImageRelease(subImage);
	
	
	
	double maxx = MKMapRectGetMaxX(updatedMapRect);
    double minx = MKMapRectGetMinX(updatedMapRect);
    double maxy = MKMapRectGetMaxY(updatedMapRect);
    double miny = MKMapRectGetMinY(updatedMapRect);
	
    CGPoint tr = [self pointForMapPoint:(MKMapPoint) {maxx, maxy}];
    CGPoint br = [self pointForMapPoint:(MKMapPoint) {maxx, miny}];
    CGPoint bl = [self pointForMapPoint:(MKMapPoint) {minx, miny}];
    CGPoint tl = [self pointForMapPoint:(MKMapPoint) {minx, maxy}];
	
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGPathMoveToPoint(cgPath, NULL, tr.x, tr.y);
    CGPathAddLineToPoint(cgPath, NULL, br.x, br.y);
    CGPathAddLineToPoint(cgPath, NULL, bl.x, bl.y);
    CGPathAddLineToPoint(cgPath, NULL, tl.x, tl.y);
    CGPathAddLineToPoint(cgPath, NULL, tr.x, tr.y); 
	
    CGContextSaveGState(context);
    CGContextAddPath(context, cgPath);
	
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 10000.0);
    CGContextStrokePath(context);
    CGPathRelease(cgPath);  
    CGContextRestoreGState(context);
	
	
	
	
}
@end
