//
//  ViewController.h
//  P2PGame
//
//  Created by 关东升 on 12-12-17.
//  Copyright (c) 2012年 516inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#define  GAMING 0          //游戏进行中
#define  GAMED  1          //游戏结束

@interface ViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate>
{
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;

@property (weak, nonatomic) IBOutlet UILabel *lblPlayer2;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayer1;
@property (weak, nonatomic) IBOutlet UIButton *btnConnect;
@property (weak, nonatomic) IBOutlet UIButton *btnClick;

@property (nonatomic, strong) GKPeerPickerController *picker;
@property (nonatomic, strong) GKSession *session;

- (IBAction)onClick:(id)sender;
- (IBAction)connect:(id)sender;

//清除UI画面上的数据
-(void) clearUI;

//更新计时器
-(void) updateTimer;


@end
