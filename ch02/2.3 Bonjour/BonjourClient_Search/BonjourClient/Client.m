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
    _services = [[NSMutableArray alloc] init];
    _serviceBrowser = [[NSNetServiceBrowser alloc] init];
	_serviceBrowser.delegate = self;
	[_serviceBrowser searchForServicesOfType:@"_tonyipp._tcp." inDomain:@"local."];
    return self;
}

#pragma mark - NSNetServiceBrowserDelegate Methods

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
    NSLog(@"didFindService: %@  lenght:%d",netService.name,[netService.name length]);
    [_services addObject:netService];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
    NSLog(@"didRemoveService");
    [_services removeObject:netService];
}


@end
