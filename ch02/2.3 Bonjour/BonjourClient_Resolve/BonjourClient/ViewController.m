//
//  ViewController.m
//  BonjourClient
//
//  Created by 关东升 on 12-12-16.
//  Copyright (c) 2012年 516inc. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _client = [[Client alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}


- (IBAction)sendData:(id)sender
{
    flag = 0;
    [self openStreams];
}

- (IBAction)receiveData:(id)sender
{
    flag = 1;
    [self openStreams];    
}

-(void)closeStreams
{
    [_outputStream close];
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream setDelegate:nil];
    [_inputStream close];
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream setDelegate:nil];
}


-(void)openStreams {
    
    for (NSNetService *service in _client.services) {
        if ([@"tony" isEqualToString:service.name]) {
            if (![service getInputStream:&_inputStream outputStream:&_outputStream]) {
                NSLog(@"连接服务器失败.");
                return;
            }
            break;  
        }
    }
    
	_outputStream.delegate = self;
	[_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outputStream open];
	_inputStream.delegate = self;
	[_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_inputStream open];
}

-(void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    NSString *event;
    switch (streamEvent) {
        case NSStreamEventNone:
            event = @"NSStreamEventNone";
            break;
        case NSStreamEventOpenCompleted:
            event = @"NSStreamEventOpenCompleted";
            break;
        case NSStreamEventHasBytesAvailable:
            event = @"NSStreamEventHasBytesAvailable";
            if (flag == 1 && theStream == _inputStream) {
                NSMutableData *input = [[NSMutableData alloc] init];
                uint8_t buffer[1024];
                int len;
                while([_inputStream hasBytesAvailable])
                {
                    len = [_inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0)
                    {
                        [input appendBytes:buffer length:len];
                    }
                }
                NSString *resultstring = [[NSString alloc] initWithData:input encoding:NSUTF8StringEncoding];
                NSLog(@"接收:%@",resultstring);
                _message.text = resultstring;
            }
            break;
        case NSStreamEventHasSpaceAvailable:
            event = @"NSStreamEventHasSpaceAvailable";
            if (flag == 0 && theStream == _outputStream) {
                //输出
                UInt8 buff[] = "Hello Server!";
                [_outputStream write:buff maxLength: strlen((const char*)buff)+1];
                //关闭输出流
                [_outputStream close];
            }
            break;
        case NSStreamEventErrorOccurred:
            event = @"NSStreamEventErrorOccurred";
            [self closeStreams];
            break;
        case NSStreamEventEndEncountered:
            event = @"NSStreamEventEndEncountered";
            break;
        default:
            [self closeStreams];
            event = @"Unknown";
            break;
    }
    NSLog(@"event------%@",event);
}


@end
