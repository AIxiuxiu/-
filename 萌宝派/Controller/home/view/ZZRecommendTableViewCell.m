//
//  ZZRecommendTableViewCell.m
//  萌宝派
//
//  Created by zhizhen on 15-3-4.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZRecommendTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ZZRecommendTableViewCell


-(UIImageView *)typeImageView{
    if (!_typeImageView) {
        _typeImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(15, 10, 62, 62)];
        _typeImageView.contentMode  = UIViewContentModeScaleAspectFill;
        _typeImageView.clipsToBounds = YES;
        _typeImageView.layer.cornerRadius = 5;
        _typeImageView.layer.masksToBounds = YES;
    }
    return _typeImageView;
}

-(UIImageView *)publishIV{
    if (!_publishIV) {
        _publishIV = [[UIImageView  alloc]initWithFrame:CGRectMake(self.publishCountLabel.frame.origin.x-22, 10, 17, 17)];
        _publishIV.image = [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"record_34x34.png" ofType:nil]];
        _publishIV.contentMode  = UIViewContentModeScaleAspectFill;
        _publishIV.clipsToBounds = YES;
        _publishIV.layer.cornerRadius = 5;
        _publishIV.layer.masksToBounds = YES;
    }
    return _publishIV;
}
-(UIImageView *)heartIv{
    if (!_heartIv) {
        _heartIv = [[UIImageView  alloc]initWithFrame:CGRectMake(self.publishIV.frame.origin.x-22, 10, 17, 17)];
        _heartIv.image = [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"heart_34x34.png" ofType:nil]];
        _heartIv.contentMode  = UIViewContentModeScaleAspectFill;
        _heartIv.clipsToBounds = YES;
        _heartIv.layer.cornerRadius = 5;
        _heartIv.layer.masksToBounds = YES;
    }
    return _heartIv;
}
-(UILabel *)describeLabel{
    if (!_describeLabel) {
        _describeLabel = [[UILabel  alloc]initWithFrame:CGRectMake(85, 10, 100, 20)];
        _describeLabel.font = [UIFont  boldSystemFontOfSize:16];
        _describeLabel.textColor = roseRedColor;
    }
    return _describeLabel;
}

-(UILabel *)publishCountLabel{
    if (!_publishCountLabel) {
        _publishCountLabel = [[UILabel  alloc]initWithFrame:CGRectMake(ScreenWidth-35, 15, 20, 15)];
        _publishCountLabel.font = [UIFont systemFontOfSize:12];
        _publishCountLabel.textAlignment = NSTextAlignmentRight;
        _publishCountLabel.textColor = roseRedColor;
        //_publishCountLabel.alpha = 0.7;
    }
    
    return _publishCountLabel;
}
-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel  alloc]initWithFrame:CGRectMake(85, 40, ScreenWidth - 125, 34)];
        _detailLabel.font = [UIFont  systemFontOfSize:12];
        _detailLabel.numberOfLines = 2;
        _detailLabel.textColor = [UIColor colorWithRed:78.0/255 green:78.0/255 blue:78.0/255 alpha:1];
    
    }
    return _detailLabel;
}


-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        _lineLabel.backgroundColor = [UIColor  colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
       
    }
    return _lineLabel;
}
//
static NSString *cellIden = @"ZZRecommendTableViewCell";
+ (ZZRecommendTableViewCell *)dequeueReusableCellWithTableView:(UITableView *)tableView{
    ZZRecommendTableViewCell*    cell = [tableView  dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[ZZRecommendTableViewCell  alloc  ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        cell.contentView.backgroundColor = [UIColor  whiteColor];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self  initShowInterface];
    }
    
    return self;
}

-(void)initShowInterface{
    self.backgroundColor = [UIColor  whiteColor];
    [self.contentView  addSubview:self.typeImageView];
    [self.contentView  addSubview:self.describeLabel];
    [self.contentView  addSubview:self.typeLabel];
    [self.contentView addSubview:self.publishIV];
    [self.contentView  addSubview:self.heartIv];

    [self.contentView  addSubview:self.publishCountLabel];
    [self.contentView  addSubview:self.detailLabel];
    [self.contentView  addSubview:self.lineLabel];
}

-(void)layoutSubviews{
    [super  layoutSubviews];
     [ self.typeImageView  sd_setImageWithURL:[NSURL  URLWithString:self.plateType.mbpImageInfo.smallImagePath] placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"loading_image_1_90x90.jpg" ofType:nil]]  options:SDWebImageRetryFailed|SDWebImageLowPriority ] ;
    self.describeLabel.text = [NSString  stringWithFormat:@"%@",self.plateType.title];
    
    //橙色字色
   // self.describeLabel.textColor = [UIColor colorWithRed:0.97 green:0.71 blue:0.32 alpha:1];
    //绿色字色
    //    self.describeLabel.textColor = [UIColor colorWithRed:0.7 green:0.83 blue:0.39 alpha:1];
    
    //self.typeLabel.text = [NSString  stringWithFormat:@"【%@】",self.plateType.title];
 
//    CGSize  typeSize = [self.publishLabel.text   sizeWithAttributes:@{NSFontAttributeName:self.publishLabel.font}];
//    //  (125, 32, 135, 20)(85, 32, 40, 20)(128, 32, 167, 20)
//    self.publishLabel.frame =CGRectMake(85, 32, typeSize.width, 20);
//    self.publishCountLabel.frame = CGRectMake(85+typeSize.width+5, 32, 167, 20);
//
    self.publishCountLabel.text =[NSString  stringWithFormat:@"%d",self.plateType.publishCount];
    CGSize  typeSize = [self.publishCountLabel.text  sizeWithAttributes:@{NSFontAttributeName:self.publishCountLabel.font}];
    self.publishCountLabel.frame = CGRectMake(ScreenWidth-15 -typeSize.width, 15, typeSize.width, 15);
    self.publishIV.frame  = CGRectMake(self.publishCountLabel.frame.origin.x-22, 10, 17, 17);
    self.heartIv.frame = CGRectMake(self.publishIV.frame.origin.x-22, 10, 17, 17);
   
  
    [self  resetContent];
}
- (void)resetContent{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString   alloc] initWithString:self.plateType.content];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle  alloc] init];
    
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
//    paragraphStyle.maximumLineHeight = 60;  //最大的行高
    
    paragraphStyle.lineSpacing = 3;  //行自定义行高度
    
   // [paragraphStyle setFirstLineHeadIndent:self.usernameLabel.frame.size.width + 5];//首行缩进 根据用户昵称宽度在加5个像素
    
   [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.plateType.content.length)];
    
    self.detailLabel.attributedText = attributedString;
   
   // [self.contentLabelsizeToFit];
    
}
@end
