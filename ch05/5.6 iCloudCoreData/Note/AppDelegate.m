//
//  AppDelegate.m
//  Note
//
//  Created by 关东升 on 12-12-30.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "AppDelegate.h"

#import "MainViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    MainViewController *controller = (MainViewController *)self.window.rootViewController;
    controller.managedObjectContext = self.managedObjectContext;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Core Data 堆栈
//返回 被管理的对象上下文
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [moc performBlockAndWait:^{
            [moc setPersistentStoreCoordinator: coordinator];
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(mergeChangesFromCloud:)
                                                        name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                      object:[self persistentStoreCoordinator]];
            
            
        }];
        _managedObjectContext = moc;
    }
    return _managedObjectContext;
}

//处理iCloud合并数据
- (void)mergeChangesFromCloud:(NSNotification *)notification {
	NSLog(@"从iCloud合并数据...");
    [_managedObjectContext performBlock:^{
        [_managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadDataChangesNotification" object:self userInfo:[notification userInfo]];
        
    }];
}

// 返回 持久化存储协调者
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    //创建NSPersistentStoreCoordinator对象
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // 在其它线程设置iCloud
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //App ID
        NSString *appID = @"98Z3R5XU29.com.51work6.DemoiCloudApp";
        
        //数据文件名
        NSString* dataFileName = @"CoreDataNotes.sqlite";
        //Ubiquitous容器在数据文件目录
        NSString *containerDataDir = @"Data.nosync";
        //Ubiquitous容器在日志文件目录
        NSString *containerLogDir = @"Log";
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //本地沙箱中数据文件路径
        NSURL *localStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:dataFileName];
        //Ubiquitous容器的根路径
        NSURL *containerURL = [fileManager URLForUbiquityContainerIdentifier:appID];
        
        if (containerURL) {
            
            NSLog(@"iCloud可以使用");
            
            NSURL *containerLogURL = [containerURL URLByAppendingPathComponent:containerLogDir];
            NSLog(@"containerLogURL = %@",containerLogURL);
            NSURL *containerDataURL = [containerURL URLByAppendingPathComponent:containerDataDir];
            NSLog(@"containerDataURL = %@",containerDataURL);
            NSURL *containerDataFile = [containerDataURL URLByAppendingPathComponent:dataFileName];
            NSLog(@"containerDataFile = %@",containerDataFile);
            
            //如果容器中数据文件目录不存在，则创建
            if(![fileManager fileExistsAtPath:[containerDataURL path]]) {
                NSError *fileSystemError;
                [fileManager createDirectoryAtPath:[containerDataURL path]
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:&fileSystemError];
                if(fileSystemError) {
                    NSLog(@"创建容器中数据文件目录失败，%@", fileSystemError);
                }
            }
            
            NSMutableDictionary *options = [NSMutableDictionary dictionary];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
            [options setObject:appID forKey:NSPersistentStoreUbiquitousContentNameKey];
            [options setObject:containerLogURL  forKey:NSPersistentStoreUbiquitousContentURLKey];
            
            [_persistentStoreCoordinator lock];
            
            [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:containerDataFile
                                                            options:options
                                                              error:nil];
            
            [_persistentStoreCoordinator unlock];
            
        } else {
            
            NSLog(@"iCloud不可用使用本地沙箱目录存储");
            NSMutableDictionary *options = [NSMutableDictionary dictionary];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
            
            [_persistentStoreCoordinator lock];
            
            [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:localStoreURL
                                                            options:options
                                                              error:nil];
            [_persistentStoreCoordinator unlock];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{//主线程调用
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadDataChangesNotification" object:self userInfo:nil];
        });
    });
    
    return _persistentStoreCoordinator;
}

//  返回 被管理的对象模型
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataNotes" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

#pragma mark - 应用程序沙箱
// 返回应用程序Docment目录的NSURL类型
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
