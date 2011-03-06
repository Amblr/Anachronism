//
//  AmblrNode.h
//  locations1
//
//  Created by Joe Zuntz on 15/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

#define STANDARD_NODE_RADIUS 20.0  //meters


//Nodes have state
//They have pre-requisites, which change their availability and state.

@class AmblrNode;
@protocol AmblrNodeDelegate

-(void) nodeWasSelected:(AmblrNode*)node;
-(void) node:(AmblrNode*) node didChangeState:(NSString*)state;
@end



@interface AmblrNode : NSObject<MKAnnotation> {
	NSNumber * latitude;
	NSNumber * longitude;
	NSNumber * radius;
	NSString * text;
	NSString * name;
	UIImage  * image;
	NSObject<AmblrNodeDelegate> * delegate;
	//JAZ We need a key field for this.  "Name" is probably a user friendly name
	//So we add another
	NSString * key;
	//Eventually this should contain an AmblrNodeContent instance.
	//Which should know what its associated view is, and how to
	//display itself.
	BOOL enabled;
}


@property (retain) 	NSObject<AmblrNodeDelegate> * delegate;
@property (retain) NSNumber * latitude;
@property (retain) NSNumber * longitude;
@property (copy) NSString * key;
@property (retain) NSNumber * radius;
@property (retain) NSString * text;
@property (retain) NSString * name;
@property (retain) UIImage * image;
@property (assign) BOOL enabled;


-(id) initWithDictionary:(NSDictionary*) nodeDictionary key:(NSString*)keyName;

//Separate this out so that sub-classes can use it
//apart from the initializer.
-(void) setStateFromDictionary:(NSDictionary*) nodeDictionary;



// MKAnnotation protocol
-(NSString*) title;
-(NSString*) subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end


