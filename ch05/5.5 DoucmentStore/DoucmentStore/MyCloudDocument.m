//
//  MyCloudDocument.m
//  DocumentStore
//
//  Created by 关东升 on 6/10/11.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "MyCloudDocument.h"

@implementation MyCloudDocument

//加载数据
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    if ([contents length] > 0) 
    {
        self.contents = [[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];        
    }
    return YES;
}

//保存数据
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    return [self.contents dataUsingEncoding:NSUTF8StringEncoding];
}


@end
