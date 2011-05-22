//
//  locations1AppDelegate.m
//  locations1
//
//  Created by Joe Zuntz on 15/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "locations1AppDelegate.h"
//#import "locations1ViewController.h"
#import "L1LoginViewController.h"
#import "L1ChooserViewController.h"

@implementation locations1AppDelegate

@synthesize window;
@synthesize mainViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

//	scenario = [[L1Scenario alloc] init];
//	user = [[L1User alloc] init];
	
    NSLog(@"I have finished launched");
    // Add the view controller's view to the window and display.
    [window addSubview:mainViewController.view];
    [window makeKeyAndVisible];

	user = [[L1User alloc] init];
//	L1LoginViewController * loginViewController = [[L1LoginViewController alloc] initWithNibName:@"L1LoginViewController" bundle:[NSBundle mainBundle]];
	
//	NSLog(@"Should now present login view: %@",loginViewController);

//    L1ChooserViewController * chooserViewController = [[L1ChooserViewController alloc] initWithNibName:@"L1ChooserViewController" bundle:[NSBundle mainBundle]];
    
//    [viewController presentModalViewController:chooserViewController animated:YES];
    NSLog(@"About to present chooser.");
    [mainViewController presentChooserView];
    
//	[viewController presentModalViewController:loginViewController animated:YES];
//	[user loginWithWebView:loginViewController.webView];
	
	
    return YES;
}


-(void) selectScenarioURL:(NSString*) url
{
    NSLog(@"Currently ignoring main scenario URL; hard-coded path and node urls.");
    NSString * baseURL = @"http://warm-earth-179.heroku.com";
    NSString * nodesURL = [baseURL stringByAppendingString:@"/nodes.json"];
    NSString * pathsURL = [baseURL stringByAppendingString:@"/paths.json"];
    scenario = [L1Scenario scenarioFromNodesURL:nodesURL pathsURL:pathsURL];
//    self.mainViewController.scenario = scenario;
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}


@end
