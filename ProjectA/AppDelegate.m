//
//  AppDelegate.m
//  ProjectA
//
//  Created by laouhn on 16/4/5.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "AppDelegate.h"
#import "DDMenuController.h"
#import "ReadViewController.h"
#import "MenuViewController.h"
#import "WelcomeViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "PlayManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //友盟分享
    [self youmengShare];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    [NSThread sleepForTimeInterval:0.1];
    //判断是否第一次启动
    BOOL isFirstLunch = [[NSUserDefaults standardUserDefaults] boolForKey:THEFIRSTLUNCH];
    //是第一次启动
    if (!isFirstLunch) {
        self.window.rootViewController = [[WelcomeViewController alloc]init];
    }else {
    
    ReadViewController *readVC = [[ReadViewController alloc]init];
    readVC.title = @"阅读";
    UINavigationController *readNVC = [[UINavigationController alloc]initWithRootViewController:readVC];
    self.ddm = [[DDMenuController alloc]initWithRootViewController:readNVC];
    MenuViewController *menuVC= [[MenuViewController alloc]init];
    self.ddm.leftViewController = menuVC;
    self.window.rootViewController =self.ddm;
    
   
    }
    //设置后台播放
    //需要在appDelegate以及plist配置环境才能运行
    //创建音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //设置支持后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //设置默认会话
    [session setActive:YES error:nil];
    
    //设置远程控制
    //注意：远程控制的页面（播放页面）需要成为第一响应者
    [application beginReceivingRemoteControlEvents];
    
    return YES;
}
//友盟分享
- (void)youmengShare {
    [UMSocialData setAppKey:U_MengShareAPPKEY];
    [UMSocialWechatHandler setWXAppId:@"wx02e8acd8a22d3a4b" appSecret:@"31c801658f788f52ed203edc61850cdb" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
                                              secret:@"04b48b094faeb16683c32669824ebdad"
        RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

#pragma  mark --远程控制调用的方法
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //接收远程控制的响应
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay :
            [[PlayManager shareManager] play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [[PlayManager shareManager] pause];
            break;
        case UIEventSubtypeRemoteControlNextTrack :
            [[PlayManager shareManager] stop];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
           [[PlayManager shareManager] nextMusic];
            break;
        default:
            break;
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
