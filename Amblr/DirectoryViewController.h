//
//  DirectoryViewController.h
//  Amblr
//
//  Created by Joe Zuntz on 09/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AmblrViewController;
@interface DirectoryViewController : UIViewController {
	AmblrViewController * delegate;
	BOOL jillPressedOnce;
	IBOutlet UIImageView * imageView;
}

@property (retain) AmblrViewController * delegate;
@property (retain) UIImageView * imageView;
-(IBAction) tapJill:(id) sender;
-(IBAction) tapNorthernLights:(id) sender;
@end
