//
//  HotelListViewController.m
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

#import "HotelListViewController.h"

@interface HotelListViewController ()

@end

@implementation HotelListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentPage = 1;
    
    //初始化UIRefreshControl
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [rc addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void) refreshTableView
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];
        //_list = [NSMutableArray new];
        currentPage = 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryHotelFinished:)
                                                     name:BLQueryHotelFinishedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryHotelFailed:)
                                                     name:BLQueryHotelFailedNotification object:nil];
        
        NSString* currentPageStr = [[NSString alloc] initWithFormat:@"%i",currentPage];
        [_queryKey setObject:currentPageStr forKey:@"currentPage"];
        [[HotelBL sharedManager] queryHotel:_queryKey];
    }
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
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    cell.lblName.text = [dict objectForKey:@"name"];
    cell.lblAddress.text = [dict objectForKey:@"address"];
    cell.lblPrice.text = [dict objectForKey:@"lowprice"];
    cell.lblGrade.text = [dict objectForKey:@"grade"];
    cell.lblPhone.text = [dict objectForKey:@"phone"];
    
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"myIndex" ofType:@"html"];
    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:htmlPath encoding: NSUTF8StringEncoding error:nil];
    
    NSRange subRange = [html rangeOfString: @"####"];
    
    if (subRange.location != NSNotFound) {
        [html replaceCharactersInRange:subRange withString: [dict objectForKey:@"img"]];
    }
    
    [cell.webView loadHTMLString:html baseURL:bundleUrl];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
        forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([_list count] == indexPath.row + 1) && _loadViewCell.hidden == NO) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryHotelFinished:)
                                                     name:BLQueryHotelFinishedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryHotelFailed:)
                                                     name:BLQueryHotelFailedNotification object:nil];
        
        NSLog(@"load data...");
        currentPage++;
        NSString* currentPageStr = [[NSString alloc] initWithFormat:@"%i",currentPage];
        [_queryKey setObject:currentPageStr forKey:@"currentPage"];
        [[HotelBL sharedManager] queryHotel:_queryKey];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if  ([identifier isEqualToString:@"showRoomDetail"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading";
        
        NSMutableDictionary* qkey = [[NSMutableDictionary alloc] init];
        [qkey setObject:[_queryKey objectForKey:@"Checkin"] forKey:@"Checkin"];
        [qkey setObject:[_queryKey objectForKey:@"Checkout"] forKey:@"Checkout"];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         NSDictionary* dict = [_list objectAtIndex:indexPath.row];
        [qkey setObject:[dict objectForKey:@"id"] forKey:@"hotelId"];
        
        _queryRoomKey = qkey;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryRoomFinished:)
                                                     name:BLQueryRoomFinishedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryRoomFailed:)
                                                     name:BLQueryRoomFailedNotification object:nil];
        
        [[RoomBL sharedManager] queryRoom:_queryRoomKey];
        
        return NO;
    }    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showRoomDetail"]) {        
        RoomListViewController* roomListViewController = (RoomListViewController*)[segue destinationViewController];
        roomListViewController.list = _roomList;
    }
    
}

//接收BL查询Hotel信息成功通知
- (void)queryHotelFinished:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryHotelFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryHotelFailedNotification object:nil];
    
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    
    NSArray *resList = not.object;
    if ([resList count] < 20) {
        _loadViewCell.hidden = YES;
    } else {
        _loadViewCell.hidden = NO;
    }
    
    if (currentPage == 1) {
        _list = [NSMutableArray new];
    }
    
    [_list addObjectsFromArray:resList];
    
    [self.tableView reloadData];
    
    
}

//接收BL查询Hotel信息失败通知
- (void)queryHotelFailed:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryHotelFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryHotelFailedNotification object:nil];
}

//接收BL查询房间成功通知
- (void)queryRoomFinished:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _roomList = not.object;
    [self performSegueWithIdentifier:@"showRoomDetail" sender:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryRoomFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryRoomFailedNotification object:nil];
}

//接收BL查询房间失败通知
- (void)queryRoomFailed:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryRoomFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BLQueryRoomFailedNotification object:nil];
}

@end
