//
//  TextViewController.h
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AmblrViewController;

@interface TextViewController : UIViewController {
	IBOutlet UITextView * textView;
	AmblrViewController * delegate;
}

-(void) deselectText;

@property (retain) UITextView * textView;
@property (retain) AmblrViewController * delegate;
@end
