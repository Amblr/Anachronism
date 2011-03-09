//
//  PurchaseViewController.h
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AmblrViewController;

@interface PurchaseViewController : UIViewController {
	AmblrViewController * delegate;
}
@property (retain) AmblrViewController * delegate;
-(IBAction) clickBuy:(id)sender;
@end
