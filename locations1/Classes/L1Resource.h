//
//  L1Resource.h
//  locations1
//
//  Created by Joe Zuntz on 04/04/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface L1Resource : NSObject {
    NSString * name;
    NSString * url;
    NSString * type;
    BOOL local;
    BOOL saveLocal;
    NSString * localFilename;
    NSString * key;
    NSMutableDictionary * metadata;
    NSData * resourceData;
}

-(id) initWithDictionary:(NSDictionary*) data;
-(id) initWithKey:(NSString*) resourceKey;
-(NSString*) localFileName;


@property (retain) NSString * name;
@property (retain) NSString * url;
@property (retain) NSString * type;
@property (assign) BOOL local;
@property (assign) BOOL saveLocal;
@property (retain) NSString * key;
@property (retain) NSMutableDictionary * metadata;
@property (retain) NSData * resourceData;


@end
