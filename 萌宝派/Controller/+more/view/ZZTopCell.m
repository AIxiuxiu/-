//
//  ZZTopCell.m
//  竖版改版
//
//  Created by charles on 15/3/5.
//  Copyright (c) 2015年 Charles_Wl. All rights reserved.
//

#import "ZZTopCell.h"

@implementation ZZTopCell

-(UIView *)topBackGround{
    if (!_topBackGround) {
        _topBackGround = [[UIView alloc]initWithFrame:CGRectMake1(5, 5,AutoSizex-10, 40)];
        _topBackGround.backgroundColor = [UIColor whiteColor];
        _topBackGround.layer.cornerRadius = _topBackGround.frame.size.height/2;
        _topBackGround.layer.borderWidth =1;
        _topBackGround.layer.borderColor =[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
    }
    return _topBackGround;
}

-(UILabel *)stickImage{
    if (!_stickImage) {
        _stickImage = [[UILabel alloc]initWithFrame:CGRectMake1(10, 10, 20*AutoSizeScaley/AutoSizeScalex, 20)];
        _stickImage.layer.cornerRadius = _stickImage.frame.size.height/2;
        _stickImage.clipsToBounds = YES;
        _stickImage.backgroundColor = [UIColor redColor];
        _stickImage.alpha = 0.7;
        _stickImage.text = @"顶";
        _stickImage.textColor = [UIColor whiteColor];
        _stickImage.textAlignment = NSTextAlignmentCenter;
        _stickImage.font = [UIFont boldSystemFontOfSize:14*AutoSizeScaley];
    }
    return _stickImage;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake1(40, 10, 260, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15*AutoSizeScaley];
        _titleLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:1];
    }
    return _titleLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.topBackGround];
        [self.topBackGround addSubview:self.stickImage];
        [self.topBackGround addSubview:self.titleLabel];
        
    }
    return self;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
