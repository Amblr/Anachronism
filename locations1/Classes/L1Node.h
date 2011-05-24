//
//  L1Node.h
//  locations1
//
//  Created by Joe Zuntz on 15/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import "L1Resource.h"
#import "SoundManager.h"

#define STANDARD_NODE_RADIUS 50.0  //meters


//Nodes have state
//They have pre-requisites, which change their availability and state.

@class L1Node;
@class L1Experience;
@protocol L1NodeDelegate

-(void) nodeWasSelected:(L1Node*)node;
-(void) node:(L1Node*) node didChangeState:(NSString*)state;
-(void) node:(L1Node*) node didCreateExperience:(L1Experience*)experience;
-(L1Experience*) node:(L1Node*) node requestsExperience:(L1Experience*)experience;
-(L1Experience*) node:(L1Node*) node requestsExperienceByName:(NSString*) name;

@end



@interface L1Node : NSObject<MKAnnotation> {
	NSNumber * latitude;
	NSNumber * longitude;
	NSNumber * radius;
	NSString * text;
	NSString * name;
    BOOL visible;
	UIImage  * image;
    NSMutableDictionary * metadata;
    NSMutableArray * resources;
    
	NSObject<L1NodeDelegate> * delegate;
	//JAZ We need a key field for this.  "Name" is probably a user friendly name
	//So we add another
	NSString * key;
	//Eventually this should contain an L1NodeContent instance.
	//Which should know what its associated view is, and how to
	//display itself.
	BOOL enabled;
}


@property (retain) 	NSObject<L1NodeDelegate> * delegate;
@property (retain) NSMutableDictionary * metadata;
@property (retain) NSMutableArray * resources;
@property (retain) NSNumber * latitude;
@property (retain) NSNumber * longitude;
@property (copy) NSString * key;
@property (retain) NSNumber * radius;
@property (retain) NSString * text;
@property (retain) NSString * name;
@property (retain) UIImage * image;
@property (assign) BOOL enabled;
@property (assign) BOOL visible;


-(id) initWithDictionary:(NSDictionary*) nodeDictionary key:(NSString*)keyName;

//Separate this out so that sub-classes can use it
//apart from the initializer.
-(void) setStateFromDictionary:(NSDictionary*) nodeDictionary;

-(CLRegion*) region;
-(CLLocation*) location;


// MKAnnotation protocol
-(NSString*) title;
-(NSString*) subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

//Sub-classes should override this to decide whether or not to 
//make the node visible, depending on the user experiences.
-(BOOL) isVisible;
-(L1Experience*) generateVisitedExperience;

-(void) registerAmbientSound;
-(void) playAmbientSound;
@end


