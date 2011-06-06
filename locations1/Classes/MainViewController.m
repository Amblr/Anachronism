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
@synthesize activeNode;
@synthesize activePath;

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
    [mediaView release];
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
    bottomLeftRect = primaryMapView.frame;
    rightRect = mediaView.frame;
    
}

- (void)viewDidUnload
{
    [mediaView release];
    mediaView = nil;
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
    NSString * nodesURL = [NSString stringWithFormat:@"%@/scenarios/%@/nodes.json",self.baseURL,scenarioID];
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
    NSError * error = nil;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"streetview" ofType:@"html"];
    NSString * streetViewHtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error==nil){
        [streetView loadHTMLString:streetViewHtml baseURL:[NSURL URLWithString:@""]];        
    }
    else{
        NSLog(@"Failed to load HTML from %@");
    }
    

}

#pragma mark - Picker View


-(void) nodeSource:(id) nodeManager didReceiveNodes:(NSDictionary*) nodes
{
	NSLog(@"MainViewController Received %d nodes", [nodes count]);
	[mapViewController performSelector:@selector(nodeSource:didReceiveNodes:) withObject:nodeManager withObject:nodes];
    self.activeNode=nil;
}


-(void) pathSource:(id) pathManager didReceivePaths:(NSDictionary*) paths
{
    
    NSLog(@"MainViewController Received %d paths", [paths count]);
    [mapViewController performSelector:@selector(pathSource:didReceivePaths:) withObject:pathManager withObject:paths];
    if ([paths count]){
        self.activePath=[[paths allValues] objectAtIndex:0];
    }

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

-(void) triggeredNode:(L1Node*) node
{
    [self didSelectNode:node];
    
}

-(void) previousButton
{
    if (!self.activeNode) return;
    if (!self.activePath) return;
    NSInteger currentIndex = [self.activePath.nodes indexOfObject:self.activeNode];
    if (currentIndex==0) return;
    if (currentIndex==NSNotFound) return;
    [self didSelectNode:[self.activePath.nodes objectAtIndex:currentIndex-1]];
}

-(void) nextButton
{
    if (!self.activeNode) return;
    if (!self.activePath) return;
    NSInteger currentIndex = [self.activePath.nodes indexOfObject:self.activeNode];
    if (currentIndex==[self.activePath.nodes count]-1) return;
    if (currentIndex==NSNotFound) return;
    [self didSelectNode:[self.activePath.nodes objectAtIndex:currentIndex+1]];
    
}

-(void) didSelectNode:(L1Node*) node
{
    
//    if ([node.resources count]){
//        
//        L1Resource * resource = [node.resources objectAtIndex:0];
//        NSString * urlString = [NSString stringWithFormat:@"%@%@",@"http://warm-earth-179.heroku.com",resource.url];
//        if (![urlString isKindOfClass:[NSNull class]]){
//            NSLog(@"Loading url: %@",urlString);
//            NSURL * url = [NSURL URLWithString:urlString];
//            NSURLRequest * request = [NSURLRequest requestWithURL:url];
//            [mediaView loadRequest:request];
//        }
//    }
    [mapViewController zoomToNode:node];
    mediaListViewController.node = node;
    [mediaSelectionView reloadData];
    self.activeNode=node;

    [self setStreetViewLocationLat:[node.latitude doubleValue] lon:[node.longitude doubleValue]];
    NSUInteger paths[2]={0,0};
    NSIndexPath * firstPath = [NSIndexPath indexPathWithIndexes:paths length:2];
    [mediaSelectionView selectRowAtIndexPath:firstPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:mediaSelectionView didSelectRowAtIndexPath:firstPath];


}

-(void) setStreetViewLocationLat:(CLLocationDegrees) lat lon:(CLLocationDegrees) lon
{
    NSString * command = [NSString stringWithFormat:@"setMyLatLng(%lf,%lf);",lat,lon];
    [streetView stringByEvaluatingJavaScriptFromString:command];
    
  
}

-(IBAction) swapViews
{
    
    BOOL mapCurrentlyBottomLeft = CGRectEqualToRect(primaryMapView.frame, bottomLeftRect);
    
    if (mapCurrentlyBottomLeft){
        [UIView beginAnimations:@"bottomView" context:NULL];
		[UIView setAnimationDuration:0.4];
		primaryMapView.frame = rightRect;
        mediaView.frame = bottomLeftRect;
		[UIView commitAnimations];

    }
    else{
        [UIView beginAnimations:@"bottomView" context:NULL];
		[UIView setAnimationDuration:0.4];
		primaryMapView.frame = bottomLeftRect;
        mediaView.frame = rightRect;
		[UIView commitAnimations];
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = [indexPath indexAtPosition:1];
    if (i==0){
        NSString * filename = [[NSBundle mainBundle] pathForResource:@"textfade" ofType:@"html"];
        NSError * error=nil;
        NSString * html_template = [NSString stringWithContentsOfFile:filename encoding:NSASCIIStringEncoding error:&error];
        if (error){
            NSLog(@"Error loading html from %@: %@",filename,error);
            return;
        }
        NSString * html = [NSString stringWithFormat:html_template,mediaListViewController.node.name,mediaListViewController.node.text];
        [mediaView loadHTMLString:html baseURL:[NSURL URLWithString:@""]];

    }
    else{
        L1Resource * resource = [mediaListViewController.node.resources objectAtIndex:i-1];
        NSString * urlString = [@"http://warm-earth-179.heroku.com" stringByAppendingString:resource.url];
        NSURL * url = [NSURL URLWithString:urlString];
        NSLog(@"Loading resource URL: %@",url);
        if (resource.local){
            NSLog(@"Local");
            if ([resource.type isEqualToString:@"image"]){
                NSLog(@"image");
                NSURL * url = [NSURL URLWithString:resource.url];
                NSData * data = resource.resourceData;
                [mediaView loadData:data MIMEType:@"image/jpeg" textEncodingName:@"utf-8" baseURL:url];
                
            }
        }
    }
}

-(IBAction) overlay
{
    [mapViewController overlayImage];
    
}



@end


