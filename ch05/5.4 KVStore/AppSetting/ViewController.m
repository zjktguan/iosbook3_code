//
//  ViewController.m
//  AppSetting
//
//  Created by 关东升 on 12-9-28.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:
     NSUbiquitousKeyValueStoreDidChangeExternallyNotification
     object:store
     queue:nil
     usingBlock:^(NSNotification *note) {
         
          //更新控件状态
         [_switchSound setOn:[store boolForKey:UbiquitousSoundKey]];
         [_switchMusic setOn:[store boolForKey:UbiquitousMusicKey]];
         
         
         UIAlertView *alert = [[UIAlertView alloc]
                               initWithTitle:@"iCloud变更通知"
                               message:@"你的iCloud存储数据已经变更"
                               delegate:nil
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil, nil];
         [alert show];
         
     }];
    
    [store synchronize];
    
    //初始化控件状态
    [_switchSound setOn:[store boolForKey:UbiquitousSoundKey]];
    [_switchMusic setOn:[store boolForKey:UbiquitousMusicKey]];
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)setData:(id)sender {
    
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
    //存储到iCloud
    [store setBool:_switchSound.isOn forKey:UbiquitousSoundKey];
    [store setBool:_switchMusic.isOn forKey:UbiquitousMusicKey];
    [store synchronize];
}


@end
