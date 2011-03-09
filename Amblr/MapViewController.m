    //
//  mapViewController.m
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "MapViewController.h"
#import "AmblrViewController.h"
#import "NVPolylineAnnotationView.h"

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
//	[self setupNodes];
	inSelectionProcess=NO;
	pinImage1 = [[UIImage imageNamed:@"silver_pin.png"] retain];
	pinImage2 = [[UIImage imageNamed:@"gold_pin.png"] retain];
	minDate=1850;
	maxDate=1925;
	date=1925;
	self.pathNodes=[NSMutableArray arrayWithCapacity:0];
	[self setupCollegeNodes];
	AmblrNode * node = [self.nodes objectAtIndex:0];
	node.assigned=YES;

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
//	for(int i=0;i<NUMBER_OF_NODES;i++) [self addNodeAnnotation:i];
	
}

-(void) awakeFromNib
{
	NSLog(@"Awoke.");
	[super awakeFromNib];
//	[self zoomToOxford];
//	[self setupCollegeNodes];
//	for(int i=0;i<[self.nodes count];i++) [self addNodeAnnotation:i];

	
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

-(void) addNewRandomAnnotation
{
	int n = [self.nodes count];
	[self generateRandomNode:n];
	[self addNodeAnnotation:[NSNumber numberWithInt:n]];
	
}





-(void) addNodeAnnotation:(NSNumber*) num
{
	int n = [num intValue];
	if (n<0 || n>=[nodes count]) return;
//	NSLog(@"Adding node annotation %d",n);
	AmblrNode * node = [self.nodes objectAtIndex:n];
	[mapView addAnnotation:node];
	
	
}

-(UIImageOrientation) randomOrientation
{
	int n = arc4random()%4;
	switch (n) {
		case 0:
			return UIImageOrientationUp;
			break;
		case 1:
			return UIImageOrientationDown;
			break;
		case 2:
			return UIImageOrientationLeft;
			break;
		case 3:
			return UIImageOrientationRight;
		default:
			break;
	}
	return UIImageOrientationUp;			
	
}

-(NSString*) randomName
{
	NSArray * names = [NSArray arrayWithObjects:@"Andrews", @"Lynn", @"Johnson", @"Michaels", @"Cavendish", @"Smyth", @"Wellesly",nil];
	return [names objectAtIndex:(arc4random()%[names count])];
	
}

-(NSString*)  randomEvent
{
	NSArray * events = [NSArray arrayWithObjects:@"Birth of %@", @"Death of %@", @"Arrest of %@", nil];
	NSString * eventType = [events objectAtIndex:(arc4random()%[events count])];
	return [NSString stringWithFormat:eventType, [self randomName]];
	
}
	

	
-(void) generateRandomNode:(int) i
{
	float deltaLatitude = 0.014638;
	float deltaLongitude = 0.023646;
	float centerLatitude = 51.755475;
	float centerLongitude = -1.260660;
	minDate=1850.;
	maxDate=1925.;
	
	NSString * key = [NSString stringWithFormat:@"node%d",i];
	float latitude = centerLatitude + ((arc4random()%10000)/10000.0-0.5)*deltaLatitude;
	float longitude = centerLongitude + ((arc4random()%10000)/10000.0-0.5)*deltaLongitude;
	float radius = 1.0;
	float nodeDate = ((arc4random()%1000000)/1000000.0)*(maxDate-minDate)+minDate; //random date
	NSString * name = [NSString stringWithFormat:@"%d %@",(int)nodeDate,[self randomEvent]];
	NSString * description = @"";
	AmblrNode * node = [self nodeWithKey:key name:name description:description latitude:latitude longitude:longitude radius:radius];
	node.date=nodeDate;
	NSLog(@"node date set = %f",node.date);
	[self.nodes addObject:node];
	
	
	
}


-(void) randomDateNode:(NSString*)name latitude:(float)latitude longitude:(float)longitude
{
	float radius = 1.0;
	float nodeDate = ((arc4random()%1000000)/1000000.0)*(maxDate-minDate)+minDate; //random date
	NSString * description = @"";
	AmblrNode * node = [self nodeWithKey:name name:name description:description latitude:latitude longitude:longitude radius:radius];
	node.date=nodeDate;
	[self.nodes addObject:node];
	
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	NSLog(@"Selected.");
	if ((!delegate.inAnnotationMode) && [view.annotation isKindOfClass:[AmblrNode class]]) [self addSelectedNodeToPath:(AmblrNode*)view.annotation];

	
	
}


-(void) setupNodes
{
	for(int i=0;i<NUMBER_OF_NODES;i++) [self generateRandomNode:i];
	
	
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


-(MKAnnotationView*) polylineViewForPolyline:(NVPolylineAnnotation*)line
{
	return [[NVPolylineAnnotationView alloc] initWithAnnotation:line mapView:mapView];
	
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
	if ([annotation isKindOfClass:[AmblrNode class]]){
		return [self annotationViewFor:theMapView forNode:(AmblrNode*)annotation];
	}
	
	if ([annotation isKindOfClass:[NVPolylineAnnotation class]]){
		return [self polylineViewForPolyline:(NVPolylineAnnotation*)annotation];
	}
	
	return nil;
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views { 
	MKAnnotationView *aV;
	for (aV in views) {
		if ([aV isKindOfClass:[NVPolylineAnnotationView class]]) continue;
		CGRect endFrame = aV.frame;
		
		aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.45];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[aV setFrame:endFrame];
		[UIView commitAnimations];
		
	}
}


-(void) clickNodeButton:(id)sender
{
	MKAnnotationView * annotationView = (MKAnnotationView *) [[sender superview] superview];
	if (![annotationView isKindOfClass:[MKAnnotationView class]]) return;
	id<MKAnnotation> annotation = annotationView.annotation;
	if (![annotation isKindOfClass:[AmblrNode class]]) return;
	AmblrNode * node = (AmblrNode*)annotation;
	
	if (delegate.inAnnotationMode){
		NSLog(@"Annotation mode; adding text");
		[self addTextToNode:node];
	}
	else{
		NSLog(@"Path mode; adding line");
		[self addSelectedNodeToPath:node];
		
	}
	
}

-(void) addTextToNode:(AmblrNode*)node
{
	
	NSString * newText = delegate.currentTextSelection;
	NSLog(@"Adding text:%@",newText);
	if (newText){
		if ([newText length]){
			node.text=newText;
			node.assigned=YES;
			MKAnnotationView * annotationView = [mapView viewForAnnotation:node];
			annotationView.image=pinImage2;
			[self.mapView deselectAnnotation:node animated:NO];
			[self.mapView selectAnnotation:node animated:NO];
		}
	}
	
	
}

-(MKAnnotationView *)annotationViewFor:(MKMapView *)theMapView forNode:(AmblrNode*)node{
	
	
	
	MKAnnotationView * annotationView = (MKAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:@"node"];
	
	if (!annotationView){
		annotationView = [[MKAnnotationView alloc] initWithAnnotation:node reuseIdentifier:@"node"];
	}
	
//	MKPinAnnotationView * pinAnnotationView = (MKPinAnnotationView *) annotationView;
	
//	annotationView.image = [self.annotationImages objectForKey:@"node"];
	annotationView.enabled = (date>=node.date);
	annotationView.centerOffset = CGPointMake(19.0, -6.0);
	//NSLog(@"enabled = %d  (%f,%f)",annotationView.enabled,date,node.date);
	annotationView.canShowCallout = YES;
	if (annotationView.enabled){
		if (node.assigned){
			 annotationView.image=pinImage2;
	//		annotationView.image.imageOrientation = [self randomOrientation];
		}
		else {
			annotationView.image=pinImage1;
	//		annotationView.image.imageOrientation = [self randomOrientation];
		}
	} else{
		annotationView.image=nil;
	}
	
//	CGFloat angle = (arc4random()%10000)/10000.0*2*M_PI;
//	annotationView.transform = CGAffineTransformRotate(CGAffineTransformIdentity,angle);

//	pinAnnotationView.pinColor=MKPinAnnotationColorRed;
	
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	SEL buttonAction = @selector(clickNodeButton:);
	[rightButton addTarget:self action:buttonAction forControlEvents:UIControlEventTouchUpInside];
	annotationView.leftCalloutAccessoryView = rightButton;
	
	
	return annotationView;
}

-(void) setDate:(float)newDate
{
	date=newDate;
	NSLog(@"Set date to %f",date);

	for (AmblrNode * node in self.nodes){
		MKAnnotationView * annotationView = [mapView viewForAnnotation:node];
		if (annotationView){
			annotationView.enabled = (date>=node.date);
			if (annotationView.enabled){
				if (node.assigned){
					annotationView.image=pinImage2;
				}
				else {
					annotationView.image=pinImage1;
				}
			} else{
				annotationView.image=nil;
			}
			[annotationView setNeedsDisplay];
		}
		
	}
	
}


-(void) addSelectedNodeToPath:(AmblrNode*) node;
{
	NSLog(@"Added node to path: %@",node.name);
	[self.pathNodes addObject:node];
	node.assigned=YES;
	MKAnnotationView * annotationView = [mapView viewForAnnotation:node];
	annotationView.image=pinImage2;

	if ([self.pathNodes count]>1){
		if (self.polyline) [mapView removeAnnotation:self.polyline];
		NSMutableArray * pathPoints = [NSMutableArray arrayWithCapacity:0];
		
		for (AmblrNode * pathNode in self.pathNodes){
			CLLocation * location = [[CLLocation alloc] initWithLatitude:[pathNode.latitude doubleValue] longitude:[pathNode.longitude doubleValue]];
			[pathPoints addObject:[location autorelease]];
		}
		self.polyline = [[NVPolylineAnnotation alloc] initWithPoints:pathPoints mapView:mapView];
		[mapView addAnnotation:self.polyline];
	}
	
	
}


@synthesize date;
@synthesize nodes;
@synthesize mapView, delegate;
@synthesize pathNodes;
@synthesize polyline;




-(void) setupCollegeNodes
{
	[self randomDateNode:@"All Souls College" latitude:51.753279 longitude:-1.253041];
	[self randomDateNode:@"Balliol College" latitude:51.754700 longitude:-1.257800];
	[self randomDateNode:@"Brasenose College" latitude:51.753206 longitude:-1.254731];
	[self randomDateNode:@"Christ Church" latitude:51.750199 longitude:-1.255853];
	[self randomDateNode:@"Corpus Christi College" latitude:51.750909 longitude:-1.253702];
	[self randomDateNode:@"Exeter College" latitude:51.753871 longitude:-1.256046];
	[self randomDateNode:@"Green Templeton College" latitude:51.761223 longitude:-1.262866];
	[self randomDateNode:@"Harris Manchester" latitude:51.755758 longitude:-1.252044];
	[self randomDateNode:@"Hertford College" latitude:51.754205 longitude:-1.253467];
	[self randomDateNode:@"Jesus College" latitude:51.753422 longitude:-1.256968];
	[self randomDateNode:@"Keble College" latitude:51.758899 longitude:-1.257715];
	[self randomDateNode:@"Kellogg College" latitude:51.764000 longitude:-1.260000];
	[self randomDateNode:@"Lady Margaret Hall" latitude:51.764830 longitude:-1.254036];
	[self randomDateNode:@"Linacre College" latitude:51.759350 longitude:-1.249840];
	[self randomDateNode:@"Lincoln College" latitude:51.753260 longitude:-1.255905];
	[self randomDateNode:@"Magdalen College" latitude:51.752374 longitude:-1.247077];
	[self randomDateNode:@"Mansfield College" latitude:51.757428 longitude:-1.252876];
	[self randomDateNode:@"Merton College" latitude:51.751062 longitude:-1.252109];
	[self randomDateNode:@"New College" latitude:51.754277 longitude:-1.251288];
	[self randomDateNode:@"Nuffield College" latitude:51.752834 longitude:-1.262917];
	[self randomDateNode:@"Oriel College" latitude:51.751567 longitude:-1.253702];
	[self randomDateNode:@"Pembroke College" latitude:51.750062 longitude:-1.257827];
	[self randomDateNode:@"The Queen's College" latitude:51.753187 longitude:-1.251043];
	[self randomDateNode:@"St Anne's College" latitude:51.762123 longitude:-1.261974];
	[self randomDateNode:@"St Antony's College" latitude:51.763149 longitude:-1.262903];
	[self randomDateNode:@"St Catherine's College" latitude:51.757066 longitude:-1.245098];
	[self randomDateNode:@"St Cross College" latitude:51.756528 longitude:-1.260311];
	[self randomDateNode:@"St Hilda's College" latitude:51.749162 longitude:-1.245334];
	[self randomDateNode:@"St Hugh's College" latitude:51.765675 longitude:-1.263406];
	[self randomDateNode:@"St John Baptist College" latitude:51.756120 longitude:-1.258605];
	[self randomDateNode:@"St Peter's College" latitude:51.752762 longitude:-1.260721];
	[self randomDateNode:@"Somerville College" latitude:51.759644 longitude:-1.261872];
	[self randomDateNode:@"Trinity College" latitude:51.754914 longitude:-1.256599];
	[self randomDateNode:@"University College" latitude:51.752453 longitude:-1.251996];
	[self randomDateNode:@"Wadham College" latitude:51.755871 longitude:-1.254593];
	[self randomDateNode:@"Wolfson College" latitude:51.770977 longitude:-1.255263];
	[self randomDateNode:@"Worcester College" latitude:51.754971 longitude:-1.263701];
	
	
	
}



@end
