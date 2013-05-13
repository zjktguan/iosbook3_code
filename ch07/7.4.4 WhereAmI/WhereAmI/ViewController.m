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
    
    _mapView.mapType = BMKMapTypeStandard ;
    _mapView.delegate = self;
    
    _search = [[BMKSearch alloc]init];
	_search.delegate = self;
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

#pragma mark -
#pragma mark BMKSearchDelegate委托方法
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
    //关闭键盘
    [_txtQueryKey resignFirstResponder];
    if (error == 0) {
        [_mapView removeAnnotations:_mapView.annotations];
        
        //调整地图位置和缩放比例
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMakeWithDistance(result.geoPt, 1000, 1000);
        [_mapView setRegion:viewRegion animated:YES];
        
        // 添加一个PointAnnotation
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = result.geoPt;
        annotation.title = result.strAddr;
        [_mapView addAnnotation:annotation];        
	}
    
}

#pragma mark -
#pragma mark BMKMapViewDelegate委托方法
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKPinAnnotationView *annotationView
            = (BMKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
        
        if(annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:@"PIN_ANNOTATION"];
        }
        
		annotationView.pinColor = BMKPinAnnotationColorPurple;
		annotationView.animatesDrop = YES;// 设置该标注点动画显示
		return annotationView;
	}
	return nil;
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
