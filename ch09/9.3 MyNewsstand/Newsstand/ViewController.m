//
//  ViewController.m
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

#import "ViewController.h"
#import "IssueService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI:)
                                                 name:UpdateUINotification
                                               object:nil];
    
    //不可见
    _progressView.alpha = 0.0f;
    _button.alpha = 0.0f;
    
    [_activityIndicator startAnimating];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)onclick:(id)sender
{
    if (_button.tag == 1) {//打开处理
        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        previewController.delegate=self;
        previewController.dataSource=self;
        [self presentViewController:previewController animated:YES completion:nil];
        
    } else if (_button.tag == 2) {//下载处理
        _progressView.alpha = 1.0f;
        _button.alpha = 0.0f;
        
        [_issueService addObserver:self forKeyPath:@"downloadProgress" options:NSKeyValueObservingOptionNew context:NULL];
        
        [_issueService download:nil];
    }
    
}

#pragma mark QuickLook
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    
    NSArray* issues =  [_issueService issues];
    //只取最新的杂志
    NSString *contentPath = [_issueService getIssueContentPathAtIndex:([issues count] -1)];
    return [NSURL fileURLWithPath:contentPath];
}


#pragma mark - 处理更新UI通知
-(void)updateUI:(NSNotification *)not {
    
    NSArray* issues =  [not object];
    NSString* issueName = [[issues lastObject] objectForKey:@"ID"];
    NKIssue* issue = [[NKLibrary sharedLibrary] issueWithName:issueName];
    //只取最新的杂志
    NSString *contentPath = [_issueService getIssueContentPathAtIndex:([issues count] -1)];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:contentPath] && issue.status == NKIssueContentStatusAvailable) {
        [_button setTitle:@"打开" forState:UIControlStateNormal];
        _button.tag = 1;
        
    } else {
        [_button setTitle:@"下载" forState:UIControlStateNormal];
        _button.tag = 2;
    }
    
    if (issue.status == NKIssueContentStatusDownloading) {
        _button.alpha = 0.0f;
        _progressView.alpha = 1.0f;
    } else {
        _button.alpha = 1.0f;
        _progressView.alpha = 0.0f;
    }
    
    NSString *coverFilePath = [CacheDirectory stringByAppendingPathComponent: [[NSString alloc] initWithFormat:@"issue%i.png",[issues count]]];
    
    UIImage *image = [UIImage imageWithContentsOfFile:coverFilePath];
    
    self.imageView.image = image;
    
    [_activityIndicator stopAnimating];
}

#pragma mark - 观察issueService中下载进度
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object
                        change:(NSDictionary*)change context:(void*)context
{
    float value = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    _progressView.progress=value;
}


@end
