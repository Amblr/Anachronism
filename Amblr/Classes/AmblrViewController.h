//
//  AmblrViewController.h
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "ToolViewController.h"
#import "TextViewController.h"
#import "WebViewController.h"
#import "PurchaseViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "DistanceViewController.h"
#define NUMBER_OF_NODES 20

@interface AmblrViewController : UIViewController {
//	IBOutlet UIView * topLeftView;
//	IBOutlet UIView * bottomLeftView;
//	IBOutlet UIView * bigView;
//	IBOutlet UIView * barView;
	
	CGRect topLeftRect;
	CGRect bottomLeftRect;
	CGRect bigRect;
	
	float date;
	
	
	// Sub views and controllers
	ToolViewController * toolViewController;
	MapViewController * mapViewController;
	TextViewController * textViewController;
	WebViewController * webViewController;
	PurchaseViewController * purchaseViewController;
	DistanceViewController * distanceViewController;
	BOOL inAnnotationMode;
	
}

//@property (readonly) UIView * topLeftView;
//@property (readonly) UIView * bottomLeftView;
//@property (readonly) UIView * bigView;
//@property (readonly) UIView * barView;
@property (retain) ToolViewController * toolViewController;


@property (retain) MapViewController * mapViewController;
@property (retain) TextViewController * textViewController;
@property (retain) WebViewController * webViewController;
@property (retain) PurchaseViewController * purchaseViewController;
@property (retain) DistanceViewController * distanceViewController;

@property (readonly) NSString * currentTextSelection;
@property (assign) float date;
//-(void) textWasAssigned;

//-(void) removeAllViews;
-(void) putInBigView:(UIView*) subView;
-(void) putInTopView:(UIView*) subView;
-(void) putInBottomView:(UIView*) subView;


//-(IBAction) logMap:(id)sender;
-(IBAction) addNodes:(id)sender;

-(IBAction) chooseMockup:(id) sender;
-(void) chooseMockup0;
-(void) chooseMockup1;
-(void) chooseMockup2;
-(void) chooseMockup3;
-(void) chooseMockup4;

@property BOOL inAnnotationMode;

//-(void) stringSelected:(NSString*) string;

@end
