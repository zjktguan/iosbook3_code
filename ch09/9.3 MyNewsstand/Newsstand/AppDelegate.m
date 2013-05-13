//
//  AppDelegate.m
//  Newsstand
//
//  Created by 关东升 on 13-1-13.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    _issueService = [[IssueService alloc] init];
    [_issueService start];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.viewController = [storyBoard instantiateInitialViewController];
    self.viewController.issueService = _issueService;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //Newsstand下载每天一次，为了在开发阶段测试需要设置这个参数
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NKDontThrottleNewsstandContentNotifications"];
    
    //注册接收通知类型
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeNewsstandContentAvailability)];
    //设置图标标记
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //处理应用程序终止时候为下载完成的处理。
    [[NSNotificationCenter defaultCenter] postNotificationName:ResumeDownloadNotification object:self];
    
    return YES;
    
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"设备令牌: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"获得令牌失败: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"application:didReceiveRemoteNotification: - %@", userInfo);
    
    NSDictionary *aps = [NSDictionary dictionaryWithDictionary:(NSDictionary *) [userInfo objectForKey:@"aps"]];
    
    // 检查是否有新的内容，如果应用与活动状态弹出对话框
    if([aps objectForKey:@"content-available"]) {
        if([[UIApplication sharedApplication] applicationState]==UIApplicationStateActive) {
            NSLog(@"应用状态：Active");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新的杂志"
                                                            message:@"有新的杂志已经发布"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            NSLog(@"应用状态：Background 或 inActive ");
            [[NSNotificationCenter defaultCenter] postNotificationName:DownloadNotification object:self];
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
