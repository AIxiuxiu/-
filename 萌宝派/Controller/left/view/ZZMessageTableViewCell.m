//
//  ZZMessageTableViewCell.m
//  萌宝派
//
//  Created by zhizhen on 15/4/14.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZMessageTableViewCell.h"

@implementation ZZMessageTableViewCell
#pragma mark  lazy load
-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel  alloc]initWithFrame:CGRectMake(10, 0, 0.5, 50)];
        _lineLabel.backgroundColor = [UIColor grayColor];
        _lineLabel.alpha = .3;
    }
    return _lineLabel;
}
-(UILabel *)circleLabel{
    if (!_circleLabel) {
        _circleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(6, 22, 8, 8)];
        _circleLabel.backgroundColor = [UIColor  whiteColor];
        _circleLabel.font = [UIFont  systemFontOfSize:8];
        _circleLabel.textColor = [UIColor  lightGrayColor];
        _circleLabel.text = @"◎";
    }
    return _circleLabel;
}
-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel  alloc]initWithFrame:CGRectMake(20, 5, 200, 20)];
        _dateLabel.font = [UIFont  boldSystemFontOfSize:16];
      
        _dateLabel.textColor = [UIColor  colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
  
    }
    return _dateLabel;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(20, 30, ScreenWidth - 30, 18)];
        _titleLabel.font = [UIFont  systemFontOfSize:16];
        _titleLabel.textColor = [UIColor  grayColor];
    }
    return _titleLabel;
}
-(UILabel *)horizontalLineLabel{
    if (!_horizontalLineLabel) {
        _horizontalLineLabel = [[UILabel  alloc]initWithFrame:CGRectMake(20, 49.5, ScreenWidth-30, 0.5)];
        _horizontalLineLabel.backgroundColor = [UIColor  colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    }
    return _horizontalLineLabel;
}

-(UILabel *)redPointLabel{
    if (!_redPointLabel) {
        _redPointLabel = [[UILabel  alloc]initWithFrame:CGRectMake(ScreenWidth-20, 5, 6, 6)];
        _redPointLabel.layer.cornerRadius = 3;
        _redPointLabel.layer.masksToBounds = YES;
        _redPointLabel.backgroundColor = [UIColor redColor];
        
    }
    return _redPointLabel;
}

#pragma mark life cycle
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.lineLabel];
        [self.contentView  addSubview:self.circleLabel];
        [self.contentView  addSubview:self.dateLabel];
        [self.contentView  addSubview:self.titleLabel];
        [self.contentView   addSubview:self.horizontalLineLabel];
       [self.contentView  addSubview:self.redPointLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super  layoutSubviews];
    self.titleLabel.text = self.message.sMessageContent;
    self.dateLabel.text = self.message.sMessageDate;
    if (self.message.sMessageFlag) {
        self.redPointLabel.hidden = NO;
    }else{
        self.redPointLabel.hidden = YES;
    }
}


@end
