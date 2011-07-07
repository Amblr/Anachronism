//
//  L1Node.m
//  locations1
//
//  Created by Joe Zuntz on 15/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "L1Node.h"
#import "L1Experience.h"


static NSDateFormatter * dateParser = nil;

@implementation L1Node

@synthesize name;
@synthesize latitude;
@synthesize longitude;
@synthesize radius;
@synthesize image;
@synthesize text;
@synthesize metadata;
@synthesize resources;
@synthesize visible;
@synthesize date;

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
    NSNumber * visibliityNumber = [nodeDictionary objectForKey:@"visible"];
    self.visible = [visibliityNumber boolValue];

    if (dateParser==nil){
        dateParser = [[NSDateFormatter alloc] init];
                                  //2011-05-24T15:50:45Z
        [dateParser setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];

    }
        NSString * dateString = [self.metadata objectForKey:@"date"];
    self.date = [dateParser dateFromString:dateString];
    NSLog(@"date = %@ (%@)",self.date,[nodeDictionary objectForKey:@"created_at"]);

    /* Resources.  Get an array of them. */
    self.resources = [[[NSMutableArray alloc] init] autorelease];
    NSArray * resourceDictionaryArray = [nodeDictionary objectForKey:@"resource_hooks"];
    for (NSDictionary * resourceHookDictionary in resourceDictionaryArray){
        NSDictionary * resourceDictionary = [resourceHookDictionary objectForKey:@"resource"];
        L1Resource * resource = [[L1Resource alloc] initWithDictionary:resourceDictionary];
        resource.saveLocal = YES;
        [self.resources addObject:resource];
        [resource autorelease];
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
	return [[[CLRegion alloc] initCircularRegionWithCenter:self.coordinate radius:r identifier:self.key] autorelease];
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

-(CLLocation*) location
{
    CLLocation * location  = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    return [location autorelease];
    
}

-(void) registerAmbientSound{
//    for(NSDictionary* resource in resources){
//        if ([metadata objectForKey:@"role"]){
           NSArray* location = [NSArray arrayWithObjects:latitude, longitude,[NSNumber numberWithFloat:0.0], nil];
            
            SoundManager* soundManager=[SoundManager sharedSoundManager];
            NSArray* soundNames = [NSArray arrayWithObjects:@"nodeSound",@"crowd",@"dog",@"thunder", nil];
            NSString* randomSoundName = [soundNames objectAtIndex: (rand()%4)];
            NSLog(@"assigning %@",randomSoundName);
            
            [soundManager createSource:randomSoundName withExtnesion:@"caf" withKey:self.key gain:1.0 pitch:1.0 frequency:44100 location:location loops:YES];
//        }
//    }
}

-(void) playAmbientSound{
    SoundManager* soundManager=[SoundManager sharedSoundManager];
    [soundManager activateSourceWithKey:self.key];
}

-(void) stopAmbientSound{
    SoundManager* soundManager=[SoundManager sharedSoundManager];
    [soundManager stopSourceWithKey:self.key ];
}


//@synthesize coordinate;
@synthesize delegate;
@synthesize enabled;
@synthesize key;
@synthesize mode;
@end
