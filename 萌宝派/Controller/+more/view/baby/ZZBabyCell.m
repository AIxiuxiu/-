//
//  ZZBabyCell.m
//  萌宝派
//
//  Created by zhizhen on 15-3-12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZBabyCell.h"
#import "UIImageView+WebCache.h"
#import "ZZMyAlertView.h"
@interface ZZBabyCell ()<ZZMyAlertViewDelgate>
@property(nonatomic,strong)UILabel*  birthdayLabel;   //生日
@property(nonatomic,strong)UILabel*  sexLabel;//性别
@property(nonatomic,strong)UILabel*  diaryLabel;//成长日记
@property(nonatomic,strong)UILabel*  peersLabel;//同龄伙伴
@property(nonatomic,strong)UILabel*  articleLabel;//篇
@property(nonatomic,strong)UILabel*  nameLabel;//名
@property(nonatomic,strong)UIImageView*  babyInfoIconIV;//生日后面 向后按钮
@property(nonatomic,strong)UIImageView*  diaryIconIV;//成长日记后面 向后按钮
@property(nonatomic,strong)UIImageView*  peersIconIV;//同龄伙伴  向后按钮
@property(nonatomic,strong)UILabel*  firstLineLabel;//第一条线
@property(nonatomic,strong)UILabel*  secondLineLabel;//第二条线



@end
@implementation ZZBabyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor   clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self  initInterface];
    }
    return self;
}

-(UIImageView *)babyHeadImageView{
    if (!_babyHeadImageView) {
        _babyHeadImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(25, 22, 55, 55)];
        _babyHeadImageView.layer.cornerRadius = 5;
        _babyHeadImageView.layer.masksToBounds = YES;
        _babyHeadImageView.clipsToBounds = YES;
        _babyHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _babyHeadImageView;
}
-(UILabel *)babyNickLabel{
    if (!_babyNickLabel) {
        _babyNickLabel =[[ UILabel  alloc]initWithFrame:CGRectMake(95, 15, 180, 20)];
        _babyNickLabel.textColor= ZZDarkGrayColor;
        _babyNickLabel.font = ZZTitleBoldFont;
        
        
    }
    return _babyNickLabel;
}

-(UILabel *)birthdayLabel{
    if (!_birthdayLabel) {
        _birthdayLabel =[[UILabel  alloc]initWithFrame:CGRectMake(95, 40, 40, 20)];
        _birthdayLabel.font = ZZTitleBoldFont;
        _birthdayLabel.text = @"生日";
        _birthdayLabel.textColor = ZZDarkGrayColor;
    }
    return _birthdayLabel;
}

-(UILabel *)babyBirthdayLabel{
    if (!_babyBirthdayLabel) {
        _babyBirthdayLabel = [[UILabel  alloc]initWithFrame:CGRectMake(138, 40, 120, 20)];
        _babyBirthdayLabel.font = ZZContentFont;
        _babyBirthdayLabel.textColor= ZZLightGrayColor;
        
    }
    return _babyBirthdayLabel;
}
-(UILabel *)sexLabel{
    if (!_sexLabel) {
        _sexLabel = [[UILabel  alloc]initWithFrame:CGRectMake(95, 65, 40, 20)];
        _sexLabel.font = ZZTitleBoldFont;
        _sexLabel.textColor = ZZDarkGrayColor;
        _sexLabel.text = @"性别";
    }
    return _sexLabel;
}
-(UILabel *)babySexLabel{
    if (!_babySexLabel) {
        _babySexLabel = [[UILabel  alloc]initWithFrame:CGRectMake(138, 65, 120, 20)];
        _babySexLabel.font = ZZContentFont;
        _babySexLabel.textColor= ZZLightGrayColor;
        
    }
    return _babySexLabel;
}
-(UILabel *)firstLineLabel{
    if (!_firstLineLabel) {

        _firstLineLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 95, ScreenWidth, 1)];
        _firstLineLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
