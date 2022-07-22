//
//  AppDelegate.m
//  ZIMKitDemo
//
//  Created by zego on 2022/5/16.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <Bugly/Bugly.h>
#import "ZegoTabBarController.h"
#import "KeyCenter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[ZIMKitManager shared] createZIM:KeyCenter.appID];
    
    LoginViewController *loginVc =  [[LoginViewController alloc] init] ;
    self.window.rootViewController = [[ZIMKitNavigationController alloc] initWithRootViewController:loginVc];
    [self configBugly];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    return YES;
}

- (void)configBugly {
//#ifndef DEBUG
    BuglyConfig *config = [BuglyConfig new];
    config.blockMonitorEnable = YES;
    [Bugly startWithAppId:@"43348be7c8" config:config];
//#endif
}

- (void)loginSuccess {
    self.window.rootViewController = [[ZegoTabBarController alloc] init];
}

- (void)logout {
    LoginViewController *loginVc =  [[LoginViewController alloc] init] ;
    self.window.rootViewController = [[ZIMKitNavigationController alloc] initWithRootViewController:loginVc];
}

@end
