//
//  ViewController.m
//  P2PGame
//
//  Created by 关东升 on 12-12-17.
//  Copyright (c) 2012年 516inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self clearUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void) clearUI
{
    [_btnConnect setTitle:@"连接" forState:UIControlStateNormal];
    [_btnClick setEnabled:NO];
    _lblPlayer2.text = @"0";
    _lblPlayer1.text = @"0";
    _lblTimer.text = @"30s";
    
    if (timer) {
        [timer invalidate];
    }
    
}


-(void) updateTimer
{
    int remainTime = [_lblTimer.text intValue];
    
    //剩余时间为0 比赛结束
    if (--remainTime == 0) {
        
        NSString *sendStr = [NSString stringWithFormat:@"{\"code\":%i}",GAMED];
        NSData* data = [sendStr dataUsingEncoding: NSUTF8StringEncoding];
        if (_session)
        {
            [_session sendDataToAllPeers:data
                            withDataMode:GKSendDataReliable
                                   error:nil];
        }
        
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"Game Over."
                                                           message:@"" delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
        [alerView show];
        [self clearUI];
        
    } else {
        _lblTimer.text = [NSString stringWithFormat:@"%is", remainTime];
    }
}

- (void)viewDidUnload {
    [self setBtnConnect:nil];
    [self setLblPlayer1:nil];
    [self setLblPlayer2:nil];
    [self setBtnClick:nil];
    [self setLblTimer:nil];
    [super viewDidUnload];
}

- (IBAction)onClick:(id)sender {
    
    
    int count = [_lblPlayer1.text intValue];
    _lblPlayer1.text = [NSString stringWithFormat:@"%i",++count];
    
    
    NSString *sendStr = [NSString stringWithFormat:@"{\"code\":%i,\"count\":%i}",GAMING,count];
    NSData* data = [sendStr dataUsingEncoding: NSUTF8StringEncoding];
    if (_session)
    {
        [_session sendDataToAllPeers:data
                        withDataMode:GKSendDataReliable
                               error:nil];
    }
    
}

- (IBAction)connect:(id)sender {
    
    _picker = [[GKPeerPickerController alloc] init];
    _picker.delegate = self;
    _picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [_picker show];
}

#pragma mark--GKPeerPickerControllerDelegate

- (void)peerPickerController:(GKPeerPickerController *)pk didConnectPeer:(NSString *)peerID
                   toSession:(GKSession *) session
{
    NSLog(@"建立连接");
    _session = session;
    _session.delegate = self;
    [_session setDataReceiveHandler:self withContext:nil];
    _picker.delegate = nil;
    [_picker dismiss];
    [_btnClick setEnabled:YES];
    [_btnConnect setTitle:@"断开连接" forState:UIControlStateNormal];
    
    //开始计时
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                           selector:@selector(updateTimer)
                                           userInfo:nil repeats:YES];
    
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)pk
{
    NSLog(@"取消连接");
    _picker.delegate = nil;
}

#pragma mark--GKSessionDelegate
- (void)session:(GKSession *)session peer:(NSString *)peerID
 didChangeState:(GKPeerConnectionState)state
{
    if (state == GKPeerStateConnected)
    {
        NSLog(@"connected");
        [_btnConnect setTitle:@"断开连接" forState:UIControlStateNormal];
        [_btnClick setEnabled:YES];
    } else if (state == GKPeerStateDisconnected)
    {
        NSLog(@"disconnected");
        [self clearUI];
    }
    
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    NSLog(@"error %@",[error description]);
}

- (void) receiveData:(NSData *)data
            fromPeer:(NSString *)peer
           inSession:(GKSession *)session
             context:(void *)context
{
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableContainers error:nil];
    NSNumber *codeObj = [jsonObj objectForKey:@"code"];
    
    if ([codeObj intValue]== GAMING) {
        NSNumber * countObj= [jsonObj objectForKey:@"count"];
        _lblPlayer2.text = [NSString stringWithFormat:@"%@",countObj];
        
    } else if ([codeObj intValue]== GAMED) {
        [self clearUI];
    }
    
}



@end
