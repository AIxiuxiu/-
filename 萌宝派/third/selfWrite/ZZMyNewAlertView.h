//
//  ZZMyAlertView.h
//  聪明宝宝
//
//  Created by zhizhen on 14-9-2.
//  Copyright (c) 2014年 zhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AHAnimationCompletionBlock)(BOOL);
@class ZZMyNewAlertView;
@protocol ZZMyNewAlertViewDelgate <NSObject>


// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)myNewAlertView:(ZZMyNewAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface ZZMyNewAlertView : UIImageView

@property(nonatomic,weak)id<ZZMyNewAlertViewDelgate>delegate;

@property(nonatomic, copy) NSString *message;

@property(nonatomic,copy)NSString *title;

@property(nonatomic)NSTextAlignment  textAlignment;



- (id)initWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle sureButtonTitle:(NSString *)sureButtonTitle;

-(void)show;

-(void)dismiss;

@end
