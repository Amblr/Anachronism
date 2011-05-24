//
//  SoundManager.m
//  soundDemo3D
//
//  Created by Stuart Lynn on 20/05/2011.
//  Copyright 2011 me. All rights reserved.
//

#import "SoundManager.h"


@implementation SoundManager

@synthesize  listenerPosition;
@synthesize soundSources;
@synthesize cachedSounds;

@synthesize soundList;

static SoundManager* sharedSoundManager = nil;

+(SoundManager *) sharedSoundManager{
    
    @synchronized(self){
        if(sharedSoundManager==nil){
            [[self alloc] init]; 
        }
    }
    return sharedSoundManager;
}


-(id) init{
    NSLog(@"running init");
    if(self =[super init]){
        NSLog(@"super worked");
        self.soundList = [NSMutableArray arrayWithCapacity:0];
        self.soundSources = [NSMutableDictionary dictionaryWithCapacity:0];
        self.listenerPosition =[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0],
            [NSNumber numberWithFloat:0],
                           [NSNumber numberWithFloat:0],nil] ;
        self.cachedSounds = [NSMutableDictionary dictionaryWithCapacity:0];
        ALfloat pos[3];
        pos[0]=0;
        pos[1]=0;
        pos[3]=0.0;

        
       //[self updateListenerPos];
        
        BOOL result = [self initOpenAL];
        if(!result) {NSLog(@"openAL initalisation worked");return nil;}
        return self;
    }
    NSLog(@"failed to initaise openAL with error");
    [self release];
    return nil;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedSoundManager == nil) {
            sharedSoundManager = [super allocWithZone:zone];
            return sharedSoundManager;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}

-(BOOL) initOpenAL{
    NSLog(@"trying to initalize openAL");
    outputDevice =alcOpenDevice(NULL);
    if (outputDevice){
        NSLog(@"got output device ");
        context= alcCreateContext(outputDevice, NULL);
        alcMakeContextCurrent(context);
        
        
        alcGetEnumValue(NULL, "ALC_RENDER_CHANNEL_COUNT_STEREO");
        alcGetEnumValue(NULL, "ALC_SPATIAL_RENDERING_QUALITY_HIGH");
        alDistanceModel(AL_INVERSE_DISTANCE);
      


            
        NSUInteger sourceID;
        for(int i=0; i< kMaxSources; i++){
            alGenSources(1, &sourceID);
            [soundList addObject:[NSNumber numberWithUnsignedInt:sourceID]];
        }
        NSLog(@"returning yes");
        return YES;
    }
    NSLog(@"returning no");
    return NO;
}


-(void) shutdownSoundManager{
    @synchronized(self){
        if(sharedSoundManager !=nil){
            [self dealloc];
        }
    }
}

-(NSUInteger) createSource:(NSString*) filename withExtnesion:(NSString*) extension withKey:(NSString*) soundKey gain:(ALfloat) gain pitch:(ALfloat) pitch frequency:(ALfloat)frequency location:(NSArray*) loc loops:(BOOL)loops{
    NSLog(@"creating sound");
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    NSLog(@"opening audio file");
    NSUInteger bufferId=NULL;
    unsigned char* data=NULL;

    if ([cachedSounds objectForKey:filename]){
        NSLog(@"getting cached sound ");
        bufferId=[[cachedSounds objectForKey:filename] unsignedIntValue];
    }
    
    
    if(bufferId==NULL){
        AudioFileID fileId = [self openAudioFile:filePath];
        
        UInt32 fileSize = [self audioFileSize:fileId];
        
        data= malloc(fileSize);
        
        OSStatus result = noErr;
        NSLog(@"loading in to buffer");
        result = AudioFileReadBytes(fileId, FALSE, 0, &fileSize,data);
        AudioFileClose(fileId);
        NSLog(@"done and closed file");
        
        if(result != 0){
            NSLog(@"something went wrong loading the sound file %@ ",filename);
            return;
        }
        
        ALenum error = alGetError();
        
        alGenBuffers(1, &bufferId);
        alBufferData(bufferId, AL_FORMAT_MONO16, data, fileSize, frequency);
        
        error = alGetError();

        if(error !=0){
            NSLog(@"failed while allocating buffer");
            return 0;
        }
        NSLog(@"caching buffer");
        [cachedSounds setObject:[NSNumber numberWithUnsignedInt:bufferId] forKey:filename];

    }
    
    NSMutableDictionary* properties= [NSMutableDictionary dictionaryWithCapacity:0];
    [properties setObject:[NSNumber numberWithFloat:gain] forKey:@"gain"];
    [properties setObject:[NSNumber numberWithFloat:pitch]  forKey:@"pitch"];
    [properties setObject:[NSNumber numberWithFloat:frequency]  forKey:@"frequency"];


    [properties setObject:[NSNumber numberWithBool:loops] forKey:@"loops"];
    [properties setObject:loc forKey:@"location"];
    [properties setObject:[NSNumber numberWithUnsignedInt:bufferId] forKey:@"bufferID"];
    
    [soundSources setObject:properties forKey:soundKey];
    
    if(data){
        free(data);
        data=NULL;
    }
}

