//
//  L1NodeManager.m
//  locations1
//
//  Created by Joe Zuntz on 15/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1NodeManager.h"
#import "JSON/JSON.h"
#import "SimpleURLConnection.h"
#import "L1Node.h"


@implementation L1NodeManager

@synthesize delegate;


-(id) init{
	self = [super init];
	if (self){
		nodes = [[NSMutableArray alloc] initWithCapacity:0];
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
	
	[delegate performSelector:@selector(nodeManager:didReceiveNodes:) withObject:self withObject:nodes];
	
	
}

-(int) count{
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
	 
	[delegate performSelector:@selector(nodeManager:didReceiveNodes:) withObject:self withObject:nodes];
	
	
	
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
	return [nodes countByEnumeratingWithState:state objects:stackbuf count:len];
	
}


-(void) failedNodeDownloadWithError:(NSError*) error
{
	NSLog(@"You are disgrace to humanity.");
}

@end
