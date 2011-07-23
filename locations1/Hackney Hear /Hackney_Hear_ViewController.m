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


#define SOUND_FADE_TIME 8.0

@implementation Hackney_Hear_ViewController
@synthesize scenario;

- (void)dealloc
{
    [realGPSControl release];
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
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    NSAssert(ok, @"Unable to ini dirs.");
    circles = [[NSMutableDictionary alloc] initWithCapacity:0];
    
}


-(void) viewDidAppear:(BOOL)animated
{
    [self setupScenario];
    [locationManager startUpdatingLocation];

}

- (void)viewDidUnload
{
    [realGPSControl release];
    realGPSControl = nil;
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
-(void) setupScenario {
    
    // Use Dickens
#ifdef ALEX_HEAR    
    NSString * storyURL = @"http://amblr.heroku.com/scenarios/4e249f58d7c4b60001000023/stories/4e249fe5d7c4b600010000c1.json";
    self.scenario = [L1Scenario scenarioFromStoryURL:storyURL withKey:@"4e249fe5d7c4b600010000c1"];
#else
    NSString * storyURL = @"http://amblr.heroku.com/scenarios/4e15c53add71aa000100025b/stories/4e15c6be7bd01600010000c0.json";
    self.scenario = [L1Scenario scenarioFromStoryURL:storyURL withKey:@"4e15c53add71aa000100025b"];
#endif        
//    self.scenario = [L1Scenario scenarioFromNodesURL:nodesURL pathsURL:pathsURL];
    mapViewController.delegate=self;
    self.scenario.delegate = self;
}

-(void) nodeSource:(id) nodeManager didReceiveNodes:(NSDictionary*) nodes
{
    for (L1Node *node in [nodes allValues]){
        NSLog(@"HH Found node: %@",node.name);
        //Add circle overlay
        MKCircle * circle = [MKCircle circleWithCenterCoordinate:node.coordinate radius:[node.radius doubleValue]];
        [circles setObject:circle forKey:node.key];
        [mapViewController addOverlay:circle];
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

-(void) nodeDownloadFailedForScenario:(L1Scenario*) scenario
{
    NSString * message = @"You don't seem to have an internet connection.  Or possibly your humble developers have screwed up.  Probably the former.";
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Network" message:message delegate:self cancelButtonTitle:@"*Sigh*" otherButtonTitles:nil];
    [alert show];
    
}


#pragma  mark -
#pragma mark Sound
-(NSString*) filenameForNodeSound:(L1Node*) node
{
    for(L1Resource * resource in node.resources){
        if ([resource.type isEqualToString:@"sound"]) NSLog(@"Resource: %@, %d, %d",resource.name,resource.saveLocal,resource.local);
        if ([resource.type isEqualToString:@"sound"] && resource.saveLocal && resource.local){
            return [resource localFileName];
        }   
    }
    return nil;
}

-(void) nodeSoundOn:(L1Node*) node
{
           
    MKCircle * circle = [circles valueForKey:node.key];
    [mapViewController setColor:[UIColor blueColor] forCircle:circle];
    NSLog(@"Node on: %@",node.name);
    NSString * filename = [self filenameForNodeSound:node];
    if (filename){
        CDLongAudioSource * sound = [[CDLongAudioSource alloc] init];
        [sound load:filename];
        [sound play];
        [audioSamples setObject:sound forKey:node.key];
        [sound release];
        
        NSLog(@"Playing sound %@",filename);
        
    }
}

-(void) decreaseSourceVolume:(NSString*) identifier
{
    CDLongAudioSource * sound = [audioSamples objectForKey:identifier];
    sound.volume = sound.volume-1.0/(SOUND_FADE_TIME);
    if (sound.volume<=0){
        [sound stop];
        [audioSamples removeObjectForKey:identifier]; 
    }
    else
    {
        SEL selector = @selector(decreaseSourceVolume:);
        [self performSelector:selector withObject:identifier afterDelay:1.0];
    }
}

-(void) nodeSoundOff:(L1Node*) node
{
    NSLog(@"Node off: %@",node.name);
    MKCircle * circle = [circles valueForKey:node.key];
    [mapViewController setColor:[UIColor greenColor] forCircle:circle];
    NSString * filename = [self filenameForNodeSound:node];
    if (filename){
        CDLongAudioSource * sound = [audioSamples objectForKey:node.key];
        if (sound){
            if (sound.volume==1.0){ //sound is not already fading
                sound.volume = 1.0 - 1.0/(SOUND_FADE_TIME);
                SEL selector = @selector(decreaseSourceVolume:);
                [self performSelector:selector withObject:node.key afterDelay:1.0];
            }
            
        }
        for(L1Resource * resource in node.resources){
            if ([resource.type isEqualToString:@"sound"] && resource.saveLocal && resource.local){
                [resource flush];
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
    if (realGPSControl.on) [self locationUpdate:newLocation.coordinate];
}

-(void) manualLocationUpdate:(CLLocation*)location
{
    NSLog(@"Location update [fake]");
    if (!realGPSControl.on) [self locationUpdate:location.coordinate];
}

- (IBAction)toggleUseTrueLocation {
    if (!realGPSControl.on){
        [self locationUpdate:mapViewController.manualUserLocation.coordinate];
        
    }
}

-(void) locationUpdate:(CLLocationCoordinate2D) location
{
    for (L1Node * node in [self.scenario.nodes allValues]){
        CLRegion * region = [node region];
        BOOL wasEnabled = node.enabled;
        BOOL nowEnabled = [region containsCoordinate:location];
        if ((!wasEnabled) && nowEnabled) [self nodeSoundOn:node];
        if (wasEnabled && (!nowEnabled)) [self nodeSoundOff:node];
        node.enabled = nowEnabled;
    }
}

@end
