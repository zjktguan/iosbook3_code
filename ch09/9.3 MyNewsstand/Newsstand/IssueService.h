//
//  Client.h
//  Newsstand
//
//  Created by 关东升 on 13-1-13.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import <Foundation/Foundation.h>
#import <NewsstandKit/NewsstandKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface IssueService : NSObject <NSURLConnectionDownloadDelegate>

//下载进度
@property (nonatomic,assign) float downloadProgress;

//从服务器取得的最新杂志列表
@property (strong, nonatomic) NSArray *issues;

//请求队列
@property (strong) ASINetworkQueue  *networkQueue;

//开始处理方法
-(void)start ;
//处理下载通知
-(void)download:(NSNotification *)not;
//处理未下载完成的通知
-(void)resumeDownload:(NSNotification *)not;
//通过索引获得杂志内容目录
-(NSString*) getIssueContentPathAtIndex:(int) index;

@end
