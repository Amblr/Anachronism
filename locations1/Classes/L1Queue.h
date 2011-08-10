//
//  Queue.h
//  GalaxyZoo
//
//  Created by Joe Zuntz on 23/07/2009.
//  Copyright 2009 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface L1Queue : NSObject
{
	NSMutableArray * array;
}

-(void) enqueue:(id) item;
-(id) dequeue;
-(int) count;
-(void) queueJump:(id)item;
-(void) clear;
@property (readonly) int length;
@end

