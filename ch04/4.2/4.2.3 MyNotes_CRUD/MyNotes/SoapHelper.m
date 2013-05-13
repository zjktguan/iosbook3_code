//
//  SoapHelper.m
//  MyNotes
//
//  Created by 关东升 on 12-12-20.
//  本书网站：http://www.iosbook3.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "SoapHelper.h"

@implementation SoapHelper

//处理查询请求字符串
+(NSString*) getQueryRequestString
{
    NSString *str = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
            "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=      \"http://www.w3.org/2003/05/soap-envelope\">"
            "  <soap12:Body>"
            "    <query xmlns=\"http://tempuri.org/\" />"
            "  </soap12:Body>"
            "</soap12:Envelope>";
    return str;
}


//处理查询应答数据解析到集合中
+(NSMutableArray*)parserQueryResponseData:(NSData*)data error:(NSError**) err
{
    NSString *str  =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"---------     \n %@",str);
    
    NSError* xmlerror;
    TBXML* tbxml = [[TBXML alloc] initWithXMLData:data error:&xmlerror];
    if (xmlerror) {
        NSLog(@"解析数据失败.");
        return nil;
    }
    
    TBXMLElement * root = tbxml.rootXMLElement;
	if (!root) {
        NSLog(@"创建Envelope对象失败.");
        return nil;
    }
    
    TBXMLElement * bodyElement = [TBXML childElementNamed:@"soap12:Body" parentElement:root];
    if (!bodyElement) {
        NSLog(@"创建Body对象失败.");
        return nil;
    }
    
    TBXMLElement * queryResponseElement = [TBXML childElementNamed:@"queryResponse" parentElement:bodyElement];
    if (!queryResponseElement) {
        //服务返回错误，解析错误信息。
        TBXMLElement * responseElement = [TBXML childElementNamed:@"Response" parentElement:bodyElement];
        if (responseElement) {//服务返回错误
            TBXMLElement * resultElement = [TBXML childElementNamed:@"Result" parentElement:responseElement];
            if (resultElement) {
                NSString *resultCodeStr = [TBXML textForElement:resultElement];
                
                NSString *message = @"操作成功。";
                
                NSInteger resultCode = [resultCodeStr integerValue];
                if (resultCode < 0) {
                    NSNumber *resultCodeNumber = [NSNumber numberWithInt:resultCode];
                    message = [resultCodeNumber errorMessage];
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message
                                                                         forKey:NSLocalizedDescriptionKey];
                    *err = [NSError errorWithDomain:@"SOAP" code:resultCode userInfo:userInfo];
                    return nil;
                }
                
                
            } else {
                NSLog(@"创建Result对象失败.");
                return nil;
            }
        } else {
            NSLog(@"创建Response对象失败.");
            return nil;
        }
    }
    
    TBXMLElement * queryResultElement = [TBXML childElementNamed:@"queryResult" parentElement:queryResponseElement];
    if (!queryResultElement) {
        NSLog(@"创建queryResult对象失败.");
        return nil;
    }
    
    TBXMLElement * noteElement = [TBXML childElementNamed:@"Note" parentElement:queryResultElement];
    if (!noteElement) {
        NSLog(@"创建noteElement对象失败.");
        return nil;
    }
    
    NSMutableArray *list = [NSMutableArray new];
    
    while ( noteElement != nil) {
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        
        TBXMLElement *CDateElement = [TBXML childElementNamed:@"CDate" parentElement:noteElement];
        if ( CDateElement) {
            NSString *CDate = [TBXML textForElement:CDateElement];
            [dict setValue:CDate forKey:@"CDate"];
        }
        
        TBXMLElement *ContentElement = [TBXML childElementNamed:@"Content" parentElement:noteElement];
        if ( ContentElement) {
            NSString *Content = [TBXML textForElement:ContentElement];
            [dict setValue:Content forKey:@"Content"];
        }
        
        TBXMLElement *UserIDElement = [TBXML childElementNamed:@"ID" parentElement:noteElement];
        if ( UserIDElement) {
            NSString *UserID = [TBXML textForElement:UserIDElement];
            [dict setValue:UserID forKey:@"ID"];
        }
        
        [list addObject:dict];
        
        noteElement = [TBXML nextSiblingNamed:@"Note" searchFromElement:noteElement];
		
    }
    
    NSLog(@"解析完成...");
    
    return list;
    
}

//处理删除请求字符串
+(NSString*) getRemoveRequestString:(NSString*)_id;
{
    NSString *str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                     "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                     "  <soap12:Body>"
                     "    <remove xmlns=\"http://tempuri.org/\">"
                     "      <_ID>%@</_ID>"
                     "    </remove>"
                     "  </soap12:Body>"
                     "</soap12:Envelope>", _id];
    
    return str;
}

