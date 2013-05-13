//
//  SendViewController.h
//  WeiBo
//
//  Created by 关东升 on 13-1-4.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import <UIKit/UIKit.h>

#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface SendViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *lblCharCounter;

- (IBAction)save:(id)sender;

- (IBAction)cancel:(id)sender;

@end
