//
//  ViewController.m
//  MyPass
//
//  Created by 关东升 on 13-1-22.
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
    
    //判断Pass库是否可用
    if (![PKPassLibrary isPassLibraryAvailable])
    {
        NSLog(@"Pass库不可用。");
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLibraryChange:) name:PKPassLibraryDidChangeNotification object:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //刷新画面
    [self handleLibraryChange:nil];
}


#pragma mark - 处理Pass库变化通知
-(void)handleLibraryChange:(NSNotification*) not
{
    
    PKPassLibrary* passLib = [[PKPassLibrary alloc] init]; 
    //排序
    NSSortDescriptor *byName  = [NSSortDescriptor sortDescriptorWithKey:@"localizedName" ascending:YES];
    _passes = [[passLib passes] sortedArrayUsingDescriptors:@[byName]];
    
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeAllObjects];
    
}


-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_passes count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PKPass *pass = [_passes objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = pass.localizedName;
    cell.detailTextLabel.text = pass.localizedDescription;
    cell.imageView.image = pass.icon;
    return cell;
    
}

#pragma mark - 处理画面跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PKPass  *pass = [_passes objectAtIndex:[indexPath row]];
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.pass = pass;
    }
}


- (IBAction)add:(id)sender {
    
    NSString *strURL = [[NSString alloc] initWithFormat:@"http://iosbook3.com/passbook/download.php?email=%@&serialNumber=%@",@"<你的iosbook3.com用户邮箱>",SerialNumber];
    
	NSURL *url = [NSURL URLWithString:strURL];
    //请求BoardingPass.pkpass下载
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        
        NSData *data  = [request responseData];
        NSError *error;
        PKPass *newPass = [[PKPass alloc] initWithData:data error:&error];
        
        if (!error) {
            PKPassLibrary* passLib = [[PKPassLibrary alloc] init];
            //获得已经存在的Pass
            PKPass *oldPass = [passLib passWithPassTypeIdentifier:@"pass.com.51work6.boarding-pass" serialNumber:SerialNumber];
            //判断是否已经存在旧的Pass
            if (oldPass)
            {
                //替换就的Pass
                [passLib replacePassWithPass:newPass];
                NSLog(@"替换Pass");
                
            } else {
                PKAddPassesViewController *addController = [[PKAddPassesViewController alloc] initWithPass:newPass];
                addController.delegate = self;
                [self presentViewController:addController animated:YES completion:nil];
            }
        }  else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误信息"
                                                                message:@"用户不存在，请到http://iosbook3.com注册。"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
            [alertView show];
        }
        
    }];

    [request startAsynchronous];
    
}



#pragma mark - PKAddPassesViewControllerDelegate 实现方法
-(void)addPassesViewControllerDidFinish: (PKAddPassesViewController*) controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"添加Pass");
}


@end
