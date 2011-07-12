//
//  L1Path.m
//  locations1
//
//  Created by Joe Zuntz on 08/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1Path.h"
#import "L1Node.h"
#import "L1Resource.h"
#import <MapKit/MapKit.h>

@implementation L1Path
@synthesize name, description, key, metadata, enabled, nodes;


-(id) initWithDictionary:(NSDictionary*) pathDictionary nodeSource:(NSDictionary*) nodeSource
{
	self = [super init];
	if (self){
        self.key = [pathDictionary objectForKey:@"id"]; 
		[self setStateFromDictionary:pathDictionary];
        NSArray * nodeNames = [pathDictionary objectForKey:@"node_ids"];
//        NSLog(@"nodes = %@",nodeNames);
        [self extractNodes:nodeNames fromSource:nodeSource];
	}
	return self;
}

-(void) setStateFromDictionary:(NSDictionary*) pathDictionary
{
	self.name = [pathDictionary objectForKey:@"title"]; 
	self.description = [pathDictionary objectForKey:@"description"]; 
    self.metadata = [pathDictionary objectForKey:@"meta_data"];
}

-(void) extractNodes:(NSArray*)nodeNames fromSource:(NSDictionary*) nodeSource
{
    self.nodes = [NSMutableArray arrayWithCapacity:[nodeNames count]];
    for (NSString * nodeName in nodeNames){
        L1Node * node = [nodeSource objectForKey:nodeName];
        if (node) [self.nodes addObject:node];
        else NSLog(@"Node in path missing from source: %@",nodeName);
    }
}

-(MKPolyline*) polyline
{
    NSUInteger number_nodes = [self length];
    CLLocationCoordinate2D coordinates[number_nodes];
    for (int i=0;i<number_nodes;i++){
        L1Node * node = [self.nodes objectAtIndex:i];
        coordinates[i] = node.coordinate;
        NSLog(@"   line[%d] = %f,%f (%@) ",i,coordinates[i].latitude,coordinates[i].longitude,node.name);
    }
    NSLog(@"Made polyline from %d nodes",number_nodes);
    MKPolyline * polyline = [MKPolyline polylineWithCoordinates:coordinates count:number_nodes]; 
    return polyline;

}

-(NSUInteger) length
{    
    return [self.nodes count];
}

-(NSString*) title
{
    return self.name;
}

-(NSString*) subtitle
{
    return self.description;
}

-(CLLocationCoordinate2D) coordinate
{
    if (![self.nodes count]){
        //No nodes yet; this is an unset path.
        NSLog(@"Warning; tried to annotate unset path %@",self.name);
        CLLocationCoordinate2D badLocation;
        badLocation.latitude=0.0;
        badLocation.longitude=0.0;
        return badLocation;
    }
    L1Node * firstNode = [self.nodes objectAtIndex:0];
    return [firstNode coordinate];
    
}

-(NSMutableArray*) locationArray
{
    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
    for (L1Node * node in self.nodes)
    {
        [array addObject:[node location]];
    }
    return array;
}

@end
