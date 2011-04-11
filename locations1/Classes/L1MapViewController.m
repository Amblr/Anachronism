//
//  L1MapViewController.m
//  locations1
//
//  Created by Joe Zuntz on 16/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1MapViewController.h"
#import "L1Node.h"
#import "L1MapImageOverlay.h"
#import "L1MapImageOverlayView.h"

@implementation L1MapViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


-(void) awakeFromNib
{
	[super awakeFromNib];
	self.annotationImages = [NSMutableDictionary dictionary];
	UIImage * image = [UIImage imageNamed:@"pentagram"];
	if(image) [self.annotationImages setObject:image forKey:@"node"];
	
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    [super viewDidLoad];
	primaryMapView.delegate=self;
	// start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 51.0;
    newRegion.center.longitude = 0.1;
    newRegion.span.latitudeDelta = 1.0;
    newRegion.span.longitudeDelta = 1.0;
	
    [primaryMapView setRegion:newRegion animated:YES];
	
	scenario = [[L1Scenario alloc] init];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

//- (void)didReceiveMemoryWarning {
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc that aren't in use.
//}
//
//- (void)viewDidUnload {
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
//
//
//- (void)dealloc {
//    [super dealloc];
//}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	NSObject * nodeObject = view.annotation;
	if ([nodeObject isKindOfClass:[L1Node class]]){
		L1Node * node = (L1Node*)nodeObject;
		NSLog(@"Selected %@",node.name);
		
		self.nodeContentViewController.modalTransitionStyle  = UIModalTransitionStyleCrossDissolve;
		[self presentModalViewController:nodeContentViewController animated:YES];
		[self.nodeContentViewController setName:node.name];
		[self.nodeContentViewController setText:node.text];
		[mapView deselectAnnotation:node animated:NO];
	}
}

-(void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray*) annotationViews
{
	
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	id<MKAnnotation> annotation = view.annotation;
	if (![annotation isKindOfClass:[L1Node class]]) return;
	L1Node * node = (L1Node*)annotation;
	[self.navigationController pushViewController:self.nodeContentViewController animated:YES];
	[self.nodeContentViewController setName:node.name];
	[self.nodeContentViewController setText:node.text];
}


-(MKAnnotationView *)annotationViewFor:(MKMapView *)mapView forNode:(L1Node*)node{

	
	
	MKAnnotationView * annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"node"];
	
	if (!annotationView){
		annotationView = [[[MKAnnotationView alloc] initWithAnnotation:node reuseIdentifier:@"node"] autorelease];
	}

	annotationView.image = [self.annotationImages objectForKey:@"node"];
	annotationView.enabled = [node isVisible];
	annotationView.canShowCallout = NO;
	
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//	[rightButton addTarget:self
//					action:@selector(showDetails:)
//		  forControlEvents:UIControlEventTouchUpInside];
	annotationView.leftCalloutAccessoryView = rightButton;
	
		
	return annotationView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

	if ([annotation isKindOfClass:[L1Node class]]){
		return [self annotationViewFor:mapView forNode:(L1Node*)annotation];
	}
	return nil;
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	NSLog(@"Getting view overlay.");
	if ([overlay isKindOfClass:[MKPolygon class]]){
		MKPolygonView * polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
		UIColor * color = [[UIColor redColor] colorWithAlphaComponent:0.25];
		polygonView.fillColor = color;	
		return [polygonView autorelease];
	}
	else if ([overlay isKindOfClass:[L1MapImageOverlay class]]){
		UIImage * image = [UIImage imageNamed:@"oxford_map.jpg"];
		NSLog(@"Loaded image %@",image);


		
		
		
		L1MapImageOverlayView * overlayView = [[L1MapImageOverlayView alloc] initWithOverlay:overlay image:image.CGImage];
//		L1MapImageOverlayView * overlayView = [[L1MapImageOverlayView alloc] initWithOverlay:overlay image:image.CGImage topLeft:topLeft bottomRight:bottomRight];
		return [overlayView autorelease];
	}
	
	return nil;
}

-(IBAction) overlayImage:(id) sender
{
	MKMapRect currentArea = [primaryMapView visibleMapRect];
	NSLog(@"current area origin = (%e,%e)  size = (%e,%e)",currentArea.origin.x,currentArea.origin.y,currentArea.size.width,currentArea.size.height);
	L1MapImageOverlay * overlay = 	[[L1MapImageOverlay alloc] init];
	CLLocationCoordinate2D coord;

	float r = 0.8312997348;
	
	CLLocationCoordinate2D originCoord;
	CLLocationCoordinate2D endCoord;

	endCoord.latitude=54.0;
	endCoord.longitude=1.0;
	
	originCoord.latitude=54.8312997348;
	originCoord.longitude=0.0;
	
	coord.latitude=endCoord.latitude+r/2;
	coord.longitude=0.5;
	
		
	MKMapPoint originPoint = MKMapPointForCoordinate(originCoord);
	MKMapPoint endPoint = MKMapPointForCoordinate(endCoord);
	
	MKMapRect rect = MKMapRectMake(originPoint.x, originPoint.y, endPoint.x-originPoint.x, endPoint.y-originPoint.y);

	
	NSLog(@"overlay area origin = (%e,%e)  size = (%e,%e)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);

	[overlay setCoordinate:coord];
	[overlay setMapRect:rect];
	[primaryMapView addOverlay:overlay];
	[overlay release];
	NSLog(@"Added overlay");
	
	
}



-(IBAction) fakeNodeTest:(id) sender
{
	NSLog(@"Faking Node");
	scenario.delegate=self;
	[scenario fakeNodes];
}

-(IBAction) testMap:(id) sender{
	NSString * baseURL = @"";
	NSString * url = [NSString stringWithFormat:@"%@/nodes",baseURL];
	[scenario startNodeDownload:url];
}

-(void) nodeSource:(id) nodeManager didReceiveNodes:(NSArray*) nodes
{
	NSLog(@"Received nodes");
	for(L1Node * node in nodes){
		[primaryMapView addAnnotation:node];
	}
}


-(IBAction) testPolygon:(id) sender{

	int n = [scenario nodeCount];
	CLLocationCoordinate2D * coords = malloc(sizeof(CLLocationCoordinate2D)*n);
	
	int i=0;
	for(L1Node * node in scenario){
		assert ([node isKindOfClass:[L1Node class]]);
		coords[i++] = node.coordinate;
	}
	MKPolygon * polygon = [MKPolygon polygonWithCoordinates:coords count:n];
	[primaryMapView addOverlay:polygon];
//	MKPolygonView * polygonView = (MKPolygonView *)[primaryMapView viewForOverlay:polygon];
}


-(void) setScenario:(L1Scenario *)newScenario
{
	[scenario autorelease];
	scenario = newScenario;
	scenario.delegate=self;
}

@synthesize annotationImages, nodeContentViewController, scenario;

@end
