//
//  L1Node.h
//  locations1
//
//  Created by Joe Zuntz on 15/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>


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
	UIImage  * image;
	id<L1NodeDelegate> delegate;
	//Eventually this should contain an L1NodeContent instance.
	//Which should know what its associated view is, and how to
	//display itself.
}


@property (retain) 	id<L1NodeDelegate> delegate;
@property (retain) NSNumber * latitude;
@property (retain) NSNumber * longitude;
@property (retain) NSNumber * radius;
@property (retain) NSString * text;
@property (retain) NSString * name;
@property (retain) UIImage * image;

-(id) initWithDictionary:(NSDictionary*) nodeDictionary;

//Separate this out so that sub-classes can use it
//apart from the initializer.
-(void) setStateFromDictionary:(NSDictionary*) nodeDictionary;


// MKAnnotation protocol
-(NSString*) title;
-(NSString*) subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

//Sub-classes should override this to decide whether or not to 
//make the node visible, depending on the user experiences.
-(BOOL) isVisible;


@end


