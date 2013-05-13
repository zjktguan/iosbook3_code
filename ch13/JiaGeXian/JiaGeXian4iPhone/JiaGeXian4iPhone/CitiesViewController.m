//
//  CitiesViewController.m
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

#import "CitiesViewController.h"

@interface CitiesViewController ()

@end

@implementation CitiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* cityPlistPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
    
    //按照拼写排序
    NSSortDescriptor *bySpell  = [NSSortDescriptor sortDescriptorWithKey:@"spell" ascending:YES];
    _cities = [[NSArray arrayWithContentsOfFile:cityPlistPath] sortedArrayUsingDescriptors:@[bySpell]];
    
    [self filterContentForSearchText:@""];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listFilterCities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* dict = [_listFilterCities objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict objectForKey:@"name"];
    
    return cell;
}

-(NSArray *) sectionIndexTitlesForTableView: (UITableView *) tableView
{
    NSMutableArray *listTitles = [[NSMutableArray alloc] initWithCapacity:[_listFilterCities count]];
    for (NSDictionary *item in _listFilterCities) {
        
        NSString *title = [[item objectForKey:@"spell"] substringToIndex:1];
        [listTitles  addObject:title];
    }
    return listTitles;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [_listFilterCities objectAtIndex:indexPath.row];
    [self.delegate closeCitiesView:dict];
}

#pragma mark --UISearchBarDelegate 协议方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //查询所有
    [self filterContentForSearchText:@""];
}


#pragma mark - UISearchDisplayController Delegate Methods
//当文本内容发生改变时候，向表视图数据源发出重新加载消息
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
        shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    //YES情况下表视图可以重新加载
    return YES;
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText
{
    
    if([searchText length]==0)
    {
        //查询所有
        _listFilterCities = [NSMutableArray arrayWithArray:_cities];
        return;
    }
    
    NSPredicate* scopePredicate = [NSPredicate predicateWithFormat:@"SELF.abbreviativeName contains[c] %@",searchText];
    NSArray* tempArray =[_cities filteredArrayUsingPredicate:scopePredicate];
    _listFilterCities = [NSMutableArray arrayWithArray:tempArray];
    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
