//
//  ZZExpertIntroduceCell.m
//  萌宝派
//
//  Created by charles on 15/4/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZExpertIntroduceCell.h"

@implementation ZZExpertIntroduceCell
#pragma mark  lazy load
-(UILabel *)adeptLabel{
    if (!_adeptLabel) {
        _adeptLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 100, 20)];
        _adeptLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:1];
        _adeptLabel.font = [UIFont systemFontOfSize:14];
        _adeptLabel.text = @"专长";
    }
    return _adeptLabel;
}
-(UILabel *)adeptContentLabel{
    if (!_adeptContentLabel) {
        _adeptContentLabel = [[UILabel alloc]init];
        _adeptContentLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        _adeptContentLabel.font = [UIFont systemFontOfSize:14];
        [_adeptContentLabel setNumberOfLines:0];
    }
    return _adeptContentLabel;
}
-(UILabel *)experienceLabel{
    if (!_experienceLabel) {
        _experienceLabel = [[UILabel alloc]init];
        _experienceLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:1];
        _experienceLabel.font = [UIFont systemFontOfSize:14];
        _experienceLabel.text = @"经验";
    }
    return _experienceLabel;
}
-(UILabel *)experienceContentLabel{
    if (!_experienceContentLabel) {
        _experienceContentLabel = [[UILabel alloc]init];
        _experienceContentLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        _experienceContentLabel.font = [UIFont systemFontOfSize:14];
        [_experienceContentLabel setNumberOfLines:0];
    }
    return _experienceContentLabel;
}
-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    }
    return _lineLabel;
}


#pragma mark  life  cycle
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor   clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.adeptLabel];
        [self.contentView addSubview:self.adeptContentLabel];
        [self.contentView addSubview:self.experienceLabel];
        [self.contentView addSubview:self.experienceContentLabel];
        [self.contentView addSubview:self.lineLabel];
    }
    return self;
}
-(void)layoutSubviews{
    [super  layoutSubviews];
    self.adeptContentLabel.text = self.expertUser.skill;
    CGSize size = CGSizeMake(ScreenWidth-20, 2000);
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:self.adeptContentLabel.font,NSFontAttributeName, nil];
    CGSize labelSize = [self.adeptContentLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.adeptContentLabel.frame = CGRectMake(10, 30, labelSize.width, labelSize.height);
    
    self.lineLabel.frame = CGRectMake(0, labelSize.height+35, 320, .5);
    
    self.experienceLabel.frame = CGRectMake(10, labelSize.height+35+8, 120, 20);
    
    self.experienceContentLabel.text = [NSString stringWithFormat:@"%@",self.expertUser.introduction];
    CGSize size1 = CGSizeMake(ScreenWidth-20, 2000);
    NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:self.experienceContentLabel.font,NSFontAttributeName, nil];
    CGSize labelSize1 = [self.experienceContentLabel.text boundingRectWithSize:size1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
    
    self.experienceContentLabel.frame = CGRectMake(10, labelSize.height+35+30, labelSize1.width, labelSize1.height);
    self.cellHeight = labelSize.height+35+40+labelSize1.height;
   

}

@end
