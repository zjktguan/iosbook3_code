//
//  MyPickerViewController.h
//  JiaGeXian4iPhone
//
//  Created by tonyguan on 13-1-25.
//  Copyright (c) 2013年 eorient. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyPickerViewControllerDelegate

- (void)myPickViewClose:(NSString*)selected;

@end

@interface MyPickerViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, retain) IBOutlet UIPickerView *picker;

@property (nonatomic, retain)  NSArray *pickerData;


@property (nonatomic,weak) id<MyPickerViewControllerDelegate> delegate;

-(void) showInView:(UIView*)superview;

-(void) hideInView;

- (IBAction)done:(id)sender;

- (IBAction)cancel:(id)sender;

@end
