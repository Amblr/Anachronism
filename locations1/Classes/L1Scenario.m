//
//  L1Scenario.m
//  locations1
//
//  Created by Joe Zuntz on 19/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "L1Scenario.h"
#import "SimpleURLConnection.h"
#import "JSON.h"
#import "L1Experience.h"
#import "ASIHTTPRequest.h"

@implementation L1Scenario
@synthesize nodes;
@synthesize paths;
@synthesize delegate;
@synthesize pathURL;
@synthesize activeNode;
@synthesize activePath;
@synthesize key;

-(id) init{
	self = [super init];
	if (self){
		nodes = [[NSMutableDictionary alloc] init];
		paths = [[NSMutableDictionary alloc] init];
		experiences = [NSMutableDictionary dictionaryWithCapacity:0];
//		locationManager = [[CLLocationManager alloc] init];
        locationManager = [SimulatedLocationManager sharedSimulatedLocationManager];
        
		[locationManager.delegates addObject: self];
        self.key=@"";
        nodesReady = NO;
        pathsReady = NO;
        pathURL = nil;
	}
	return self;
}

-(void) walkPath:(L1Path*)path
{
    locationManager.pathElements = [path locationArray];
    [locationManager startPath];
}

-(void) startStoryDownload:(NSString*)urlString
{
    
    SimpleURLConnection * connection = [[SimpleURLConnection alloc] initWithURL:urlString
                                                                       delegate:self 
                                                                   passSelector:@selector(downloadedStoryData:withResponse:) 
                                                                   failSelector:@selector(failedStoryDownloadWithError:) ];
#warning REMOVE THIS TEMPORARY HACK AND PUT PASSWORD SOMEWHERE SENSIBLE
	[connection.request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
	[connection runRequest];

}

-(void) failedStoryDownloadWithError:(NSError*) error
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"A problem" message:@"Sorry - there was a problem with the app.  Please inform the Amblr Team" delegate:nil cancelButtonTitle:@"*Sigh*" otherButtonTitles: nil];
    [alert show];
    
    
}

-(void) downloadedStoryData:(NSData*) data withResponse:(NSHTTPURLResponse*) response
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
	
	[delegate performSelector:@selector(nodeSource:didReceiveNodes:) withObject:self withObject:nodes];
    //Should now handle paths too but no time now!
    NSArray * pathArray = [storyDictionary objectForKey:@"paths"];
    NSLog(@"Scenario paths data downloaded");

    
    if ([pathArray isKindOfClass:[NSArray class]]){
        for(NSDictionary * pathDictionary in pathArray){
            L1Path * path = [[L1Path alloc] initWithDictionary:pathDictionary nodeSource:nodes];
            [paths setObject:path forKey:path.key];
        }
        [delegate performSelector:@selector(pathSource:didReceivePaths:) withObject:self withObject:paths];
    }
    else{
        NSLog(@"Non-array found from path data");   
    }

    
}


+(L1Scenario*) scenarioFromScenarioURL:(NSString*) url withKey:(NSString *)scenarioKey
{
    L1Scenario * scenario = [[L1Scenario alloc] init];
    scenario.key = scenarioKey;
    [scenario startScenarioDownload:url];
    return [scenario autorelease];
}


-(void) startScenarioDownload:(NSString*)urlString
{
    SimpleURLConnection * connection = [[SimpleURLConnection alloc] initWithURL:urlString
                                                                       delegate:self 
                                                                   passSelector:@selector(downloadedScenarioData:withResponse:) 
                                                                   failSelector:@selector(failedScenarioDownloadWithError:) ];
	
	
	[connection.request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
	[connection runRequest];
    
}



-(void) downloadedScenarioData:(NSData*) data withResponse:(NSHTTPURLResponse*) response
{
    
    
    
    NSLog(@"Scenario story info list downloaded");
	SBJsonParser * parser = [[SBJsonParser alloc] init];
    NSArray * storyArray = [parser objectWithData:data];
    if ([storyArray count]==0) return;
    NSDictionary * storyDictionary = [storyArray objectAtIndex:0];
    NSString * storyID = [storyDictionary objectForKey:@"id"];
    NSString * storyFormat = @"http://amblr.heroku.com/scenarios/%@/stories/%@.json";
    NSString * storyURL = [NSString stringWithFormat:storyFormat, self.key, storyID];
    [self startStoryDownload:storyURL];
    
//    NSArray * pathArray = [storyDictionary objectForKey:@"paths"];
//
//    
//    for (NSDictionary* pathDictionary in pathArray){
//        NSArray * nodeArray = [pathDictionary objectForKey:@"nodes"];
//        for(NSDictionary * nodeDictionary in nodeArray){
//            NSString * nodeID = [nodeDictionary objectForKey:@"id"];
//            if ([nodes objectForKey:nodeID]==nil){
//                @try{
//                    L1Node * node = [[L1Node alloc] initWithDictionary:nodeDictionary key:[nodeDictionary objectForKey:@"id"]];
//                    [nodes setObject:[node autorelease] forKey:node.key];
//                }
//                @catch (NSException *e ) {
//                    NSLog(@"Bad node: %@",e);
//                }
//            }
//        }
//	}
//	[delegate performSelector:@selector(nodeSource:didReceiveNodes:) withObject:self withObject:nodes];
//    //Should now handle paths too but no time now!
//    
//    
//    NSLog(@"Scenario paths data downloaded");
//
//    
//    if ([pathArray isKindOfClass:[NSArray class]]){
//        for(NSDictionary * pathDictionary in pathArray){
//            @try{
//                L1Path * path = [[L1Path alloc] initWithDictionary:pathDictionary nodeSource:nodes];
//                [paths setObject:path forKey:path.key];
//            }
//            @catch (NSException * e) {
//                NSLog(@"Bad path: %@",e);
//            }
//        }
//        [delegate performSelector:@selector(pathSource:didReceivePaths:) withObject:self withObject:paths];
//    }
//    else{
//        NSLog(@"Non-array found from path data");   
//    }
//    
//    [parser release];

    
    
}


-(void) failedScenarioDownloadWithError:(NSError*) error
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"A problem" message:@"Sorry - there was a problem with the app.  Please inform the Amblr Team" delegate:nil cancelButtonTitle:@"*Sigh*" otherButtonTitles: nil];
    [alert show];
    
    
}


