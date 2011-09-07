//
//  L1Plotline.m
//  locations1
//
//  Created by Joe Zuntz on 19/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1Story.h"
#import "SimpleURLConnection.h"
#import "SBJsonParser.h"
#import "L1Node.h"
#import "L1Path.h"


@implementation L1Story
@synthesize nodes;
@synthesize paths;
@synthesize key;
@synthesize name;
@synthesize delegate;


-(void) startDownload:(NSString*)urlString
{
    SimpleURLConnection * connection = [[SimpleURLConnection alloc] initWithURL:urlString
                                                                       delegate:self 
                                                                   passSelector:@selector(downloadedStoryData:withResponse:) 
                                                                   failSelector:@selector(failedStoryDownloadWithError:) ];
	
	
	[connection.request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
	[connection runRequest];
    
}

-(void) failedStoryDownloadWithError:(NSError*) error
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"A problem" message:@"Sorry - there was a problem with the app.  Please inform the Amblr Team" delegate:nil cancelButtonTitle:@"*Sigh*" otherButtonTitles: nil];
    [alert show];
    
    
}

-(void) downloadedData:(NSData*) data withResponse:(NSHTTPURLResponse*) response
{
    NSLog(@"Node data downloaded");
	SBJsonParser * parser = [[SBJsonParser alloc] init];
	NSDictionary * storyDictionary = [parser objectWithData:data];
    NSArray * nodeArray = [storyDictionary objectForKey:@"nodes"];
	[parser release];
	for(NSDictionary * nodeDictionary in nodeArray){
        @try{
            L1Node * node = [[L1Node alloc] initWithDictionary:nodeDictionary key:[nodeDictionary objectForKey:@"id"]];
            [nodes setObject:[node autorelease] forKey:node.key];
        }
        @catch (NSException *e ) {
            NSLog(@"Bad node: %@",e);
        }
	}
	
    SEL nodeSelector = @selector(nodeSource:didReceiveNodes:);
    if ([delegate respondsToSelector:nodeSelector])
        [delegate performSelector:nodeSelector withObject:self withObject:nodes];
    //Should now handle paths too but no time now!
    NSArray * pathArray = [storyDictionary objectForKey:@"paths"];
    NSLog(@"Scenario paths data downloaded");
    
    
    if ([pathArray isKindOfClass:[NSArray class]]){
        for(NSDictionary * pathDictionary in pathArray){
            L1Path * path = [[L1Path alloc] initWithDictionary:pathDictionary nodeSource:nodes];
            [paths setObject:path forKey:path.key];
        }
        SEL pathSelector = @selector(pathSource:didReceivePaths:);
        if ([delegate respondsToSelector:pathSelector])
            [delegate performSelector:pathSelector withObject:self withObject:paths];
    }
    else{
        NSLog(@"Non-array found from path data");   
    }
    
    
}


@end
