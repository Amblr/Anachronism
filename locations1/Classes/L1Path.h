//
//  L1Path.h
//  locations1
//
//  Created by Joe Zuntz on 08/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface L1Path : NSObject<MKAnnotation> {
    NSString * key;
    NSString * name;
    NSString * description;
    NSMutableArray * nodes;
    NSMutableDictionary * metadata;
    NSMutableArray * resources;
    BOOL enabled;
}
@property (retain) NSMutableArray * nodes;
@property (retain) NSString * key;
@property (retain) NSString * name;
@property (retain) NSString * description;
//@property (retain) UIImage * image;
@property (retain) NSMutableDictionary * metadata;
//@property (retain) NSMutableArray * resources;
@property (assign) BOOL enabled;

-(id) initWithDictionary:(NSDictionary*) pathDictionary nodeSource:(NSDictionary*) nodeSource;
-(void) setStateFromDictionary:(NSDictionary*) pathDictionary;
-(void) extractNodes:(NSArray*) nodeNames fromSource:(NSDictionary*)nodeSource;
-(NSUInteger) length;
-(MKPolyline*) polyline;
@end
