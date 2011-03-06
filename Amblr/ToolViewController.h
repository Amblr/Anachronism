//
//  ToolViewController.h
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ToolViewController : UIViewController<UITextViewDelegate> {
	id delegate;
}
@property (retain) id delegate;

@end
