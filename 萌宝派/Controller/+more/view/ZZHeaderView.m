//
//  ZZHeaderView.m
//  萌宝派
//
//  Created by zhizhen on 15-3-12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZHeaderView.h"
#import "UIImageView+WebCache.h"

@interface ZZHeaderView ()


@end
@implementation ZZHeaderView
-(instancetype)init{
    self = [super init];
    if (self) {
       
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super  initWithFrame:frame];
    if (self) {
        [self addSubview:self.publishIV];
        [self  addSubview:self.headImage];
        [self  addSubview:self.topicName];
        [self  addSubview:self.number];
        [self  addSubview:self.attentionButton];
        [self  addSubview:self.contentLabel];
    }
    return self;
}

-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(28, 22, 60, 60)];
        _headImage.layer.cornerRadius = 5;
        _headImage.layer.masksToBounds = YES;
        _headImage.clipsToBounds = YES;
        _headImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImage;
}

-(UILabel *)topicName{
    if (!_topicName) {
        _topicName  = [[UILabel alloc]initWithFrame:CGRectMake(28+60+10, 22, 170, 20)];
        _topicName.font = [UIFont boldSystemFontOfSize:16];
        _topicName.textColor = roseRedColor;
    }
    return _topicName;
}
-(UIImageView *)publishIV{
    if (!_publishIV) {
        _publishIV = [[UIImageView  alloc]init];
        _publishIV.image = [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"record_34x34.png" ofType:nil]];
        
        _publishIV.contentMode  = UIViewContentModeScaleAspectFill;
        _publishIV.clipsToBounds = YES;
        _publishIV.layer.cornerRadius = 5;
        _publishIV.layer.masksToBounds = YES;
    }
    return _publishIV;
}

-(UILabel *)number{
    if (!_number) {
        _number = [[UILabel alloc]init];
        _number.textColor = roseRedColor;
        _number.textAlignment = NSTextAlignmentRight;
        _number.font = [UIFont systemFontOfSize:12];
    }
    return _number;
}
-(UIButton *)attentionButton{
    if (!_attentionButton) {
        _attentionButton = [[UIButton alloc]init];
        
        _attentionButton.layer.cornerRadius = 3;
        _attentionButton.layer.masksToBounds = YES;
        _attentionButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _attentionButton;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:1];
        [_contentLabel setNumberOfLines:0];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        //_contentLabel.backgroundColor = [UIColor  redColor];
    }
    
    return _contentLabel;
}

-(void)layoutSubviews{
    [super  layoutSubviews];
     //self.headImage.image = [UIImage imageNamed:@"j_5.jpg"];
    [self.headImage  sd_setImageWithURL:[NSURL  URLWithString:self.plateType.mbpImageInfo.smallImagePath] placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"loading_image_1_90x90.jpg" ofType:nil]] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    self.topicName.text =  [NSString  stringWithFormat:@"%@",self.plateType.title ];
    CGSize  typeSize1 = [self.topicName.text   sizeWithAttributes:@{NSFontAttributeName:self.topicName.font}];
    self.attentionButton.frame = CGRectMake(28+60+10+typeSize1.width+10, 22, 50, 20);
    self.number.text = [NSString   stringWithFormat:@"%lu",(unsigned long)self.plateType.publishCount];
    CGSize contentSize1 = CGSizeMake(MAXFLOAT, 20);
    NSDictionary* contentDic1 = [NSDictionary dictionaryWithObjectsAndKeys:self.number.font,NSFontAttributeName, nil];
    CGSize typeSize = [self.number.text boundingRectWithSize:contentSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic1 context:nil].size;
    self.number.frame = CGRectMake(ScreenWidth-25-typeSize.width, 28, typeSize.width, 15);
    
    self.publishIV.frame = CGRectMake(ScreenWidth-35-10-typeSize.width, 23, 17, 17);
    
    
    
    self.contentLabel.text = self.plateType.content;
//    CGSize size1 = CGSizeMake([UIScreen mainScreen].bounds.size.width-40, 2000);
//    NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:self.contentLabel.font,NSFontAttributeName, nil];
//    CGSize labelSize1 = [self.contentLabel.text boundingRectWithSize:size1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
    self.contentLabel.frame = CGRectMake(28+60+10, 48, ScreenWidth-130, [ZZHeaderView  getFrameSizeHeightWith:self.contentLabel.text]-65);
    
    if (self.plateType.attention) {
        //绿色按钮
        self.attentionButton.backgroundColor = [UIColor  colorWithRed:0.57 green:0.85 blue:0.37 alpha:1];
        [self.attentionButton setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        //蓝色按钮
        self.attentionButton.backgroundColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1];
        [self.attentionButton setTitle:@"+关注" forState:UIControlStateNormal];
    }
}
//自身的高度
+(CGFloat)getFrameSizeHeightWith:(NSString*)str{

    CGSize size1 = CGSizeMake(ScreenWidth-130, 2000);
    NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
    CGSize labelSize1 = [str boundingRectWithSize:size1 options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
    if (labelSize1.height+65<88) {
        return 98;
    }else{
        return labelSize1.height+65;
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
