//
//  OspreyViewController.m
//  Osprey
//
//  Created by Joe Zuntz on 06/06/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "OspreyViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation OspreyViewController

- (void)dealloc
{
    [alphaSlider release];
    [mapViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [alphaSlider release];
    alphaSlider = nil;
    [mapViewController release];
    mapViewController = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)startDisplay{
    CLLocationDegrees londonLatitude = 51.507222;
    CLLocationDegrees londonLongitude = -0.1275;
    CLLocationCoordinate2D londonCoordinate = CLLocationCoordinate2DMake(londonLatitude, londonLongitude);
    overlays = [[NSMutableArray alloc] initWithCapacity:0];
    
    [mapViewController zoomToCoordinate:londonCoordinate];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)alphaSliderValueChanged {
    float alpha = alphaSlider.value;
}
@end
