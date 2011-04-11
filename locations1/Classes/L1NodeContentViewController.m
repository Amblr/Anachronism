//
//  L1NodeContentViewController.m
//  locations1
//
//  Created by Joe Zuntz on 19/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "L1NodeContentViewController.h"
#import <QuartzCore/QuartzCore.h>

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


-(IBAction) exitModal:(id) sender
{
	NSLog(@"Exit Modal");
	[self dismissModalViewControllerAnimated:YES];
}



-(IBAction) rotate:(id) sender
{
	NSLog(@"Rotate");
	CALayer * layer = nodeImage.layer;

	CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
	spinAnimation.fromValue =[NSNumber numberWithFloat:0];
	spinAnimation.toValue = [NSNumber numberWithFloat:3.14*2];
	spinAnimation.duration=3.0;
	spinAnimation.repeatCount=666666;
	[layer addAnimation:spinAnimation forKey:@"spinAnimation"];
    
    CABasicAnimation *spinAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	spinAnimation2.fromValue =[NSNumber numberWithFloat:0];
	spinAnimation2.toValue = [NSNumber numberWithFloat:3.14*2];
	spinAnimation2.duration=3.0;
	spinAnimation2.repeatCount=666666;
	[layer addAnimation:spinAnimation2 forKey:@"spinAnimation2"];

	
	
	
}


- (void)dealloc {
    [super dealloc];
}


@end
