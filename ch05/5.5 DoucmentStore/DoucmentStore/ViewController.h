//
//  ViewController.h
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

#import <UIKit/UIKit.h>
#import "MyCloudDocument.h"


@interface ViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UITextField *txtContent;
@property (strong, nonatomic) MyCloudDocument *myCloudDocument;
@property (strong, nonatomic) NSURL *ubiquitousDocumentsURL;
    
@property (strong, nonatomic) NSMetadataQuery *query;

- (IBAction)saveClick:(id)sender;

@end
