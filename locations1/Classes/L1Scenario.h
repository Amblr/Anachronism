//
//  L1Scenario.h
//  locations1
//
//  Created by Joe Zuntz on 19/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>

//Has many nodes
//Has many plots
//Each plot can have many nodes
//Has many user experiences

@interface L1Scenario : NSObject {
	NSMutableArray * nodes;
	NSMutableArray * plots;
	NSMutableArray * experiences;
}

@end
