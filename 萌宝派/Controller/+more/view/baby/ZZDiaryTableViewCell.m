//
//  ZZDiaryTableViewCell.m
//  萌宝派
//
//  Created by zhizhen on 15-3-13.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZDiaryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZZMengBaoPaiImageInfo.h"
#import "ZZMyAlertView.h"
@interface   ZZDiaryTableViewCell()<ZZMyAlertViewDelgate>
@property(nonatomic,strong)UILabel*  dateShowLabel;  //日期显示的label

@property(nonatomic,strong)UILabel*  verticalLineLabel;  //竖线label
@property(nonatomic,strong)UIView*   whiteBackView;//图片的白色背景
@property(nonatomic,strong)UIImageView*  firstIV ;//第一张图片
@property(nonatomic,strong)UIImageView*  secondIV;//第二张图片
@property(nonatomic,strong)UIImageView*   thirdIV;//第三张图片
@property(nonatomic,strong)UILabel*  separLabel;//分割线
@property(nonatomic,strong)UILabel* whiteLabel;//白线label
@property(nonatomic)NSInteger imageCount;
@property(nonatomic,strong)UIButton*  deleteButton ;//删除日记
@property (nonatomic, weak)id<ZZDiaryTableViewCellDelegate>delegate;
@end
@implementation ZZDiaryTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView  addSubview:self.verticalLineLabel];
        [self.contentView  addSubview:self.whiteLabel];
        [self.contentView  addSubview:self.dateShowLabel];
        [self.contentView  addSubview:self.whiteBackView];
        [self.contentView  addSubview:self.separLabel ];
        [self.contentView  addSubview:self.deleteButton];
        [self.whiteBackView  addSubview:self.firstIV];
        [self.whiteBackView  addSubview:self.secondIV];
        [self.whiteBackView  addSubview:self.thirdIV];
        self.backgroundColor = [UIColor  clearColor];
        self.contentView.backgroundColor = [UIColor  clearColor];
    }
    return self;
}
-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [[UIButton  alloc]initWithFrame:CGRectMake(ScreenWidth - 37, 10, 30, 30)];
        _deleteButton.layer.cornerRadius = 5;
        _deleteButton.layer.masksToBounds = YES;
         [_deleteButton  setImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"delete_40x40.png" ofType:nil] ] forState:UIControlStateNormal];
        _deleteButton.backgroundColor = ZZGreenColor;
       [_deleteButton  addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

-(UILabel *)dateShowLabel{
    if (!_dateShowLabel) {
        _dateShowLabel = [[UILabel  alloc]initWithFrame:CGRectMake(13, 12.5, 192,  25)];
        _dateShowLabel.backgroundColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1];
        
        //_dateShowLabel.textAlignment = NSTextAlignmentCenter;
        _dateShowLabel.layer.masksToBounds = YES;
        _dateShowLabel.layer.cornerRadius =12.5;
        _dateShowLabel.font = ZZContentFont;
        _dateShowLabel.textColor = [UIColor  whiteColor];
    }
    return _dateShowLabel;
}
-(UIView *)whiteBackView{
    if (!_whiteBackView) {
        _whiteBackView = [[UIView  alloc]initWithFrame:CGRectMake(15, 50, ScreenWidth - 30, 290)];
        _whiteBackView.backgroundColor = [UIColor   whiteColor];
        _whiteBackView.layer.cornerRadius=5;
        _whiteBackView.layer.masksToBounds = YES;
    }
    return _whiteBackView;
}

