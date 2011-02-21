//
//  locations1AppDelegate.h
//  locations1
//
//  Created by Joe Zuntz on 15/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L1MapViewController.h"

@class locations1ViewController;

@interface locations1AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    locations1ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet locations1ViewController *viewController;

@end

