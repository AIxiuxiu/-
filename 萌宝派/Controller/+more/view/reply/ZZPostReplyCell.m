//
//  ZZPostReplyCell.m
//  萌宝派
//
//  Created by zhizhen on 15/8/12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZPostReplyCell.h"
#import "ZZSIzeFitButton.h"
#import "ZZMyAlertView.h"
#import "TTTAttributedLabel.h"
@interface ZZPostReplyCell ()<ZZMyAlertViewDelgate>
@property (nonatomic, strong)UIView *whiteBackView;
@property (nonatomic, strong)TTTAttributedLabel *nickLabel;
@property (nonatomic, strong)UILabel *floorLabel;
@property (nonatomic, strong)UIImageView *headIV;

@property (nonatomic, strong)UILabel *permissLabel;
@property (nonatomic, strong)ZZSIzeFitButton *timeButton;
//@property (nonatomic, strong)ZZSIzeFitButton *replyButton;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIImageView *contentIV;
@property (nonatomic, strong)UIButton *replyButton;
@property (nonatomic, strong)UIButton *reportButton;
@property (nonatomic, strong)UIButton *deleteButton;

@property (nonatomic, strong)UIView *replyView;
@property (nonatomic, strong)UILabel *replyFloorLabel;
@property (nonatomic, strong)UIImageView *replyHeadIV;
@property (nonatomic, strong)UILabel *replyNickLabel;
@property (nonatomic, strong)UILabel *replyContentLabel;
@end
@implementation ZZPostReplyCell

#pragma mark lazyout
-(UIView *)whiteBackView{
    if (_whiteBackView == nil) {
        _whiteBackView = [[UIView  alloc]init];
        _whiteBackView.backgroundColor = [UIColor  whiteColor];
        _whiteBackView.layer.cornerRadius = 5;
        _whiteBackView.layer.masksToBounds = YES;
        _whiteBackView.layer.borderColor = ZZViewBackColor.CGColor;
        _whiteBackView.layer.borderWidth = 0.2;
        [self.contentView  insertSubview:_whiteBackView atIndex:0];
    }
    return _whiteBackView;
}

-(UILabel *)floorLabel{
    if (_floorLabel == nil) {
        _floorLabel = [[UILabel  alloc]init];
        _floorLabel.font = ZZTimeFont;
        _floorLabel.textColor = ZZGreenColor;
        _floorLabel.textAlignment = NSTextAlignmentCenter;
        _floorLabel.adjustsFontSizeToFitWidth = YES;
      
        [self.contentView  addSubview:_floorLabel];
    }
    return _floorLabel;
}

-(UIImageView *)headIV{
    if (_headIV == nil) {
        _headIV = [[UIImageView  alloc]init];
        _headIV.contentMode = UIViewContentModeScaleAspectFill;
        _headIV.clipsToBounds = YES;
        _headIV.layer.masksToBounds = YES;
        _headIV.layer.cornerRadius = 5;
        _headIV.layer.borderWidth = 0.1;
        _headIV.layer.borderColor = ZZLightGrayColor.CGColor;
        [self.contentView  addSubview:_headIV];
    }
    return _headIV;
}
-(TTTAttributedLabel *)nickLabel{
    if (_nickLabel == nil) {
        _nickLabel = [[TTTAttributedLabel  alloc]initWithFrame:CGRectZero];
        _nickLabel.font = ZZContentFont;
        _nickLabel.adjustsFontSizeToFitWidth = YES;
        _nickLabel.textColor = ZZDarkGrayColor;
        [self.contentView  addSubview:_nickLabel];
    }
    return _nickLabel;
}
-(UILabel *)permissLabel{
    if (_permissLabel ==nil) {
        _permissLabel = [[UILabel  alloc]init];
        _permissLabel.textColor = ZZGoldYellowColor;
        _permissLabel.font = ZZTimeFont;
         [self.contentView  addSubview:_permissLabel];
    }
    return _permissLabel;
}

