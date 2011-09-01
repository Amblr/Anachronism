//
//  HHSoundManager.m
//  locations1
//
//  Created by Joe Zuntz on 01/09/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "HHSoundManager.h"

#define SOUND_UPDATE_TIME_STEP 0.5

#define SOUND_FADE_TIME 5.0
#define SOUND_FADE_TIME_SPEECH 3.0
#define SOUND_FADE_TIME_INTRO 2.0
#define SOUND_FADE_TIME_MUSIC 15.0
#define SOUND_FADE_TIME_ATMOS 15.0

#define SOUND_RISE_TIME 5.0
#define SOUND_RISE_TIME_SPEECH 3.0
#define SOUND_RISE_TIME_INTRO 2.0
#define SOUND_RISE_TIME_MUSIC 5.0
#define SOUND_RISE_TIME_ATMOS 5.0

#define SPEECH_RESTART_REWIND 2.0


#define SPEECH_MINIMUM_INTERVAL 60
#define INTRO_SOUND_BREAK_POINT 68
#define INTRO_SOUND_KEY @"HH_INTRO_SOUND"



@implementation L1CDLongAudioSource
@synthesize soundType;
@synthesize key;

-(void) timeJump:(NSTimeInterval) deltaTime
{
    NSTimeInterval currentTime = audioSourcePlayer.currentTime;
    NSTimeInterval newTime = currentTime+deltaTime;
    NSTimeInterval maxTime = audioSourcePlayer.duration;
    if (newTime<0.0) newTime=0.0;
    if (newTime>maxTime) newTime=maxTime-0.01; //Give some buffer just before end, just in case.
    [audioSourcePlayer setCurrentTime:newTime];
    
}


@end





@implementation HHSoundManager
@synthesize introBeforeBreakPoint;

-(id) init
{
    self = [super init];
    if (self){
        audioSamples = [[NSMutableDictionary alloc] initWithCapacity:0];
        activeSpeechTrack=nil;
        fadingSounds = [[NSMutableDictionary alloc] initWithCapacity:0];
        risingSounds = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        lastCompletionTime = [[NSMutableDictionary alloc] initWithCapacity:0];
        introIsPlaying=NO;
        volumeChangeTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateSoundVolumes:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:volumeChangeTimer forMode:NSDefaultRunLoopMode];
   
    }
    return self;
    
    
}


#pragma mark Intro Sound
-(void) skipIntro
{
    if (!introIsPlaying) return;
    NSLog(@"Skipping Intro");
    [self fadeOutSound:INTRO_SOUND_KEY];
    introIsPlaying=NO;
    introBeforeBreakPoint=NO;
    
}


-(void) introBreakReached:(NSObject*) dummy
{
    //We have reached the break-point in the audio.  From now on we should 
    //end the intro if any audio is triggered.
    NSLog(@"Reached Intro Audio Break Point");
    introBeforeBreakPoint=NO;
}


-(void) startIntro
{
    L1CDLongAudioSource * introSound = [[L1CDLongAudioSource alloc] init];
    introSound.delegate=self;
    introSound.soundType=L1SoundTypeIntro;
    introSound.key=INTRO_SOUND_KEY;
    NSString * filename = [[NSBundle mainBundle] pathForResource:@"HHIntroSound" ofType:@"mp3"];
    [audioSamples setObject:introSound forKey:INTRO_SOUND_KEY];
    [introSound load:filename];
    [introSound play];
    [introSound release];
    introIsPlaying=YES;
    introBeforeBreakPoint=YES;
    [self performSelector:@selector(introBreakReached:) withObject:nil afterDelay:INTRO_SOUND_BREAK_POINT];


}


-(void) fadeOutSound:(NSString *) key
{
    L1CDLongAudioSource * sound = [audioSamples objectForKey:key];
    if (!sound){
        NSLog(@"Tried to fade out sound not found: %@",sound.key);
        return;
    }
    //If the sound is already rising then we should over-rule this and start fading.
    if ([risingSounds objectForKey:key]){
        [risingSounds removeObjectForKey:key];
    }
    [fadingSounds setObject:sound forKey:key];
    
}

-(void) fadeInSound:(NSString *) key
{
    L1CDLongAudioSource * sound = [audioSamples objectForKey:key];
    if (!sound){
        NSLog(@"Tried to fade out sound not found: %@",sound.key);
        return;
    }

    //If the sound is already fading then we should over-rule this and start rising.
    if ([fadingSounds objectForKey:key]){
        [fadingSounds removeObjectForKey:key];
    }
    [risingSounds setObject:sound forKey:key];

    
}


