//
//  L1MultiNode.h
//  locations1
//
//  Created by Joe Zuntz on 20/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "L1Node.h"


@interface L1MultiNode : L1Node {
	NSMutableDictionary * states;
	NSString * activeState;
}

@property (retain) NSString * state;


@end
