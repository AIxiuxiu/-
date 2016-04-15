//
//  ZZLabelHeightTool.m
//  萌宝派
//
//  Created by zhizhen on 15/9/6.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZLabelHeightTool.h"
static UILabel *cumLabel ;
@implementation ZZLabelHeightTool
singleton_implementation(ZZLabelHeightTool);
- (CGSize )sizeWithAttStr:(NSAttributedString *)attStr limitSize:(CGSize )size{
    if (cumLabel == nil) {
        cumLabel = [[UILabel  alloc]init];
        cumLabel.numberOfLines = 0;
    }
    cumLabel.attributedText = attStr;
    return [cumLabel  sizeThatFits:size];
}
@end
