//
//  Hackney_Hear_AppDelegate.m
//  Hackney Hear 
//
//  Created by Joe Zuntz on 05/07/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "Hackney_Hear_AppDelegate.h"

#import "Hackney_Hear_ViewController.h"
#import "HTNotifier.h"

@implementation Hackney_Hear_AppDelegate
@synthesize  scenario;

@synthesize window=_window;

@synthesize mainTabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];

    self.window.rootViewController = self.mainTabBarController;
    NSLog(@"view controller = %@",self.mainTabBarController);
    [self.window makeKeyAndVisible];
    [self setupScenario];
    [HTNotifier startNotifierWithAPIKey:@"bf9845eaf284ec17a3652f0a82d70702" environmentName:HTNotifierDevelopmentEnvironment];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
//    [_viewController release];
    [super dealloc];
}


#pragma mark -
#pragma mark Story Elements

-(void) setupScenario {
    
    // Use Dickens
#ifdef ALEX_HEAR    
    NSString * storyURL = @"http://amblr.heroku.com/scenarios/4e249f58d7c4b60001000023/stories/4e249fe5d7c4b600010000c1.json";
    self.scenario = [L1Scenario scenarioFromStoryURL:storyURL withKey:@"4e249fe5d7c4b600010000c1"];
#else
    NSString * storyURL = @"http://amblr.heroku.com/scenarios/4e15c53add71aa000100025b/stories/4e15c6be7bd01600010000c0.json";
    self.scenario = [L1Scenario scenarioFromStoryURL:storyURL withKey:@"4e15c53add71aa000100025b"];
#endif        
    //    self.scenario = [L1Scenario scenarioFromNodesURL:nodesURL pathsURL:pathsURL];
    self.scenario.delegate = hhViewController;
    hhViewController.scenario = scenario;
    mediaStatusViewController.scenario = scenario;
}
-(void) nodeSource:(id) nodeManager didReceiveNodes:(NSDictionary*) nodes
{
    [hhViewController nodeSource:self didReceiveNodes:nodes];
    
}

-(void) nodeDownloadFailedForScenario:(L1Scenario*) scenario
{
    NSString * message = @"You don't seem to have an internet connection.  Or possibly your humble developers have screwed up.  Probably the former.";
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Network" message:message delegate:self cancelButtonTitle:@"*Sigh*" otherButtonTitles:nil];
    [alert show];
    
}



@end
