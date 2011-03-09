//
//  ExploreViewController.h
//  Amblr
//
//  Created by Joe Zuntz on 09/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AmblrViewController;
@interface ExploreViewController : UIViewController {
	IBOutlet UIButton * immerseButton;
	IBOutlet UIImageView * imageView;
	AmblrViewController * delegate;
	
}
@property (retain) AmblrViewController * delegate;
-(IBAction) immerse:(id)sender;
@end
