//
//  HotelListViewController.h
//  JiaGeXian4iPhone
//
//  Created by 关东升 on 13-1-26.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import <UIKit/UIKit.h>
#import "HotelBL.h"
#import "HotelTableViewCell.h"
#import "RoomListViewController.h"
#import "MBProgressHUD.h"

@interface HotelListViewController : UITableViewController
{
    int currentPage; //当前页数
}

//查询条件
@property(nonatomic,strong) NSMutableDictionary* queryKey;
//查询结果
@property(nonatomic,strong) NSMutableArray *list;
//加载视图单元格
@property (weak, nonatomic) IBOutlet UIView *loadViewCell;

//查询房间条件
@property(nonatomic,strong) NSMutableDictionary* queryRoomKey;

//查询房间结果
@property(nonatomic,strong) NSMutableArray *roomList;

@end