-(UILabel *)contentLabel{
    if (_contentLabel ==nil) {
        _contentLabel = [[UILabel  alloc]init];
        _contentLabel.textColor = ZZLightGrayColor;
        _contentLabel.font = ZZTitleFont;
        _contentLabel.numberOfLines = 0;
         [self.contentView  addSubview:_contentLabel];
    }
    return _contentLabel;
}
-(UIImageView *)contentIV{
    if (_contentIV == nil) {
        _contentIV = [[UIImageView  alloc]init];
        _contentIV.userInteractionEnabled = YES;
        _contentIV.contentMode = UIViewContentModeScaleAspectFill;
        _contentIV.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(conentIVTap:)];
        [_contentIV  addGestureRecognizer:tap];
         [self.contentView  addSubview:_contentIV];
    }
    return _contentIV;
}



-(UIButton *)replyButton{
    if (_replyButton == nil) {
        _replyButton = [[UIButton  alloc]init];
        _replyButton.tag = ZZPostReplyCellButtonTypeReply;
        [_replyButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"re_discuss_16x16" ofType:@"png"]] forState:UIControlStateNormal];
        [_replyButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView  addSubview:_replyButton];
    }
    return _replyButton;
}

-(UIButton *)deleteButton{
    if (_deleteButton == nil) {
        _deleteButton = [[UIButton  alloc]init];
        _deleteButton.layer.masksToBounds =YES;
        _deleteButton.layer.cornerRadius =5;
        _deleteButton.tag = ZZPostReplyCellButtonTypeDelete;
        [_deleteButton  setBackgroundImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"delete_40x40.png" ofType:nil] ] forState:UIControlStateNormal];
        [_deleteButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.backgroundColor = ZZLightGrayColor;
        [self.contentView  addSubview:_deleteButton];
    }
    return _deleteButton;
}
-(UIButton *)reportButton{
    if (!_reportButton) {
        _reportButton = [[UIButton  alloc]init];
        _reportButton.tag = ZZPostReplyCellButtonTypeReport;
        //[_reportButton  setTitle:@"举报" forState:UIControlStateNormal];
        [_reportButton  setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]  pathForResource:@"report_40x40" ofType:@"png"]] forState:UIControlStateNormal];
        _reportButton.layer.masksToBounds =YES;
        _reportButton.layer.cornerRadius = 5;
        _reportButton.backgroundColor =ZZLightGrayColor;
        [_reportButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView  addSubview:_reportButton];
        // [_reportButton  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
    }
    return _reportButton;
}

-(ZZSIzeFitButton *)timeButton{
    if (_timeButton == nil) {
        _timeButton = [[ZZSIzeFitButton  alloc]init];
        _timeButton.titleLabel.font =ZZTimeFont;
        _timeButton.margin = 5;
        _timeButton.alpha = 0.7;
        _timeButton.userInteractionEnabled = NO;
        [_timeButton  setTitleColor:ZZLightGrayColor forState:UIControlStateNormal];
        [_timeButton  setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"clock_14x14" ofType:@"png"]] forState:UIControlStateNormal];
          [self.contentView  addSubview:_timeButton];
    }
    return _timeButton;
}

-(UILabel *)replyFloorLabel{
    if (_replyFloorLabel == nil) {
        _replyFloorLabel = [[UILabel  alloc]init];
        _replyFloorLabel.font = ZZTimeFont;
        _replyFloorLabel.textColor = ZZLightGrayColor;
        _replyFloorLabel.textAlignment = NSTextAlignmentCenter;
        _replyFloorLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.replyView  addSubview:_replyFloorLabel];
    }
    return _replyFloorLabel;
}
-(UIImageView *)replyHeadIV{
    if (_replyHeadIV == nil) {
        _replyHeadIV = [[UIImageView  alloc]init];
        _replyHeadIV.contentMode = UIViewContentModeScaleAspectFill;
        _replyHeadIV.clipsToBounds = YES;
        _replyHeadIV.layer.masksToBounds = YES;
        _replyHeadIV.layer.cornerRadius = 5;
        _replyHeadIV.layer.borderWidth = 0.1;
        _replyHeadIV.layer.borderColor = ZZLightGrayColor.CGColor;
        [self.replyView  addSubview:_replyHeadIV];
    }
    return _replyHeadIV;
}
-(UILabel *)replyNickLabel{
    if (_replyNickLabel == nil) {
        _replyNickLabel = [[UILabel  alloc]init];
        _replyNickLabel.font = ZZContentFont;
        _replyNickLabel.textColor = ZZDarkGrayColor;
        [self.replyView  addSubview:_replyNickLabel];
    }
    return _replyNickLabel;
}


