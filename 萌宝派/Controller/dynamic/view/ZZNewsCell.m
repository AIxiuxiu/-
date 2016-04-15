//
//  ZZNewsCell.m
//  萌宝派
//
//  Created by charles on 15/3/12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZNewsCell.h"
#import "UIImageView+WebCache.h"
#import "ZZMessage.h"
#import "ZZHeadImageView.h"
#import "ZZIconView.h"
#import "ZZSIzeFitButton.h"
@interface ZZNewsCell ()
@property(nonatomic,strong)ZZHeadImageView* headImage;
@property(nonatomic,strong)UILabel* nickLabel;

@property(nonatomic,strong)ZZSIzeFitButton *timeButton;

@property(nonatomic,strong)UILabel* lineLabel;
@property(nonatomic,strong)UILabel* contentLabel;
@property(nonatomic,strong)UILabel* answerLabel;
@property(nonatomic,strong)UILabel* bkLabel;
@property(nonatomic,strong)UILabel* userType;
@end
@implementation ZZNewsCell
-(UILabel *)userType{
    if (!_userType) {
        _userType = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.nickLabel.frame), CGRectGetMaxY(self.nickLabel.frame)+2, 80, 14)];
        _userType.font = ZZTimeFont;
        _userType.layer.cornerRadius = 3;
        _userType.layer.masksToBounds = YES;
        _userType.clipsToBounds = YES;
        _userType.textColor =ZZGoldYellowColor;
    }
    return _userType;
}
-(ZZHeadImageView *)headImage{
    if (!_headImage) {
        _headImage = [[ZZHeadImageView alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
    }
    return _headImage;
}
-(UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImage.frame)+10, CGRectGetMinY(self.headImage.frame), 180, 16)];
        _nickLabel.font = ZZContentFont;
        _nickLabel.textColor = ZZLightGrayColor;
    }
    return _nickLabel;
}
-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 115, ScreenWidth, 5)];
        _lineLabel.backgroundColor = ZZViewBackColor;
    }
    return _lineLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        CGFloat y = CGRectGetMaxY(self.answerLabel.frame) +3;
        CGFloat x = CGRectGetMinX(self.timeButton.frame);
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, ScreenWidth -2 *x, 20)];
        _contentLabel.font = ZZTitleFont;
        _contentLabel.textColor = ZZDarkGrayColor;

    }
    return _contentLabel;
}

-(ZZSIzeFitButton *)timeButton{
    if (_timeButton == nil) {
            ZZSIzeFitButton *button = [[ZZSIzeFitButton alloc]initWithFrame:CGRectMake(5, 5, 0, 0)];
            button.titleLabel.font = ZZTimeFont;
            button.margin = 5;
            button.alpha = 0.7;
        button.userInteractionEnabled = NO;
            [button  setTitleColor:ZZLightGrayColor forState:UIControlStateNormal];
            [button  setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"clock_14x14.png" ofType:nil]] forState:UIControlStateNormal];
        _timeButton = button;
      
    }
    return _timeButton;
}
-(UILabel *)answerLabel{
    if (!_answerLabel) {
        _answerLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(self.timeButton.frame)+2, CGRectGetWidth(self.bkLabel.frame)- 50, 16)];
        _answerLabel.textColor = ZZLightGrayColor;
        _answerLabel.font = ZZContentFont;
        
        
    }
    return _answerLabel;
}

-(UILabel *)bkLabel{
    if (!_bkLabel) {
        CGFloat x = CGRectGetMinX(self.headImage.frame);
        _bkLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(self.headImage.frame)+5, ScreenWidth -2 *x, 65)];
        _bkLabel.backgroundColor = ZZViewBackColor;
        _bkLabel.layer.cornerRadius = 5;
        _bkLabel.layer.masksToBounds = YES;
//        _bkLabel.layer.borderWidth = 0.5;
//        _bkLabel.layer.borderColor = ZZViewBackColor.CGColor;
    }
    return _bkLabel;
}
static NSString *cellIden = @"ZZNewsCell";
+ (ZZNewsCell *)dequeueReusableCellWithTableView:(UITableView *)tableView{
    ZZNewsCell*    cell = [tableView  dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[ZZNewsCell  alloc  ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.nickLabel];
        [self.bkLabel addSubview:self.timeButton];

        [self.bkLabel addSubview:self.contentLabel];
        [self.contentView addSubview:self.lineLabel];
        [self.bkLabel addSubview:self.answerLabel];
        [self.contentView addSubview:self.bkLabel];
        [self.contentView addSubview:self.userType];
    }
    return self;
    
}


-(void)setMessage:(ZZMessage *)message{
    _message = message;
    ZZUser *user = message.replayInfo.user;
    self.headImage.user = user;

    self.nickLabel.text = user.nick;

    self.userType.text = [user  getUserIdentify];
    [self.timeButton  setTitle:message.replayInfo.replayTime forState:UIControlStateNormal];

    self.contentLabel.text = message.replayInfo.replayContent;
    
    NSString  *str = [NSString stringWithFormat:@"回复我的主题：“%@”",message.postInfo.postTitle];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString  alloc]initWithString:str];
        [attStr  addAttributes:@{NSFontAttributeName:ZZContentFont,NSForegroundColorAttributeName :ZZGreenColor} range:NSMakeRange(0, 2)];
        [attStr  addAttributes:@{NSFontAttributeName:ZZContentFont,NSForegroundColorAttributeName :ZZLightGrayColor} range:NSMakeRange(2, str.length -2)];
    self.answerLabel.attributedText = attStr;
}
@end
