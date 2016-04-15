//
//  ZZInputTF.m
//  萌宝派
//
//  Created by charles on 15/8/11.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZInputTF.h"

@implementation ZZInputTF

-(void)awakeFromNib{
    UIView* whiteIV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
    whiteIV.backgroundColor = [UIColor clearColor];
    [self setLeftView:whiteIV];
    self.leftViewMode = UITextFieldViewModeAlways;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
