//
//  ZZFunctionCollCell.m
//  萌宝派
//
//  Created by zhizhen on 15/5/18.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZFunctionCollCell.h"

@implementation ZZFunctionCollCell
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel  alloc]initWithFrame:CGRectMake(17, 36, 46, 14)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor  whiteColor];
        _nameLabel.font = ZZTimeFont;
    }
    return _nameLabel;
}

-(UIImageView *)nameIv{
    if (!_nameIv) {
        
        _nameIv = [[UIImageView  alloc]initWithFrame:CGRectMake(27, 10, 26, 26)];
        _nameIv.contentMode = UIViewContentModeScaleAspectFill;
        _nameIv.clipsToBounds = YES;
    }
    return _nameIv;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super  initWithFrame:frame];
    if (self) {
        [self.contentView  addSubview:self.nameIv];
        [self.contentView  addSubview:self.nameLabel];
    }
    return self;
}
@end
