//
//  UILabel+ZLLUsual.h
//  萌宝派
//
//  Created by zhizhen on 15/6/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZLLUsual)
/**
 *  计算自定义行高时的label的size
 *
 *  @param text      显示的文字内容
 *  @param maxW      最大宽度
 *  @param lineSpace 行间距
 *
 *  @return 对应的labelSize
 */
- (CGSize)setAttributedText:(NSString*)text  maxW:(CGFloat)maxW  lineSpace:(CGFloat)lineSpace;


@end
