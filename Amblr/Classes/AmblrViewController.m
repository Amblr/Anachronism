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
#import "SplashScreenController.h"
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
	if (started) return;
	 SplashScreenController * splashScreenController2 = [[SplashScreenController alloc] initWithNibName:@"SplashScreenController" bundle:nil];
	[self presentModalViewController:splashScreenController2 animated:NO];
	[self performSelector:@selector(startup:) withObject:nil afterDelay:2.0];
}

-(void) resplash:(id)sender
{
	SplashScreenController * splashScreenController3 = [[SplashScreenController alloc] initWithNibName:@"SplashScreenController" bundle:nil];

	[self presentModalViewController:splashScreenController3 animated:YES];

}

-(void) startup:(id) obj
{
	[self dismissModalViewControllerAnimated:YES];
	started=YES;
	[self chooseMockup0];
}
	 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"view Did Load");
    [super viewDidLoad];
	started=NO;
	self.toolViewController = [[ToolViewController alloc] initWithNibName:@"ToolViewController" bundle:nil];
	self.mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
	self.textViewController = [[TextViewController alloc] initWithNibName:@"TextViewController" bundle:nil];
	self.webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
	self.tabViewController = [[TabViewController alloc] initWithNibName:@"TabViewController" bundle:nil];
	self.purchaseViewController = [[PurchaseViewController alloc] initWithNibName:@"PurchaseViewController" bundle:nil];
	self.distanceViewController = [[DistanceViewController alloc] initWithNibName:@"DistanceViewController" bundle:nil];
	self.mediaViewController = [[MediaViewController alloc] initWithNibName:@"MediaViewController" bundle:nil];
	self.directoryViewController = [[DirectoryViewController alloc] initWithNibName:@"DirectoryViewController" bundle:nil];
	self.exploreViewController = [[ExploreViewController alloc] initWithNibName:@"ExploreViewController" bundle:nil];
	
	self.toolViewController.delegate = self;
	self.mapViewController.delegate = self;
	self.textViewController.delegate = self;
	self.webViewController.delegate = self;
	self.distanceViewController.delegate = self;
	self.tabViewController.delegate = self;
	self.directoryViewController.delegate = self;
	self.exploreViewController.delegate = self;
	self.purchaseViewController.delegate = self;
	
	
	bottomLeftRect = CGRectFromString(@"{{45, 420}, {275, 275}}");
	topLeftRect = CGRectFromString(@"{{45, 70}, {275, 275}}");
	tabRect = CGRectFromString(@"{{45, 355}, {300, 50}}");
	bigRect = CGRectFromString(@"{{375, 70}, {600, 600}}");
	
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
	if (![newViews member:distanceViewController.view]) [distanceViewController.view removeFromSuperview];	
//	if (![newViews member:tabViewController.view]) [tabViewController.view removeFromSuperview];	
	if (![newViews member:mediaViewController.view]) [mediaViewController.view removeFromSuperview];	
	if (![newViews member:directoryViewController.view]) [directoryViewController.view removeFromSuperview];	
	
	if ([newViews member:webViewController.view]){
		self.inAnnotationMode=YES;
		NSLog(@"Entering/staying in annotation mode");
	}
	else {
		self.inAnnotationMode=NO;
		NSLog(@"Exiting/staying out of annotation mode");
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

-(void) putInTabView:(UIView*) subView
{
	if ([subView superview]!=self.view) [self.view addSubview:subView];
	subView.frame=tabRect;
}




 -(void) chooseMockup0
{
	[self putInTabView:self.tabViewController.view];
	NSSet * views = [NSSet setWithObjects:mapViewController.view,distanceViewController.view,mediaViewController.view,nil];
	[UIView beginAnimations:@"mockup0" context:NULL];
	[UIView setAnimationDuration:0.4];
	[self removeViewsNotIn:views];
	[self putInBigView:mapViewController.view];
	[self putInBottomView:mediaViewController.view];
	[self putInTopView:distanceViewController.view];
	[UIView commitAnimations];

}


-(void) chooseMockup1
{
	NSSet * views = [NSSet setWithObjects:webViewController.view,mapViewController.view,toolViewController.view,nil];
	[UIView beginAnimations:@"mockup1" context:NULL];
	[self removeViewsNotIn:views];
	[UIView setAnimationDuration:0.4];
	[self putInBigView:webViewController.view];
	[self putInBottomView:mapViewController.view];
	[self putInTopView:toolViewController.view];
	[UIView commitAnimations];
	
}

-(void) chooseMockup2{
	NSSet * views = [NSSet setWithObjects:mapViewController.view,directoryViewController.view,distanceViewController.view,nil];
	[UIView beginAnimations:@"mockup2" context:NULL];
	[UIView setAnimationDuration:0.4];
	[self removeViewsNotIn:views];

	[self putInBigView:mapViewController.view];
	[self putInBottomView:directoryViewController.view];
	[self putInTopView:distanceViewController.view];	
	[UIView commitAnimations];

}
-(void) chooseMockup3{
	NSSet * views = [NSSet setWithObjects:exploreViewController.view,mediaViewController.view,mapViewController.view,nil];
	[UIView beginAnimations:@"mockup3" context:NULL];
	[UIView setAnimationDuration:0.4];

	[self removeViewsNotIn:views];
	[self putInTopView:exploreViewController.view];	
	[self putInBottomView:mapViewController.view];
	[self putInBigView:mediaViewController.view];
	[UIView commitAnimations];

}

-(void) chooseMockup4{
	NSSet * views = [NSSet setWithObjects:mapViewController.view,directoryViewController.view,self.distanceViewController.view,nil];
	directoryViewController.imageView.image = [UIImage imageNamed:@"directory1.png"];
	[UIView beginAnimations:@"mockup4" context:NULL];
	[UIView setAnimationDuration:0.4];
	
	[self removeViewsNotIn:views];
	[self putInTopView:distanceViewController.view];	
	[self putInBottomView:directoryViewController.view];
	[self putInBigView:mapViewController.view];
	[UIView commitAnimations];
}

- (void)dealloc {
    [super dealloc];
}



-(IBAction) addNodes:(id)sender
{
	for (int i=1;i<NUMBER_OF_NODES;i++){
		NSNumber * num = [NSNumber numberWithInt:i];
		[self.mapViewController performSelector:@selector(addNodeAnnotation:) withObject:num afterDelay:i*0.05];
	}
		//		[self.mapViewController addNodeAnnotation:i];	
}

-(void) flashImageBorder
{
	UIColor * gold = [UIColor colorWithRed:215.0/256. green:203.0/256. blue:158.0/256. alpha:1.0];
	self.mediaViewController.view.backgroundColor=gold;
	[UIView beginAnimations:@"flashDim" context:nil];
	[UIView setAnimationDuration:3.0];
	self.mediaViewController.view.backgroundColor=[UIColor whiteColor];
	[UIView commitAnimations];
	
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

-(void) showPurchaseView
{
	[UIView beginAnimations:@"mockup3" context:NULL];
	[self putInTopView:purchaseViewController.view];	
	[UIView commitAnimations];
	
	
}


//@synthesize topLeftView, bigView, bottomLeftView, barView;
@synthesize toolViewController, mapViewController, tabViewController, textViewController, webViewController, purchaseViewController, mediaViewController;
@synthesize currentTextSelection,date, inAnnotationMode;
@synthesize distanceViewController, directoryViewController, exploreViewController;

@end
