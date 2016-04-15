//
//  ZZSecurityButton.h
//  TalentService
//
//  Created by zhizhen on 15/7/29.
//  Copyright (c) 2015年 zhizhen. All rights reserved.
// 验证码按钮

#import <UIKit/UIKit.h>

@interface ZZSecurityButton : UIButton



/**
 *  验证完成后调用该方法，保证该对象销毁
 */
- (void) clearButton;

/**
 *  停止及时
 */
- (void) stop;

- (void) startWithSecond:(NSUInteger)second;
@end
