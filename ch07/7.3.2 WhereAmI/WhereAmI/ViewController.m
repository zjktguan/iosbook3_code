//
//  ViewController.m
//  WhereAmI
//
//  Created by 关东升 on 13-1-6.
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)geocodeQuery:(id)sender {
    
    if (_txtQueryKey.text == nil || [_txtQueryKey.text length] == 0) {
        return;
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_txtQueryKey.text completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"查询记录数：%i",[placemarks count]);
        if ([placemarks count] > 0) {
            CLPlacemark* placemark = placemarks[0];

            CLLocationCoordinate2D coordinate = placemark.location.coordinate;
            
            
            NSString *urlString = [NSString stringWithFormat:
                                   @"http://maps.google.com/maps?q=%f,%f",
                                   coordinate.latitude,
                                   coordinate.longitude];
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            [[UIApplication sharedApplication] openURL:url];
      
            //关闭键盘
            [_txtQueryKey resignFirstResponder];
        }
    }];

}


@end
