//
//  ZZBaseViewController.h
//  萌宝派
//
//  Created by zhizhen on 15/4/24.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZBaseViewController : UIViewController
@property(nonatomic,strong)UILabel*  tipsLabel;//提醒在进行网络刷新


//加载开始
-(void)netStartRefresh;
//加载结束
-(void)netStopRefresh;
/**
 *  网络加载标识开始
 */
-(void)netLoadLogoStartWithView:(UIView*)view;
/**
 *  网络加载标识结束
 */
-(void)netLoadLogoEndWithView:(UIView*)view;
/**
 *  网络加载失败
 *
 *  @param text   <#text description#>
 *  @param action <#action description#>
 *  @param back   <#back description#>
 */
-(void)netLoadFailWithText:(NSString*)text  isBack:(BOOL)back;

/**
 *  网络加载失败
 *
 *  @param text   <#text description#>
 *  @param action <#action description#>
 *  @param back   <#back description#>
 */
-(void)netLoadFailWithText:(NSString*)text view:(UIView*)view isBack:(BOOL)back;
@end
