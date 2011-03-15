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
	[self performSelector:@selector(startup:) withObject:nil afterDelay:5.0];
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
	
	
	self.mediaViewController.view.backgroundColor=[UIColor clearColor];
	self.tabViewController.view.backgroundColor=[UIColor clearColor];
	
	self.inAnnotationMode=YES;
//	[self chooseMockup0];


	
	
	
	
//	mapViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//	toolViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;


	
}


-(void) setInAnnotationMode:(BOOL)newMode
{
	inAnnotationMode=newMode;
//	for (MKAnnotationView * view in self.mapViewController.nodeViews){
//		view.canShowCallout = inAnnotationMode;
//	}
	
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

-(void) killView:(UIView*) view
{
	
	
}

-(void) removeViewsNotIn:(NSSet*) newViews
{
	[UIView beginAnimations:@"removeViews" context:NULL];
	[UIView setAnimationDuration:0.4];

	if (![newViews member:mapViewController.view]) mapViewController.view.alpha=0.0;
	if (![newViews member:toolViewController.view]) toolViewController.view.alpha=0.0;
	if (![newViews member:textViewController.view]) textViewController.view.alpha=0.0;
	if (![newViews member:webViewController.view]) webViewController.view.alpha=0.0;
	if (![newViews member:purchaseViewController.view]) purchaseViewController.view.alpha=0.0;
	if (![newViews member:distanceViewController.view]) distanceViewController.view.alpha=0.0;
	if (![newViews member:mediaViewController.view]) mediaViewController.view.alpha=0.0;
	if (![newViews member:directoryViewController.view]) directoryViewController.view.alpha=0.0;
	if (![newViews member:exploreViewController.view]) exploreViewController.view.alpha=0.0;
	[UIView commitAnimations];

	if (![newViews member:mapViewController.view])  [mapViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4f];
	if (![newViews member:toolViewController.view]) [toolViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4f];
	if (![newViews member:textViewController.view]) [textViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4f];
	if (![newViews member:webViewController.view]) [webViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4f];
	if (![newViews member:purchaseViewController.view]) [purchaseViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4f];
//	if (![newViews member:distanceViewController.view]) [distanceViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4f];
	if (![newViews member:distanceViewController.view]) [distanceViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4f];
	if (![newViews member:mediaViewController.view]) [mediaViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4f];
	if (![newViews member:directoryViewController.view]) [directoryViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4f];
	if (![newViews member:exploreViewController.view]) [exploreViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4f];
	
	
	
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
	BOOL new_view = ([subView superview]!=self.view);

	if (new_view){
		
		subView.frame = bigRect;
		[UIView beginAnimations:@"bigView" context:NULL];
		[UIView setAnimationDuration:0.4];
		subView.alpha=1.0;
		[self.view addSubview:subView];
		[UIView commitAnimations];
	}
	else{
		[UIView beginAnimations:@"bigView" context:NULL];
		[UIView setAnimationDuration:0.4];
		subView.frame = bigRect;
		[UIView commitAnimations];
		
	}

}

-(void) putInTopView:(UIView*) subView
{
	BOOL new_view = ([subView superview]!=self.view);

	if (new_view){
		subView.frame = topLeftRect;
		[UIView beginAnimations:@"topView" context:NULL];
		[UIView setAnimationDuration:0.4];
		subView.alpha=1.0;
		[self.view addSubview:subView];
		[UIView commitAnimations];
	}
	else{
		[UIView beginAnimations:@"topView" context:NULL];
		[UIView setAnimationDuration:0.4];
		subView.frame = topLeftRect;
		[UIView commitAnimations];
		
	}
}

-(void) putInBottomView:(UIView*) subView
{
	BOOL new_view = ([subView superview]!=self.view);

	if (new_view){
		subView.frame = bottomLeftRect;
		[UIView beginAnimations:@"bottomView" context:NULL];
		[UIView setAnimationDuration:0.4];
		[self.view addSubview:subView];
		subView.alpha=1.0;
		[UIView commitAnimations];
	}
	else{
		[UIView beginAnimations:@"bottomView" context:NULL];
		[UIView setAnimationDuration:0.4];
		subView.frame = bottomLeftRect;
		[UIView commitAnimations];
		
	}
	
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
	[self removeViewsNotIn:views];
	[self putInBigView:webViewController.view];
	[self putInBottomView:mapViewController.view];
	[self putInTopView:toolViewController.view];
	
}

-(void) chooseMockup2{
	NSSet * views = [NSSet setWithObjects:mapViewController.view,directoryViewController.view,distanceViewController.view,nil];
	[self removeViewsNotIn:views];

	[self putInBigView:mapViewController.view];
	[self putInBottomView:directoryViewController.view];
	[self putInTopView:distanceViewController.view];	

}
-(void) chooseMockup3{
	NSSet * views = [NSSet setWithObjects:exploreViewController.view,mediaViewController.view,mapViewController.view,nil];
	[self removeViewsNotIn:views];
	mediaViewController.imageView.image = [UIImage imageNamed:@"fairground.jpg"];
	mediaViewController.imageView.contentMode=UIViewContentModeScaleAspectFill;
	[self putInTopView:exploreViewController.view];	
	[self putInBottomView:mapViewController.view];
	[self putInBigView:mediaViewController.view];

}

-(void) chooseMockup4{
	NSSet * views = [NSSet setWithObjects:mapViewController.view,directoryViewController.view,self.distanceViewController.view,nil];
	directoryViewController.imageView.image = [UIImage imageNamed:@"directory1.png"];
	
	[self removeViewsNotIn:views];
	[self putInTopView:distanceViewController.view];	
	[self putInBottomView:directoryViewController.view];
	[self putInBigView:mapViewController.view];
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
	self.mediaViewController.view.backgroundColor=[UIColor clearColor];
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
	NSSet * views = [NSSet setWithObjects:mapViewController.view,directoryViewController.view,self.purchaseViewController.view,nil];
	[self removeViewsNotIn:views];
	[self putInTopView:purchaseViewController.view];	
	[UIView commitAnimations];
	
	
}


//@synthesize topLeftView, bigView, bottomLeftView, barView;
@synthesize toolViewController, mapViewController, tabViewController, textViewController, webViewController, purchaseViewController, mediaViewController;
@synthesize currentTextSelection,date, inAnnotationMode;
@synthesize distanceViewController, directoryViewController, exploreViewController;

@end
