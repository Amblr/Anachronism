//
//  L1Scenario.h
//  locations1
//
//  Created by Joe Zuntz on 19/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "L1Node.h"

//Has many nodes
//Has many plots
//Each plot can have many nodes
//Has many user experiences



@interface L1Scenario : NSObject<NSFastEnumeration,L1NodeDelegate> {
	NSMutableArray * nodes;
	NSMutableArray * plots;
	NSMutableDictionary * experiences;
	id delegate;

}
@property (retain) id delegate;

-(int) nodeCount;
-(void) downloadedNodeData:(NSData*) data withResponse:(NSHTTPURLResponse*) response;
-(void) failedNodeDownloadWithError:(NSError*) error;
-(void) startNodeDownload:(NSString *) url;
-(void) fakeNodes;

@end