+(L1Scenario*) scenarioFromStoryURL:(NSString*) url withKey:(NSString *)scenarioKey
{
    L1Scenario * scenario = [[L1Scenario alloc] init];
    scenario.key = scenarioKey;

    [scenario startStoryDownload:url];
    return [scenario autorelease];
}

+(L1Scenario*) scenarioFromStoryFile:(NSString*) filename withKey:(NSString *)scenarioKey
{
    L1Scenario * scenario = [[L1Scenario alloc] init];
    scenario.key = scenarioKey;
    NSData * data = [NSData dataWithContentsOfFile:filename];
    [scenario downloadedStoryData:data withResponse:nil];
    return [scenario autorelease];
}


//-(void) downloadStoryList:(NSString*) urlString
//{
//        
//}
//
//
//+(L1Scenario*) scenarionFromScenarioURLString:(NSString*) urlString
//{
//    L1Scenario * scenario = [[L1Scenario alloc] init];
//    [scenario downloadStoryList:urlString];
//    return  [scenario autorelease];
//}


+(L1Scenario*) fakeScenarioFromNodeFile:(NSString*)nodeFile pathFile:(NSString*)pathFile delegate:(id) delegate
{
    L1Scenario * scenario = [[L1Scenario alloc] init];
    scenario.key = @"my_fake_scenario";
    scenario.delegate = delegate;
    NSData * nodeData=  [NSData dataWithContentsOfFile:nodeFile];
    NSData * pathData=  [NSData dataWithContentsOfFile:pathFile];
    [scenario downloadedNodeData:nodeData withResponse:nil];
    [scenario downloadedPathData:pathData withResponse:nil];
    return [scenario autorelease];
    
}

