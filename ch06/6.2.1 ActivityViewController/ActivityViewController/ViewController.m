//
//  ViewController.m
//  ActivityViewController
//
//  Created by 关东升 on 13-1-3.
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

- (IBAction)shareAction:(id)sender {
    
    NSString *textToShare = @"请大家登录《iOS云端与网络通讯》服务网站。";
    UIImage *imageToShare = [UIImage imageNamed:@"icon@2x.png"];
    NSURL *urlToShare = [NSURL URLWithString:@"http://www.iosbook3.com"];
    NSArray *activityItems = @[textToShare, urlToShare,imageToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:TRUE completion:nil];
    
}

@end
