//
//  AmblrViewController.m
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "AmblrViewController.h"
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation AmblrViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	NSLog(@"View Did Appear");
	[self performSelector:@selector(startup:) withObject:nil afterDelay:0.4];

	
}

-(void) startup:(id) obj
{
	[self chooseMockup0];
}
	 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"view Did Load");
    [super viewDidLoad];
	self.toolViewController = [[ToolViewController alloc] initWithNibName:@"ToolViewController" bundle:nil];
	self.mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
	self.textViewController = [[TextViewController alloc] initWithNibName:@"TextViewController" bundle:nil];
	self.webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
	self.purchaseViewController = [[PurchaseViewController alloc] initWithNibName:@"PurchaseViewController" bundle:nil];
	self.distanceViewController = [[DistanceViewController alloc] initWithNibName:@"DistanceViewController" bundle:nil];

	
	self.toolViewController.delegate = self;
	self.mapViewController.delegate = self;
	self.textViewController.delegate = self;
	self.webViewController.delegate = self;
	self.distanceViewController.delegate = self;
	
	bottomLeftRect = CGRectFromString(@"{{70, 350}, {300, 300}}");
	topLeftRect = CGRectFromString(@"{{70, 50}, {300, 300}}");
	bigRect = CGRectFromString(@"{{400, 50}, {600, 600}}");
	
	NSLog(@"bottom: %@",NSStringFromCGRect(bottomLeftRect));
	NSLog(@"top: %@",NSStringFromCGRect(topLeftRect));
	NSLog(@"big: %@",NSStringFromCGRect(bigRect));
	
	
	self.inAnnotationMode=YES;
//	[self chooseMockup0];


	
	
	
	
//	mapViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//	toolViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;


	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(IBAction) logMap:(id)sender
{
	MKMapView * mapView = mapViewController.mapView;
	MKCoordinateRegion region = mapView.region;
	
	NSLog(@"%f,%f  %f,%f",region.center.latitude,region.center.longitude,region.span.latitudeDelta,region.span.longitudeDelta);
	
}


-(void) chooseMockup:(id) sender
{
	UISegmentedControl * control = (UISegmentedControl *) sender;
	int index = control.selectedSegmentIndex;
	NSLog(@"Running mockup %d",index);
	switch (index) {
		case 0:
			[self chooseMockup0];
			break;
		case 1:
			[self chooseMockup1];
			break;
		case 2:
			[self chooseMockup2];
			break;
		case 3:
			[self chooseMockup3];
			break;
		case 4:
			[self chooseMockup4];
			break;
			
		default:
			 NSLog(@"Unknown Mockup");
			break;
	}
}


-(void) removeViewsNotIn:(NSSet*) newViews
{
	if (![newViews member:mapViewController.view]) [mapViewController.view removeFromSuperview];	
	if (![newViews member:toolViewController.view]) [toolViewController.view removeFromSuperview];	
	if (![newViews member:textViewController.view]) [textViewController.view removeFromSuperview];	
	if (![newViews member:webViewController.view]) [webViewController.view removeFromSuperview];	
	if (![newViews member:purchaseViewController.view]) [purchaseViewController.view removeFromSuperview];	
	if (![newViews member:distanceViewController.view]) [distanceViewController.view removeFromSuperview];	
	
	if ([newViews member:webViewController.view]){
		self.inAnnotationMode=YES;
	}
	else {
		self.inAnnotationMode=NO;
	}

	
}

-(void) putInBigView:(UIView*) subView
{
	if ([subView superview]!=self.view) [self.view addSubview:subView];
	subView.frame = bigRect;
}

-(void) putInTopView:(UIView*) subView
{
	if ([subView superview]!=self.view) [self.view addSubview:subView];
	subView.frame=topLeftRect;
}

-(void) putInBottomView:(UIView*) subView
{
	if ([subView superview]!=self.view) [self.view addSubview:subView];
	subView.frame=bottomLeftRect;
}



 -(void) chooseMockup0
{
	NSSet * views = [NSSet setWithObjects:mapViewController.view,distanceViewController.view,toolViewController.view,nil];
	[UIView beginAnimations:@"mockup0" context:NULL];
	[UIView setAnimationDuration:0.4];
	[self removeViewsNotIn:views];
	[self putInBigView:mapViewController.view];
	[self putInBottomView:distanceViewController.view];
	[self putInTopView:toolViewController.view];
	[UIView commitAnimations];

}


-(void) chooseMockup1
{
	NSSet * views = [NSSet setWithObjects:mapViewController.view,distanceViewController.view,toolViewController.view,nil];
	[UIView beginAnimations:@"mockup1" context:NULL];
	[self removeViewsNotIn:views];
	[UIView setAnimationDuration:0.4];
	[self putInBigView:mapViewController.view];
	[self putInBottomView:toolViewController.view];
	[self putInTopView:distanceViewController.view];
	[UIView commitAnimations];
	
}

-(void) chooseMockup2{
	NSSet * views = [NSSet setWithObjects:mapViewController.view,webViewController.view,distanceViewController.view,nil];
	[UIView beginAnimations:@"mockup2" context:NULL];
	[UIView setAnimationDuration:0.4];
	[self removeViewsNotIn:views];

	[self putInBigView:webViewController.view];
	[self putInBottomView:mapViewController.view];
	[self putInTopView:distanceViewController.view];	
	[UIView commitAnimations];

}
-(void) chooseMockup3{
	NSSet * views = [NSSet setWithObjects:mapViewController.view,webViewController.view,purchaseViewController.view,nil];
	[UIView beginAnimations:@"mockup3" context:NULL];
	[UIView setAnimationDuration:0.4];

	[self removeViewsNotIn:views];
	[self putInTopView:mapViewController.view];	
	[self putInBottomView:purchaseViewController.view];
	[self putInBigView:webViewController.view];
	[UIView commitAnimations];

}

-(void) chooseMockup4{
	NSSet * views = [NSSet setWithObjects:mapViewController.view,webViewController.view,self.toolViewController.view,nil];
	[UIView beginAnimations:@"mockup4" context:NULL];
	[UIView setAnimationDuration:0.4];
	
	[self removeViewsNotIn:views];
	[self putInTopView:webViewController.view];	
	[self putInBottomView:toolViewController.view];
	[self putInBigView:mapViewController.view];
	[UIView commitAnimations];
}

- (void)dealloc {
    [super dealloc];
}



-(IBAction) addNodes:(id)sender
{
	for (int i=0;i<NUMBER_OF_NODES;i++)  [self.mapViewController addNodeAnnotation:i];	
}


-(NSString*) currentTextSelection
{
	NSString * selection = [webViewController getSelection];
	NSLog(@"Selection is %@", selection);
	return selection;
	
}

-(void) setDate:(float)newDate
{
	date=newDate;
	mapViewController.date=newDate;
	
}


//@synthesize topLeftView, bigView, bottomLeftView, barView;
@synthesize toolViewController, mapViewController, textViewController, webViewController, purchaseViewController;
@synthesize currentTextSelection,date, inAnnotationMode;
@synthesize distanceViewController;
@end
