//
//  L1Resource.h
//  locations1
//
//  Created by Joe Zuntz on 04/04/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum L1SoundType {
    L1SoundTypeSpeech,
    L1SoundTypeMusic,
    L1SoundTypeAtmos,
    L1SoundTypeOther,
    L1SoundTypeUnknown,
} L1SoundType;




@interface L1Resource : NSObject {
    NSString * name;
    NSString * url;
    NSString * type;
    BOOL local;
    BOOL downloading;
    BOOL saveLocal;
    NSString * localFilename;
    NSString * key;
    NSMutableDictionary * metadata;
    NSData * resourceData;
    L1SoundType soundType;
}

-(id) initWithDictionary:(NSDictionary*) data;
-(id) initWithKey:(NSString*) resourceKey;
-(NSString*) localFileName;
-(void) flush;


+(void) setupHHSpeechNodes;

@property (retain) NSString * name;
@property (retain) NSString * url;
@property (retain) NSString * type;
@property (assign) BOOL local;
@property (assign) BOOL downloading;
@property (assign) BOOL saveLocal;
@property (retain) NSString * key;
@property (retain) NSMutableDictionary * metadata;
@property (retain) NSData * resourceData;
@property (assign) L1SoundType soundType;


-(void) downloadResourceData;

@end
