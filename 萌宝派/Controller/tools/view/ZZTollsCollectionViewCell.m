//
//  ZZTollsCollectionViewCell.m
//  萌宝派
//
//  Created by zhizhen on 15/4/15.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZTollsCollectionViewCell.h"

@implementation ZZTollsCollectionViewCell
-(UIImageView *)iconIV{
    if (!_iconIV) {
      
        _iconIV = [[UIImageView  alloc]initWithFrame:CGRectMake(25, 12, 40, 40)];
    }
    return _iconIV;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0,52, CGRectGetWidth(self.backView.frame), 20)];
        _nameLabel.font = ZZTitleBoldFont;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView  alloc]initWithFrame:CGRectMake(0,0, 90, 90)];
        _backView.layer.cornerRadius = 45;
        _backView.layer.masksToBounds=YES;
        _backView.layer.borderColor = [UIColor  whiteColor].CGColor;
        _backView.layer.borderWidth =2;
    }
    return _backView;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super  initWithFrame:frame];
    if (self) {
        
        [self.backView  addSubview:self.iconIV];
        [self.backView addSubview:self.nameLabel];
        [self.contentView  addSubview:self.backView];
    }
    return self;
}
-(void)layoutSubviews{
    [super   layoutSubviews];
    NSString*  imageName;
    NSString*  str ;
    UIColor*  textColor;
    UIColor *  backColor ;
    switch (self.indexpath.section) {
        case 0:
            switch (self.indexpath.row) {
                case 0:
                   imageName = @"treasure_button_01_40x40.png";
                    str= @"急诊室";
                    backColor =[[UIColor alloc]initWithRed:0.97 green:0.71 blue:0.32 alpha:1];
                    textColor = [UIColor  redColor];
                    break;
                case 1:
                    imageName = @"treasure_button_05_40x40.png";
                    str= @"导航帮助";
                    backColor =[[UIColor alloc]initWithRed:1 green:0.66 blue:0.81 alpha:1];
                    textColor = [UIColor  whiteColor];
                    break;
                default:
                    break;
            }
            break;
//        case 1:
//            imageName = @"treasure_button_03_40x40.png";
//            str= @"成长记录";
//            backColor =[[UIColor alloc]initWithRed:0.55 green:0.59 blue:0.80 alpha:1];
//            textColor = [UIColor  whiteColor];
//            break;
        case 1:
            switch (self.indexpath.row) {
                case 0:
                    imageName = @"treasure_button_02_40x40.png";
                    str= @"育儿建议";
                    backColor =[[UIColor alloc]initWithRed:0.49 green:0.81 blue:0.96 alpha:1];
                    textColor = [UIColor  whiteColor];
                    break;
                case 1:
                    imageName = @"treasure_button_04_40x40.png";
                    str= @"疫苗接种";
                    backColor = [[UIColor alloc]initWithRed:0.50 green:0.76 blue:0.41 alpha:1];
                    textColor = [UIColor  whiteColor];
                    break;
                default:
                    break;
            }
            break;
    }
    self.backView.backgroundColor  =backColor;
    self.iconIV.image =[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imageName ofType:nil]];
    self.nameLabel.text = str;
    self.nameLabel.textColor = textColor;
    
    self.backView.center = CGPointMake(self.width/2, self.height/2);
 
   // self.backView.frame = CGRectMake(30, 5+self.frame.size.height/2-47.5, 80, 80);
}
@end