//=======
//        _firstLineLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 95.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
//        _firstLineLabel.backgroundColor = [UIColor   colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
//>>>>>>> .r1173
    }
    return _firstLineLabel;
}
-(UILabel *)diaryLabel{
    if (!_diaryLabel) {
        _diaryLabel = [[UILabel  alloc]initWithFrame:CGRectMake(25, 110, 60, 20)];
        _diaryLabel.text = @"成长日记";
        _diaryLabel.textColor = ZZLightGrayColor;
        _diaryLabel.font = ZZContentFont;
    }
    return _diaryLabel;
}
-(UILabel *)babyDiaryCountLabel{
    if (!_babyDiaryCountLabel) {
        _babyDiaryCountLabel = [[UILabel  alloc]initWithFrame:CGRectMake(95, 110, 40, 20)];
        _babyDiaryCountLabel.textColor = [UIColor  colorWithRed:0.57 green:0.85 blue:0.37 alpha:1];
        _babyDiaryCountLabel.font = ZZContentFont;
     
    }
    return _babyDiaryCountLabel;
}
-(UILabel *)articleLabel{
    if (!_articleLabel) {
        _articleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(140, 110, 20, 20)];
        _articleLabel.text = @"篇";
        _articleLabel.textColor = ZZLightGrayColor;
        _articleLabel.font = ZZContentFont;
    }
    return _articleLabel;
}
-(UILabel *)secondLineLabel{
    if (!_secondLineLabel) {

        _secondLineLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 145, ScreenWidth, 1)];
        _secondLineLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
//=======
//        _secondLineLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 145.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
//        _secondLineLabel.backgroundColor = [UIColor  colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
//>>>>>>> .r1173
    }
    return _secondLineLabel;
}

-(UILabel *)babyPeersCountLabel{
    if (!_babyPeersCountLabel) {
        _babyPeersCountLabel = [[UILabel  alloc]initWithFrame:CGRectMake(95, 160, 40, 20)];
        _babyPeersCountLabel.textColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1];
        _babyPeersCountLabel.font = ZZContentFont;
      
    }
    return _babyPeersCountLabel;
}
-(UILabel *)peersLabel{
    if (!_peersLabel) {
        _peersLabel = [[UILabel  alloc]initWithFrame:CGRectMake(25, 160, 60, 20)];
        _peersLabel.text = @"同龄伙伴";
        _peersLabel.textColor = ZZLightGrayColor;
        _peersLabel.font = ZZContentFont;
    }
    return _peersLabel;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel  alloc]initWithFrame:CGRectMake(140, 160, 20, 20)];
        _nameLabel.text = @"名";
        _nameLabel.textColor = ZZLightGrayColor;
        _nameLabel.font = ZZContentFont;
    }
    return _nameLabel;
}
-(UIImageView *)babyInfoIconIV{
    if (!_babyInfoIconIV) {
    
        _babyInfoIconIV = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 40, 32.5, 30, 30)];
        _babyInfoIconIV.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"arrow_black_40x40.png" ofType:nil]];
    }
    return _babyInfoIconIV;
}
-(UIImageView *)diaryIconIV{
    if (!_diaryIconIV) {
        _diaryIconIV = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 40, 105, 30, 30)];
        _diaryIconIV.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"arrow_black_40x40.png" ofType:nil]];
    }
    return _diaryIconIV;
}
-(UIImageView *)peersIconIV{
    if (!_peersIconIV) {
        _peersIconIV = [[UIImageView  alloc]initWithFrame:CGRectMake(ScreenWidth - 40, 155, 30, 30)];
        _peersIconIV.image =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"arrow_black_40x40.png" ofType:nil]];
    }
    return _peersIconIV;
}
-(UIView *)babyView{
    if (!_babyView) {
        _babyView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 320, 95)];
        _babyView.tag =111;
        _babyView.alpha = 0.5;
        UITapGestureRecognizer*  tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(jumpToNewController:)];
        [_babyView  addGestureRecognizer:tap];
    }
    return _babyView;
}
-(UIView *)diaryView{
    if (!_diaryView) {
        _diaryView = [[UIView  alloc]initWithFrame:CGRectMake(0, 95.5, 320, 49.5)];
     
        _diaryView.alpha = 0.5;
        _diaryView.tag = 112;
        UITapGestureRecognizer*  tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(jumpToNewController:)];
        [_diaryView  addGestureRecognizer:tap];
    }
    return _diaryView;
}
-(UIView *)peersView{
    if (!_peersView) {
        _peersView = [[UIView  alloc]initWithFrame:CGRectMake(0, 145.5, 320, 49.5)];
        _peersView.alpha = 0.5;
        _peersView.tag = 113;
        UITapGestureRecognizer*  tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(jumpToNewController:)];
        [_peersView  addGestureRecognizer:tap];
    }
    return _peersView;
}
-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [[UIButton  alloc]initWithFrame:CGRectMake(ScreenWidth - 40, 13, 30, 30)];
        _deleteButton.layer.cornerRadius = 5;
        _deleteButton.layer.masksToBounds = YES;
        [_deleteButton  setBackgroundImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"delete_40x40.png" ofType:nil] ] forState:UIControlStateNormal];
        [_deleteButton  addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
static NSString *cellIden = @"ZZBabyCell";
+ (ZZBabyCell *)dequeueReusableCellWithTableView:(UITableView *)tableView{
    ZZBabyCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[ZZBabyCell  alloc  ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    return cell;
}
-(void)initInterface{
    UIView*  whiteBakcView = [[UIView  alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 195)];
    whiteBakcView.backgroundColor = [UIColor  whiteColor];
    whiteBakcView.layer.masksToBounds = YES;
    whiteBakcView.layer.borderWidth = 0.5;
    whiteBakcView.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]CGColor];
    [self.contentView  addSubview:whiteBakcView];
    [whiteBakcView  addSubview:self.babyHeadImageView];
    [whiteBakcView  addSubview:self.babyNickLabel];
    [whiteBakcView  addSubview:self.babyBirthdayLabel];
    [whiteBakcView  addSubview:self.babySexLabel];
    [whiteBakcView  addSubview:self.birthdayLabel];
    [whiteBakcView  addSubview:self.sexLabel];
    [whiteBakcView  addSubview:self.firstLineLabel];
    [whiteBakcView  addSubview:self.babyDiaryCountLabel];
    [whiteBakcView  addSubview:self.diaryLabel];
    [whiteBakcView  addSubview:self.articleLabel];
    [whiteBakcView  addSubview:self.secondLineLabel];
    [whiteBakcView  addSubview:self.babyPeersCountLabel];
    [whiteBakcView  addSubview:self.peersLabel];
    [whiteBakcView  addSubview:self.peersIconIV];
    [whiteBakcView  addSubview:self.nameLabel];
    [whiteBakcView  addSubview:self.diaryIconIV];
    [whiteBakcView  addSubview:self.babyInfoIconIV];
    [whiteBakcView  addSubview:self.babyView];
    [whiteBakcView  addSubview:self.diaryView];
    [whiteBakcView  addSubview:self.peersView];
    [self.contentView  addSubview:self.deleteButton];
}

