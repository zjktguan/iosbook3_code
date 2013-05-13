//
//  ViewController.m
//  LocalNotificationDemo
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

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scheduleStart:(id)sender {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    //设置通知10秒后触发
    localNotification.fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:10];
    
    //设置通知消息
    localNotification.alertBody = @"计划通知，新年好!";
    //设置通知标记数
    localNotification.applicationIconBadgeNumber = 1;
    
    //设置通知出现时候声音
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //设置动作按钮的标题
    localNotification.alertAction = @"View Details";
    
    //计划通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}

- (IBAction)scheduleEnd:(id)sender {
    
    //结束计划通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}

- (IBAction)nowStart:(id)sender {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    //设置通知消息
    localNotification.alertBody = @"立刻通知，新年好!";
    //设置通知徽章数
    localNotification.applicationIconBadgeNumber = 1;
    
    //设置通知出现时候声音
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //设置动作按钮的标题
    localNotification.alertAction = @"View Details";
    
    //立刻发通知
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
}

@end
