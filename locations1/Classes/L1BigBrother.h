//
//  L1BigBrother.h
//  locations1
//
//  Created by Joe Zuntz on 23/07/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "L1Path.h"
#import "L1Node.h"

@interface L1BigBrother : NSObject {
    
    NSMutableArray * locations;
    NSMutableArray * nodes; //Not implemented yet
    
    
}
@property (retain) NSMutableArray * locations;
//-(L1Path*) path;   // A path generated by the user node visits.  Not done yet.
//-(void) addNode:(L1Node*) node;
-(void) addLocation:(CLLocation*) location;


@end
