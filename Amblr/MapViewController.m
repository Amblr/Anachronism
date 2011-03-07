    //
//  mapViewController.m
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "MapViewController.h"
#import "AmblrViewController.h"

@implementation MapViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"Loaded.");
	[self zoomToOxford];
	self.nodes = [NSMutableArray arrayWithCapacity:0];
	[self setupNodes];
	inSelectionProcess=NO;

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(void) viewDidAppear:(BOOL)animated
{	
	NSLog(@"Appeared.");
	[super viewDidAppear:animated];
	[self zoomToOxford];
	
}

-(void) awakeFromNib
{
	NSLog(@"Awoke.");
	[super awakeFromNib];
	[self zoomToOxford];
	[self setupNodes];
	
	
}

-(void) zoomToOxford
{
	NSLog(@"Zoom.");

	MKCoordinateSpan span = MKCoordinateSpanMake(0.014638, 0.023646);
	CLLocationCoordinate2D center;
	center.latitude = 51.755475;
	center.longitude = -1.260660;
	[self.mapView setRegion:MKCoordinateRegionMake(center, span)];
}

-(void) addNodeAnnotation:(int) n
{
	
	if (n<0 || n>=[nodes count]) return;
	AmblrNode * node = [self.nodes objectAtIndex:n];
	[mapView addAnnotation:node];
	
	
}



-(void) setupNodes
{
	float deltaLatitude = 0.014638;
	float deltaLongitude = 0.023646;
	float centerLatitude = 51.755475;
	float centerLongitude = -1.260660;
	
	for (int i=0;i<10;i++){
		NSString * name = [NSString stringWithFormat:@"Node Number %d",i];
		NSString * key = [NSString stringWithFormat:@"node%d",i];
		NSString * description = [NSString stringWithFormat:@"Of many nodes here, this is number %d",i];
		float latitude = centerLatitude + ((arc4random()%10000)/10000.0-0.5)*deltaLatitude;
		float longitude = centerLongitude + ((arc4random()%10000)/10000.0-0.5)*deltaLongitude;
		float radius = 1.0;
		AmblrNode * node = [self nodeWithKey:key name:name description:description latitude:latitude longitude:longitude radius:radius];
		[self.nodes addObject:node];
	}
}

-(AmblrNode*) nodeWithKey:(NSString*) key name:(NSString*)name description:(NSString*)description latitude:(float) latitude longitude:(float)longitude radius:(float)radius
{
	NSArray * keys = [NSArray arrayWithObjects:@"name",@"description",@"radius",@"coords",nil];
	NSArray * coords = [NSArray arrayWithObjects:[NSNumber numberWithFloat:latitude],[NSNumber numberWithFloat:longitude],nil];
	NSArray * objects = [NSArray arrayWithObjects:name,description,[NSNumber numberWithFloat:radius],coords,nil];
	NSDictionary * dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	AmblrNode * node = [[AmblrNode alloc] initWithDictionary:dictionary key:key];
	return [node autorelease];
}

-(void) changeNodeColors:(int) color
{
	for(AmblrNode * node in self.nodes){
		MKAnnotationView * annotationView  = [mapView viewForAnnotation:node];
		MKPinAnnotationView * pinView = (MKPinAnnotationView *) annotationView;
		pinView.pinColor=color;
	}
}
/*
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	if (![view.annotation isKindOfClass:[AmblrNode class]]) return;
	if (inSelectionProcess) return;
	inSelectionProcess=YES;
	AmblrNode * node = (AmblrNode*) view.annotation;
	MKPinAnnotationView * pinView = (MKPinAnnotationView*) view;
	NSLog(@"Selected annotation %@", node.name);
	NSString * newText = delegate.currentTextSelection;
	if (newText){
		if ([newText length]){
			node.text=newText;
			NSLog(@"%@",pinView.leftCalloutAccessoryView);
			NSLog(@"Set text to %@",newText);		
			pinView.pinColor = MKPinAnnotationColorPurple;
			[self.mapView deselectAnnotation:node animated:NO];
			[self.mapView selectAnnotation:node animated:NO];
		}
	}
	inSelectionProcess=NO;

	
}
*/
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
	if ([annotation isKindOfClass:[AmblrNode class]]){
		return [self annotationViewFor:theMapView forNode:(AmblrNode*)annotation];
	}
	return nil;
}


-(void) addTextToNode:(id)sender
{

	
	MKAnnotationView * annotationView = (MKAnnotationView *) [[sender superview] superview];
	NSLog(@"annotationView = %@",annotationView);
	if (![annotationView isKindOfClass:[MKAnnotationView class]]) return;
	id<MKAnnotation> annotation = annotationView.annotation;
	if (![annotation isKindOfClass:[AmblrNode class]]) return;
	MKPinAnnotationView * pinView = (MKPinAnnotationView*)annotationView;
	AmblrNode * node = (AmblrNode*)annotation;
	
	NSString * newText = delegate.currentTextSelection;
	NSLog(@"Adding text:%@",newText);
	if (newText){
		if ([newText length]){
			node.text=newText;
			pinView.pinColor = MKPinAnnotationColorPurple;
			[self.mapView deselectAnnotation:node animated:NO];
			[self.mapView selectAnnotation:node animated:NO];
		}
	}
	
	
}

-(MKAnnotationView *)annotationViewFor:(MKMapView *)theMapView forNode:(AmblrNode*)node{
	
	
	
	MKAnnotationView * annotationView = (MKAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:@"node"];
	
	if (!annotationView){
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:node reuseIdentifier:@"node"];
	}
	
	MKPinAnnotationView * pinAnnotationView = (MKPinAnnotationView *) annotationView;
	
//	annotationView.image = [self.annotationImages objectForKey:@"node"];
	annotationView.enabled = YES;
	annotationView.canShowCallout = YES;
	pinAnnotationView.pinColor=MKPinAnnotationColorRed;
	
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	SEL buttonAction = @selector(addTextToNode:);
	[rightButton addTarget:self action:buttonAction forControlEvents:UIControlEventTouchUpInside];
	annotationView.leftCalloutAccessoryView = rightButton;
	
	
	return annotationView;
}



@synthesize date;
@synthesize nodes;
@synthesize mapView, delegate;
@end
