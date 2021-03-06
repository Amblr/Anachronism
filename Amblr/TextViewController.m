    //
//  TextViewController.m
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "TextViewController.h"
#import "AmblrViewController.h"

@implementation TextViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


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

-(void) deselectText
{
//	self.textView.scrollEnabled=NO;
	NSRange range = self.textView.selectedRange;
	self.textView.selectedRange=range;
	self.textView.editable=NO;
//	self.textView.scrollEnabled=YES;
}

- (void)textViewDidChangeSelection:(UITextView *)theTextView
{
	SEL selectionSelector = @selector(stringSelected:);
	NSString * fullText = theTextView.text;
	NSRange range = theTextView.selectedRange;
	NSString * selection;
	if (range.location<0 || range.location+range.length>=[fullText length]){
		selection=nil;
	}
	else{
		selection = [fullText substringWithRange:range]; 
	}
	if ([self.delegate respondsToSelector:selectionSelector]) [self.delegate performSelector:selectionSelector withObject:selection];
	
}


@synthesize textView, delegate;
@end
