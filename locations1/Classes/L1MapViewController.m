//
//  L1MapViewController.m
//  locations1
//
//  Created by Joe Zuntz on 16/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1MapViewController.h"
#import "L1Node.h"

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
		annotationView = [[MKAnnotationView alloc] initWithAnnotation:node reuseIdentifier:@"node"];
	}

	annotationView.image = [self.annotationImages objectForKey:@"node"];
	annotationView.enabled = [node isVisible];
	annotationView.canShowCallout = YES;
	
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//	[rightButton addTarget:self
//					action:@selector(showDetails:)
//		  forControlEvents:UIControlEventTouchUpInside];
	annotationView.rightCalloutAccessoryView = rightButton;
	
		
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

	if (![overlay isKindOfClass:[MKPolygon class]]) return nil;
	MKPolygonView * polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
	UIColor * color = [[UIColor redColor] colorWithAlphaComponent:0.3];
	polygonView.fillColor = color;
	
	return polygonView;
	
}




-(IBAction) fakeNodeTest:(id) sender
{
	nodeManager = [[L1NodeManager alloc] init];
	nodeManager.delegate=self;
	[nodeManager fakeNodes];
}

-(IBAction) testMap:(id) sender{
	nodeManager = [[L1NodeManager alloc] init];
	nodeManager.delegate=self;
	NSString * baseURL = @"";
	NSString * url = [NSString stringWithFormat:@"%@/nodes",baseURL];
	[nodeManager startNodeDownload:url];
}

-(void) nodeManager:(L1NodeManager*) nodeManager didReceiveNodes:(NSArray*) nodes
{
	for(L1Node * node in nodes){
		[primaryMapView addAnnotation:node];
	}
}


-(IBAction) testPolygon:(id) sender{
	if (!nodeManager) return;
	int n = [nodeManager count];
	CLLocationCoordinate2D * coords = malloc(sizeof(CLLocationCoordinate2D)*n);
	
	int i=0;
	for(L1Node * node in nodeManager){
		assert ([node isKindOfClass:[L1Node class]]);
		coords[i++] = node.coordinate;
	}
	MKPolygon * polygon = [MKPolygon polygonWithCoordinates:coords count:n];
	[primaryMapView addOverlay:polygon];
	MKPolygonView * polygonView = (MKPolygonView *)[primaryMapView viewForOverlay:polygon];
}



@synthesize annotationImages, nodeContentViewController;

@end
