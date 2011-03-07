//
//  distanceViewController.h
//  Amblr
//
//  Created by Joe Zuntz on 07/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AmblrViewController;

@interface DistanceViewController : UIViewController {
	IBOutlet UISlider * distanceSlider;
	AmblrViewController * delegate;
}
@property (retain) AmblrViewController * delegate;
-(IBAction) distanceSliderChanged:(id) sender;
-(IBAction) addNode:(id) sender;

@end
