//
//  ViewController.h
//  HTTPQueue
//
//  Created by 关东升 on 12-12-21.
//  Copyright (c) 2012年 516inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "NSNumber+Message.h"
#import "NSString+URLEncoding.h"


@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong) ASINetworkQueue  *networkQueue;

- (IBAction)onClick:(id)sender;
@end
