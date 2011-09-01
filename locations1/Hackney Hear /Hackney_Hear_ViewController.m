//
//  Hackney_Hear_ViewController.m
//  Hackney Hear 
//
//  Created by Joe Zuntz on 05/07/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "Hackney_Hear_ViewController.h"
#import "L1Path.h"
#import "L1Utils.h"


#define SOUND_FADE_TIME 5.0
#define SOUND_FADE_TIME_SPEECH 3.0
#define SOUND_FADE_TIME_INTRO 2.0
#define SOUND_FADE_TIME_MUSIC 15.0
#define SOUND_FADE_TIME_ATMOS 15.0
#define SOUND_DECREASE_TIME_STEP 0.5

#define SOUND_RISE_TIME 5.0
#define SOUND_RISE_TIME_SPEECH 3.0
#define SOUND_RISE_TIME_INTRO 2.0
#define SOUND_RISE_TIME_MUSIC 5.0
#define SOUND_RISE_TIME_ATMOS 5.0
#define SOUND_INCREASE_TIME_STEP 0.5


#define SPEECH_MINIMUM_INTERVAL 60
#define INTRO_SOUND_BREAK_POINT 68
#define INTRO_SOUND_KEY @"HH_INTRO_SOUND"


#define SPECIAL_SHAPE_NODE_NAME @"2508 bway sound track01"

@implementation L1CDLongAudioSource
@synthesize soundType;
@synthesize key;

@end





@implementation Hackney_Hear_ViewController
@synthesize scenario;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
//    audioEngine = [[SimpleAudioEngine alloc] init];
    audioSamples = [[NSMutableDictionary alloc] init];
    BOOL ok = [L1Utils initializeDirs];
    NSAssert(ok, @"Unable to ini dirs.");
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    circles = [[NSMutableDictionary alloc] initWithCapacity:0];
    //self.scenario=nil;
    realLocationTracker = [[L1BigBrother alloc] init];
    fakeLocationTracker = [[L1BigBrother alloc] init];
    mapViewController.delegate=self;
    activeSpeechTrack=nil;
    lastCompletionTime = [[NSMutableDictionary alloc] initWithCapacity:0];
    proximityMonitor = [[L1DownloadProximityMonitor alloc] init];
    introIsPlaying=NO;
    skipButton=nil;
    [self checkFirstLaunch];
    

}

-(void) skipIntro
{
    NSLog(@"Skip");
    [skipButton removeFromSuperview];
    skipButton=nil;
//    [self.view setNeedsDisplay];
    [self decreaseSourceVolume:INTRO_SOUND_KEY];
    introIsPlaying=NO;
    introBeforeBreakPoint=NO;
    
}

-(void) endIntroIfAudioReady:(NSObject*) dummy
{
    //We have reached the break-point in the audio.  From now on we should 
    //end the intro if any audio is triggered.
    NSLog(@"Reached Intro Audio Break Point");
    introBeforeBreakPoint=NO;
}

-(void) checkFirstLaunch{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *markerPath = [documentsPath stringByAppendingPathComponent:@"application_launched_before.marker"];
    NSFileManager * manager = [[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:markerPath] || 1){
        //Do all the first launch things
        BOOL ok = [manager createFileAtPath:markerPath contents:[NSData data] attributes:nil];
        NSAssert(ok, @"Failed to create marker file.");
        
        //Play the intro sound.
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
        
        
        //Set up the "skip" button
        skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [skipButton addTarget:self 
                   action:@selector(skipIntro)
         forControlEvents:UIControlEventTouchUpInside];
        [skipButton setTitle:@"Skip Intro" forState:UIControlStateNormal];
        skipButton.frame = CGRectMake(80.0, 10.0, 160.0, 40.0);
        [self.view addSubview:skipButton];
        
        
        //Start a timer that will end when the natural break point in the sound is reached (?)
        [self performSelector:@selector(endIntroIfAudioReady:) withObject:nil afterDelay:INTRO_SOUND_BREAK_POINT];
        
    }
    [manager release];
}

