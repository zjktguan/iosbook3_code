//
//  ViewController.h
//  JiaGeXian4iPhone
//
//  Created by 关东升 on 13-1-24.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import <UIKit/UIKit.h>
#import "CitiesViewController.h"
#import "KeyViewController.h"
#import "HotelBL.h"
#import "MyPickerViewController.h"
#import "MyDatePickerViewController.h"
#import "HotelListViewController.h"

@interface ViewController : UIViewController
    <CitiesViewControllerDelegate,KeyViewControllerDelegate,MyPickerViewControllerDelegate,MyDatePickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblKey;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckin;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckout;

@property(nonatomic,strong)MyPickerViewController* pickerViewController;

@property(nonatomic,strong)MyDatePickerViewController* checkinDatePickerViewController;

@property(nonatomic,strong)MyDatePickerViewController* checkoutDatePickerViewController;

@property(nonatomic,strong)NSDictionary* cityInfo;

//关键字查询结果
@property(nonatomic, strong) NSDictionary* keyDict;
//Hotel查询结果
@property(nonatomic,strong) NSMutableArray *hotelList;
//Hotel查询条件
@property(nonatomic,strong) NSMutableDictionary* hoteQueryKey;

- (IBAction)selectPrice:(id)sender;
- (IBAction)selectCheckinDate:(id)sender;
- (IBAction)selectCheckoutDate:(id)sender;

@end
