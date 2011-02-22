//
//  L1Scenario.m
//  locations1
//
//  Created by Joe Zuntz on 19/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1Scenario.h"
#import "SimpleURLConnection.h"
#import "JSON.h"
#import "L1Experience.h"

@implementation L1Scenario

@synthesize delegate;


-(id) init{
	self = [super init];
	if (self){
		nodes = [[NSMutableArray alloc] initWithCapacity:0];
		plots = [[NSMutableArray alloc] initWithCapacity:0];
		experiences = [NSMutableDictionary dictionaryWithCapacity:0];
	}
	return self;
}


-(void) startNodeDownload:(NSString *) url
{
	SimpleURLConnection * connection = [[SimpleURLConnection alloc] initWithURL:url 
																	   delegate:self 
																   passSelector:@selector(downloadedNodeData:withResponse:) 
																   failSelector:@selector(failedNodeDownloadWithError:) ];
	
	
	[connection.request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
	[connection runRequest];
}



-(void) fakeNodes
{
	
	NSString * fakeNodeText = @"[{\"radius\": 1.0, \"resource_hooks\": [], \"coords\": [51.0, -0.2000000000000002], \"name\": \"Train Station\", \"description\": \"This dark and evil train station radiates a dark sense of evil.\"}, {\"radius\": 1.0, \"resource_hooks\": [], \"coords\": [51.2, -0.2050000000000001], \"name\": \"Ice Rink\", \"description\": \"This dark and evil ice rink radiates a dark sense of evil.\"}, {\"radius\": 1.0, \"resource_hooks\": [], \"coords\": [51.3, 0.3000000000000002], \"name\": \"Stadium\", \"description\": \"This dark and evil stadium radiates a dark sense of evil.\"}]";
	SBJsonParser * parser = [[SBJsonParser alloc] init];
	NSArray * nodeArray = [parser objectWithString:fakeNodeText];
	[parser release];
	for(NSDictionary * nodeDictionary in nodeArray){
		L1Node * node = [[L1Node alloc] initWithDictionary:nodeDictionary];
		[nodes addObject:[node autorelease]];
	}
	
	[delegate performSelector:@selector(nodeSource:didReceiveNodes:) withObject:self withObject:nodes];
	
	
}

-(int) nodeCount{
	return [nodes count];
}



-(void) downloadedNodeData:(NSData*) data withResponse:(NSHTTPURLResponse*) response
{
	SBJsonParser * parser = [[SBJsonParser alloc] init];
	NSArray * nodeArray = [parser objectWithData:data];
	[parser release];
	
	for(NSDictionary * nodeDictionary in nodeArray){
		L1Node * node = [[L1Node alloc] initWithDictionary:nodeDictionary];
		[nodes addObject:[node autorelease]];
	}
	
	[delegate performSelector:@selector(nodeSource:didReceiveNodes:) withObject:self withObject:nodes];
	
	
	
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
	return [nodes countByEnumeratingWithState:state objects:stackbuf count:len];
	
}


-(void) failedNodeDownloadWithError:(NSError*) error
{
	NSLog(@"You are disgrace to humanity.");
}


-(void) nodeWasSelected:(L1Node*)node
{
	//Good.
}
-(void) node:(L1Node*) node didChangeState:(NSString*)state
{
	
}

-(void) node:(L1Node*) node didCreateExperience:(L1Experience*)experience
{
	[experiences setObject:experience forKey:experience.eventID];
}

-(L1Experience*) node:(L1Node*) node requestsExperience:(L1Experience*)requestedExperience
{
	NSString * targetEventID = requestedExperience.eventID;
	return [experiences objectForKey:targetEventID]!=nil;
}

-(L1Experience*) node:(L1Node*) node requestsExperienceByName:(NSString*) name
{
	return [experiences objectForKey:name];
	
}

@end
