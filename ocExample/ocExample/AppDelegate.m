//
//  AppDelegate.m
//  ocExample
//
//  Created by yang chuang on 2021/5/2.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ViewController *index = [[ViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = index;
    [self.window makeKeyAndVisible];
    return YES;
}



@end