//处理删除应答数据解析到字典中
+(void)parserRemoveResponseData:(NSData*)data error:(NSError**) err
{
    NSString *str  =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"---------     \n %@",str);
    
    NSError* xmlerror;
    TBXML* tbxml = [[TBXML alloc] initWithXMLData:data error:&xmlerror];
    if (xmlerror) {
        NSLog(@"解析数据失败.");
    }
    
    TBXMLElement * root = tbxml.rootXMLElement;
	if (!root) {
        NSLog(@"创建Envelope对象失败.");
    }
    
    TBXMLElement * bodyElement = [TBXML childElementNamed:@"soap12:Body" parentElement:root];
    if (!bodyElement) {
        NSLog(@"创建Body对象失败.");
    }
    
    TBXMLElement * removeResponseElement = [TBXML childElementNamed:@"removeResponse" parentElement:bodyElement];
    if (!removeResponseElement) {
        NSLog(@"创建removeResponse对象失败.");
    }
    
    //服务返回错误，解析错误信息。
    TBXMLElement * removeResultElement = [TBXML childElementNamed:@"removeResult" parentElement:removeResponseElement];
    if (removeResultElement) {
        NSString *resultCodeStr = [TBXML textForElement:removeResultElement];
        
        NSInteger resultCode = [resultCodeStr integerValue];
        if (resultCode < 0) {
            NSNumber *resultCodeNumber = [NSNumber numberWithInt:resultCode];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[resultCodeNumber errorMessage]
                                                                 forKey:NSLocalizedDescriptionKey];
            *err = [NSError errorWithDomain:@"SOAP" code:resultCode userInfo:userInfo];
        }
        
    }
    
    NSLog(@"解析完成...");
    
}

//处理插入请求字符串
+(NSString*) getAddRequestStringWithDate:(NSString*)CDate andContent:(NSString*)Content
{
    NSString *str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                     "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                     "  <soap12:Body>"
                     "    <add xmlns=\"http://tempuri.org/\">"
                     "      <CDate>%@</CDate>"
                     "      <Content>%@</Content>"
                     "    </add>"
                     "  </soap12:Body>"
                     "</soap12:Envelope>", CDate,Content];
    
    return str;
}

//处理插入应答数据解析到字典中
+(void)parserAddResponseData:(NSData*)data error:(NSError**) err
{
    NSString *str  =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"---------     \n %@",str);
    
    NSError* xmlerror;
    TBXML* tbxml = [[TBXML alloc] initWithXMLData:data error:&xmlerror];
    if (xmlerror) {
        NSLog(@"解析数据失败.");
    }
    
    TBXMLElement * root = tbxml.rootXMLElement;
	if (!root) {
        NSLog(@"创建Envelope对象失败.");
    }
    
    TBXMLElement * bodyElement = [TBXML childElementNamed:@"soap12:Body" parentElement:root];
    if (!bodyElement) {
        NSLog(@"创建Body对象失败.");
    }
    
    TBXMLElement * addResponseElement = [TBXML childElementNamed:@"addResponse" parentElement:bodyElement];
    if (!addResponseElement) {
        NSLog(@"创建addResponse对象失败.");
    }
    
    //服务返回错误，解析错误信息。
    TBXMLElement * addResultElement = [TBXML childElementNamed:@"addResult" parentElement:addResponseElement];
    if (addResultElement) {
        NSString *resultCodeStr = [TBXML textForElement:addResultElement];
        
        NSInteger resultCode = [resultCodeStr integerValue];
        if (resultCode < 0) {
            NSNumber *resultCodeNumber = [NSNumber numberWithInt:resultCode];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[resultCodeNumber errorMessage]
                                                                 forKey:NSLocalizedDescriptionKey];
            *err = [NSError errorWithDomain:@"SOAP" code:resultCode userInfo:userInfo];
        }
        
    }
    
    NSLog(@"解析完成...");
}



//处理修改请求字符串
+(NSString*) getModfidyRequestStringWithDate:(NSString*)CDate andContent:(NSString*)Content andID:(NSString*)_id
{
    NSString *str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                     "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                     "  <soap12:Body>"
                     "    <modify xmlns=\"http://tempuri.org/\">"
                     "      <_ID>%@</_ID>"
                     "      <CDate>%@</CDate>"
                     "      <Content>%@</Content>"
                     "    </modify>"
                     "  </soap12:Body>"
                     "</soap12:Envelope>", _id,CDate,Content];
    
    return str;
}

//处理修改应答数据解析到字典中
+(void)parserModifyResponseData:(NSData*)data error:(NSError**) err
{
    NSString *str  =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"---------     \n %@",str);
    
    NSError* xmlerror;
    TBXML* tbxml = [[TBXML alloc] initWithXMLData:data error:&xmlerror];
    if (xmlerror) {
        NSLog(@"解析数据失败.");
    }
    
    TBXMLElement * root = tbxml.rootXMLElement;
	if (!root) {
        NSLog(@"创建Envelope对象失败.");
    }
    
    TBXMLElement * bodyElement = [TBXML childElementNamed:@"soap12:Body" parentElement:root];
    if (!bodyElement) {
        NSLog(@"创建Body对象失败.");
    }
    
    TBXMLElement * modifyResponseElement = [TBXML childElementNamed:@"modifyResponse" parentElement:bodyElement];
    if (!modifyResponseElement) {
        NSLog(@"创建modifyResponse对象失败.");
    }
    
    //服务返回错误，解析错误信息。
    TBXMLElement * modifyResultElement = [TBXML childElementNamed:@"modifyResult" parentElement:modifyResponseElement];
    if (modifyResultElement) {
        NSString *resultCodeStr = [TBXML textForElement:modifyResultElement];
        
        NSInteger resultCode = [resultCodeStr integerValue];
        if (resultCode < 0) {
            NSNumber *resultCodeNumber = [NSNumber numberWithInt:resultCode];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[resultCodeNumber errorMessage]
                                                                 forKey:NSLocalizedDescriptionKey];
            *err = [NSError errorWithDomain:@"SOAP" code:resultCode userInfo:userInfo];
        }
        
    }
    
    NSLog(@"解析完成...");
}


@end