-(AudioFileID) openAudioFile:(NSString*) filePath{
    AudioFileID fileId;
    NSLog(@"loading %@",filePath);
    NSURL *fileurl =[NSURL fileURLWithPath:filePath];
    OSStatus result = AudioFileOpenURL((CFURLRef)fileurl, kAudioFileReadPermission, 0, &fileId);
    if (result!=0) {
        NSLog(@"Error opening file %@",filePath);
        return ;
    }
    return fileId;
}

- (UInt32) audioFileSize:(AudioFileID)fileDescriptor {
	UInt64 outDataSize = 0;
	UInt32 thePropSize = sizeof(UInt64);
	OSStatus result = AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outDataSize);
	if(result != 0)	NSLog(@"ERROR: cannot file file size");
	return (UInt32)outDataSize;
}


-(NSUInteger) activateSourceWithKey:(NSString*) key{
    NSLog(@"%@",soundSources);
    NSLog(@"trying to play sound for key %@",key);
    ALenum error = alGetError(); // clears the error
    
    NSDictionary* properties = [soundSources objectForKey:key];
    NSLog(@"got  %@",properties);

    ALfloat frequency = [[properties objectForKey:@"frequency"] floatValue];
    ALfloat gain      = [[properties objectForKey:@"gain"] floatValue];
    ALfloat pitch     = [[properties objectForKey:@"pitch"] floatValue];
    ALboolean loops   = [[properties objectForKey:@"loops"] boolValue];
    NSArray* location = [properties objectForKey:@"location"];
    
    NSLog(@"got frquenct %f",frequency);
    NSLog(@"got gain %f",gain);
    NSLog(@"pitch %f", pitch);
    
    NSNumber *buffer = [properties objectForKey:@"bufferID"];
    NSLog(@"got buffer %@",buffer);
    
    if(buffer==nil) return 0;

    NSUInteger bufferId = [buffer unsignedIntValue];
    
    NSUInteger sourceId = [self nextAvaliableSource];
    NSLog(@"source id is %i",sourceId);
   
   
	
    alSourcei(sourceId, AL_BUFFER,0);
    alSourcef(sourceId, AL_PITCH, pitch);
    alSourcef(sourceId, AL_GAIN, gain);
    alSource3f(sourceId, AL_POSITION, 
               [[location objectAtIndex:0] floatValue],
               [[location objectAtIndex:1] floatValue],
               [[location objectAtIndex:2] floatValue]);
    alSourcef(sourceId, AL_REFERENCE_DISTANCE, kRefrenceDistance);
    alSourcef(sourceId, AL_MAX_DISTANCE, kMaxDistance);
    
    alSourcei(sourceId, AL_BUFFER, bufferId);
    
    if(loops){
        alSourcei(sourceId, AL_LOOPING, AL_TRUE);
    }
    else{
        alSourcei(sourceId, AL_LOOPING, AL_FALSE);

    }
    
    error = alGetError();
        alSourcePlay(sourceId);
    
    return sourceId;
}
     
