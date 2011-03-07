    //
//  WebViewController.m
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

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
	NSString * filePath = [[NSBundle mainBundle] pathForResource:@"genesis" ofType:@"html"];

	NSError * error;
	NSStringEncoding * encoding;
	NSString * htmlContent = [NSString stringWithContentsOfFile:filePath usedEncoding:encoding error:&error];
	webView.delegate=self;
	[webView loadHTMLString:htmlContent baseURL:nil];

    webView.backgroundColor = [UIColor whiteColor];
//    for (UIView* subView in [webView subviews])
//    {
//        if ([subView isKindOfClass:[UIScrollView class]]) {
//            for (UIView* shadowView in [subView subviews])
//            {
//                if ([shadowView isKindOfClass:[UIImageView class]]) {
//                    [shadowView setHidden:YES];
//                }
//            }
//        }
//    }
	
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


- (void)dealloc {
    [super dealloc];
}

-(NSString*) getSelection
{
	return [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
}

@synthesize webView;
@synthesize delegate;
@end
