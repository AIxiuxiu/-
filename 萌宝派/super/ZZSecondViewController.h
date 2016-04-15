//
//  ZZSecondViewController.h
//  萌宝派
//
//  Created by charles on 15/3/12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBaseViewController.h"
@interface ZZSecondViewController : ZZBaseViewController



//去除字符串前后得空格回车
-(NSString*)removeWhitespaceAndNewlineCharacterWithOrignString:(NSString*)string;
//摇动视图
- (void)shakeAnimationForView:(UIView *) view;
@end
