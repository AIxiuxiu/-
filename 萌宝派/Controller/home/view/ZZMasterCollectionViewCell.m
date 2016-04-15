//
//  ZZMasterCollectionViewCell.m
//  萌宝派
//
//  Created by zhizhen on 15/4/10.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZMasterCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ZZMasterCollectionViewCell
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView   alloc]initWithFrame:CGRectMake(8.5, 3.5, 40, 40)];
        _headImageView.layer.cornerRadius = 20;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
    
    }
    return _headImageView;
}
-(UIImageView *)masterImageView{
    if (!_masterImageView) {
        //CGFloat  headImageViewWidth=self.headImageView.frame.size.width;
        _masterImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(36.5, 31.5, 12, 12)];
        _masterImageView.contentMode = UIViewContentModeScaleAspectFill;
        _masterImageView.clipsToBounds = YES;
       // _masterImageView.image = [UIImage  imageNamed:@"user_tarento_level_five_10x10.jpg"];
    }
    return _masterImageView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 45, 57, 15)];
        //_nameLabel .backgroundColor = [UIColor  redColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont  systemFontOfSize:10];
        _nameLabel.textColor =[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1];
    }
    return _nameLabel;
}
-(UILabel *)masterTypeLabel{
    if (!_masterTypeLabel) {
        _masterTypeLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 60, 57, 15)];
        //_nameLabel .backgroundColor = [UIColor  redColor];
        
        _masterTypeLabel.font = [UIFont  systemFontOfSize:10];
        _masterTypeLabel.textAlignment= NSTextAlignmentCenter;
        _masterTypeLabel.textColor = [UIColor  redColor];
    }
    return _masterTypeLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super  initWithFrame:frame];
    if (self) {
        [self.contentView  addSubview:self.headImageView];
        [self.contentView  addSubview:self.masterImageView];
        [self.contentView  addSubview:self.nameLabel];
        [self.contentView  addSubview:self.masterTypeLabel];
        self.selectedBackgroundView = [[UIView  alloc]init];
        self.selectedBackgroundView.backgroundColor = [UIColor  grayColor];

    }
    return self;
}
-(void)layoutSubviews{
    [super  layoutSubviews];

      [self.headImageView  sd_setImageWithURL:[NSURL URLWithString:self.masterUser.mbpImageinfo.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"head_portrait_55x55.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
    self.masterImageView.image = [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:[self.masterUser  getClassImagePathWithDaRenLevel:self.masterUser.superStarLv] ofType:nil]] ;
    
    self.nameLabel.text = self.masterUser.nick;
    self.masterTypeLabel.text = [NSString  stringWithFormat:@"%@达人",self.masterUser.superStarName];
}
@end
