//
//  main.m
//  TCPServer
//
//  Created by 关东升 on 12-12-14.
//  Copyright (c) 2012年 516inc. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 9000

void AcceptCallBack(CFSocketRef, CFSocketCallBackType, CFDataRef, const void *, void *);

void WriteStreamClientCallBack(CFWriteStreamRef stream, CFStreamEventType eventType, void *);

void ReadStreamClientCallBack (CFReadStreamRef stream, CFStreamEventType eventType,void *);

int main(int argc, const char * argv[])
{
    /* 定义一个Server Socket引用 */
    CFSocketRef sserver;

    /* 创建socket context */
    CFSocketContext CTX = { 0, NULL, NULL, NULL, NULL };
    
    /* 创建server socket  TCP IPv4 设置回调函数 */
    sserver = CFSocketCreate(NULL, PF_INET, SOCK_STREAM, IPPROTO_TCP,
                             kCFSocketAcceptCallBack, (CFSocketCallBack)AcceptCallBack, &CTX);
    if (sserver == NULL)
        return -1;
    
    
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
    addr.sin_port = htons(PORT);                //htons函数 无符号短整型数转换成“网络字节序”
    addr.sin_addr.s_addr = htonl(INADDR_ANY);   //INADDR_ANY有内核分配，htonl函数 无符号长整型数转换成“网络字节序”
        
    /* 从指定字节缓冲区复制，一个不可变的CFData对象*/
    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8*)&addr, sizeof(addr));
    
    /* 设置Socket*/
    if (CFSocketSetAddress(sserver, (CFDataRef)address) != kCFSocketSuccess) {
        fprintf(stderr, "Socket绑定失败\n");
        CFRelease(sserver);
        return -1;
    }
    
    /* 创建一个Run Loop Socket源 */
    CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, sserver, 0);
    /* Socket源添加到Run Loop中 */
    CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopCommonModes);
    CFRelease(sourceRef);
    
    printf("Socket listening on port %d\n", PORT);
    /* 运行Loop */
    CFRunLoopRun();
    
    
}

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