//
//  L1Scenario.h
//  locations1
//
//  Created by Joe Zuntz on 19/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "L1Node.h"
#import "L1Path.h"

#import "SimulatedLocationManager.h"
#import <CoreLocation/CoreLocation.h>
//Has many nodes
//Has many plots
//Each plot can have many nodes
//Has many user experiences



@interface L1Scenario : NSObject<NSFastEnumeration,L1NodeDelegate,CLLocationManagerDelegate> {
	NSMutableDictionary * nodes;
	NSMutableDictionary * paths;
	NSMutableDictionary * experiences;
    NSString * key;
//	CLLocationManager * locationManager;
    SimulatedLocationManager * locationManager;
    
    L1Node * activeNode;
    L1Path * activePath;
    
	id delegate;
    BOOL nodesReady, pathsReady;
    NSString * pathURL;

}
@property (retain) NSMutableDictionary * paths;
@property (retain) NSMutableDictionary * nodes;
@property (retain) L1Node * activeNode;
@property (retain) L1Path * activePath;
@property (retain) NSString * key;
@property (retain) id delegate;
@property (retain) NSString * pathURL;
-(int) nodeCount;
-(int) pathCount;

-(void) downloadedNodeData:(NSData*) data withResponse:(NSHTTPURLResponse*) response;
-(void) failedNodeDownloadWithError:(NSError*) error;
-(void) startNodeDownload:(NSString *) url;

-(void) startPathDownload:(NSString *) url;
-(void) downloadedPathData:(NSData*) data withResponse:(NSHTTPURLResponse*) response;
-(void) failedPathDownloadWithError:(NSError*) error;

-(void) startScenarioDownload:(NSString*)urlString;
-(void) downloadedScenarioData:(NSData*) data withResponse:(NSHTTPURLResponse*) response;
-(void) failedScenarioDownloadWithError:(NSError*) error;

-(void) startStoryDownload:(NSString*)urlString;
-(void) failedStoryDownloadWithError:(NSError*) error;
-(void) downloadedStoryData:(NSData*) data withResponse:(NSHTTPURLResponse*) response;


-(void) walkPath:(L1Path*)path;

-(void) downloadedStoryData:(NSData*) data withResponse:(NSHTTPURLResponse*) response;

-(void) startMonitoringAllNodesProximity;
-(void) startMonitoringNodeProximity:(L1Node*)node;
+(L1Scenario*) scenarioFromStoryURL:(NSString*) url withKey:(NSString*)scenarioKey;
+(L1Scenario*) scenarioFromScenarioURL:(NSString*) url withKey:(NSString*)scenarioKey;
+(L1Scenario*) scenarioFromNodesURL:(NSString*) nodesURL pathsURL:(NSString*) pathsURL withKey:(NSString*)scenarioKey;
+(L1Scenario*) fakeScenarioFromNodeFile:(NSString*)nodeFile pathFile:(NSString*)pathFile delegate:(id) delegate;
@end
