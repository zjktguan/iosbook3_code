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
    
    _search = [[BMKSearch alloc]init];
	_search.delegate = self;
    
    //定位服务管理对象初始化
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 1000.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开始定位
    [_locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    //停止定位
    [_locationManager stopUpdatingLocation];
}

#pragma mark Core Location委托方法用于实现位置的更新
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currLocation = [locations lastObject];
	_txtLat.text = [NSString stringWithFormat:@"%3.5f",
                    _currLocation.coordinate.latitude];
	_txtLng.text = [NSString stringWithFormat:@"%3.5f",
                    _currLocation.coordinate.longitude];
    _txtAlt.text = [NSString stringWithFormat:@"%3.5f",
                    _currLocation.altitude];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)geocodeQuery:(id)sender {
    
    if (_txtQueryKey.text == nil || [_txtQueryKey.text length] == 0) {
        return;
    }
    //地理信息编码
    [_search geocode:_txtQueryKey.text withCity:@"北京"];
    
}

- (IBAction)reverseGeocode:(id)sender {
    
    //发起反地理编码
	CLLocationCoordinate2D pt = _currLocation.coordinate;
	[_search reverseGeocode:pt];
}

#pragma mark -
#pragma mark BMKSearchDelegate委托方法
//地理编码和反编码结果
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
    //关闭键盘
    [_txtQueryKey resignFirstResponder];
    if (error == 0) {
        _txtView.text = [NSString stringWithFormat:@"经度：%3.5f , 纬度：%3.5f \n地址： %@",
                         result.geoPt.longitude,result.geoPt.latitude, result.strAddr ];
	}
    
}

@end
