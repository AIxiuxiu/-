//
//  ZZAdviceTableViewCell.m
//  萌宝派
//
//  Created by zhizhen on 15-3-22.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZAdviceTableViewCell.h"

@implementation ZZAdviceTableViewCell
-(UILabel *)contentLabel{
    
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel  alloc]init];
        
        _contentLabel.backgroundColor = [UIColor  clearColor];
        
        _contentLabel.numberOfLines = 0;
        
        _contentLabel.textColor = ZZLightGrayColor;
        
        _contentLabel.font =ZZContentFont;
    }
    return _contentLabel;
}

-(UILabel *)titleLable{
    
    if (!_titleLable) {
        _titleLable = [[UILabel  alloc]initWithFrame:CGRectMake(20, 10, 160, 20)];
        _titleLable.textColor = [UIColor  whiteColor];
        
        _titleLable.font = ZZTitleFont;
    }
    
    return _titleLable;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor  clearColor];

        [self.contentView  addSubview:self.titleLable];
        [self.contentView  addSubview:self.contentLabel];
    }
    return self;
}


-(void)layoutSubviews{
    [super  layoutSubviews];
    
    CGRect rect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth - 60, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :self.contentLabel.font} context:nil];
    self.contentLabel.frame = CGRectMake(20, 30, ScreenWidth -60, rect.size.height+10);
}

@end
