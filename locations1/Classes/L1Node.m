//
//  L1Node.m
//  locations1
//
//  Created by Joe Zuntz on 15/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1Node.h"


@implementation L1Node

@synthesize name;
@synthesize latitude;
@synthesize longitude;
@synthesize radius;
@synthesize image;
@synthesize text;



-(id) initWithDictionary:(NSDictionary*) nodeDictionary
{
	self = [super init];
	if (self){
		[self setStateFromDictionary:nodeDictionary];
	}
	return self;
}

-(void) setStateFromDictionary:(NSDictionary*) nodeDictionary
{
	name = [[nodeDictionary objectForKey:@"name"] retain]; 
	text = [[nodeDictionary objectForKey:@"description"] retain]; 
	radius = [[nodeDictionary objectForKey:@"radius"] retain];
	
	NSArray * coords = [nodeDictionary objectForKey:@"coords"];
	latitude = [[coords objectAtIndex:0] retain];
	longitude = [[coords objectAtIndex:1] retain];
	
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


@synthesize coordinate;


@end
