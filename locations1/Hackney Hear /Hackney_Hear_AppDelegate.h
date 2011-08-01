//
//  Hackney_Hear_AppDelegate.h
//  Hackney Hear 
//
//  Created by Joe Zuntz on 05/07/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L1Scenario.h"
#import "HHMediaStatusViewController.h"
#import "Hackney_Hear_ViewController.h"

@class Hackney_Hear_ViewController;
@class HackneyHearTabViewController;

@interface Hackney_Hear_AppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UITabBarController*  mainTabBarController;
    IBOutlet Hackney_Hear_ViewController * hhViewController;
    IBOutlet HHMediaStatusViewController * mediaStatusViewController;
    L1Scenario * scenario;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController*  mainTabBarController;


@property (retain) L1Scenario * scenario;
// Story contents
-(void) setupScenario;
-(void) pathSource:(id) pathManager didReceivePaths:(NSDictionary*) paths;
-(void) nodeSource:(id) nodeManager didReceiveNodes:(NSDictionary*) nodes;
-(void) nodeDownloadFailedForScenario:(L1Scenario*) scenario;


@end
