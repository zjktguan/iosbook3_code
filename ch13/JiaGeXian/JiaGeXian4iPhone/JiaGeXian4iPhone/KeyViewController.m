//
//  KeyViewController.m
//  JiaGeXian4iPhone
//
//  Created by 关东升 on 13-1-24.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "KeyViewController.h"

@interface KeyViewController ()

@end

@implementation KeyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _keyTypeList = [_keyDict allKeys];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_keyDict count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *keyName = [_keyTypeList objectAtIndex:section];
    NSArray* keyList = [_keyDict objectForKey:keyName];
    
    return [keyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *keyName = [_keyTypeList objectAtIndex:indexPath.section];
    NSArray* keyList = [_keyDict objectForKey:keyName];
    
    cell.textLabel.text = [[keyList objectAtIndex:indexPath.row] objectForKey:@"key"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *keyTypeName = [_keyTypeList objectAtIndex:section];
	return keyTypeName;
}

-(NSArray *) sectionIndexTitlesForTableView: (UITableView *) tableView
{
    return  [_keyDict allKeys];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyName = [_keyTypeList objectAtIndex:indexPath.section];
    NSArray* keyList = [_keyDict objectForKey:keyName];
    [self.delegate closeKeysView:[[keyList objectAtIndex:indexPath.row] objectForKey:@"key"]];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
