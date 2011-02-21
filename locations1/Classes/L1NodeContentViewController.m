//
//  L1NodeContentViewController.m
//  locations1
//
//  Created by Joe Zuntz on 19/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "L1NodeContentViewController.h"


@implementation L1NodeContentViewController

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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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


-(void) setName:(NSString*)name
{
	nodeName.text=name;
}

-(void) setText:(NSString*)text
{
	nodeText.text=text;
}

-(void) setImage:(UIImage*)image
{
	nodeImage.image=image;
}



- (void)dealloc {
    [super dealloc];
}


@end
