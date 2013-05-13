//
//  Client.m
//  BonjourClient
//
//  Created by 关东升 on 12-12-16.
//  Copyright (c) 2012年 516inc. All rights reserved.
//

#import "Client.h"

@implementation Client

-(id)init {
    _service = [[NSNetService alloc] initWithDomain:@"local." type:@"_tonyipp._tcp." name:@"tony"];
    [_service setDelegate:self];
    //设置解析地址超时时
    [_service resolveWithTimeout:1.0];
    
    _services = [[NSMutableArray alloc] init];
    return self;
}

#pragma mark - NSNetServiceDelegate Methods

- (void)netServiceDidResolveAddress:(NSNetService *)netService {
    NSLog(@"netServiceDidResolveAddress");
    [_services addObject:netService];
}

- (void)netService:(NSNetService *)netService didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"didNotResolve: %@",errorDict);
}


@end
