//
//  AppDelegate.m
//  PushChat
//
//  Created by 关东升 on 13-1-1.
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
    //注册接收通知类型
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes: 
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //设置图标标记
    application.applicationIconBadgeNumber = 1;
    
    return YES;
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

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"设备令牌: %@", deviceToken);
    
    NSString *tokeStr = [NSString stringWithFormat:@"%@",deviceToken];
    
    if ([tokeStr length] == 0) {
        return;
    }
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\<\>"];
    tokeStr = [tokeStr stringByTrimmingCharactersInSet:set];
    tokeStr = [tokeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *strURL = @"http://192.168.1.103/mynotes/push_chat_service.php";
    
	NSURL *url = [NSURL URLWithString:strURL];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:tokeStr forKey:@"token"];
    [request setPostValue:@"98Z3R5XU29.com.51work6.PushChat" forKey:@"appid" ];
    
    [request setDelegate:self];
    NSLog(@"发送给服务器");
    [request startAsynchronous];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"获得令牌失败: %@", error);
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"成功");
    NSString *str = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] ;
    NSLog(@"%@",str);
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", [error localizedDescription]);
}


@end
