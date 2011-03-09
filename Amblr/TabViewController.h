//
//  TabViewController.h
//  Amblr
//
//  Created by Joe Zuntz on 09/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AmblrViewController;

@interface TabViewController : UIViewController {
	IBOutlet UIButton * mediaButton;
	IBOutlet UIButton * mapButton;
	AmblrViewController * delegate;
	int currentMode;
}

-(IBAction) pressMediaButton:(id)sender;
-(IBAction) pressMapButton:(id)sender;
@property (retain) AmblrViewController * delegate;

@end
