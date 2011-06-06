//
//  L1Overlay.m
//  locations1
//
//  Created by Joe Zuntz on 06/06/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1Overlay.h"


@implementation L1Overlay
@synthesize boundingMapRect;
@synthesize coordinate;
@synthesize overlayImage;
@synthesize alpha;

- (id) initWithImage:(UIImage*) image withLowerLeftCoordinate:(CLLocationCoordinate2D)lowerLeftCoordinate withUpperRightCoordinate:(CLLocationCoordinate2D)upperRightCoordinate
{
    self = [super init];
    if (self){

        MKMapPoint lowerLeft = MKMapPointForCoordinate(lowerLeftCoordinate);
        MKMapPoint upperRight = MKMapPointForCoordinate(upperRightCoordinate);
        
        boundingMapRect = MKMapRectMake(lowerLeft.x, upperRight.y, upperRight.x - lowerLeft.x, lowerLeft.y - upperRight.y);
        
        //map rect "origin" is top-left, it seems.
        coordinate = MKCoordinateForMapPoint(MKMapPointMake((lowerLeft.x+upperRight.x)/2., (lowerLeft.y+upperRight.y)/2.));
        self.overlayImage=image;
        self.alpha=1.0;
    }
    return self;
}




//
//-(CGImageRef) imageChunkForMapRect:(MKMapRect) mapRect
//{
//    NSLog(@"Asked for chunk");
//
//    MKMapRect overlapRect = MKMapRectIntersection(mapRect, boundingMapRect);
//    if (MKMapRectIsNull(overlapRect)) return nil;
//    
//    double chunkWidth = overlapRect.size.width/boundingMapRect.size.width*self.overlayImage.size.width;
//    double chunkHeight = overlapRect.size.height/boundingMapRect.size.height*self.overlayImage.size.height;
//    double chunkX = (overlapRect.origin.x-boundingMapRect.origin.x)/boundingMapRect.size.width*self.overlayImage.size.width;
//    double chunkY = (overlapRect.origin.y-boundingMapRect.origin.y)/boundingMapRect.size.height*self.overlayImage.size.height;
//    
//    CGRect rect = CGRectMake(chunkX, chunkY, chunkWidth, chunkHeight);
//    NSLog(@"Chunk loaded:%.1f,%.1f,%.1f,%.1f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
//
//    CGImageRef chunk =  CGImageCreateWithImageInRect (self.overlayImage.CGImage,rect);
//    return chunk;
//}

@end
