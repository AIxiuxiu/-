//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+HM.h"

@implementation MBProgressHUD (HM)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
   [hud hide:YES afterDelay:1.2];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (void)showNetActivityIndicatorViewWithText:(NSString *)text view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.color = [UIColor  clearColor];
    hud.labelText = text;
    // 再设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    //设置字体颜色
    hud.label.textColor = [UIColor grayColor];
 
        hud.activityIndicatorColor = [UIColor  grayColor];
   
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)showNetLoadFailWithText:(NSString *)text toView:(UIView *)view target:(id)target action:(SEL)action  isBack:(BOOL)back{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 快速显示一个提示信息
    //  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    if (back) {
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"error.png"]]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        hud.dimBackground = YES;
    }else{
        hud.color = [UIColor clearColor];
        // 再设置模式
        hud.mode = MBProgressHUDModeText;
        //设置字体颜色
        hud.label.textColor = [UIColor grayColor];
         hud.activityIndicatorColor = [UIColor  grayColor];
      
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    [hud  addTarget:target action:action];
}


- (void)hideSelf{
    [self  hide:YES];
}

+ (MBProgressHUD *)showNetLoadText:(NSString *)text toView:(UIView *)view  xOffset:(CGFloat)xOffset  yOffset:(CGFloat)yOffset   isDimback:(BOOL)dimBack{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.color = [UIColor  clearColor];
    // 再设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    //设置字体颜色
    hud.label.textColor = [UIColor grayColor];
  hud.activityIndicatorColor = [UIColor  grayColor];
    hud.labelText = text;
    hud.xOffset = xOffset;
    hud.yOffset = yOffset;
    //蒙板效果
     hud.dimBackground = dimBack;
   
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)text toView:(UIView *)view  isDimback:(BOOL)dimBack{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.color = [UIColor  whiteColor];
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    hud.backgroundColor = [UIColor  whiteColor];
    //设置字体颜色
    hud.label.textColor = ZZGreenColor;
    hud.labelText = text;
    //蒙板效果
    hud.dimBackground = dimBack;

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}
/**
 *  给自己添加响应
 *
 *  @param target <#target description#>
 *  @param action <#action description#>
 */
- (void)addTarget:(id)target action:(SEL)action{
    UIButton *btn = [[UIButton  alloc]initWithFrame:self.bounds];
    btn.backgroundColor = [UIColor  clearColor];
    [btn  addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn  addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:btn];
}
@end
