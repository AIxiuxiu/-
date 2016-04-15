//
//  ZZBadgeView.m
//  萌宝派
//
//  Created by zhizhen on 15/8/7.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZBadgeView.h"

@implementation ZZBadgeView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = ZZTimeFont;
        [self setBackgroundImage:[UIImage resizedImage:@"main_badge"] forState:UIControlStateNormal];
        // 按钮的高度就是背景图片的高度
        self.height = self.currentBackgroundImage.size.height;
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = [badgeValue copy];
    
    // 设置文字
    [self setTitle:badgeValue forState:UIControlStateNormal];
    
    // 根据文字计算自己的尺寸
    [self sizeToFit];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