-(void) stopSourceWithKey:(NSString *)key{
}

-(NSUInteger) nextAvaliableSource{
    NSInteger sourceState;
    for(NSNumber* sourceNumber in soundList){
        alGetSourcei([sourceNumber unsignedIntValue], AL_SOURCE_STATE, &sourceState);
        if(sourceState!=AL_PLAYING){ NSLog(@"returning not playing source id "); return [sourceNumber unsignedIntValue];}
    }
    
    NSInteger looping;
    
    for(NSNumber* sourceNumber in soundList){
        alGetSourcei([sourceNumber unsignedIntValue], AL_LOOPING, &looping);
        if(!looping){
            NSUInteger sourceID = [sourceNumber unsignedIntValue];
            alSourceStop(sourceID);
            return sourceID;
        }
    }
    
    NSUInteger sourceID = [[soundList objectAtIndex:0] unsignedIntValue];
    alSourceStop(sourceID);
    return sourceID;
    
}

-(void) setGain:(NSNumber*) gain OfSourceWithKey:(NSString*)key{
}

-(void) setPitch:(NSNumber*) pitch OfSourceWithKey:(NSString*)key{
    
}

-(void) updateListenerPos{
    NSLog(@"updating listener position");
    alListener3f(AL_POSITION, [[listenerPosition objectAtIndex:0] floatValue],
                [[listenerPosition objectAtIndex:1] floatValue], [[listenerPosition objectAtIndex:2] floatValue]);
    alListener3f(AL_VELOCITY, 0, 0, 0);
    //alListener3f(AL_ORIENTATION, 0, 1, 0);

}


-(void) updateListenerPosX:(NSNumber *)xPos{
    [listenerPosition replaceObjectAtIndex:0 withObject:xPos];
    NSLog(@"%@",listenerPosition);

    [self updateListenerPos];
}
-(void) updateListenerPosY:(NSNumber *)yPos{
    [listenerPosition replaceObjectAtIndex:1 withObject:yPos];
    NSLog(@"%@",listenerPosition);
    
    [self updateListenerPos];
}
-(void) updateListenerPosX:(NSNumber *)xPos posY:(NSNumber*) yPos{
    [listenerPosition replaceObjectAtIndex:0 withObject:xPos];
    [listenerPosition replaceObjectAtIndex:1 withObject:yPos];
    [self updateListenerPos];
}


-(void) setLocationOfSoundWithKey:(NSString*)key xPos:(NSNumber*)x yPos:(NSNumber*) y zPos:(NSNumber*) z{
    NSNumber* sourceId=[self getSourceForKey:key];

     NSLog(@"source if is %@",sourceId);
    alSource3f([sourceId unsignedIntValue], AL_POSITION, [x floatValue], [y floatValue], [z floatValue]);
}

-(NSNumber *) getSourceForKey:(NSString*)key{
    NSDictionary* targetDetails = [soundSources objectForKey:key];
    NSLog(@"target details are %@",targetDetails);
    NSUInteger bufferId = [[targetDetails objectForKey: @"bufferID"] unsignedIntValue];
    NSInteger currentBuffer;

    for(NSNumber* sourceNumber in soundList){
        alGetSourcei([sourceNumber unsignedIntValue], AL_BUFFER, &currentBuffer);
        if(currentBuffer==bufferId) return sourceNumber;
    }
    
    return nil;
}

-(id) retain{
    return self;
}

-(unsigned)retainCount {
    return UINT_MAX;
}

-(id) autorelease{
    return self;
}

-(void) dealloc{
    for(NSNumber* i in soundList){
        NSUInteger sourceId = [i unsignedIntValue];
        alDeleteSources(1, &sourceId);
    }
    
    for(NSDictionary* properties in soundSources){
        NSUInteger bufferId = [[properties objectForKey:@"bufferID"] unsignedIntValue];
        alDeleteBuffers(1, &bufferId);
    }
    [soundList release];
    [soundSources release];
    [listenerPosition release];
    alcMakeContextCurrent(NULL);
    alcDestroyContext(context);
    [super dealloc];
}
@end
