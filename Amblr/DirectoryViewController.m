    //
//  DirectoryViewController.m
//  Amblr
//
//  Created by Joe Zuntz on 09/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "DirectoryViewController.h"
#import "AmblrViewController.h"

@implementation DirectoryViewController

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
	jillPressedOnce=NO;
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


-(IBAction) tapJill:(id) sender
{
	if (jillPressedOnce){
		[self.delegate showPurchaseView];
	}
	else{
		imageView.image = [UIImage imageNamed:@"directory2.png"];
		jillPressedOnce=YES;
		for (int i=1;i<5;i++){
			NSNumber * num = [NSNumber numberWithInt:i];
			[self.delegate.mapViewController performSelector:@selector(addNodeAnnotation:) withObject:num afterDelay:i*0.05];
		}
}
}
-(IBAction) tapNorthernLights:(id) sender
{
	imageView.image = [UIImage imageNamed:@"directory3.png"];
	[self.delegate addNodes:nil];

}


- (void)dealloc {
    [super dealloc];
}

@synthesize delegate;
@synthesize imageView;
@end
