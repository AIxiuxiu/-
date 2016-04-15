//
//  ZZSIzeFitButton.h
//  TalentService
//
//  Created by zhizhen on 15/7/29.
//  Copyright (c) 2015年 zhizhen. All rights reserved.
// button的宽度根据问题和图片自适应，图片大小适当

typedef enum : NSUInteger {
    ZZSIzeFitButtonTypeImageLeft,
    ZZSIzeFitButtonTypeTitleLeft

} ZZSIzeFitButtonType;
#import <UIKit/UIKit.h>

@interface ZZSIzeFitButton : UIButton

/**
 *  设置button是 图片在左边还是文字在左边
 */
@property (nonatomic) ZZSIzeFitButtonType sizeFitButtonType;

/**
 *  图片与文字中间的间距,在设置标题前设置
 */
@property (nonatomic) CGFloat  margin;

- (void)title:(NSString *)title;

@end
