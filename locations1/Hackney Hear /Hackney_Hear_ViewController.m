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
#define SOUND_FADE_TIME_MUSIC 15.0
#define SOUND_FADE_TIME_ATMOS 15.0
#define SOUND_DECREASE_TIME_STEP 0.5
#define SPEECH_MINIMUM_INTERVAL 60


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

}


-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"View = %@",self.view);
    realGPSControl = [[NSUserDefaults standardUserDefaults] boolForKey:@"use_real_location"];
    NSLog(@"Real GPS Control is now:  %d",realGPSControl);
    trackMe = [[NSUserDefaults standardUserDefaults] boolForKey:@"track_user_location"];
    [locationManager startUpdatingLocation];
    if (!self.scenario){
//        [self setupScenario];

    }
    else{
        //We just came back from the prefs pane, or somewhere else, perhaps.
        //If we just set the use_real_location to off then we should update the manual location.
        if (realGPSControl){
            [self locationUpdate:locationManager.location.coordinate];
        }
        else {
            [self locationUpdate:mapViewController.manualUserLocation.coordinate];
        }
    }
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
        
        BOOL isSpeech= (sound.soundType==L1SoundTypeSpeech);

        
        NSLog(@"HH Found node: %@",node.name);
        //Add circle overlay
        UIColor * circleColor;
        if (isSpeech){
            circleColor = [UIColor cyanColor];
        }
        else{
            circleColor = [UIColor greenColor];
        }
        
        
        L1Circle * circle = [mapViewController addCircleAt:node.coordinate radius:[node.radius doubleValue] soundType:sound.soundType];


        [circles setObject:circle forKey:node.key];

        
        //Add node to map.
        [mapViewController addNode:node];
        //We use the enabled flag to track whether a node is playing.
        node.enabled = NO; 
    }
    if ([nodes count]) {
        L1Node * firstNode = [[nodes allValues] objectAtIndex:0];
        [mapViewController zoomToNode:firstNode];   
        CLLocationCoordinate2D firstNodeCoord = firstNode.coordinate;
        firstNodeCoord.latitude -= 5.0e-4;
        firstNodeCoord.longitude -= 5.0e-4;
        [mapViewController addManualUserLocationAt:firstNodeCoord];
    }
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
        if ([resource.type isEqualToString:@"sound"]) NSLog(@"Resource: %@, %d, %d",resource.name,resource.saveLocal,resource.local);
        if ([resource.type isEqualToString:@"sound"] && resource.saveLocal && resource.local){
            *soundType = resource.soundType;
            return [resource localFileName];
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
        
        L1CDLongAudioSource * sound = [[L1CDLongAudioSource alloc] init];
        sound.delegate=self;
        sound.soundType=soundType;
        sound.key=node.key;
        [sound load:filename];
        [sound play];
        [audioSamples setObject:sound forKey:node.key];
        [sound release];
        
        //If a new speec track has come a long then fade out any existing one.
        if (soundType==L1SoundTypeSpeech){
            if (activeSpeechTrack) [self decreaseSourceVolume:activeSpeechTrack];
            activeSpeechTrack=sound.key;
        }
        
        NSLog(@"Playing sound %@",filename);
    }
}

-(void) decreaseSourceVolume:(NSString*) identifier
{
    L1CDLongAudioSource * sound = [audioSamples objectForKey:identifier];
    if (!sound) return; //sound must already have finished in the meantime.
    float fadeTime = SOUND_FADE_TIME;
    if (sound.soundType==L1SoundTypeAtmos) fadeTime=SOUND_FADE_TIME_ATMOS;
    if (sound.soundType==L1SoundTypeMusic) fadeTime=SOUND_FADE_TIME_MUSIC;
    if (sound.soundType==L1SoundTypeSpeech) fadeTime=SOUND_FADE_TIME_SPEECH;
    
    
    sound.volume = sound.volume-SOUND_DECREASE_TIME_STEP/(fadeTime);
    if (sound.volume<=0){
        [sound stop];
        [audioSamples removeObjectForKey:identifier]; 
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
            if ([resource.type isEqualToString:@"sound"] && resource.saveLocal && resource.local){
                [resource flush];
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
    for (L1Node * node in [self.scenario.nodes allValues]){
        CLRegion * region = [node region];
        BOOL wasEnabled = node.enabled;
        BOOL nowEnabled = [region containsCoordinate:location];
        if (nowEnabled) NSLog(@"Node now enabled: %@.  Old Status %d",node.name,wasEnabled);
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
    
    //        [timeLastFinished setObject:[NSDate date] forKey:audioSource.]
}


@end