-(UILabel *)verticalLineLabel{
    if (!_verticalLineLabel) {
        _verticalLineLabel = [[UILabel  alloc]initWithFrame:CGRectMake(30, -2, 2, 355)];
        _verticalLineLabel.backgroundColor = [UIColor  grayColor];
        _verticalLineLabel.alpha = .3;
    }
    return _verticalLineLabel;
}
-(UILabel *)separLabel{
    if (!_separLabel) {
        _separLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 351, ScreenWidth, 0.5)];
        _separLabel.backgroundColor = ZZViewBackColor;
    }
    return _separLabel;
}
-(UILabel *)whiteLabel{
    if (!_whiteLabel) {
        _whiteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 351.5, ScreenWidth, 0.5)];
        _whiteLabel.backgroundColor = [UIColor whiteColor];
    }
    return _whiteLabel;
}
-(UIImageView *)firstIV{
    if (!_firstIV) {
        _firstIV = [[UIImageView alloc]init];
        _firstIV.contentMode = UIViewContentModeScaleAspectFill;
        _firstIV.clipsToBounds = YES;
       
    }
    return _firstIV;
}
-(UIImageView *)secondIV{
    if (!_secondIV) {
        _secondIV = [[UIImageView  alloc]init];
        _secondIV.contentMode = UIViewContentModeScaleAspectFill;
        _secondIV.clipsToBounds = YES;
       
    }
    return _secondIV;
}
-(UIImageView *)thirdIV{
    if (!_thirdIV) {
        _thirdIV = [[UIImageView  alloc]init];
        _thirdIV.contentMode = UIViewContentModeScaleAspectFill;
        _thirdIV.clipsToBounds = YES;
        
    }
    return _thirdIV;
}
static NSString *cellIden = @"ZZDiaryTableViewCell";
+ (ZZDiaryTableViewCell *)dequeueReusableCellWithTableView:(UITableView *)tableView delegate:(id<ZZDiaryTableViewCellDelegate>)delgate{
    ZZDiaryTableViewCell*    cell = [tableView  dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[ZZDiaryTableViewCell  alloc  ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    cell.delegate = delgate;
    return cell;
}

-(void)layoutSubviews{
    [super  layoutSubviews];
    self.imageCount = 0;

    self.dateShowLabel.text = [NSString stringWithFormat:@"   ●   %@",self.diaryInfo.diaryDate];
    if (self.diaryInfo.diaryImagesAray.count>3||self.diaryInfo.diaryImagesAray.count==3) {
        self.imageCount = 0;
    }else if (self.diaryInfo.diaryImagesAray.count == 2){
        self.imageCount = 1;
    }else if (self.diaryInfo.diaryImagesAray.count == 1){
        self.imageCount = 2;
    }
    CGFloat width = CGRectGetWidth(self.whiteBackView.frame);
    CGFloat  everyWidth = (width -30)/2 ;
    switch (self.imageCount) {
        case 0:
        {
            ZZMengBaoPaiImageInfo* image1 = self.diaryInfo.diaryImagesAray[0];
            ZZMengBaoPaiImageInfo* image2 = self.diaryInfo.diaryImagesAray[1];
            ZZMengBaoPaiImageInfo* image3 = self.diaryInfo.diaryImagesAray[2];
            [self.firstIV  sd_setImageWithURL:[NSURL URLWithString:image1.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"loading_image_1_90x90.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
            [self.secondIV  sd_setImageWithURL:[NSURL URLWithString:image2.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"loading_image_1_90x90.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
            [self.thirdIV  sd_setImageWithURL:[NSURL URLWithString:image3.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"loading_image_1_90x90.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
            self.firstIV.frame = CGRectMake(10, 10, everyWidth, 270);
            self.secondIV.frame = CGRectMake(20+everyWidth, 10, everyWidth, 130);
           self.thirdIV.frame = CGRectMake(20+everyWidth, 150, everyWidth, 130);
            self.firstIV.hidden = NO;
            self.secondIV.hidden = NO;
            self.thirdIV.hidden = NO;
            break;
        }
            
         case 1:
        {
            ZZMengBaoPaiImageInfo* image3 = self.diaryInfo.diaryImagesAray[0];
            ZZMengBaoPaiImageInfo* image4 = self.diaryInfo.diaryImagesAray[1];
            self.firstIV.frame = CGRectMake(10, 10, everyWidth, 270);
            self.secondIV.frame = CGRectMake(20+everyWidth, 10, everyWidth, 270);
            [self.firstIV  sd_setImageWithURL:[NSURL URLWithString:image3.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"loading_image_1_90x90.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
            [self.secondIV  sd_setImageWithURL:[NSURL URLWithString:image4.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"loading_image_1_90x90.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
      
            self.firstIV.hidden = NO;
            self.secondIV.hidden = NO;
            self.thirdIV.hidden = YES;
            break;
        }
            
         case 2:
        {
            ZZMengBaoPaiImageInfo* image5 = self.diaryInfo.diaryImagesAray[0];
            self.firstIV.frame = CGRectMake(10, 10, width - 20, 270);
            [self.firstIV  sd_setImageWithURL:[NSURL URLWithString:image5.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"loading_image_2_320x500.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
            self.firstIV.hidden = NO;
            self.secondIV.hidden = YES;
            self.thirdIV.hidden = YES;
            break;
        }
            
        default:
            break;
    }
}

- (void)deleteButtonAction{
    if([self.delegate  respondsToSelector:@selector(diaryTableViewCellDelebuttonClicked:)]){
        ZZMyAlertView*  alertView = [[ZZMyAlertView  alloc]initWithMessage:@"你确定要删除这篇日记" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
        [alertView  show];
    }
}

-(void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self.delegate  diaryTableViewCellDelebuttonClicked:self];
    }
}
@end
