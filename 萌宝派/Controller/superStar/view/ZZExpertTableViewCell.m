//
//  ZZExpertTableViewCell.m
//  萌宝派
//
//  Created by charles on 15/4/8.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZExpertTableViewCell.h"

@implementation ZZExpertTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.superStarHeadImageView];
        [self.contentView addSubview:self.superStarNameLabel];
        [self.contentView addSubview:self.attentionButton];
        [self.contentView addSubview:self.lineLabel];
    }
    return self;
    
}
#pragma mark setter andGetter
-(UIImageView *)superStarHeadImageView{
    if (!_superStarHeadImageView) {
        _superStarHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        _superStarHeadImageView.layer.cornerRadius = 15;
        _superStarHeadImageView.layer.masksToBounds = YES;
        _superStarHeadImageView.clipsToBounds = YES;
        _superStarHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _superStarHeadImageView;
}
-(UILabel *)superStarNameLabel{
    if (!_superStarNameLabel) {
        _superStarNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 17.5, 150, 15)];
        _superStarNameLabel.textColor = [UIColor colorWithRed:.34 green:.34 blue:.34 alpha:1];
        _superStarNameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _superStarNameLabel;
}
-(UIButton *)attentionButton{
    if (!_attentionButton) {
        _attentionButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-120, 15, 50, 20)];
        _attentionButton.layer.cornerRadius = 10;
        _attentionButton.layer.masksToBounds = YES;
        _attentionButton.layer.borderWidth = 1;
        _attentionButton.layer.borderColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1].CGColor;
        _attentionButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _attentionButton;
}
-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 49.5, ScreenWidth, 0.5)];
        _lineLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    }
    return _lineLabel;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
