//
//  HHSoundManager.h
//  locations1
//
//  Created by Joe Zuntz on 01/09/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"
#import "L1Scenario.h"

#define HH_INTRO_SOUND_ENDED_NOTIFICATION @"HH_INTRO_SOUND_ENDED_NOTIFICATION"



@interface L1CDLongAudioSource : CDLongAudioSource
{
    L1SoundType soundType;
    NSString * key;
    BOOL isFading;
    BOOL isRising;
}

-(void) timeJump:(NSTimeInterval) deltaTime;

@property (assign) L1SoundType soundType;
@property (retain) NSString * key;
@end




@interface HHSoundManager : NSObject<CDLongAudioSourceDelegate> {
    NSMutableDictionary * fadingSounds;
    NSMutableDictionary * risingSounds;
    NSMutableDictionary *audioSamples;
    NSString * activeSpeechTrack;
    BOOL introIsPlaying;
    BOOL introBeforeBreakPoint;
    NSDate * introSoundLaunchTime;
    NSMutableDictionary * lastCompletionTime;
    NSTimer * volumeChangeTimer;

}

@property (readonly) BOOL introBeforeBreakPoint;



-(void) playSoundWithFilename:(NSString*)filename key:(NSString*)key type:(L1SoundType) soundType;
-(void) stopSoundWithKey:(NSString*) key;

-(void) startIntro;
-(void) skipIntro;


-(void) fadeInSound:(NSString *) key;
-(void) fadeOutSound:(NSString *) key;


@end