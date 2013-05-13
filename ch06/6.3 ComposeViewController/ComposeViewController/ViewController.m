//
//  ViewController.m
//  ComposeViewController
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
    
    SLComposeViewController *composeViewController=[SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        
        SLComposeViewControllerCompletionHandler __block completionHandler = ^(SLComposeViewControllerResult result) {
            
            [composeViewController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                    NSLog(@"Cancelled.....");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Posted....");
                    break;
            }
        };
        
        [composeViewController addImage:[UIImage imageNamed:@"icon@2x.png"]];
        [composeViewController setInitialText:@"请大家登录《iOS云端与网络通讯》服务网站。"];
        [composeViewController addURL:[NSURL URLWithString:@"http://www.iosbook3.com"]];
        [composeViewController setCompletionHandler:completionHandler];
        //模态视图呈现，如果是iPad则要Popover视图呈现
        [self presentViewController:composeViewController animated:YES completion:nil];
        
    }
}

@end
