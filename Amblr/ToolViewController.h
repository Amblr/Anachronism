//
//  ToolViewController.h
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AmblrViewController;
@interface ToolViewController : UIViewController<UITextViewDelegate> {
	AmblrViewController * delegate;
	IBOutlet UISlider * dateSlider;
	IBOutlet UIButton * addNodeButton;
}
@property (retain) AmblrViewController * delegate;
-(IBAction) dateSliderChanged:(id) sender;
-(IBAction) addNode:(id) sender;
@end