-(void) playSoundWithFilename:(NSString*)filename key:(NSString*)key type:(L1SoundType) soundType
{
    NSDate * lastPlay = [lastCompletionTime objectForKey:key];
    if (lastPlay && [[NSDate date] timeIntervalSinceDate:lastPlay]<SPEECH_MINIMUM_INTERVAL){
        NSLog(@"Not playing sound - too recent.");
        return;
    }
    
    //If we have reached the intro break point
    //then starting any new node should kill the intro
    if (!introBeforeBreakPoint) [self skipIntro];
    
    //If we find the sound in audioSamples then we must have played it before.
    //Otherwise it is new
    L1CDLongAudioSource * sound = [audioSamples objectForKey:key];

    //If this is a new sound we will need to load it and then play it.
    //And this is pretty much it.
    if (!sound){
        sound = [[L1CDLongAudioSource alloc] init];
        sound.delegate=self;
        sound.soundType=soundType;
        sound.key=key;
        [sound load:filename];
        [sound play];
        [audioSamples setObject:sound forKey:key];
        [sound release];
    }
    else{
        //If it is a resumed sound then we can restart it.
        //But we rewind two seconds
        //If speech, restart at full volume immediately
        if (sound.soundType==L1SoundTypeSpeech){
            sound.volume=1.0;
            [sound timeJump:-SPEECH_RESTART_REWIND];
            [sound resume];
        }
        //If not speech, fade in.
        else{
            [self fadeInSound:sound.key];
        }
        
    }
    
    //If a new speech track has come along then fade out any existing one.
    if (soundType==L1SoundTypeSpeech){
        if (activeSpeechTrack){
         [self fadeOutSound:activeSpeechTrack];
            NSLog(@"Fading old speech track: %@",activeSpeechTrack);
        }
        activeSpeechTrack=sound.key;
    }
    
    NSLog(@"Playing sound %@",filename);
}


-(void) stopSoundWithKey:(NSString*) key
{
    [self fadeOutSound:key];
    
}

-(float) fadeTimeForSound:(L1CDLongAudioSource*)sound
{
    switch (sound.soundType) {
        case L1SoundTypeAtmos:
            return SOUND_FADE_TIME_ATMOS;
            break;
        case L1SoundTypeMusic:
            return SOUND_FADE_TIME_MUSIC;
            break;
        case L1SoundTypeSpeech:
            return SOUND_FADE_TIME_SPEECH;
            break;
        case L1SoundTypeIntro:
            return SOUND_FADE_TIME_INTRO;
            break;
        default:
            return SOUND_FADE_TIME;
            break;
    }
}

-(float) riseTimeForSound:(L1CDLongAudioSource*)sound
{
    switch (sound.soundType) {
        case L1SoundTypeAtmos:
            return SOUND_RISE_TIME_ATMOS;
            break;
        case L1SoundTypeMusic:
            return SOUND_RISE_TIME_MUSIC;
            break;
        case L1SoundTypeSpeech:
            return SOUND_RISE_TIME_SPEECH;
            break;
        case L1SoundTypeIntro:
            return SOUND_RISE_TIME_INTRO;
            break;
        default:
            return SOUND_RISE_TIME;
            break;
    }
}



//This method gets triggered every 1/2 second or so to update the sound volumes.
-(void) updateSoundVolumes:(NSObject*) dummy
{
    int nRising = [risingSounds count];
    int nFading = [fadingSounds count];
    if (nRising==0 && nFading==0) return;

    NSArray * fadingSoundsArray = [fadingSounds allValues];
    for (L1CDLongAudioSource * sound in fadingSoundsArray){
        float fadeTime = [self fadeTimeForSound:sound];
        sound.volume = sound.volume-SOUND_UPDATE_TIME_STEP/fadeTime;        
        //When the sound has fully faded we pause so we can restart it later.
        NSLog(@"Fading %@",sound.key);
        if (sound.volume<=0.0){
            sound.volume=0.0;
            NSLog(@"Done fading %@",sound.key);
            [sound pause];
            if ([sound.key isEqualToString:activeSpeechTrack]) activeSpeechTrack=nil;
            [fadingSounds removeObjectForKey:sound.key];
        }
    }
    
    NSArray * risingSoundsArray = [risingSounds allValues];
    for (L1CDLongAudioSource * sound in risingSoundsArray){
        float riseTime = [self riseTimeForSound:sound];
        sound.volume = sound.volume+SOUND_UPDATE_TIME_STEP/riseTime;        
        NSLog(@"Rising %@",sound.key);

        //When the sound has fully faded we pause so we can restart it later.
        if (sound.volume>=1.0){
            NSLog(@"Done rising %@",sound.key);

            sound.volume=1.0;
            [risingSounds removeObjectForKey:sound.key];
        }

    }
}


- (void) cdAudioSourceDidFinishPlaying:(CDLongAudioSource *) audioSource
{
    if (![audioSource isKindOfClass:[L1CDLongAudioSource class]]) return;
    L1CDLongAudioSource * source = (L1CDLongAudioSource*) audioSource;
    NSLog(@"Sound finished: %@",source.key);
    
    if ([source.key isEqualToString:activeSpeechTrack]) activeSpeechTrack=nil;
    if ([source.key isEqualToString:INTRO_SOUND_KEY]){
        introIsPlaying=NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:HH_INTRO_SOUND_ENDED_NOTIFICATION object:nil];
    }
    
    
    if (source.soundType==L1SoundTypeSpeech){
        [lastCompletionTime setObject:[NSDate date] forKey:source.key];
    }
    
    //We want to repeat music and atmost when they finish
    if (source.soundType==L1SoundTypeMusic || source.soundType==L1SoundTypeAtmos){
        [source play];
    }
    else
    {
        if ([risingSounds objectForKey:source.key]) [risingSounds removeObjectForKey:source.key];
        if ([fadingSounds objectForKey:source.key]) [fadingSounds removeObjectForKey:source.key];
        [audioSamples removeObjectForKey:source.key];
    }
    
    
}


@end
