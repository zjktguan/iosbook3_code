//
//  Server.m
//  BonjourServer
//
//  Created by 关东升 on 12-12-16.
//  Copyright (c) 2012年 516inc. All rights reserved.
//

#import "Server.h"

void AcceptCallBack(CFSocketRef, CFSocketCallBackType, CFDataRef, const void *, void *);

void WriteStreamClientCallBack(CFWriteStreamRef stream, CFStreamEventType eventType, void *);

void ReadStreamClientCallBack (CFReadStreamRef stream, CFStreamEventType eventType,void *);

@implementation Server

-(id)init {
    
    BOOL succeed = [self startServer];
    
    if (succeed) {
        // 通过Bonjour 发布服务
        succeed = [self publishService];
    } else {
        NSLog(@"服务器启动失败.");
    }
    
    return self;
}

/* 启动服务器 */
- (BOOL) startServer
{
    
    /* 定义一个Server Socket引用 */
    CFSocketRef sserver;
    
    /* 创建socket context */
    CFSocketContext CTX = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    /* 创建server socket  TCP IPv4 设置回调函数 */
    sserver = CFSocketCreate(NULL, PF_INET, SOCK_STREAM, IPPROTO_TCP,
                             kCFSocketAcceptCallBack, (CFSocketCallBack)AcceptCallBack, &CTX);
    
    if ( sserver == NULL ) {
        return NO;
    }
    
    /* 设置是否重新绑定标志 */
    int yes = 1;
    /* 设置socket属性 SOL_SOCKET是设置tcp SO_REUSEADDR是重新绑定，yes 是否重新绑定*/
    setsockopt(CFSocketGetNative(sserver), SOL_SOCKET, SO_REUSEADDR,
               (void *)&yes, sizeof(yes));
    
    
    /* 设置端口和地址 */
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));             //memset函数对指定的地址进行内存拷贝
    addr.sin_len = sizeof(addr);
    addr.sin_family = AF_INET;                  //AF_INET是设置 IPv4
    addr.sin_port = 0;//htons(PORT);                //htons函数 无符号短整型数转换成“网络字节序”
    addr.sin_addr.s_addr = htonl(INADDR_ANY);   //INADDR_ANY有内核分配，htonl函数 无符号长整型数转换成“网络字节序”
    
    
    /* 从指定字节缓冲区复制，一个不可变的CFData对象*/
    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8*)&addr, sizeof(addr));
    
    /* 设置Socket*/
    if (CFSocketSetAddress(sserver, (CFDataRef)address) != kCFSocketSuccess) {
        fprintf(stderr, "Socket绑定失败\n");
        CFRelease(sserver);
        return NO;
    }
    
    // 通过Bonjour广播服务器时候使用
    NSData *socketAddressActualData = (__bridge NSData *)CFSocketCopyAddress(sserver) ;
    
    // 转换sockaddr_in->socketAddressActual
    struct sockaddr_in socketAddressActual;
    memcpy(&socketAddressActual, [socketAddressActualData bytes], [socketAddressActualData length]);
    
    self.port = ntohs(socketAddressActual.sin_port);
    
    printf("Socket listening on port %d\n", self.port);
    
    /* 创建一个Run Loop Socket源 */
    CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, sserver, 0);
    /* Socket源添加到Run Loop中 */
    CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopCommonModes);
    CFRelease(sourceRef);
    
    return YES;
}

- (BOOL) publishService
{
    
    // 创建服务器实例
 	_service = [[NSNetService alloc] initWithDomain:@"local." type:@"_tonyipp._tcp." name:@"tony" port:self.port];
    
    //添加服务到当前的Run Loop
	[_service scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_service setDelegate:self];
    
    // 发布服务
	[_service publish];
    
    return YES;
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceWillResolve:(NSNetService *)netService {
    NSLog(@"netServiceWillResolve");
}

- (void)netServiceWillPublish:(NSNetService *)netService
{
    NSLog(@"netServiceWillPublish");
}

- (void)netServiceDidPublish:(NSNetService *)netService {
    NSLog(@"netServiceDidPublish");
    if ([@"tony" isEqualToString:netService.name]) {
        if (![netService getInputStream:&_inputStream outputStream:&_outputStream]) {
            NSLog(@"连接到服务器失败.");
            return;
        }
    }
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
    NSLog(@"didNotPublish");
}

- (void)netServiceDidResolveAddress:(NSNetService *)netService {
    NSLog(@"netServiceDidResolveAddress");
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"didNotResolve");
}

- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data {
    NSLog(@"didUpdateTXTRecordData");
}

- (void)netServiceDidStop:(NSNetService *)netService {
    NSLog(@"netServiceDidStop");
}


@end


/* 接收客户端请求后，回调函数  */
void AcceptCallBack(
                    CFSocketRef socket,
                    CFSocketCallBackType type,
                    CFDataRef address,
                    const void *data,
                    void *info)
{
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    /* data 参数涵义是，如果是kCFSocketAcceptCallBack类型，data是CFSocketNativeHandle类型的指针 */
    CFSocketNativeHandle sock = *(CFSocketNativeHandle *) data;
    
    /* 创建读写Socket流 */
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, sock,
                                 &readStream, &writeStream);
    
    if (!readStream || !writeStream) {
        close(sock);
        fprintf(stderr, "CFStreamCreatePairWithSocket() 失败\n");
        return;
    }
    
    CFStreamClientContext streamCtxt = {0, NULL, NULL, NULL, NULL};
    // 注册两种回调函数
    CFReadStreamSetClient(readStream, kCFStreamEventHasBytesAvailable, ReadStreamClientCallBack, &streamCtxt);
    CFWriteStreamSetClient(writeStream, kCFStreamEventCanAcceptBytes, WriteStreamClientCallBack, &streamCtxt);
    
    //加入到循环当中
    CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
    CFWriteStreamScheduleWithRunLoop(writeStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
    
    CFReadStreamOpen(readStream);
    CFWriteStreamOpen(writeStream);
    
}

/* 读取流操作 客户端有数据过来时候调用 */
void ReadStreamClientCallBack(CFReadStreamRef stream, CFStreamEventType eventType, void* clientCallBackInfo){
    
    UInt8 buff[255];
    CFReadStreamRef inputStream = stream;
    
    if(NULL != inputStream)
    {
        CFReadStreamRead(stream, buff, 255);
        printf("接受到数据：%s\n",buff);
        CFReadStreamClose(inputStream);
        CFReadStreamUnscheduleFromRunLoop(inputStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
        inputStream = NULL;
    }
}

/* 写入流操作 客户端在读取数据时候调用 */
void WriteStreamClientCallBack(CFWriteStreamRef stream, CFStreamEventType eventType, void* clientCallBackInfo)
{
    CFWriteStreamRef    outputStream = stream;
    //输出
    UInt8 buff[] = "Hello Client!";
    if(NULL != outputStream)
    {
        CFWriteStreamWrite(outputStream, buff, strlen((const char*)buff)+1);
        //关闭输出流
        CFWriteStreamClose(outputStream);
        CFWriteStreamUnscheduleFromRunLoop(outputStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
        outputStream = NULL;
    }
}
