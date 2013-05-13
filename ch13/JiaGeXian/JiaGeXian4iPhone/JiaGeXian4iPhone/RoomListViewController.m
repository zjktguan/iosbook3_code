//
//  RoomListViewController.m
//  JiaGeXian4iPhone
//
//  Created by 关东升 on 13-1-26.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "RoomListViewController.h"


@implementation RoomListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    RoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    cell.lblName.text = [dict objectForKey:@"name"];
    cell.lblBreakfast.text = [dict objectForKey:@"breakfast"];
    cell.lblBroadband.text = [dict objectForKey:@"broadband"];
    cell.lblFrontprice.text = [dict objectForKey:@"frontprice"];
    cell.lblPaymode.text= [dict objectForKey:@"paymode"];
    cell.lblBed.text = [dict objectForKey:@"bed"];
    
    return cell;
}

@end
