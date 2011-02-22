//
//  locations1AppDelegate.h
//  locations1
//
//  Created by Joe Zuntz on 15/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L1MapViewController.h"
#import "L1Scenario.h"
#import "L1User.h"

@class locations1ViewController;

@interface locations1AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    IBOutlet L1MapViewController *viewController;
	L1Scenario * scenario;
	IBOutlet UIWebView * loginView;
	L1User * user;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet L1MapViewController *viewController;

@end

