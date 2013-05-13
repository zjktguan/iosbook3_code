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
#import "BMapKit.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <BMKMapViewDelegate,BMKSearchDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtQueryKey;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic)  BMKSearch *search;

- (IBAction)geocodeQuery:(id)sender;

@end
