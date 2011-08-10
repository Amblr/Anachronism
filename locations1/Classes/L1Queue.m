//
//  Queue.m
//  GalaxyZoo
//
//  Created by Joe Zuntz on 23/07/2009.
//  Copyright 2009 Imperial College London. All rights reserved.
//

#import "L1Queue.h"


@implementation L1Queue

-(id) init{
	self = [super init];
	if (self){
		array = [[NSMutableArray alloc] init];
		[array retain];
	}
	return self;
	
}

-(void) queueJump:(id) item {
    [array addObject:item];
}

-(void) clear{
    [array removeAllObjects];
}

-(void) enqueue:(id) item {
	[array insertObject:item atIndex:0];
}

-(id) dequeue {
    if ([array count]==0) return nil;
	id item = [array lastObject];
    [item retain];
	[array removeLastObject];
    [item autorelease];
//    NSLog(@"dequeue - %d",[item retainCount]);
	return item;
}

-(int) count {
	return [array count];
}
-(void) dealloc{
	[array release];
	[super dealloc];
}
-(int) length{
return [self count];
}

@end
