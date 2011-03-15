    //
//  TabViewController.m
//  Amblr
//
//  Created by Joe Zuntz on 09/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "TabViewController.h"
#import "AmblrViewController.h"

@implementation TabViewController

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
	[mediaButton setImage:[UIImage imageNamed:@"mediaButton.png"] forState:UIControlStateNormal];
	[mapButton setImage:[UIImage imageNamed:@"mapButtonBright.png"] forState:UIControlStateNormal];

	currentMode=1;
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


-(IBAction) pressMediaButton:(id)sender
{
	NSLog(@"Mode = %d\n",currentMode);
	if (currentMode==1){
		currentMode++;	
		[mediaButton setImage:[UIImage imageNamed:@"mediaButtonBright.png"] forState:UIControlStateNormal];
		[mapButton setImage:[UIImage imageNamed:@"mapButton.png"] forState:UIControlStateNormal];
		[delegate chooseMockup1];
	}
	
	if (currentMode==3){
		currentMode++;
		[mediaButton setImage:[UIImage imageNamed:@"mediaButtonBright.png"] forState:UIControlStateNormal];
		[mapButton setImage:[UIImage imageNamed:@"mapButton.png"] forState:UIControlStateNormal];
		[delegate chooseMockup3];

		
	}
}
-(IBAction) pressMapButton:(id)sender
{
	NSLog(@"Press map");
	if (currentMode==2){
		currentMode++;
		[mediaButton setImage:[UIImage imageNamed:@"mediaButton.png"] forState:UIControlStateNormal];
		[mapButton setImage:[UIImage imageNamed:@"mapButtonBright.png"] forState:UIControlStateNormal];
		[delegate chooseMockup2];
	}
	if (currentMode==4){
		currentMode++;
		[self.delegate.mapViewController.mapView removeAnnotations:self.delegate.mapViewController.nodes];
		[self.delegate.mapViewController.mapView removeAnnotations:self.delegate.mapViewController.polylines];
		[self.delegate.mapViewController.mapView removeAnnotations:self.delegate.mapViewController.pathNodes];

		[mediaButton setImage:[UIImage imageNamed:@"mediaButton.png"] forState:UIControlStateNormal];
		[mapButton setImage:[UIImage imageNamed:@"mapButtonBright.png"] forState:UIControlStateNormal];
		[delegate chooseMockup4];
	}
	
	
	
}

@synthesize delegate;
@end