-(void) viewDidAppear:(BOOL)animated
{
    //We may have just lanched the application or have flipped back here from another tab
    //either way we check if anything has changed in the options,
    //and then alter our tracking behaviour accordingly.
    //This is also a good time to check for location updates, in case the user
    //just switched to real location from fake or vice versa.
    realGPSControl = [[NSUserDefaults standardUserDefaults] boolForKey:@"use_real_location"];
    trackMe = [[NSUserDefaults standardUserDefaults] boolForKey:@"track_user_location"];
    [locationManager startUpdatingLocation];
    if (self.scenario){
        if (realGPSControl){
            [self locationUpdate:locationManager.location.coordinate];
        }
        else {
            [self locationUpdate:mapViewController.manualUserLocation.coordinate];
        }
    }
    
    NSLog(@"Tiles adding");
    NSString * tileDir = @"Tiles";
    //[mapViewController addTilesFromDirectory:tileDir];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Story Elements


//This is a delegate method that gets called when some nodes have been downloaded.
//in our case that means that the scenario download is complete and we
//shoudl start normal behaviour.
//That means reading through the nodes and adding them to the map if they have a sound attached.
-(void) nodeSource:(id) nodeManager didReceiveNodes:(NSDictionary*) nodes
{
    for (L1Node *node in [nodes allValues]){
        
        //Check if node has any sound resources.  If not ignore it.
        L1Resource * sound = nil;
        for (L1Resource * resource in node.resources){
            if ([resource.type isEqualToString:@"sound"]){
                sound=resource;
            }
        }
        if (!sound) continue;
        NSLog(@"HH Found node: %@",node.name);
        
                
        //Add circle overlay.  The colour depends on the sound type.
        //Choose the colour here.
        UIColor * circleColor;
        BOOL isSpeech = (sound.soundType==L1SoundTypeSpeech);
        if (isSpeech) circleColor = [UIColor cyanColor];
        else circleColor = [UIColor greenColor];
        
        //Create the circle here, store it so we can keep track and change its color later,
        //and add it to the map.
        L1Circle * circle = [mapViewController addCircleAt:node.coordinate radius:[node.radius doubleValue] soundType:sound.soundType];
        [circles setObject:circle forKey:node.key];
        [mapViewController addNode:node];

        //We use the enabled flag to track whether a node is playing.
        //None of them start enabled.
        node.enabled = NO; 
    }
    
    // If any nodes have been found we should zoom the map to their location.
    //We use an arbitrary on to zoom to for now.
    if ([nodes count]) {
        L1Node * firstNode = [[nodes allValues] objectAtIndex:0];
        [mapViewController zoomToNode:firstNode];
        
        //We also add a pin representing the fake user location (for testing)
        //a little offset from the first node.
        CLLocationCoordinate2D firstNodeCoord = firstNode.coordinate;
        firstNodeCoord.latitude -= 5.0e-4;
        firstNodeCoord.longitude -= 5.0e-4;
        [mapViewController addManualUserLocationAt:firstNodeCoord];
    }
    
    //Now all the nodes are in place we can track them to see if we should
    //download their data.  We do that with the proximity manager.
    [proximityMonitor addNodes:[nodes allValues]];
    
    //This is also a good time to update our location.
    //In particular to trigger proximity downloads.
    [self locationManager:locationManager didUpdateToLocation:locationManager.location fromLocation:nil];
    
}


-(void) pathSource:(id) pathManager didReceivePaths:(NSDictionary*) paths
{
    for (L1Path *path in [paths allValues]){
        NSLog(@"Found path: %@",path.name);
    }
}



#pragma  mark -
#pragma mark Sound
-(NSString*) filenameForNodeSound:(L1Node*) node getType:(L1SoundType*) soundType
{
    for(L1Resource * resource in node.resources){
        if ([resource.type isEqualToString:@"sound"] && resource.saveLocal){
            if (resource.local){
                *soundType = resource.soundType;
                return [resource localFileName];
            }else{
                [resource downloadResourceData]; //We wanted the data but could not get it.  Start DL now so we might next time.
            }
        }   
    }
    
    return nil;
}

-(void) nodeSoundOn:(L1Node*) node
{           
    
    NSLog(@"Node on: %@",node.name);
    L1SoundType soundType;
    NSString * filename = [self filenameForNodeSound:node getType:&soundType];
    
    if (filename){
        NSDate * lastPlay = [lastCompletionTime objectForKey:node.key];
        if (lastPlay && [[NSDate date] timeIntervalSinceDate:lastPlay]<SPEECH_MINIMUM_INTERVAL){
            NSLog(@"Not playing sound - too recent.");
            return;
        }
        
        //If we have reached the intro break point
        //then starting any new node should kill the intro
        if (!introBeforeBreakPoint) [self skipIntro];
        
        L1CDLongAudioSource * sound = [audioSamples objectForKey:node.key];
        
        //If the sound is already in the audioSamples then we must have paused it earlier.
        //so we just carry on from where we left off.
        
        //Otherwise we need to load it afresh.  This might be because it finished and was flushed or because 
        //we never heard it before
        BOOL newSound=false;
        if (!sound){
            newSound=true;
            sound = [[L1CDLongAudioSource alloc] init];
            sound.delegate=self;
            sound.soundType=soundType;
            sound.key=node.key;
            [sound load:filename];
            [sound play];
        }
        else{
            //If it is a resumed sound then we can restart it.
            //If speech, restart at full volume immediately
            if (sound.soundType==L1SoundTypeSpeech){
                sound.volume=1.0;
                [sound resume];
            }
            //If not speech, fade in.
            else{
                float riseTime = SOUND_RISE_TIME;
                if (sound.soundType==L1SoundTypeAtmos) riseTime=SOUND_RISE_TIME_ATMOS;
                if (sound.soundType==L1SoundTypeMusic) riseTime=SOUND_RISE_TIME_MUSIC;
                if (sound.soundType==L1SoundTypeSpeech) riseTime=SOUND_RISE_TIME_SPEECH;
                [sound resume];
                sound.volume = SOUND_INCREASE_TIME_STEP/riseTime;
                SEL selector = @selector(increaseSourceVolume:);
                [self performSelector:selector withObject:node.key afterDelay:SOUND_INCREASE_TIME_STEP];
            }
            
        }
        [audioSamples setObject:sound forKey:node.key];
        if (newSound) [sound release];
        
        //If a new speech track has come a long then fade out any existing one.
        if (soundType==L1SoundTypeSpeech){
            if (activeSpeechTrack) [self decreaseSourceVolume:activeSpeechTrack];
            activeSpeechTrack=sound.key;
        }
        
        NSLog(@"Playing sound %@",filename);
    }
}

//This is begging to be refactored.
-(void) increaseSourceVolume:(NSString*) identifier
{
    L1CDLongAudioSource * sound = [audioSamples objectForKey:identifier];
    
    if (!sound) return; //sound must already have finished in the meantime.
    L1SoundType soundType=sound.soundType;
    float riseTime = SOUND_RISE_TIME;
    if (soundType==L1SoundTypeAtmos) riseTime=SOUND_RISE_TIME_ATMOS;
    if (soundType==L1SoundTypeMusic) riseTime=SOUND_RISE_TIME_MUSIC;
    if (soundType==L1SoundTypeSpeech) riseTime=SOUND_RISE_TIME_SPEECH;
    if (soundType==L1SoundTypeIntro) riseTime=SOUND_RISE_TIME_INTRO;
    
    
    sound.volume = sound.volume+SOUND_INCREASE_TIME_STEP/(riseTime);
    
    //When the sound has fully risen we just stop increasing it
    if (sound.volume>=1.0){
        sound.volume = 1.0;
    }
    else  //otherwise schedule the next volume rise.
    {
        SEL selector = @selector(increaseSourceVolume:);
        [self performSelector:selector withObject:identifier afterDelay:SOUND_INCREASE_TIME_STEP];
    }
}

-(void) decreaseSourceVolume:(NSString*) identifier
{
    L1CDLongAudioSource * sound = [audioSamples objectForKey:identifier];
    
    if (!sound) return; //sound must already have finished in the meantime.
    L1SoundType soundType=sound.soundType;
    float fadeTime = SOUND_FADE_TIME;
    if (soundType==L1SoundTypeAtmos) fadeTime=SOUND_FADE_TIME_ATMOS;
    if (soundType==L1SoundTypeMusic) fadeTime=SOUND_FADE_TIME_MUSIC;
    if (soundType==L1SoundTypeSpeech) fadeTime=SOUND_FADE_TIME_SPEECH;
    if (soundType==L1SoundTypeIntro) fadeTime=SOUND_FADE_TIME_INTRO;
    
    
    sound.volume = sound.volume-SOUND_DECREASE_TIME_STEP/(fadeTime);

    //When the sound has fully faded we pause it rather than stopping it
    //so we can restart it again later
    if (sound.volume<=0){
        [sound pause];
//         [audioSamples removeObjectForKey:identifier];    
    }
    else
    {
        SEL selector = @selector(decreaseSourceVolume:);
        [self performSelector:selector withObject:identifier afterDelay:SOUND_DECREASE_TIME_STEP];
    }
}

-(void) nodeSoundOff:(L1Node*) node
{
    NSLog(@"Node off: %@",node.name);
    
    L1SoundType soundType;
    NSString * filename = [self filenameForNodeSound:node getType:&soundType];
    if (filename){
        L1CDLongAudioSource * sound = [audioSamples objectForKey:node.key];
        if (sound){
            if (sound.volume==1.0){ //sound is not already fading
                float fadeTime = SOUND_FADE_TIME;
                if (sound.soundType==L1SoundTypeAtmos) fadeTime=SOUND_FADE_TIME_ATMOS;
                if (sound.soundType==L1SoundTypeMusic) fadeTime=SOUND_FADE_TIME_MUSIC;
                if (sound.soundType==L1SoundTypeSpeech) fadeTime=SOUND_FADE_TIME_SPEECH;

                sound.volume = 1.0 - SOUND_DECREASE_TIME_STEP/fadeTime;
                SEL selector = @selector(decreaseSourceVolume:);
                [self performSelector:selector withObject:node.key afterDelay:SOUND_DECREASE_TIME_STEP];
            }
        }
        for(L1Resource * resource in node.resources){
            if ([resource.type isEqualToString:@"sound"]){
                L1Circle * circle = [circles valueForKey:node.key];
                if (circle){
                    if (resource.soundType==L1SoundTypeSpeech){
                        [mapViewController setColor:[UIColor cyanColor] forCircle:circle];
                    }else {
                        [mapViewController setColor:[UIColor greenColor] forCircle:circle];
                    }
                }

                break;
                
            }
        }

    }
}

#pragma mark -
#pragma mark Location Awareness


-(BOOL) inSpecialRegion:(CLLocationCoordinate2D) location
{
    
    return false;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location update [real]");
    if (realGPSControl) {
        NSLog(@"Using update");

        [self locationUpdate:newLocation.coordinate];
        if (trackMe)[realLocationTracker addLocation:newLocation];
    }
    else{
        NSLog(@"Ignoring update");
        
    }

}

-(void) manualLocationUpdate:(CLLocation*)location
{
    NSLog(@"Location update [fake]");
    if (!realGPSControl) {
        NSLog(@"Using update");
        [self locationUpdate:location.coordinate];
        if (trackMe) [fakeLocationTracker addLocation:location];
    }
    else{
        NSLog(@"Ignoring update");

    }
}


-(void) locationUpdate:(CLLocationCoordinate2D) location
{
    NSLog(@"Updated to location: lat = %f,   lon = %f", location.latitude,location.longitude);
    [proximityMonitor updateLocation:location];
    
    //We do not want to start playing any kind of sound if the intro is still before its break point.
    //So we should not enable any nodes or anything like that either.
    //So quitting this suborutine early seems the easiest way of doing this.
    if (introBeforeBreakPoint){
        NSLog(@"Ignoring location update since intro has not reached break point");
        return;
    }
    for (L1Node * node in [self.scenario.nodes allValues]){
        CLRegion * region = [node region];
        BOOL wasEnabled = node.enabled;
        BOOL nowEnabled = [region containsCoordinate:location];
        if ([node.name isEqualToString:SPECIAL_SHAPE_NODE_NAME]){
            nowEnabled = [self inSpecialRegion:location];
        }

        if (nowEnabled) NSLog(@"Node now (or still) enabled: %@.  Old Status %d",node.name,wasEnabled);
        if ((!wasEnabled) && nowEnabled) [self nodeSoundOn:node];
        if (wasEnabled && (!nowEnabled)) [self nodeSoundOff:node];
        node.enabled = nowEnabled;
        if (nowEnabled){
            L1Circle * circle = [circles valueForKey:node.key];
            [mapViewController setColor:[UIColor blueColor] forCircle:circle];

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
        NSLog(@"skipButton = %@",skipButton);
        [skipButton removeFromSuperview];
//        [self.view setNeedsDisplay];
        skipButton=nil;
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
        [audioSamples removeObjectForKey:source.key];
    }
    
    
}


@end
