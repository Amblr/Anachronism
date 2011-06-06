//
//  OspreyAppDelegate.h
//  Osprey
//
//  Created by Joe Zuntz on 06/06/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OspreyViewController;

@interface OspreyAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet OspreyViewController *viewController;

@end
