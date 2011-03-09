    //
//  distanceViewController.m
//  Amblr
//
//  Created by Joe Zuntz on 07/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "DistanceViewController.h"
#import "AmblrViewController.h"


@implementation DistanceViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


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


-(IBAction) addNode:(id) sender
{
	[self.delegate.mapViewController addNodeAnnotation:[NSNumber numberWithInt:0]];
	[self.delegate flashImageBorder];
	
}

- (void)dealloc {
    [super dealloc];
}


-(IBAction) distanceSliderChanged:(id) sender
{
	self.delegate.mapViewController.date=distanceSlider.value;
	
}



@synthesize delegate;
@end