-(UILabel *)replyContentLabel{
    if (_replyContentLabel ==nil) {
        _replyContentLabel = [[UILabel  alloc]init];
        _replyContentLabel.textColor = ZZLightGrayColor;
        _replyContentLabel.font = ZZContentFont;
        _replyContentLabel.numberOfLines = 0;
        [self.replyView  addSubview:_replyContentLabel];
    }
    return _replyContentLabel;
}
-(UIView *)replyView{
    if (_replyView == nil) {
        _replyView = [[UIView alloc]init];
        _replyView.backgroundColor = [UIColor  colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
        _replyView.layer.masksToBounds = YES;
        _replyView.layer.cornerRadius = 5;
        _replyView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _replyView.layer.borderWidth = 0.2;
        [self.contentView  addSubview:_replyView];
    }
    return _replyView;
}

-(void)setReplyFrame:(ZZReplyFrame *)replyFrame{
    _replyFrame = replyFrame;
    
    ZZUser *user = replyFrame.reply.user;
    ZZReplayInformation *reply = replyFrame.reply;
    //头像
    self.headIV.frame = replyFrame.headIVF;
  [  self.headIV  setImageWithURL:user.mbpImageinfo.smallImagePath placeholderImageName:@"head_portrait_55x55.jpg"];
    //楼层
    self.floorLabel.frame = replyFrame.floorLabelF;
    self.floorLabel.text = [NSString  stringWithFormat:@"%ld楼",reply.floor];
    //昵称
    self.nickLabel.frame = replyFrame.nickLabelF;
    [self.nickLabel  getHeightWithLabelString:user.nick limitSize:CGSizeMake(replyFrame.nickLabelF.size.width, 20) numberOfLines:1];
//     [self.nickLabel  getHeightWithLabelString:user.nick andlabelFont:self.nickLabel.font andSize:CGSizeMake(replyFrame.nickLabelF.size.width, 20)] ;

    //按钮
    self.reportButton.frame = replyFrame.reportButtonF;
    self.replyButton.frame = replyFrame.replyButtonF;
    
    self.floorLabel.y = self.replyButton.y+3;
    if (reply.isCurrentUser&&reply.isDelete == NO) {
          self.deleteButton.hidden = NO;
         self.deleteButton.frame = replyFrame.deleteButtonF;
      
    }else{
        self.deleteButton.hidden = YES;
    }
   //权限
    self.permissLabel.frame = replyFrame.permissLabelF;
    self.permissLabel.text = [user  getUserIdentify];
    //回复内容
    if (reply.replayContent.length) {
        self.contentLabel.hidden = NO;
        self.contentLabel.frame = replyFrame.contentLabelF;
        self.contentLabel.attributedText = reply.attributedContent;
   
    }else{
        self.contentLabel.hidden = YES;
    }
    //回复图片
    if (reply.imageInfo && reply.isDelete == NO) {
        self.contentIV.hidden = NO;
        self.contentIV.frame = replyFrame.contentIVF;
        [self.contentIV  setImageWithURL:reply.imageInfo.smallImagePath placeholderImageName:@"loading_image_1_90x90.jpg"];
    }else{
        self.contentIV.hidden = YES;
    }
    //回复的回复
    if (reply.relReplayPost) {
        self.replyView.hidden = NO;
        self.replyView.frame = replyFrame.replyViewF;
        
         [self.replyHeadIV  setImageWithURL:reply.relReplayPost.user.mbpImageinfo.smallImagePath placeholderImageName:@"head_portrait_55x55.jpg"];
        self.replyHeadIV.frame = replyFrame.replyHeadIVF;
        
        self.replyNickLabel.frame = replyFrame.replyNickLabelF;
        self.replyNickLabel.text = reply.relReplayPost.user.nick;
        
        self.replyFloorLabel.frame = replyFrame.replyFloorLabelF;
        self.replyFloorLabel.text = [NSString  stringWithFormat:@"%ld楼",reply.relReplayPost.floor];
        
        self.replyContentLabel.frame = replyFrame.replyContentLabelF;
        self.replyContentLabel.attributedText = reply.relReplayPost.attributedContent;
        
    }else{
        self.replyView.hidden = YES;
    }
    self.timeButton.frame = replyFrame.timeButtonF;
    [self.timeButton  title:reply.replayTime];
    
    self.whiteBackView.frame = replyFrame.whiteBackViewF;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self.contentView  addSubview:self.headIV];
//        [self.contentView  addSubview:self.floorLabel];
//        [self.contentView  addSubview:self.nickLabel];
//        [self.contentView  addSubview:self.permissLabel];
//        [self.contentView   addSubview:self.deleteButton];
//        [self.contentView   addSubview:self.replyButton];
//        [self.contentView  addSubview:self.reportButton];
//        [self.contentView   addSubview:self.timeButton];
//        [self.contentView   addSubview:self.contentLabel];
//        [self.contentView   addSubview:self.contentIV];
    }
    return self;
}
static NSString *cellIden = @"ZZPostReplyCell";
+ (ZZPostReplyCell *)dequeueReusableCellWithTableView:(UITableView *)tableView{
    ZZPostReplyCell*    cell = [tableView  dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[ZZPostReplyCell  alloc  ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        
        cell.contentView.backgroundColor = [UIColor  clearColor];
        cell.backgroundColor = ZZViewBackColor;
    }
    return cell;
}
#pragma event response
- (void)buttonAction:(UIButton *)btn{
    if ([self.delegate  respondsToSelector:@selector(postReplyButtonAction:buttonType:)]) {
        switch (btn.tag) {
            case ZZPostReplyCellButtonTypeDelete:
            {
                ZZMyAlertView*  myAlert = [[ZZMyAlertView  alloc]initWithMessage:@"你确定要删除这个回复嘛" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
                myAlert.tag = 333;
                [myAlert  show];
                return;
            }
                break;
            case ZZPostReplyCellButtonTypeReply:
                [self  callDelegateMethodWithType:ZZPostReplyCellButtonTypeReply];
                break;
            case ZZPostReplyCellButtonTypeReport:
            {
                ZZMyAlertView*  myAlert = [[ZZMyAlertView  alloc]initWithMessage:@"你确定要举报这个回复嘛" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
                myAlert.tag = 444;
                [myAlert  show];
                return;
            }
                break;
            default:
                break;
        }
    }
    
}
- (void)conentIVTap:(UITapGestureRecognizer *)tap{
    if ([self.delegate  respondsToSelector:@selector(postReplyCellContentIVTap:imageView:)]) {
        [self.delegate  postReplyCellContentIVTap:self imageView:tap.view];
    }
}
//调用协议方法
- (void)callDelegateMethodWithType:(ZZPostReplyCellButtonType)buttonType{
    [self.delegate  postReplyButtonAction:self buttonType:buttonType];
}



#pragma mark -ZZMyAlertViewDelgate
-(void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        if (alertView.tag == 333) {//删除
            [self  callDelegateMethodWithType:ZZPostReplyCellButtonTypeDelete];
        }else if (alertView.tag == 444){//举报
            [self  callDelegateMethodWithType:ZZPostReplyCellButtonTypeReport];
        }
    }
}
/*
//绘制背景色
-(void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIColor *bgColor = [UIColor whiteColor];
//     CGContextSetLineWidth(context, 1);
//    CGContextSetStrokeColorWithColor(context, [UIColor  blueColor].CGColor);
//    CGContextSetFillColorWithColor(context, bgColor.CGColor);
//    CGRect bgRect = CGRectMake(5, 5, rect.size.width - 10, rect.size.height - 10);
//    CGContextAddRect(context, bgRect);
//    CGContextDrawPath(context, kCGPathFillStroke);
    CGFloat lineWidth = 0.1;
    CGContextRef context = UIGraphicsGetCurrentContext();
   UIGraphicsPushContext(context);
    CGContextSetGrayFillColor(context, 0.0f, 1.0);//设置不透明
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
   CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetAlpha(context,1.0);
    CGRect boxRect = CGRectMake(ZZReplyCellLine, ZZReplyCellLine, rect.size.width - 2*ZZReplyCellLine - 2*lineWidth, rect.size.height - ZZReplyCellLine-2*lineWidth);
    float radius = 5;
    CGContextBeginPath(context);
   // CGContextSetRGBStrokeColor(context,1,0,0,1);//设置红色画笔
    CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
 
    CGContextClosePath(context);
   //CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
   UIGraphicsPopContext();
}
*/
@end
