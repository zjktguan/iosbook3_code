//
//  ViewController.m
//  WeiBo
//
//  Created by 关东升 on 13-1-3.
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
    
    //初始化UIRefreshControl
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [rc addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) refreshTableView
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];
        
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                      ACAccountTypeIdentifierSinaWeibo];
        
        [account requestAccessToAccountsWithType:accountType options:nil
                                      completion:^(BOOL granted, NSError *error)
         {
             if (granted == YES)
             {
                 NSArray *arrayOfAccounts = [account
                                             accountsWithAccountType:accountType];
                 
                 if ([arrayOfAccounts count] > 0)
                 {
                     ACAccount *weiboAccount = [arrayOfAccounts lastObject];
                     
                     NSDictionary *parameters = [NSDictionary dictionaryWithObject:@"20" forKey:@"count"];
                     
                     NSURL *requestURL = [NSURL
                                          URLWithString:@"https://api.weibo.com/2/statuses/user_timeline.json"];
                     
                     SLRequest *request = [SLRequest
                                               requestForServiceType:SLServiceTypeSinaWeibo
                                               requestMethod:SLRequestMethodGET
                                               URL:requestURL parameters:parameters];
                     
                     
                     request.account = weiboAccount;
                     
                     [request performRequestWithHandler:^(NSData *responseData,
                                                              NSHTTPURLResponse *urlResponse, NSError *error)
                      {
                          
                          NSError *err;
                          
                          id jsonObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err];
                          if (!err) {
                              _listData =  [jsonObj objectForKey:@"statuses"];
                              [self.tableView reloadData];
                          }
                          
                          NSLog(@"Weibo HTTP response: %i", [urlResponse statusCode]);
                          //停止下拉刷新
                          if (self.refreshControl) {
                              [self.refreshControl endRefreshing];
                              self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
                          }
                      }];
                 }
             };
         }];
        
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSDictionary  *rowDict = self.listData[indexPath.row];
    cell.textLabel.text = [rowDict objectForKey:@"text"];
    cell.detailTextLabel.text = [rowDict objectForKey:@"created_at"];
    
    return cell;
}



@end
