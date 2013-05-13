//
//  AddViewController.m
//  MyNotes
//
//  Created by 关东升 on 12-9-26.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "AddViewController.h"


@interface AddViewController () 


@end

@implementation AddViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onclickDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onclickSave:(id)sender {
    
    [self startRequest];
    
    [_txtView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}



/*
 * 开始请求Web Service
 */
-(void)startRequest
{
    
    NSString *strURL = [[NSString alloc] initWithFormat:@"http://iosbook3.com/service/mynotes/webservice.php?email=%@&type=%@",@"<你的iosbook3.com用户邮箱>",@"SOAP"];
    
	NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    //准备参数
    NSDate *date = [NSDate new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];   
    
    NSString *envelopeText = [SoapHelper getAddRequestStringWithDate:dateStr andContent:_txtView.text];    
    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:envelope];
    [request setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [envelope length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
    

    if (connection) {
        _datas = [NSMutableData new];
    }
}


#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_datas appendData:data];
}


-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    
    NSLog(@"%@",[error localizedDescription]);
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    
    NSLog(@"请求完成...");
    
    NSError *err;
    NSString *message;
    
    [SoapHelper parserAddResponseData:_datas error:&err];
    if (!err) {
        message = @"操作成功。";
    } else {
        message = [err localizedDescription];
    }
    
    if (message) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [alertView show];
    }
}




@end
