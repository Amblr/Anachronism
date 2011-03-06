//
//  WebViewController.h
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AmblrViewController;
@interface WebViewController : UIViewController<UIWebViewDelegate> {
	IBOutlet UIWebView * webView;
	AmblrViewController * delegate;
	NSString * getSelectionJavaScript;
}
@property (retain) AmblrViewController * delegate;
@property (retain) UIWebView * webView;
-(NSString*) getSelection;
@end
