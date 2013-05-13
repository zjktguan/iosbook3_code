//
//  MyDatePickerViewController.h
//  Test2
//
//  Created by tonyguan on 13-1-25.
//  Copyright (c) 2013年 eorient. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyDatePickerViewController;

@protocol MyDatePickerViewControllerDelegate

- (void)myPickDateViewControllerDidFinish:(MyDatePickerViewController *)controller andSelectedDate:(NSDate*)selected;

@end

@interface MyDatePickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

@property (nonatomic,weak) id<MyDatePickerViewControllerDelegate> delegate;

-(void) showInView:(UIView*)superview;

-(void) hideInView;

- (IBAction)done:(id)sender;

- (IBAction)cancel:(id)sender;

@end