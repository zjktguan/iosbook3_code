//
//  Client.h
//  BonjourClient
//
//  Created by 关东升 on 12-12-16.
//  Copyright (c) 2012年 516inc. All rights reserved.
//

#import <netinet/in.h>
#import <sys/socket.h>

@interface Client : NSObject <NSNetServiceDelegate> {
    int port;
}

@property(nonatomic,strong) NSMutableArray *services;
@property(nonatomic,strong) NSNetService *service;

@end
