//
//  ZZDairyCollectionViewCell.m
//  萌宝派
//
//  Created by charles on 15/4/1.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZDairyCollectionViewCell.h"

@implementation ZZDairyCollectionViewCell
-(UIImageView *)smallImage{
    if (!_smallImage) {
        _smallImage = [[UIImageView alloc]init];
        _smallImage.contentMode = UIViewContentModeScaleAspectFill;
        _smallImage.clipsToBounds = YES;
    }
    return _smallImage;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super  initWithFrame:frame];
    if (self) {
        [self.contentView  addSubview:self.smallImage];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.smallImage.frame = self.bounds;
}
@end
