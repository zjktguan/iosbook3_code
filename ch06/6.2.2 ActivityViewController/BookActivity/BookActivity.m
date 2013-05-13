//
//  BookActivity.m
//  ActivityViewController
//
//  Created by 关东升 on 13-1-4.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "BookActivity.h"

@implementation BookActivity


- (NSString *)activityType
{
	return NSStringFromClass([self class]);
}

- (NSString *)activityTitle
{
	return NSLocalizedStringFromTable(@"Open Book", @"BookActivity", nil);
}

- (UIImage *)activityImage
{
	return [UIImage imageNamed:@"Book"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]]) {
            if ([[UIApplication sharedApplication] canOpenURL:activityItem]) {
                return YES;
            }
		}
	}
	
	return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]]) {
			_url = activityItem;
		}
	}
}

- (void)performActivity
{
	BOOL completed = [[UIApplication sharedApplication] openURL:_url];
	
	[self activityDidFinish:completed];
}


@end
