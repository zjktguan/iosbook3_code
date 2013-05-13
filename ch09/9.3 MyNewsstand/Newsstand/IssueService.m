//
//  Client.m
//  Newsstand
//
//  Created by 关东升 on 13-1-13.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "IssueService.h"

@implementation IssueService

-(id) init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(download:)
                                                     name:DownloadNotification  object:nil];
        //继续下载
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resumeDownload:)
                                                     name:ResumeDownloadNotification object:nil];
    }
    return self;
}

-(void) start {
    
    NSString *strURL = [[NSString alloc] initWithFormat:@"http://iosbook3.com/service/newsstand/issues.php?email=%@",@"<你的iosbook3.com用户邮箱>"];
    
	NSURL *url = [NSURL URLWithString:strURL];
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        
        NSData *data  = [request responseData];
        NSError *error;
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        }
        _issues = [resDict objectForKey:@"issues"];
        // 添加报刊杂志到NSLibrary库
        [self addIssuesInNewsstand];
        // 下载报刊杂志封面
        [self downloadIssuesCover];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"%@", [error localizedDescription]);
        
    }];
    [request startAsynchronous];
    
}

-(void)addIssuesInNewsstand {
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    [_issues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *_ID = [(NSDictionary *)obj objectForKey:@"ID"];
        NKIssue *nkIssue = [nkLib issueWithName:_ID];
        
        if(!nkIssue) {
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* date = [inputFormatter dateFromString:[obj objectForKey:@"ReleaseDate"]];
            
            nkIssue = [nkLib addIssueWithName:_ID date:date];
        }
        NSLog(@"Issue: %@",nkIssue);
    }];
}

-(void)downloadIssuesCover {
    
    if (!_networkQueue) {
        _networkQueue = [[ASINetworkQueue alloc] init];
    }
    
    // 停止以前的队列
	[_networkQueue cancelAllOperations];
	
	// 创建ASI队列
	[_networkQueue setDelegate:self];
	[_networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
	[_networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
	[_networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
    
    [_issues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *coverFilePath = [CacheDirectory stringByAppendingPathComponent: [[NSString alloc] initWithFormat:@"issue%i.png",(idx+1)]];
        
        //文件不存在，则下载
        if (![[NSFileManager defaultManager] fileExistsAtPath:coverFilePath]) {
            
            NSString *strURL = [[NSString alloc] initWithFormat:@"http://iosbook3.com/service/newsstand/issue%i.png",(idx+1)];
            NSURL *url = [NSURL URLWithString:strURL];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            
            request.tag = (idx+1);
            [_networkQueue addOperation:request];
        }
    }];
    
	[_networkQueue go];
    
    //没有杂志下载直接更新UI
    if ([_networkQueue requestsCount] == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUINotification object:_issues];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *data = [request responseData];
    NSError *eror;
    NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&eror];
    
    if (!resDict) {
        NSString *coverFilePath = [CacheDirectory stringByAppendingPathComponent: [[NSString alloc] initWithFormat:@"issue%i.png",request.tag]];
        [data writeToFile:coverFilePath atomically:YES];
    }
    if ([_networkQueue requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
    
    NSLog(@"请求成功");
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",[error localizedDescription]);
    if ([_networkQueue requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
    NSLog(@"请求失败");
}


- (void)queueFinished:(ASIHTTPRequest *)request
{
	if ([_networkQueue requestsCount] == 0) {
		[self setNetworkQueue:nil];
        
        //取出最后的杂志封面更新UI
        NSString *coverFilePath = [CacheDirectory stringByAppendingPathComponent: [[NSString alloc] initWithFormat:@"issue%i.png", [_issues count]]];
 
        UIImage *image = [UIImage imageWithContentsOfFile:coverFilePath];
        
        // 更新杂志封面
        if(image) {
            [[UIApplication sharedApplication] setNewsstandIconImage:image];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUINotification object:_issues];
        
	}
    NSLog(@"队列完成");
}


#pragma mark - 处理下载通知
-(void)download:(NSNotification *)not {
    //取最新的杂志
    NKIssue *nkIssue = [self getIssueAtIndex: [_issues count] -1];
    
    if (nkIssue.status != NKIssueContentStatusDownloading) {
        
        NSURL *downloadURL = [NSURL URLWithString:[_issues[0] objectForKey:@"DownloadURL"]];
        
        NSURLRequest *req = [NSURLRequest requestWithURL:downloadURL];
        NKAssetDownload *asset = [nkIssue addAssetWithRequest:req];
        [asset downloadWithDelegate:self];
        
    }
}

#pragma mark - 处理断点续传下载通知
-(void)resumeDownload:(NSNotification *)not {
    // 处理应用程序终止时候为下载完成的处理。
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    for(NKAssetDownload *asset in [nkLib downloadingAssets]) {
        NKIssue *nkIssue = [asset issue];
        NSLog(@"继续下载 issue %@ (asset ID: %@)",nkIssue.name,asset.identifier);
        [asset downloadWithDelegate:self];
    }
}

#pragma mark - NSURLConnectionDownloadDelegate
-(void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten
    totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes
{
    self.downloadProgress = 1.0f * totalBytesWritten/expectedTotalBytes;
    NSLog(@"下载进度: %.0f%%",_downloadProgress*100);
}

-(void)connectionDidResumeDownloading:(NSURLConnection *)connection
    totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes
{
    self.downloadProgress = 1.0f * totalBytesWritten/expectedTotalBytes;
    NSLog(@"下载进度: %.0f%%",_downloadProgress*100);
}

-(void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL {
    NKAssetDownload *dnl = connection.newsstandAssetDownload;
    NKIssue *nkIssue = dnl.issue;
    
    NSString *contentPath = [self downloadPathForIssue:nkIssue];
    NSError *moveError=nil;
    NSLog(@"文件拷贝失败 %@",contentPath);
    
    if([[NSFileManager defaultManager] moveItemAtPath:[destinationURL path] toPath:contentPath error:&moveError]==NO) {
        NSLog(@"文件拷贝失败 从 %@ 到 %@",destinationURL,contentPath);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUINotification object:_issues];
}

//获得下载杂志路径
-(NSString *)downloadPathForIssue:(NKIssue *)nkIssue {
    return [[nkIssue.contentURL path] stringByAppendingPathComponent:@"magazine.pdf"];
}

//根据获得下载杂志
-(NKIssue*) getIssueAtIndex:(int) index
{
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    NSString *_ID = [_issues[index] objectForKey:@"ID"];
    NKIssue *nkIssue = [nkLib issueWithName:_ID];
    return nkIssue;
}

//根据获得下载杂志路径
-(NSString*) getIssueContentPathAtIndex:(int) index
{
    NKIssue *nkIssue = [self getIssueAtIndex:index];
    return [self downloadPathForIssue:nkIssue];
}

@end
