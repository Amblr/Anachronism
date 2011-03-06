//
//  L1ResponsiveNode.m
//  locations1
//
//  Created by Joe Zuntz on 21/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "L1ResponsiveNode.h"
#import "L1Experience.h"

@implementation L1ResponsiveNode
-(id) initWithDictionary:(NSDictionary*) statesDictionary key:(NSString*)keyName initialState:(NSString*)initialState responses:(NSArray*)responses
{
	self = [super initWithDictionary:statesDictionary key:keyName initialState:initialState];
	if (self){
		possibleResponses = [[NSMutableArray alloc] initWithArray:responses];
	}
	return self;
}


-(void) selectResponse:(NSString*)response
{
	L1Experience * experience = [[L1Experience alloc] init];
	experience.date=[NSDate date];
	experience.eventID = [[@"SELECTED RESPONSE" stringByAppendingString:self.key] stringByAppendingString:response];

	SEL call = @selector(node:didCreateExperience:);
	if ([self.delegate respondsToSelector:call]){
		[self.delegate performSelector:call withObject:self withObject:experience];
	}
	
	
	
}

@synthesize possibleResponses;
@end
