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
#import "L1Path.h"


@implementation L1Scenario
@synthesize nodes;
@synthesize paths;
@synthesize delegate;
@synthesize pathURL;

-(id) init{
	self = [super init];
	if (self){
		nodes = [[NSMutableDictionary alloc] init];
		paths = [[NSMutableDictionary alloc] init];
		experiences = [NSMutableDictionary dictionaryWithCapacity:0];
//		locationManager = [[CLLocationManager alloc] init];
        locationManager = [[SimulatedLocationManager alloc] init];
        
		locationManager.delegate=self;
        nodesReady = NO;
        pathsReady = NO;
        pathURL = nil;
#warning NEED TO CHECK IF USER HAS ENABLED LOCATION SERVICES
	}
	return self;
}




+(L1Scenario*) scenarioFromURL:(NSString*) url
{
    L1Scenario * scenario = [[L1Scenario alloc] init];
    [scenario startNodeDownload:url];
    return scenario;
}


+(L1Scenario*) fakeScenarioFromNodeFile:(NSString*)nodeFile pathFile:(NSString*)pathFile delegate:(id) delegate
{
    L1Scenario * scenario = [[L1Scenario alloc] init];
    scenario.delegate = delegate;
    NSData * nodeData=  [NSData dataWithContentsOfFile:nodeFile];
    NSData * pathData=  [NSData dataWithContentsOfFile:pathFile];
    [scenario downloadedNodeData:nodeData withResponse:nil];
    [scenario downloadedPathData:pathData withResponse:nil];
    return scenario;
    
}

+(L1Scenario*) scenarioFromNodesURL:(NSString*) nodesURL pathsURL:(NSString*) pathsURL
{
    L1Scenario * scenario = [[L1Scenario alloc] init];
    scenario.pathURL = pathsURL;
    [scenario startNodeDownload:nodesURL];
    return scenario;
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
	
	for(NSDictionary * nodeDictionary in nodeArray){
        @try{
		L1Node * node = [[L1Node alloc] initWithDictionary:nodeDictionary key:[nodeDictionary objectForKey:@"id"]];
		[nodes setObject:[node autorelease] forKey:node.key];
        CLLocation * nodeLocation = [[CLLocation alloc] initWithLatitude:[node.latitude doubleValue] longitude:[node.longitude doubleValue]];
        CLLocationDistance dist = [nodeLocation distanceFromLocation:locationManager.location];
        NSLog(@"Distance from %@ = %f (%@,%@)",node.name,dist,nodeLocation,locationManager.location);
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
    NSString * str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%@",str);
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
	
//	[self startMonitoringAllNodesProximity];

}




- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
	return [nodes countByEnumeratingWithState:state objects:stackbuf count:len];
}


-(void) failedNodeDownloadWithError:(NSError*) error
{
	NSLog(@"Node download failed: you are disgrace to humanity.\nError was: %@",error);
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
    CLRegion * region = [node region];
	[locationManager startMonitoringForRegion:[node region] desiredAccuracy:0.0];
    if ([region containsCoordinate:locationManager.location.coordinate]){
        NSLog(@"Started inside region");
        [self locationManager:locationManager didEnterRegion:region];
    }
	
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
	NSLog(@"Approached the region for the node named %@",region);
    NSString * text = [NSString stringWithFormat:@"You are near the %@",region.identifier];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Pub Found!" message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Pub Found" message:@"Why not visit the lovely pub that is nearby?" delegate:self cancelButtonTitle:@"OK",nil];
    [alert show];
	
}




@end
