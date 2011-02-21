//
//  L1MultiNode.m
//  locations1
//
//  Created by Joe Zuntz on 20/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "L1MultiNode.h"


@implementation L1MultiNode


-(id) initWithDictionary:(NSDictionary*) statesDictionary initialState:(NSString*)initialState
{
	NSDictionary * nodeDictionary = [statesDictionary objectForKey:initialState];
	self = [super initWithDictionary:nodeDictionary];
	if (self){
		states=[[NSMutableDictionary dictionaryWithDictionary:statesDictionary] retain];
		activeState=[initialState retain];
	}
	return self;
	
	
}

-(NSString*) state
{
	return activeState;
}

-(void) setState:(NSString*)state
{
	[activeState autorelease];
	activeState=[state retain];
	NSDictionary * nodeDictionary = [states objectForKey:state];
	[self setStateFromDictionary:nodeDictionary];
}

@end
