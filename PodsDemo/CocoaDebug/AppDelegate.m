//
//  AppDelegate.m
//  CocoaDebug
//
//  Created by Jobs on 2019/12/4.
//  Copyright © 2019 Jobs. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#if DEBUG
@import CocoaDebug;
#endif

@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nvc;
    [self.window makeKeyAndVisible];
    
    NSLog(@"===%@", @"jdskfdjs");
    NSLog(@"===%@", @"jdskfdjs");
    NSLog(@"===%@", @"jdskfdjs");
    NSLog(@"===%@", @"jdskfdjs");
    // Override point for customization after application launch.
    
#if DEBUG
    CocoaDebug.serverURL = @"http://www.baidu.com";
    CocoaDebug.ignoredURLs = @[@"mob.com"];
    [CocoaDebug enable];
#endif
    
    return YES;
}

@end
