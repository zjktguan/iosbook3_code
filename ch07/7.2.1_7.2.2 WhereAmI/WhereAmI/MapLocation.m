//
//  MapLocation.m
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

#import "MapLocation.h"

@implementation MapLocation

- (NSString *)title {
    return @"您的位置!";
}
- (NSString *)subtitle {
    
    NSMutableString *ret = [NSMutableString new];
    if (_state)
        [ret appendString:_state];
    if (_city)
        [ret appendString:_city];
    if (_city && _state)
        [ret appendString:@", "];
    if (_streetAddress && (_city || _state || _zip))
        [ret appendString:@" • "];
    if (_streetAddress)
        [ret appendString:_streetAddress];
    if (_zip)
        [ret appendFormat:@", %@", _zip];
    
    return ret;
}


@end
