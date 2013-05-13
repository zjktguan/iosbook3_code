//
//  MainViewController.m
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

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"ReloadDataChangesNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (void)viewDidUnload {
    [self setTxtDate:nil];
    [self setTxtContent:nil];
    [super viewDidUnload];
}

- (IBAction)save:(id)sender {
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    NSManagedObject *noteEntity  = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Note" inManagedObjectContext:cxt];
    [noteEntity setValue:_txtDate.text forKey:@"date"];
    [noteEntity setValue:_txtContent.text forKey:@"content"];
    
    NSError *err;
    if (![cxt save:&err]) {
        NSLog(@"An error has occured: %@", [err localizedDescription]);
    }
}

- (IBAction)query:(id)sender {

    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Note" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF.date contains[c] %@",_txtDate.text];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *values = [cxt executeFetchRequest:request error:&error];

    
    if (!error && [values count] > 0) {
        NSManagedObject *note = values[0];
        NSLog(@"date = %@", [note valueForKey:@"date"]);
        NSLog(@"content = %@", [note valueForKey:@"content"]);
        
        _txtContent.text = [note valueForKey:@"content"];
        _txtDate.text = [note valueForKey:@"date"];
        
    }
    
}


//重新加载数据
- (void)reloadData:(NSNotification*)note {
    
    NSLog(@"重新加载数据...");
    
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Note" inManagedObjectContext:cxt];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *values = [cxt executeFetchRequest:request error:&error];
    
    for (NSManagedObject *note in values) {
        NSLog(@"date = %@,content = %@", [note valueForKey:@"date"],[note valueForKey:@"content"]);
    }
}

@end
