//
//  DetailViewController.m
//  MyPass
//
//  Created by 关东升 on 13-1-22.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    _lblOrganizationName.text = _pass.organizationName;
    _lblLocalizedDescription.text = _pass.localizedDescription;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
	if (_pass.relevantDate) {
            _lblRelevantDate.text = [dateFormat stringFromDate: _pass.relevantDate];
    }
    _lblSerialNumber.text = _pass.serialNumber;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)remove:(id)sender {
    
    NSLog(@"删除Pass");
    
    PKPassLibrary* passLib = [[PKPassLibrary alloc] init];

    [passLib removePass:_pass];
    //返回上一级视图
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
