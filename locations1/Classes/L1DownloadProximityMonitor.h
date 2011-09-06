//
//  L1DownloadProximityMonitor.h
//  locations1
//
//  Created by Joe Zuntz on 10/08/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "L1Node.h"


@interface L1DownloadProximityMonitor : NSObject {
    NSMutableArray * nodes;
    CLLocationDistance proximityTrigger;
}

@property (assign) CLLocationDistance proximityTrigger;

-(void) addNodes:(NSArray*) newNodes;
-(void) updateLocation:(CLLocationCoordinate2D)location;
-(void) downloadAll;

@end
