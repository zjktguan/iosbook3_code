//
//  BLHelp.h
//  BusinessLogicLayer
//
//  Created by 关东升 on 13-1-25.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import <Foundation/Foundation.h>

@interface BLHelp : NSObject

+(NSString *)URLEncodedString:(NSString *)str;
+(NSString *)URLDecodedString:(NSString *)str;
//预处理价格
+(NSString *)prePrice:(NSString *)price;
//预处理级别
+(NSString *)preGrade:(NSString *)grade;
//预处理早餐
+(NSString *)preBreakfast:(NSString *)breakfast;
//预处理床型
+(NSString *)preBed:(NSString *)bed;
//预处理支付类型
+(NSString *)prePaymode:(NSString *)prepay;
//预处理床型
+(NSString *)preBroadband:(NSString *)broadband;

@end
