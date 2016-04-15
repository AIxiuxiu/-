//
//  ZZMyAlertView.h
//  聪明宝宝
//
//  Created by zhizhen on 14-9-2.
//  Copyright (c) 2014年 zhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AHAnimationCompletionBlock)(BOOL);
@class ZZMyAlertView;
@protocol ZZMyAlertViewDelgate <NSObject>

@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface ZZMyAlertView : UIView

@property(nonatomic,weak)id<ZZMyAlertViewDelgate>delegate;

@property(nonatomic, copy) NSString *message;

@property(nonatomic,strong)UIImage*  backgroundImage;

- (id)initWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle sureButtonTitle:(NSString *)sureButtonTitle;

-(void)show;

-(void)dismiss;

@end
