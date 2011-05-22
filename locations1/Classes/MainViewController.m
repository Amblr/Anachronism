//
//  MainViewController.m
//  locations1
//
//  Created by Joe Zuntz on 12/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "MainViewController.h"
#import "L1Path.h"

@implementation MainViewController

@synthesize scenario, baseURL;
@synthesize chooserViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.scenario = nil;
        self.baseURL = @"http://warm-earth-179.heroku.com";
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [primaryMapView release];
    [pathSelectionView release];
    [mediaView release];
    [titleText release];
    [descriptionText release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [pathSelectionView release];
    pathSelectionView = nil;
    [mediaView release];
    mediaView = nil;
    [titleText release];
    titleText = nil;
    [descriptionText release];
    descriptionText = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Choosing Scenario

- (IBAction)walkPath:(id)sender {
    NSInteger pathIndex = [pathSelectionView selectedRowInComponent:0];
    NSArray * paths = [scenario.paths allValues];
    L1Path * path = [paths objectAtIndex:pathIndex];
    [self.scenario walkPath:path];
    
    
}

-(void) presentChooserView
{
    self.chooserViewController = [[L1ScenarioChooserViewController alloc] initWithNibName:@"L1ScenarioChooserView" bundle:[NSBundle mainBundle]]
    ;
    self.chooserViewController.delegate = self;
    [self presentModalViewController:self.chooserViewController animated:YES];
    
}


-(void) chooseScenario:(NSString*) scenarioID
{
    NSLog(@"Choosing scenario with ID %@",scenarioID);
    self.chooserViewController=nil;
    self.baseURL = @"http://warm-earth-179.heroku.com";
    NSString * nodesURL = [NSString stringWithFormat:@"%@/nodes.json",self.baseURL];
    NSString * pathsURL = [NSString stringWithFormat:@"%@/paths_for_scenario/%@.json",self.baseURL,scenarioID];
    NSLog(@"base = %@",self.baseURL);
    NSLog(@"nodes = %@",nodesURL);
    NSLog(@"paths = %@",pathsURL);
    
//    NSString * nodesFile = @"/Users/joe/src/projects/locations/nodes.json";
//    NSString * pathsFile = @"/Users/joe/src/projects/locations/paths.json";
    
    self.scenario = [L1Scenario scenarioFromNodesURL:nodesURL pathsURL:pathsURL];
    mapViewController.delegate=self;
//    self.scenario = [L1Scenario fakeScenarioFromNodeFile:nodesFile pathFile:pathsFile delegate:self];
//    mapViewController.scenario=self.scenario;
    self.scenario.delegate = self;
    [pathSelectionView reloadAllComponents];

}

#pragma mark - Picker View


-(void) nodeSource:(id) nodeManager didReceiveNodes:(NSDictionary*) nodes
{
	NSLog(@"MainViewController Received %d nodes", [nodes count]);
	[mapViewController performSelector:@selector(nodeSource:didReceiveNodes:) withObject:nodeManager withObject:nodes];
}


-(void) pathSource:(id) pathManager didReceivePaths:(NSDictionary*) paths
{
    
    NSLog(@"MainViewController Received %d paths", [paths count]);
    [pathSelectionView reloadAllComponents];
    [mapViewController performSelector:@selector(pathSource:didReceivePaths:) withObject:pathManager withObject:paths];

}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [scenario pathCount];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSArray * paths = [scenario.paths allValues];
    L1Path * path =  [paths objectAtIndex:row];
    return path.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"picked row %d",row);
    NSArray * paths = [scenario.paths allValues];
    L1Path * path = [paths objectAtIndex:row];
    [mapViewController addPath:path];
}



-(void) didSelectNode:(L1Node*) node
{
    
    titleText.text = node.name;
    descriptionText.text = node.text;
    if ([node.resources count]){
        
        L1Resource * resource = [node.resources objectAtIndex:0];
        NSString * urlString = resource.url;
        NSLog(@"Loading url: %@",urlString);
        NSURL * url = [NSURL URLWithString:urlString];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [mediaView loadRequest:request];
        
    }
}

@end


