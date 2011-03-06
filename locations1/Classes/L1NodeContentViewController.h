//
//  L1NodeContentViewController.h
//  locations1
//
//  Created by Joe Zuntz on 19/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface L1NodeContentViewController : UIViewController {
	IBOutlet UILabel * nodeName;
	IBOutlet UILabel * nodeText;
	IBOutlet UIImageView * nodeImage;
}

-(void) setName:(NSString*)name;
-(void) setText:(NSString*)text;
-(void) setImage:(UIImage*)image;

-(IBAction) exitModal:(id) sender;
-(IBAction) rotate:(id) sender;

@end
