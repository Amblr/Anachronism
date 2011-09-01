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





#define SPECIAL_SHAPE_NODE_NAME @"2508 bway sound track01"





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
    soundManager = [[HHSoundManager alloc] init];

    BOOL ok = [L1Utils initializeDirs];
    NSAssert(ok, @"Unable to ini dirs.");
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    circles = [[NSMutableDictionary alloc] initWithCapacity:0];
    //self.scenario=nil;
    realLocationTracker = [[L1BigBrother alloc] init];
    fakeLocationTracker = [[L1BigBrother alloc] init];
    mapViewController.delegate=self;
    proximityMonitor = [[L1DownloadProximityMonitor alloc] init];
    skipButton=nil;
    NSLog(@"Tiles adding");
    NSString * tileDir = @"Tiles";
    [mapViewController addTilesFromDirectory:tileDir];
    [self checkFirstLaunch];

    

}


-(void) skipIntro:(NSObject*) dummy
{
    [skipButton removeFromSuperview];
    skipButton = nil;
    [soundManager skipIntro];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [soundManager startIntro];
            
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(aWindowBecameMain:)
                                                     name:HH_INTRO_SOUND_ENDED_NOTIFICATION object:nil];

        
        //Set up the "skip" button
        skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [skipButton addTarget:self 
                       action:@selector(skipIntro:)
         forControlEvents:UIControlEventTouchUpInside];
        [skipButton setTitle:@"Skip Intro" forState:UIControlStateNormal];
        skipButton.frame = CGRectMake(80.0, 10.0, 160.0, 40.0);
        [self.view addSubview:skipButton];
        
        
        //Start a timer that will end when the natural break point in the sound is reached (?)
        
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
        [soundManager playSoundWithFilename:filename key:node.key type:soundType];
    }
}


-(void) nodeSoundOff:(L1Node*) node
{
    NSLog(@"Node off: %@",node.name);
        [soundManager stopSoundWithKey:node.key];
}

#pragma mark -
#pragma mark Location Awareness


/*
 Coordinates of the special region.
 -0.063043,51.535805
 -0.061262,51.538181
 -0.060328,51.537498
 -0.061744,51.535519

 
 */

-(BOOL) inSpecialRegion:(CLLocationCoordinate2D) location
{
#define NVERT 4
    float X[NVERT] = {-0.063043, -0.061262, -0.060328, -0.061744};
    float Y[NVERT] = {51.535805, 51.538181, 51.537498, 51.535519};
    
    int inRegion =  point_in_polygon(NVERT, X, Y, location.longitude, location.latitude);
    if (inRegion) NSLog(@"In special region");
    return inRegion;
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
    if (soundManager.introBeforeBreakPoint){
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
        else{
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
}




@end
