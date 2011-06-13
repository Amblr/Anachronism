//
//  OspreyViewController.h
//  Osprey
//
//  Created by Joe Zuntz on 06/06/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L1MapViewController.h"

@interface OspreyViewController : UIViewController {
    
    IBOutlet UISlider *alphaSlider;
    IBOutlet L1MapViewController *mapViewController;
    NSMutableArray * overlays;
}
- (IBAction)alphaSliderValueChanged;

@end