+(L1Scenario*) scenarioFromNodesURL:(NSString*) nodesURL pathsURL:(NSString*) pathsURL  withKey:(NSString *)scenarioKey
{
    L1Scenario * scenario = [[L1Scenario alloc] init];
    scenario.key = scenarioKey;

    scenario.pathURL = pathsURL;
    [scenario startNodeDownload:nodesURL];
    return [scenario autorelease];
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

-(void) startPathDownload:(NSString *) url
{
	SimpleURLConnection * connection = [[SimpleURLConnection alloc] initWithURL:url 
                                         delegate:self
                                         passSelector:@selector(downloadedPathData:withResponse:) 
                                         failSelector:@selector(failedPathDownloadWithError:) ];
	
	
	[connection.request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
	[connection runRequest];
}



-(int) nodeCount{
	return [nodes count];
}

-(int) pathCount{
	return [paths count];
}




-(void) downloadedNodeData:(NSData*) data withResponse:(NSHTTPURLResponse*) response
{
    NSLog(@"Node data downloaded");
	SBJsonParser * parser = [[SBJsonParser alloc] init];
	NSArray * nodeArray = [parser objectWithData:data];
	[parser release];
	int i=0;
	for(NSDictionary * nodeDictionary in nodeArray){
        @try{
		L1Node * node = [[L1Node alloc] initWithDictionary:nodeDictionary key:[nodeDictionary objectForKey:@"id"]];
		[nodes setObject:[node autorelease] forKey:node.key];
//        CLLocation * nodeLocation = [[CLLocation alloc] initWithLatitude:[node.latitude doubleValue] longitude:[node.longitude doubleValue]];
//        CLLocationDistance dist = [nodeLocation distanceFromLocation:locationManager.location];
        //NSLog(@"Distance from %@ = %f (%@,%@)",node.name,dist,nodeLocation,locationManager.location);
            
            if (i%4==0){
                //NSLog(@"ACTIVE NODE NAME IS %@",node.name);
                //[node registerAmbientSound];
                //[node playAmbientSound];
            }
            i++;
        }
        @catch (NSException *e ) {
            NSLog(@"Bad node: %@",e);
        }
	}
	
	[delegate performSelector:@selector(nodeSource:didReceiveNodes:) withObject:self withObject:nodes];
//	[self startMonitoringAllNodesProximity];
    
    if (self.pathURL) [self startPathDownload:self.pathURL];
    self.pathURL = nil;

}



-(void) downloadedPathData:(NSData*) data withResponse:(NSHTTPURLResponse*) response
{
    NSLog(@"Paths data downloaded");
	SBJsonParser * parser = [[SBJsonParser alloc] init];
	NSArray * pathArray = [parser objectWithData:data];
	[parser release];
    
    if (pathArray){
        if ([pathArray isKindOfClass:[NSArray class]]){
         	for(NSDictionary * pathDictionary in pathArray){
                @try{
                L1Path * path = [[L1Path alloc] initWithDictionary:pathDictionary nodeSource:nodes];
                [paths setObject:path forKey:path.key];
                }
                @catch (NSException * e) {
                    NSLog(@"Bad path: %@",e);
                }
            }
            [delegate performSelector:@selector(pathSource:didReceivePaths:) withObject:self withObject:paths];
        }
        else{
            NSLog(@"Non-array found from path data");   
        }
    }
    else {
        NSLog(@"Could not parse path data as JSON");
    }
	
	//[self startMonitoringAllNodesProximity];

}




- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
	return [nodes countByEnumeratingWithState:state objects:stackbuf count:len];
}


-(void) failedNodeDownloadWithError:(NSError*) error
{
	NSLog(@"Node download failed: you are disgrace to humanity.\nError was: %@",error);
    SEL selector = @selector(nodeDownloadFailedForScenario:);
    if ([delegate respondsToSelector:selector]){
        [delegate performSelector:selector withObject:self];
    }
}


-(void) failedPathDownloadWithError:(NSError*) error
{
	NSLog(@"Path download failed: you are hateful fool.\nError was: %@",error);
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
	NSLog(@"The node %@ generated the experience %@ at %@",node.name,experience.eventID,experience.date);
}

-(L1Experience*) node:(L1Node*) node requestsExperience:(L1Experience*)requestedExperience
{
	NSString * targetEventID = requestedExperience.eventID;
	return [experiences objectForKey:targetEventID];
}

-(L1Experience*) node:(L1Node*) node requestsExperienceByName:(NSString*) name
{
	return [experiences objectForKey:name];
	
}

-(void) startMonitoringNodeProximity:(L1Node*)node
{
    NSLog(@"Region from %@",[node class]);
//    CLRegion * region = [node region];
	[locationManager startMonitoringForRegion:[node region] desiredAccuracy:0.0];
//    if ([region containsCoordinate:locationManager.location.coordinate]){
//        NSLog(@"Started inside region");
//        [self locationManager:locationManager didEnterRegion:region];
//    }
	
}

-(void) startMonitoringAllNodesProximity
{
    NSArray * nodeValues = [nodes allValues];
    for(L1Node * node in nodeValues){
		[self startMonitoringNodeProximity:node];
	}
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
//	NSLog(@"Approached the region for a node: %@",region);
//    NSString * text = [NSString stringWithFormat:@"You are near the %@",region.identifier];
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Pub Found!" message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Pub Found" message:@"Why not visit the lovely pub that is nearby?" delegate:self cancelButtonTitle:@"OK",nil];
//    [alert show];
//    [alert autorelease];
    NSString * identifier = region.identifier;
    L1Node * node = [nodes objectForKey:identifier];
    if (node){
        SEL selector = @selector(triggeredNode:);
        if ([delegate respondsToSelector:selector]){
            [delegate performSelector:selector withObject:node];
        }
    }
//	
}


-(void) locationManager:(SimulatedLocationManager*) locationManager didUpdateToLocation:(CLLocation*)toLocation fromLocation: (CLLocation*)fromLocation
{
    
    SoundManager* soundManager = [SoundManager sharedSoundManager];
    [soundManager updateListenerPosX:[NSNumber numberWithFloat:toLocation.coordinate.latitude] posY:[NSNumber numberWithFloat:toLocation.coordinate.longitude]];
}


-(NSMutableDictionary*) nodesBetweenDates:(NSDate*) startDate and:(NSDate*) endDate
{
    NSMutableDictionary * outputNodes = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for (NSString * nodeKey in self.nodes){
        L1Node * node = [self.nodes objectForKey:nodeKey];
        NSDate * date = [node.metadata objectForKey:@"date"];
        if (!date) continue;
        if ([date compare:startDate]==NSOrderedAscending) continue;
        if ([date compare:endDate]==NSOrderedDescending) continue;
        [outputNodes setObject:nodes forKey:nodeKey];
    }
    return outputNodes;
    
}

@end
