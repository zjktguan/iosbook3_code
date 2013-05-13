//
//  ViewController.h
//  BonjourClient
//
//  Created by 关东升 on 12-12-16.
//  Copyright (c) 2012年 516inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>

#import "Client.h"

@interface ViewController : UIViewController <NSStreamDelegate>
{
    int flag ; //操作标志 0为发送 1为接收
}

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic,strong) Client *client;

@property (weak, nonatomic) IBOutlet UILabel *message;

- (IBAction)sendData:(id)sender;
- (IBAction)receiveData:(id)sender;

@end
