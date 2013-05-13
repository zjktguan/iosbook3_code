//
//  RoomBL.m
//  BusinessLogicLayer
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

#import "RoomBL.h"

@implementation RoomBL


static RoomBL *sharedManager = nil;

+ (RoomBL*)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


-(void)queryRoom:(NSDictionary*)keyInfo
{
    NSURL *url = [NSURL URLWithString:[BLHelp URLEncodedString:ROOM_QUERY_URL]];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"<你的iosbook3.com用户邮箱>" forKey:@"email"];
    
    [request setPostValue:[keyInfo objectForKey:@"Checkin"] forKey:@"fromDate"];
    [request setPostValue:[keyInfo objectForKey:@"Checkout"] forKey:@"toDate"];
    
//    [request setPostValue:[keyInfo objectForKey:@"hotelId"] forKey:@"hotelId"];
    [request setPostValue:[keyInfo objectForKey:@"hotelId"] forKey:@"supplierid"];
    
    
    [request setCompletionBlock:^{
        
        NSData *data  = [request responseData];
        
        //NSString *xml = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        NSMutableArray *list = [NSMutableArray new];
        
        NSError *error = nil;
        
        TBXML* tbxml = [[TBXML alloc] initWithXMLData:data error:&error];
        
        if (!error) {
            TBXMLElement * root = tbxml.rootXMLElement;
            
            if (root) {
                TBXMLElement * roomsElement = [TBXML childElementNamed:@"rooms" parentElement:root];
                
                if (roomsElement) {
                    TBXMLElement * roomElement = [TBXML childElementNamed:@"room" parentElement:roomsElement];
                    
                    while (roomElement) {
                        
                        NSMutableDictionary *dict = [NSMutableDictionary new];
                        //取name
                        NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:roomElement];
                        [dict setValue:name forKey:@"name"];
                        //取breakfast
                        NSString *breakfast = [TBXML valueOfAttributeNamed:@"breakfast" forElement:roomElement];
                        [dict setValue:[BLHelp preBreakfast:breakfast] forKey:@"breakfast"];
                        
                        //取bed
                        NSString *bed = [TBXML valueOfAttributeNamed:@"bed" forElement:roomElement];
                        [dict setValue:[BLHelp preBed:bed] forKey:@"bed"];
                        
                        //取broadband
                        NSString *broadband = [TBXML valueOfAttributeNamed:@"broadband" forElement:roomElement];
                        [dict setValue:[BLHelp preBroadband:broadband] forKey:@"broadband"];
                        
                        //取paymode
                        NSString *paymode = [TBXML valueOfAttributeNamed:@"paymode" forElement:roomElement];
                        [dict setValue:[BLHelp prePaymode:paymode]  forKey:@"paymode"];
                        
                        //取frontprice
                        NSString *frontprice = [TBXML valueOfAttributeNamed:@"frontprice" forElement:roomElement];
                        [dict setValue:[BLHelp prePrice:frontprice] forKey:@"frontprice"];
                        
                        
                        roomElement = [TBXML nextSiblingNamed:@"room" searchFromElement:roomElement];
                        
                        [list addObject:dict];
                    }
                }
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BLQueryRoomFinishedNotification object:list];
        
        NSLog(@"解析完成...");
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"%@", [error localizedDescription]);
        [[NSNotificationCenter defaultCenter] postNotificationName:BLQueryRoomFailedNotification object:nil];
        
    }];
    [request startAsynchronous];
}

@end
