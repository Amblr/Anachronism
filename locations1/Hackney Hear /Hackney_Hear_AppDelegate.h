//
//  Hackney_Hear_AppDelegate.h
//  Hackney Hear 
//
//  Created by Joe Zuntz on 05/07/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hackney_Hear_ViewController;

@interface Hackney_Hear_AppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Hackney_Hear_ViewController *viewController;
-(void) setupScenario;


@end