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
    audioEngine = [[SimpleAudioEngine alloc] init];
    audioUnits = [[NSMutableDictionary alloc] init];
    BOOL ok = [L1Utils initializeDirs];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    NSAssert(ok, @"Unable to ini dirs.");
}


-(void) viewDidAppear:(BOOL)animated
{
    [self setupScenario];
    [locationManager startUpdatingLocation];

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
-(void) setupScenario {
    NSString * nodesURL = @"http://amblr.heroku.com/scenarios/4ddbbf01875dcc0001000015/nodes.json";
    NSString * pathsURL = @"http://amblr.heroku.com/paths_for_scenario/4ddbbf01875dcc0001000015.json";
    //Hackney Hear: 4e136bf3ece479000100001a
    //Dickens: 4ddbbf01875dcc0001000015
    self.scenario = [L1Scenario scenarioFromNodesURL:nodesURL pathsURL:pathsURL];
    mapViewController.delegate=self;
    self.scenario.delegate = self;
}

-(void) nodeSource:(id) nodeManager didReceiveNodes:(NSDictionary*) nodes
{
    for (L1Node *node in [nodes allValues]){
        NSLog(@"HH Found node: %@",node.name);
        //Add circle overlay
        MKCircle * circle = [MKCircle circleWithCenterCoordinate:node.coordinate radius:[node.radius doubleValue]];
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
}


-(void) pathSource:(id) pathManager didReceivePaths:(NSDictionary*) paths
{
    for (L1Path *path in [paths allValues]){
        NSLog(@"Found path: %@",path.name);
    }
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
    NSLog(@"Mute status: %d", [audioEngine mute]);
           
           
    NSLog(@"Node on: %@",node.name);
    NSString * filename = [self filenameForNodeSound:node];
    if (filename){
        ALuint unit = [audioEngine playEffect:filename];
        NSLog(@"Playing sound %@",filename);
        [audioUnits setObject:[NSNumber numberWithUnsignedInt:unit] forKey:filename];
        NSLog(@"Audio unit set to %u",unit);
    }
}

-(void) nodeSoundOff:(L1Node*) node
{
    NSLog(@"Node off: %@",node.name);
    NSString * filename = [self filenameForNodeSound:node];
    if (filename){
        NSNumber * unitNumber = [audioUnits valueForKey:filename];
        ALuint unit = [unitNumber unsignedIntValue];
        [audioEngine stopEffect:unit];
    }
   
}

#pragma mark -
#pragma mark Location Awareness

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self locationUpdate:newLocation.coordinate];
}

-(void) manualLocationUpdate:(CLLocation*)location
{
    [self locationUpdate:location.coordinate];
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
