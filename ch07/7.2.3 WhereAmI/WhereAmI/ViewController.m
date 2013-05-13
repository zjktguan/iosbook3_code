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
    
    if ([CLLocationManager locationServicesEnabled])
    {
        _mapView.mapType = MKMapTypeStandard;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark -
#pragma mark Map View Delegate Methods
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{    
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)theMapView withError:(NSError *)error
{
    NSLog(@"error : %@",[error description]);
}

@end
