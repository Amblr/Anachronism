//
//  SoundManager.h
//  soundDemo3D
//
//  Created by Stuart Lynn on 20/05/2011.
//  Copyright 2011 me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>

#define kMaxSources 32
#define kRefrenceDistance 0.0003
#define kMaxDistance 0.2

@interface SoundManager : NSObject {
    ALCcontext *context;
    
    ALCdevice *outputDevice;
    
    NSMutableDictionary* soundSources;
    NSMutableArray* soundList;
    NSMutableArray* listenerPosition;
    NSMutableDictionary* cachedSounds;
    
}

-(id) init;
-(NSUInteger) createSource:(NSString*) filename withExtnesion:(NSString*) extension withKey:(NSString*) soundKey gain:(ALfloat) gain pitch:(ALfloat) pitch frequency:(ALfloat)frequency location:(NSArray*) loc loops:(BOOL)loops;
-(NSUInteger) activateSourceWithKey:(NSString*) key;
-(NSUInteger) nextAvaliableSource;
- (UInt32) audioFileSize:(AudioFileID)fileDescriptor;
-(void) stopSourceWithKey:(NSString*)key;
-(NSNumber*) getSourceForKey:(NSString*) key;
+(SoundManager *) sharedSoundManager;
-(void) shutdownSoundManager;
-(void) updateListenerPosX:(NSNumber *)xPos;
-(void) updateListenerPosY:(NSNumber *)yPos;
-(void) updateListenerPosX:(NSNumber *)xPos posY:(NSNumber*) yPos;
-(void)setLocationOfSoundWithKey:(NSString*)key xPos:(NSNumber*)x yPos:(NSNumber*) y;

-(AudioFileID) openAudioFile:(NSString*) filePath;

@property (retain) NSMutableArray* listenerPosition;
@property (retain) NSMutableDictionary* soundSources;
@property (retain) NSMutableDictionary* cachedSounds;

@property (retain) NSMutableArray* soundList;
@end

