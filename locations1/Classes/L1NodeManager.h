//
//  L1NodeManager.h
//  locations1
//
//  Created by Joe Zuntz on 15/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface L1NodeManager : NSObject<NSFastEnumeration> {
	NSMutableArray * nodes;
	id delegate;
}

@property (retain) id delegate;

-(int) count;
-(void) downloadedNodeData:(NSData*) data withResponse:(NSHTTPURLResponse*) response;
-(void) failedNodeDownloadWithError:(NSError*) error;
-(void) startNodeDownload:(NSString *) url;
-(void) fakeNodes;

@end
