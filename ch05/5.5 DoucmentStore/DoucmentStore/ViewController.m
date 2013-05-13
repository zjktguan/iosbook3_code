//
//  ViewController.m
//  DoucmentStore
//
//  Created by 关东升 on 12-12-28.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    //为查询iCloud文件的变化，注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUbiquitousDocuments:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUbiquitousDocuments:)
                                                 name:NSMetadataQueryDidUpdateNotification object:nil];

    //查询iCloud文件的变化
    [self searchFilesOniCloud];

}

- (void)viewWillAppear:(BOOL)animated {
    [_query enableUpdates];
    [_query startQuery];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_query disableUpdates];
    [_query stopQuery];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//查询iCloud文件的变化
-(void) searchFilesOniCloud {
    _ubiquitousDocumentsURL = [self ubiquitousDocumentsURL];
    if (_ubiquitousDocumentsURL) {
        _query = [[NSMetadataQuery alloc] init];
        _query.predicate = [NSPredicate predicateWithFormat:@"%K like 'abc.txt'", NSMetadataItemFSNameKey];
        _query.searchScopes = [NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope];
    }
}

//当iCloud中的文件变化时候调用
- (void)updateUbiquitousDocuments:(NSNotification *)notification
{
    
    //文件存在
    if ([_query.results count] == 1) {
        NSURL *ubiquityURL = [[_query.results lastObject] valueForAttribute:NSMetadataItemURLKey];
        
        _myCloudDocument = [[MyCloudDocument alloc] initWithFileURL:ubiquityURL];
        
        [_myCloudDocument openWithCompletionHandler:^(BOOL success)
         {
             if (success)
             {
                 NSLog(@"打开iCloud文档");
                 _txtContent.text = _myCloudDocument.contents;
                 
             }
         }];
    }
    else //文件不存在
    {
        NSURL *documentiCloudPath = [_ubiquitousDocumentsURL URLByAppendingPathComponent:@"abc.txt"];
        _myCloudDocument = [[MyCloudDocument alloc] initWithFileURL:documentiCloudPath];
        _myCloudDocument.contents = _txtContent.text;         
    }
    

    if (_myCloudDocument) {
        //注册CloudDocument对象到文档协调者，文档状态变化才能收到通知
        [NSFileCoordinator addFilePresenter:_myCloudDocument];
        
        //注册文档状态变化通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resolveConflict:) name:UIDocumentStateChangedNotification object:nil];
        
    }

}



//请求本地Ubiquity容器，从容器中获得Document目录URL
- (NSURL *)ubiquitousDocumentsURL {
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* containerURL = [fileManager
                           URLForUbiquityContainerIdentifier:@"98Z3R5XU29.com.51work6.MyNotes"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Documents"];
    return containerURL;
}


//文档冲突解决
- (void)resolveConflict:(NSNotification *)notification
{
    
    if (_myCloudDocument && _myCloudDocument.documentState == UIDocumentStateInConflict)
    {
        NSLog(@"冲突发生");
        
        //文档冲突解决策略
        NSError *error;
        if (![NSFileVersion removeOtherVersionsOfItemAtURL:_myCloudDocument.fileURL error:&error])
        {
            NSLog(@"移除其它的文档: %@", [error localizedFailureReason]);
            return;
        }
        _myCloudDocument.contents = _txtContent.text;
        [_myCloudDocument updateChangeCount:UIDocumentChangeDone];
        
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDocumentStateChangedNotification object:nil];
    //从文档协调者中解除CloudDocument对象
    [NSFileCoordinator removeFilePresenter:_myCloudDocument];
    
}


- (IBAction)saveClick:(id)sender {
    _myCloudDocument.contents = _txtContent.text;
    [_myCloudDocument updateChangeCount:UIDocumentChangeDone];
    [_txtContent resignFirstResponder];
}

@end
