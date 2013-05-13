//
//  MasterViewController.m
//  MyNotes
//
//  Created by 关东升 on 12-9-26.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation MasterViewController


- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    action = ACTION_QUERY;
    [self startRequest];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"  forIndexPath:indexPath];
    
    NSMutableDictionary*  dict = self.listData[indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"Content"];
    cell.detailTextLabel.text = [dict objectForKey:@"CDate"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //删除数据
        action = ACTION_REMOVE;
        deleteRowId = indexPath.row;
        [self startRequest];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary*  dict = self.listData[indexPath.row];
        DetailViewController *detailViewController = [segue destinationViewController];
        [detailViewController setDetailItem:[dict objectForKey:@"ID"]];
        [detailViewController setDetailContent: [dict objectForKey:@"Content"]];
    }
}

/*
 * 开始请求Web Service
 */
-(void)startRequest
{
    NSString *strURL = [[NSString alloc] initWithFormat:@"http://iosbook3.com/service/mynotes/webservice.php?email=%@&type=%@",@"<你的iosbook3.com用户邮箱>",@"SOAP"];
    
	NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSString *envelopeText;
    if (action == ACTION_QUERY) {//查询处理
        //组装调用查询方法的SOAP请求消息字符串
        envelopeText = [SoapHelper getQueryRequestString];
    } else if (action == ACTION_REMOVE) {//删除处理
        //获取选中行的id
        NSMutableDictionary*  dict = self.listData[deleteRowId];
        //通过id组装调用删除方法的SOAP请求消息字符串
        envelopeText = [SoapHelper getRemoveRequestString: [dict objectForKey:@"ID"]];
    }
    
    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    //创建可变请求对象
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置POST方法
	[request setHTTPMethod:@"POST"];
    //设置请求体
	[request setHTTPBody:envelope];
    //设置请求头，Content-Type字段
    [request setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //设置请求头，Content-Length字段
    [request setValue:[NSString stringWithFormat:@"%d", [envelope length]] forHTTPHeaderField:@"Content-Length"];
    	
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
	
    if (connection) {
        _datas = [NSMutableData new];
    }
}


#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_datas appendData:data];
}


-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {    
    NSLog(@"%@",[error localizedDescription]);
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    
    NSLog(@"请求完成...");
    
    NSError *err;
    NSString *message;
    
    if (action == ACTION_QUERY) {//查询处理
        
        NSMutableArray * array = [SoapHelper parserQueryResponseData:_datas error:&err];
        if (!err) {
            _listData = array;
            [self.tableView reloadData];
            return;
        } else {
            message = [err localizedDescription];
        }
    } else if (action == ACTION_REMOVE) {//删除处理
        
        [SoapHelper parserRemoveResponseData:_datas error:&err];
        if (!err) {
            message = @"操作成功。";
        } else {
            message = [err localizedDescription];
        }
    }
    
    if (message) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [alertView show];
        //重新查询
        action = ACTION_QUERY;
        [self startRequest];
    }
 
}

@end
