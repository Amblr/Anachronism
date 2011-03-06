//
//  AmblrAppDelegate.h
//  Amblr
//
//  Created by Joe Zuntz on 06/03/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AmblrViewController;

@interface AmblrAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AmblrViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AmblrViewController *viewController;



@end

