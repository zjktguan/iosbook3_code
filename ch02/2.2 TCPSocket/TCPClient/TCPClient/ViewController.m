//
//  ViewController.m
//  TCPClient
//
//  Created by 关东升 on 12-12-15.
//  Copyright (c) 2012年 516inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initNetworkCommunication
{
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.1.103", PORT, &readStream, &writeStream);
    
    _inputStream = (__bridge_transfer NSInputStream *)readStream;
    _outputStream = (__bridge_transfer NSOutputStream
                     *)writeStream;
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                            forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                             forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
    
}

-(void)close
{
    [_outputStream close];
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream setDelegate:nil];
    [_inputStream close];
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream setDelegate:nil];
}

- (IBAction)sendData:(id)sender {
    flag = 0;
    [self initNetworkCommunication];
    
}

- (IBAction)receiveData:(id)sender {
    flag = 1;
    [self initNetworkCommunication];
    
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
            if (flag ==1 && theStream == _inputStream) {
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
            if (flag ==0 && theStream == _outputStream) {
                //输出
                UInt8 buff[] = "Hello Server!";
                [_outputStream write:buff maxLength: strlen((const char*)buff)+1];
                 //必须关闭输出流否则，服务器端一直读取不会停止，
                [_outputStream close];
            }
            break;
        case NSStreamEventErrorOccurred:
            event = @"NSStreamEventErrorOccurred";
            [self close];
            break;
        case NSStreamEventEndEncountered:
            event = @"NSStreamEventEndEncountered";
            NSLog(@"Error:%d:%@",[[theStream streamError] code], [[theStream streamError] localizedDescription]);
            break;
        default:
            [self close];
            event = @"Unknown";
            break;
    }
    NSLog(@"event------%@",event);
}

@end
