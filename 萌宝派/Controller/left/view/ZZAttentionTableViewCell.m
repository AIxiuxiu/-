//
//  ZZAttentionTableViewCell.m
//  萌宝派
//
//  Created by zhizhen on 15/4/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZAttentionTableViewCell.h"
#import "ZZHeadImageView.h"
#import "ZZIconView.h"
#import "ZZUser.h"
@interface ZZAttentionTableViewCell ()
@property (nonatomic, strong)ZZHeadImageView *headImageView;
@property (nonatomic, strong)ZZIconView *iconView;
@end
@implementation ZZAttentionTableViewCell
#pragma mark lazy  load
-(ZZHeadImageView *)headImageView{
    if (_headImageView == nil) {
        _headImageView = [[ZZHeadImageView  alloc]init];
    }
    return _headImageView;
}
-(ZZIconView *)iconView{
    if (_iconView == nil) {
        _iconView = [[ZZIconView  alloc]init];
    }
    return _iconView;
}
-(UIImageView *)bigLv{
    if (!_bigLv) {
        _bigLv = [[UIImageView alloc]initWithFrame:CGRectMake(85,  42, 18, 18)];
    }
    return _bigLv;
}

-(UIImageView *)middleLv{
    if (!_middleLv) {
        _middleLv = [[UIImageView alloc]initWithFrame:CGRectMake(105, 46, 10, 10)];
    }
    return _middleLv;
}
-(UIImageView *)smallLv{
    if (!_smallLv) {
        _smallLv = [[UIImageView  alloc]init];
    }
    return _smallLv;
}
-(UIImageView*)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 60, 60)];
        _headImage.layer.cornerRadius = 5;
        _headImage.layer.masksToBounds = YES;
        _headImage.clipsToBounds = YES;
        _headImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImage;
}

-(UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 20, 200, 20)];
        _nickLabel.font = ZZTitleFont;
        _nickLabel.textColor = ZZLightGrayColor;
    }
    return _nickLabel;
}

-(UILabel *)permissLabel{
    if (!_permissLabel) {
        _permissLabel = [[UILabel  alloc]initWithFrame:CGRectMake(120, 42, 70, 20)];
        _permissLabel.font = ZZContentFont;
        _permissLabel.textColor = ZZGoldYellowColor;
    }
    return _permissLabel;
}



-(UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(290, 25, 30, 30)];
        _iconImage.image  = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"arrow_black_40x40.png" ofType:nil]];
    }
    return _iconImage;
}
static NSString *cellIden = @"ZZAttentionTableViewCell";
+ (ZZAttentionTableViewCell *)dequeueReusableCellWithTableView:(UITableView *)tableView{
    ZZAttentionTableViewCell*    cell = [tableView  dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[ZZAttentionTableViewCell  alloc  ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        cell.contentView.backgroundColor = [UIColor  whiteColor];
    }
    return cell;
}
#pragma mark life cycle
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
       
    
        self.lineLabel = [[UILabel alloc]init];
        self.lineLabel.backgroundColor = ZZViewBackColor;
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nickLabel];
        [self.contentView addSubview:self.permissLabel];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.lineLabel];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      
    }
    return self;
    
}

-(void)setUser:(ZZUser *)user{
    _user = user;
    self.headImageView.user = user;
    self.iconView.user = user;
    self.nickLabel.text = user.nick;
    self.permissLabel.text = [user  getUserIdentify];
}

-(void)layoutSubviews{
    [super  layoutSubviews];
    CGFloat width = self.width;
    CGFloat height = self.height;
    // 头像
    CGFloat  headMargin = 10;
    CGFloat  headW = height - 2* headMargin;
    self.headImageView.frame = CGRectMake(headMargin, headMargin, headW, headW);
    
    //昵称
    CGFloat nickX = CGRectGetMaxX(self.headImageView.frame) + headMargin;
    CGFloat nickY = 2 *headMargin ;
    self.nickLabel.frame = CGRectMake(nickX, nickY, 150, 20);
    //icon
    CGFloat iconY = CGRectGetMaxY(self.nickLabel.frame) + headMargin;
    self.iconView.frame = CGRectMake(nickX, iconY-5, 44, 22);
    //权限
    CGFloat permiX = CGRectGetMaxX(self.iconView.frame)+headMargin;
    self.permissLabel.frame = CGRectMake(permiX, iconY, width -permiX -50, 20);
    //line
    self.lineLabel.frame = CGRectMake(5, height-1, width - 10, 1);
}
@end
