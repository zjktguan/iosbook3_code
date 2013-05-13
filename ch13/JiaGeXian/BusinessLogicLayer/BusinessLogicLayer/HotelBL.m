//
//  HotelBL.m
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

#import "HotelBL.h"

@implementation HotelBL


static HotelBL *sharedManager = nil;

+ (HotelBL*)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


-(void)selectKey:(NSString*)city
{
    NSString *strURL = [[NSString alloc] initWithFormat:KEY_QUERY_URL, city ,@"<你的iosbook3.com用户邮箱>"];
    
	NSURL *url = [NSURL URLWithString:[BLHelp URLEncodedString:strURL]];
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        
        NSData *data  = [request responseData];
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: BLQueryKeyFinishedNotification
                                                            object: resDict];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"%@", [error localizedDescription]);
        [[NSNotificationCenter defaultCenter] postNotificationName: BLQueryKeyFailedNotification
                                                            object: nil];
        
    }];
    [request startAsynchronous];
}

//查询酒店
-(void)queryHotel:(NSDictionary*)keyInfo
{
    
    NSURL *url = [NSURL URLWithString:[BLHelp URLEncodedString:HOTEL_QUERY_URL]];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"<你的iosbook3.com用户邮箱>" forKey:@"email"];
    [request setPostValue:[keyInfo objectForKey:@"Plcityid"] forKey:@"f_plcityid"];
    [request setPostValue:[keyInfo objectForKey:@"key"] forKey:@"q"];
    [request setPostValue:[keyInfo objectForKey:@"currentPage"] forKey:@"currentPage"];
    
    NSString *price = [keyInfo objectForKey:@"Price"];
    if ([price isEqualToString:@"价格不限"]) {
        [request setPostValue:@"￥0" forKey:@"priceSlider_minSliderDisplay"];
        [request setPostValue:@"￥3000+" forKey:@"priceSlider_maxSliderDisplay"];
    } else {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"--> "];
        NSArray *tempArray = [price componentsSeparatedByCharactersInSet:set];
        [request setPostValue:tempArray[0] forKey:@"priceSlider_minSliderDisplay"];
        [request setPostValue:tempArray[3] forKey:@"priceSlider_maxSliderDisplay"];
        
    }
    
    [request setPostValue:[keyInfo objectForKey:@"Checkin"] forKey:@"fromDate"];
    [request setPostValue:[keyInfo objectForKey:@"Checkout"] forKey:@"toDate"];
    
    [request setCompletionBlock:^{
        
        NSData *data  = [request responseData];
        
        // NSString *xml = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        
        NSMutableArray *list = [NSMutableArray new];
        
        NSError *error = nil;
        
        TBXML* tbxml = [[TBXML alloc] initWithXMLData:data error:&error];
        
        if (!error) {
            TBXMLElement * root = tbxml.rootXMLElement;
            
            if (root) {
                TBXMLElement * hotel_listElement = [TBXML childElementNamed:@"hotel_list" parentElement:root];
                if (hotel_listElement) {
                    TBXMLElement * hotelElement = [TBXML childElementNamed:@"hotel" parentElement:hotel_listElement];
                    
                    while (hotelElement) {
                        
                        NSMutableDictionary *dict = [NSMutableDictionary new];
                        //取id
                        TBXMLElement *idElement = [TBXML childElementNamed:@"id" parentElement:hotelElement];
                        if (idElement) {
                            [dict setValue:[TBXML textForElement:idElement] forKey:@"id"];
                        }
                        //取name
                        TBXMLElement *nameElement = [TBXML childElementNamed:@"name" parentElement:hotelElement];
                        if (nameElement) {
                            [dict setValue:[TBXML textForElement:nameElement] forKey:@"name"];
                        }
                        //取city
                        TBXMLElement *cityElement = [TBXML childElementNamed:@"city" parentElement:hotelElement];
                        if (cityElement) {
                            [dict setValue:[TBXML textForElement:cityElement] forKey:@"city"];
                        }
                        //取address
                        TBXMLElement *addressElement = [TBXML childElementNamed:@"address" parentElement:hotelElement];
                        if (addressElement) {
                            [dict setValue:[TBXML textForElement:addressElement] forKey:@"address"];
                        }
                        //取phone
                        TBXMLElement *phoneElement = [TBXML childElementNamed:@"phone" parentElement:hotelElement];
                        if (phoneElement) {
                            [dict setValue:[TBXML textForElement:phoneElement] forKey:@"phone"];
                        }
                        //取lowprice
                        TBXMLElement *lowpriceElement = [TBXML childElementNamed:@"lowprice" parentElement:hotelElement];
                        if (lowpriceElement) {
                            NSString *price = [BLHelp prePrice:[TBXML textForElement:lowpriceElement]];
                            [dict setValue:price forKey:@"lowprice"];
                        }
                        //取grade
                        TBXMLElement *gradeElement = [TBXML childElementNamed:@"grade" parentElement:hotelElement];
                        if (gradeElement) {
                            NSString *grade = [BLHelp preGrade:[TBXML textForElement:gradeElement]];
                            [dict setValue:grade forKey:@"grade"];
                        }
                        //取description
                        TBXMLElement *descriptionElement = [TBXML childElementNamed:@"description" parentElement:hotelElement];
                        if (descriptionElement) {
                            [dict setValue:[TBXML textForElement:descriptionElement] forKey:@"description"];
                        }
                        //取img
                        TBXMLElement *imgElement = [TBXML childElementNamed:@"img" parentElement:hotelElement];
                        if (imgElement) {
                            NSString *src = [TBXML valueOfAttributeNamed:@"src" forElement:imgElement];
                            [dict setValue:src forKey:@"img"];
                        }
                        
                        hotelElement = [TBXML nextSiblingNamed:@"hotel" searchFromElement:hotelElement];
                        
                        [list addObject:dict];
                    }
                    
                }
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BLQueryHotelFinishedNotification object:list];
        
        NSLog(@"解析完成...");
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"%@", [error localizedDescription]);
        [[NSNotificationCenter defaultCenter] postNotificationName:BLQueryHotelFailedNotification object:nil];
        
    }];
    [request startAsynchronous];
}

@end
