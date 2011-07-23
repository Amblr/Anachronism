//
//  L1BigBrother.m
//  locations1
//
//  Created by Joe Zuntz on 23/07/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1BigBrother.h"


@implementation L1BigBrother
@synthesize locations;

-(id) init
{
    self = [super init];
    if (self){
        self.locations = [[[NSMutableArray alloc] init] autorelease];
        nodes = [[NSMutableArray alloc] init];  //not actually implemented

    }
    return self;
}

-(void) addLocation:(CLLocation*) location
{
    [locations addObject:location];
    
}


@end
