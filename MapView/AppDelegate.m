//
//  AppDelegate.m
//  MapView
//
//  Created by Stanislav Sumbera on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "WMSOverlay.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    MapViewController * mapViewController = [[MapViewController alloc] init];
    
    UINavigationController *mainNavCtrl = [[UINavigationController alloc]initWithRootViewController:mapViewController];

    self.window.rootViewController = mainNavCtrl;
    
    [self.window makeKeyAndVisible];
    
       
    WMSOverlay * wmsOverlay =[[WMSOverlay alloc] initWithName:@"Ozone" Url:@"http://wdc.dlr.de/ogc/produkt_t?LAYERS=GOME2_O3&TRANSPARENT=TRUE&FORMAT=image%2Fpng&STYLES=&SLD=http%3A%2F%2Fwdc.dlr.de%2Fsld%2FGOME2_O3_sld.xml&TIME=2012-02-12T00%3A00%3A00Z&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&SRS=EPSG%3A4326&WIDTH=256&HEIGHT=256" Opacity:0.5];

    [mapViewController  addWMSOverlays:[NSArray arrayWithObjects:wmsOverlay, nil]];
    
    
    
   // mapViewController
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

@end
