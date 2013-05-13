//
//  SoapHelper.h
//  MyNotes
//
//  Created by 关东升 on 12-12-20.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import <Foundation/Foundation.h>
#import "NSNumber+Message.h"
#import "TBXML.h"

@interface SoapHelper : NSObject

//处理查询请求字符串
+(NSString*) getQueryRequestString;

//处理查询应答数据解析到集合中
+(NSMutableArray*)parserQueryResponseData:(NSData*)data error:(NSError**) err;

//处理删除请求字符串
+(NSString*) getRemoveRequestString:(NSString*)_id;

//处理删除改应答数据解析
+(void)parserRemoveResponseData:(NSData*)data error:(NSError**) err;

//处理插入请求字符串
+(NSString*) getAddRequestStringWithDate:(NSString*)CDate andContent:(NSString*)Content;

//处理插入应答数据解析
+(void)parserAddResponseData:(NSData*)data error:(NSError**) err;

//处理修改请求字符串
+(NSString*) getModfidyRequestStringWithDate:(NSString*)CDate andContent:(NSString*)Content andID:(NSString*)_id;

//处理修改应答数据解析
+(void)parserModifyResponseData:(NSData*)data error:(NSError**) err;


@end
