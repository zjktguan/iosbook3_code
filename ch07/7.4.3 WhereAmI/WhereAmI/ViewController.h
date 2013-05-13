//
//  ViewController.h
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

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "BMapKit.h"

@interface ViewController : UIViewController <BMKSearchDelegate,CLLocationManagerDelegate>

//查询关键字文本框
@property (weak, nonatomic) IBOutlet UITextField *txtQueryKey;

//经度
@property (weak, nonatomic) IBOutlet UITextField *txtLng;
//纬度
@property (weak, nonatomic) IBOutlet UITextField *txtLat;
//高度
@property (weak, nonatomic) IBOutlet UITextField *txtAlt;
//显示结果的文本框
@property (weak, nonatomic) IBOutlet UITextView *txtView;

@property(nonatomic, strong) CLLocationManager *locationManager;

//存储定位结果
@property(nonatomic, strong)  CLLocation *currLocation;

@property (strong, nonatomic)  BMKSearch *search;

//地理信息编码查询
- (IBAction)geocodeQuery:(id)sender;
//地理信息反编码查询
- (IBAction)reverseGeocode:(id)sender;

@end
