//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (HM)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;


+ (void)showNetActivityIndicatorViewWithText:(NSString *)text view:(UIView *)view;

/**
 *  网络加载失败提示
 *
 *  @param text   <#text description#>
 *  @param view   <#view description#>
 *  @param target <#target description#>
 *  @param action <#action description#>
 *  @param back   是否有背景色，有错误标识
 */
+ (void)showNetLoadFailWithText:(NSString *)text toView:(UIView *)view target:(id)target action:(SEL)action  isBack:(BOOL)back;

/**
 *  加载网络提示
 *
 *  @param text    提示内容
 *  @param view    <#view description#>
 *  @param xOffset 提示的x轴偏移量
 *  @param yOffset 提示的y轴偏移量
 *
 *  @return
 */
+ (MBProgressHUD *)showNetLoadText:(NSString *)text toView:(UIView *)view  xOffset:(CGFloat)xOffset  yOffset:(CGFloat)yOffset isDimback:(BOOL)dimBack;

/**
 *  显示提示信息
 *
 *  @param text    显示的内容
 *  @param view    加到哪个view上
 *  @param dimBack 是否有背景蒙板
 *
 *  @return <#return value description#>
 */
+ (MBProgressHUD *)showMessage:(NSString *)text toView:(UIView *)view  isDimback:(BOOL)dimBack;

/**
 *  给hud添加点击响应事件
 *
 *  @param target
 *  @param action
 */
- (void)addTarget:(id)target action:(SEL)action;
@end
