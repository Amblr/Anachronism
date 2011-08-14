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
#import "MainViewController.h"
#import "L1User.h"

//@class locations1ViewController;

@interface locations1AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
//    L1MapViewController *viewController;
    IBOutlet MainViewController * mainViewController;
    IBOutlet L1MapViewController * mapViewController;
	L1Scenario * scenario;
	L1User * user;
}


//-(void) selectScenarioURL:(NSString*) url;


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end

