//
//  L1Node.m
//  locations1
//
//  Created by Joe Zuntz on 15/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "L1Node.h"
#import "L1Experience.h"

@implementation L1Node

@synthesize name;
@synthesize latitude;
@synthesize longitude;
@synthesize radius;
@synthesize image;
@synthesize text;
@synthesize metadata;
@synthesize resources;

-(id) initWithDictionary:(NSDictionary*) nodeDictionary
{
	self = [super init];
	if (self){
        self.key=[nodeDictionary objectForKey:@"id"];

		[self setStateFromDictionary:nodeDictionary];
	}
	return self;
}



-(id) initWithDictionary:(NSDictionary*) nodeDictionary key:(NSString*)keyName
{
	self = [super init];
	if (self){
		[self setStateFromDictionary:nodeDictionary];
	}
	self.key=keyName;
	return self;
}

-(void) setStateFromDictionary:(NSDictionary*) nodeDictionary
{
	self.name = [nodeDictionary objectForKey:@"name"]; 
	self.text = [nodeDictionary objectForKey:@"description"]; 
    NSLog(@"desc = %@", self.text);
	self.radius = [nodeDictionary objectForKey:@"radius"];
	NSArray * coords = [nodeDictionary objectForKey:@"coords"];
	self.latitude = [coords objectAtIndex:0];
	self.longitude = [coords objectAtIndex:1];
    self.metadata = [nodeDictionary objectForKey:@"meta_data"];

    /* Resources.  Get an array of them. */
    self.resources = [[[NSMutableArray alloc] init] autorelease];
    NSArray * resourceDictionaryArray = [nodeDictionary objectForKey:@"resources"];
    for (NSDictionary * resourceDictionary in resourceDictionaryArray){
        L1Resource * resource = [[L1Resource alloc] initWithDictionary:resourceDictionary];
        [self.resources addObject:resource];
    }
	
}


-(NSString*) title{
	return self.name;
}
-(NSString*) subtitle{
	return self.text;
}


-(CLLocationCoordinate2D) coordinate
{
	CLLocationCoordinate2D value;
	value.latitude=[latitude floatValue];
	value.longitude=[longitude floatValue];
	return value;
}

-(void) setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
	
	latitude=[NSNumber numberWithFloat: newCoordinate.latitude];
	longitude=[NSNumber numberWithFloat: newCoordinate.longitude];
	
}


-(BOOL) isVisible
{
	return YES;
	
}

-(CLRegion*) region
{
	CLLocationDistance r = [self.radius doubleValue];
	r=STANDARD_NODE_RADIUS;
#warning Ignoring node radii 
    
	return [[[CLRegion alloc] initCircularRegionWithCenter:self.coordinate radius:r identifier:self.name] autorelease];
	
}

-(L1Experience*) generateVisitedExperience
{
	L1Experience * experience = [[L1Experience alloc] init];
	experience.date = [NSDate date];
	experience.eventID = [@"Visited " stringByAppendingString:self.key];
	SEL call = @selector(node:didCreateExperience:);
	if ([self.delegate respondsToSelector:call]) [self.delegate performSelector:call withObject:self withObject:experience];
	return [experience autorelease];
	
}

//@synthesize coordinate;
@synthesize delegate;
@synthesize enabled;
@synthesize key;
@end
