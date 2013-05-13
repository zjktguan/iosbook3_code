//
//  ViewController.h
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

#import <UIKit/UIKit.h>
#import <NewsstandKit/NewsstandKit.h>
#import <QuickLook/QuickLook.h>
#import "IssueService.h"

@interface ViewController : UIViewController <QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IssueService *issueService;

- (IBAction)onclick:(id)sender;

@end
