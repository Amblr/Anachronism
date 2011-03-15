//
//  AmblrNode.m
//  locations1
//
//  Created by Joe Zuntz on 15/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "AmblrNode.h"
#import <CoreLocation/CoreLocation.h>

@implementation AmblrNode

@synthesize name;
@synthesize latitude;
@synthesize longitude;
@synthesize radius;
@synthesize image;
@synthesize text;



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
	name = [[nodeDictionary objectForKey:@"name"] retain]; 
	text = [[nodeDictionary objectForKey:@"description"] retain]; 
	radius = [[nodeDictionary objectForKey:@"radius"] retain];
	
	NSArray * coords = [nodeDictionary objectForKey:@"coords"];
	latitude = [[coords objectAtIndex:0] retain];
	longitude = [[coords objectAtIndex:1] retain];
	
	assigned=NO;
	
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


//@synthesize coordinate;
@synthesize delegate;
@synthesize enabled,assigned;
@synthesize key;
@synthesize date;
@end