-(void)layoutSubviews{
    [super  layoutSubviews];
    [self.babyHeadImageView  sd_setImageWithURL:[NSURL URLWithString:self.babyInfo.imageInfo.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"head_portrait_55x55.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
    self.babyNickLabel.text = self.babyInfo.nick;
    self.babyBirthdayLabel.text = self.babyInfo.birthday;
    if (self.babyInfo.sex%2 == 1) {
        self.babySexLabel.text = @"男";
    }else{
        self.babySexLabel.text = @"女";
    }
    self.babyDiaryCountLabel.text = [NSString stringWithFormat:@"%ld",self.babyInfo.growingCount];
    self.babyPeersCountLabel.text = [NSString stringWithFormat:@"%ld",self.babyInfo.ageCount];
    CGSize describeLabelTextSize =  [self.babyDiaryCountLabel.text  sizeWithAttributes:@{NSFontAttributeName:self.babyDiaryCountLabel.font}];
    self.babyDiaryCountLabel.frame = CGRectMake(90, 110, describeLabelTextSize.width, 20);
    
    self.articleLabel.frame =CGRectMake(CGRectGetMaxX(self.babyDiaryCountLabel.frame)+5, 110, 30, 20);
    
    CGSize nameLabelTextSize =  [self.babyPeersCountLabel.text  sizeWithAttributes:@{NSFontAttributeName:self.babyPeersCountLabel.font}];
    self.babyPeersCountLabel.frame = CGRectMake(90, 160, nameLabelTextSize.width, 20);
    
    self.nameLabel.frame =CGRectMake(CGRectGetMaxX(self.babyPeersCountLabel.frame)+5, 160, 30, 20);
}

//手势响应事件
-(void)jumpToNewController:(UITapGestureRecognizer*)tap{
    
//  NSIndexPath*  indexPath=  [self.delegate.babyTableView indexPathForCell:self];
   NSInteger type =tap.view.tag;
//    [self.delegate babyInfoJumpToNewControllerWithType:type andRow:indexPath];
//    
    if ([self.delegate  respondsToSelector:@selector(babyCellSectionClicked:type:)]) {
        [self.delegate  babyCellSectionClicked:self type:type];
    }
}

- (void)deleteButtonAction{
    if ([self.delegate  respondsToSelector:@selector(babyCellDeleteButtonClicked:)]) {
        
        ZZMyAlertView*  alertView = [[ZZMyAlertView  alloc]initWithMessage:@"你确定要删除这个宝宝" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
        alertView.tag = 113;
        [alertView  show];
      
    }
}
#pragma mark -ZZMyAlertViewDelgate
-(void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self.delegate  babyCellDeleteButtonClicked:self];
    }
}
@end
