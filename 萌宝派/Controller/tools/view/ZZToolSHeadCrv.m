//
//  ZZToolSHeadCrv.m
//  萌宝派
//
//  Created by zhizhen on 15/4/15.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZToolSHeadCrv.h"

@implementation ZZToolSHeadCrv
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel  alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = ZZTitleFont;
        _titleLabel.textColor = ZZLightGrayColor;
    }
    return _titleLabel;
}
-(UILabel *)lineLabel{
    if (_lineLabel == nil) {
        _lineLabel = [[UILabel  alloc]init];
        _lineLabel.backgroundColor = ZZGrayWhiteColor;
    }
    return _lineLabel;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super  initWithFrame:frame];
    if (self) {
        [self  addSubview:self.titleLabel];
//        [self  addSubview:self.lineLabel];
    }
    return self;
}
-(void)layoutSubviews{
    [super  layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height-23, self.frame.size.width, 18);
//    self.lineLabel.frame = CGRectMake(0, 0, self.frame.size.width, 1);
   // self.titleLabel .frame =CGRectMake(100, self.frame.size.height-18, 80, 18);
}
@end
