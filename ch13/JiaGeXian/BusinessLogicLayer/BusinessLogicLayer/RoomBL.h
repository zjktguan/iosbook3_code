//
//  RoomBL.h
//  BusinessLogicLayer
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

#import "ASIFormDataRequest.h"
#import "TBXML.h"
#import "BLHelp.h"

//#define ROOM_QUERY_URL @"http://www.jiagexian.com/priceline/hotelroom/hotelroomqunar.mobile"
#define ROOM_QUERY_URL @"http://www.jiagexian.com/priceline/hotelroom/hotelroomcache.mobile"

@interface RoomBL : NSObject 

+ (RoomBL*)sharedManager;

//查询酒店房间
-(void)queryRoom:(NSDictionary*)keyInfo;

@end
