//
//  Server.h
//  BonjourServer
//
//  Created by 关东升 on 12-12-16.
//  Copyright (c) 2012年 516inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <netinet/in.h>
#import <sys/socket.h>

@interface Server :  NSObject <NSNetServiceDelegate,NSStreamDelegate>

@property(nonatomic,strong) NSNetService *service;
@property(nonatomic,strong) NSSocketPort *socket;

@property(nonatomic,strong) NSInputStream *inputStream;
@property(nonatomic,strong) NSOutputStream	*outputStream;

@property(nonatomic,assign) int port;


@end
