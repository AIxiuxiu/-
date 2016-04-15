//
//  ZZDynamicCell.m
//  萌宝派
//
//  Created by charles on 15/3/11.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZDynamicCell.h"
#import "ZZUser.h"
@interface ZZDynamicCell ()
@property(nonatomic,strong)UIImageView* headImage;
@property(nonatomic,strong)UILabel* nickLabel;
//@property(nonatomic,strong)UILabel* introduceLabel;
//@property(nonatomic,strong)UILabel* numberLabel;
@property(nonatomic,strong)UIImageView* iconImage;
@property(nonatomic,strong)UILabel* lineLabel;
@end
@implementation ZZDynamicCell
-(UIImageView*)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
        _headImage.layer.cornerRadius = 25;
        _headImage.layer.masksToBounds = YES;
        _headImage.clipsToBounds = YES;
        _headImage.contentMode = UIViewContentModeScaleAspectFill;
        _headImage.layer.borderColor = ZZLightGrayColor.CGColor;
        _headImage.layer.borderWidth = 0.5;
    }
    return _headImage;
}

-(UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 22, 200, 16)];
        _nickLabel.font = ZZContentFont;
        _nickLabel.textColor = ZZDarkGrayColor;
    }
    return _nickLabel;
}

-(UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _iconImage.image  = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"arrow_black_40x40.png" ofType:nil]];
    }
    return _iconImage;
}

static NSString *cellIden = @"ZZDynamicCell";
+ (ZZDynamicCell *)dequeueReusableCellWithTableView:(UITableView *)tableView{
    ZZDynamicCell*    cell = [tableView  dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[ZZDynamicCell  alloc  ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,59, ScreenWidth-20, 1)];
        self.lineLabel.backgroundColor = ZZViewBackColor;
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.nickLabel];
  
        self.accessoryView = self.iconImage;
        [self.contentView addSubview:self.lineLabel];
    }
    return self;
    
}
-(void)setUser:(ZZUser *)user{
    _user = user;
    [self.headImage  setImageWithURL:user.mbpImageinfo.smallImagePath placeholderImageName:@"head_portrait_55x55.jpg"];
    
    self.nickLabel.text = user.nick;
}


@end
