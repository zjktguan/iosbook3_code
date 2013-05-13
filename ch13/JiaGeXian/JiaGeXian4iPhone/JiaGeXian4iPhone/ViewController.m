//
//  ViewController.m
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

#import "ViewController.h"
#import "MBProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home-bg.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"selectKey"]
        && [_lblCity.text isEqualToString:@"选择城市"]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"请先选择城市"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles: nil];

        [alertView show];

        return NO;
    } else if  ([identifier isEqualToString:@"selectKey"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading";


        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryKeyFinished:)
                                                     name:BLQueryKeyFinishedNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryKeyFailed:)
                                                     name:BLQueryKeyFailedNotification object:nil];

        [[HotelBL sharedManager] selectKey:_lblCity.text];
        return NO;
    } else if  ([identifier isEqualToString:@"queryHotel"]) {
        
        NSString *errorMsg ;
        
        if ([_lblCity.text isEqualToString:@"选择城市"]) {
            errorMsg = @"请选择城市";
        } else if ([_lblKey.text isEqualToString:@"选择关键字"]) {
            errorMsg = @"请选择关键字";
        } else if ([_lblCheckin.text isEqualToString:@"选择日期"]) {
            errorMsg = @"请选择入住日期";
        } else if ([_lblCheckout.text isEqualToString:@"选择日期"]) {
            errorMsg = @"请选择退房日期";
        }
        
        if (errorMsg) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                message:errorMsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alertView show];
            return NO;
        }
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading";

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryHotelFinished:)
                                                     name:BLQueryHotelFinishedNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryHotelFailed:)
                                                     name:BLQueryHotelFailedNotification object:nil];

        _hoteQueryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         [_cityInfo objectForKey:@"Plcityid"], @"Plcityid",
                                         @"1",@"currentPage",
                                         _lblKey.text, @"key",
                                         _lblPrice.text, @"Price",
                                         _lblCheckin.text, @"Checkin",
                                         _lblCheckout.text, @"Checkout",
                                         nil];
        [[HotelBL sharedManager] queryHotel:_hoteQueryKey];
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"selectCity"]) {
        UINavigationController* nvgViewController = (UINavigationController*)[segue destinationViewController];
        CitiesViewController* citiesViewController = (CitiesViewController*)nvgViewController.topViewController ;
        citiesViewController.delegate = self;
        
    } else if ([[segue identifier] isEqualToString:@"selectKey"]) {
        UINavigationController* nvgViewController = (UINavigationController*)[segue destinationViewController];
        KeyViewController* keyViewController = (KeyViewController*)nvgViewController.topViewController ;
        keyViewController.delegate = self;
        keyViewController.keyDict = _keyDict;
        
    }  else if ([[segue identifier] isEqualToString:@"queryHotel"]) {
        HotelListViewController* hotelListViewController = (HotelListViewController*)[segue destinationViewController];
        hotelListViewController.queryKey = _hoteQueryKey;
        hotelListViewController.list = _hotelList;
        
    }
}

//关闭城市选择对话框委托方法
- (void)closeCitiesView:(NSDictionary*)info
{
    _cityInfo = info;
    [self dismissViewControllerAnimated:YES completion:nil];
    _lblCity.text = [info objectForKey:@"name"];
    //重新设置关键字
    _lblKey.text = @"选择关键字";
}

//关闭关键字选择对话框委托方法
- (void)closeKeysView:(NSString*)selectKey
{
    [self dismissViewControllerAnimated:YES completion:nil];
    _lblKey.text = selectKey;

}

//关闭价格拾取器委托方法
- (void)myPickViewClose:(NSString*)selected
{
    NSLog(@"selected %@",selected);
    _lblPrice.text = selected;
}

//关闭日期拾取器委托方法
- (void)myPickDateViewControllerDidFinish:(MyDatePickerViewController *)controller
    andSelectedDate:(NSDate*)selected
{
    // NSDateFormatter
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString * strDate = [dateFormat stringFromDate:selected];
    NSLog(@"strDate %@",strDate);
    if (_checkoutDatePickerViewController == controller) {
        _lblCheckout.text = strDate;
    } else {
        _lblCheckin.text = strDate;
    }
}

//接收BL查询关键字成功通知
- (void)queryKeyFinished:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryKeyFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryKeyFailedNotification object:nil];
    _keyDict = not.object;
    [self performSegueWithIdentifier:@"selectKey" sender:nil];

}

//接收BL查询关键字失败通知
- (void)queryKeyFailed:(NSNotification*)not{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryKeyFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryKeyFailedNotification object:nil];
}


//接收BL查询Hotel信息成功通知
- (void)queryHotelFinished:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _hotelList = not.object;
    [self performSegueWithIdentifier:@"queryHotel" sender:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryHotelFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryHotelFailedNotification object:nil];
}

//接收BL查询Hotel信息成功通知
- (void)queryHotelFailed:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryHotelFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryHotelFailedNotification object:nil];
}


- (IBAction)selectPrice:(id)sender {
    if (_pickerViewController == nil) {
        _pickerViewController = [[MyPickerViewController alloc] init];
    }
    [_pickerViewController showInView:self.view];
    _pickerViewController.delegate = self;
}

- (IBAction)selectCheckinDate:(id)sender {
    _checkinDatePickerViewController = [[MyDatePickerViewController alloc] init];
    [_checkinDatePickerViewController showInView:self.view];
    _checkinDatePickerViewController.delegate = self;
}

- (IBAction)selectCheckoutDate:(id)sender {
    _checkoutDatePickerViewController = [[MyDatePickerViewController alloc] init];
    [_checkoutDatePickerViewController showInView:self.view];
    _checkoutDatePickerViewController.delegate = self;
}
@end
