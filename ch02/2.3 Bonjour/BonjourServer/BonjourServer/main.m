//
//  main.m
//  BonjourServer
//
//  Created by 关东升 on 12-12-16.
//  Copyright (c) 2012年 516inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"

int main(int argc, const char * argv[])
{
    Server *server = [[Server alloc] init];
    CFRunLoopRun();
    return 0;
}

