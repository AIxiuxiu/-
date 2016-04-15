//
//  ZZLastCell.m
//  萌宝派
//
//  Created by apple on 15/3/13.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZLastCell.h"

@implementation ZZLastCell

-(UIView *)bkView{
    if (!_bkView) {
        _bkView = [[UIView alloc]init];
        _bkView.backgroundColor = [UIColor whiteColor];
        
        UILabel* line1 = [[UILabel alloc]init];
        line1.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        
        UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 35.5, 320, 0.5)];
        line2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        
        [_bkView addSubview:line1];
        [_bkView addSubview:line2];
    }
    return _bkView;
}

-(UIView *)upLineView{
    if (!_upLineView) {
        _upLineView = [[UILabel alloc]init];
        _upLineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    }
    return _upLineView;
}

-(UIView *)downLineView{
    if (!_downLineView) {
        _downLineView = [[UILabel alloc]init];
        _downLineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    }
    return _downLineView;
}
-(UILabel *)lastLabel{
    if (!_lastLabel) {
        _lastLabel = [[UILabel alloc]init];
        _lastLabel.text = @"已到最后";
        _lastLabel.font = [UIFont systemFontOfSize:14];
        _lastLabel.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1];
        _lastLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _lastLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView  addSubview:self.upLineView];
        [self.contentView  addSubview:self.downLineView];
        [self.contentView addSubview:self.lastLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [super  layoutSubviews];
    CGSize size = self.bounds.size;
    self.upLineView.frame = CGRectMake(0, 0, size.width, 0.5);
    self.downLineView.frame = CGRectMake(0, size.height - 0.5, size.width, 0.5);
    self.lastLabel.frame = self.bounds;
}

@end
