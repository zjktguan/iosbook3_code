//
//  SendViewController.m
//  WeiBo
//
//  Created by 关东升 on 13-1-4.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "SendViewController.h"

@interface SendViewController ()

@end

@implementation SendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)save:(id)sender {
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType options:nil
                                  completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 
                 NSDictionary *parameters = [NSDictionary dictionaryWithObject:_textView.text forKey:@"status"];
                 
                 NSURL *requestURL = [NSURL
                                      URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
                 
                 SLRequest *request = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodPOST
                                           URL:requestURL parameters:parameters];
                 
                 
                 request.account = twitterAccount;
                 
                 [request performRequestWithHandler:^(NSData *responseData,
                                                          NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      NSLog(@" HTTP response: %i", [urlResponse statusCode]);
                  }];
             }
         };
     }];
    
    //放弃第一响应者
    [_textView resignFirstResponder];
    //关闭模态视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    
    //放弃第一响应者
    [_textView resignFirstResponder];
    //关闭模态视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


//TextView 委托方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{    
    NSString *content = _textView.text;
    NSInteger counter = 140 - [content length];
    
    if (counter <=0) {
        _lblCharCounter.text = @"0";
        return NO;
    }
    _lblCharCounter.text = [NSString stringWithFormat:@"%i", counter];
    return YES;
}

@end
