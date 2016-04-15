//
//  ZZTopicPostCell.m
//  竖版改版
//
//  Created by charles on 15/3/5.
//  Copyright (c) 2015年 Charles_Wl. All rights reserved.
//

#import "ZZTopicPostCell.h"
#import "ZZPost.h"
#import "ZZUser.h"
#import "ZZUprightViewController.h"
#import "ZZMyAlertView.h"
#import "UIImageView+WebCache.h"
@interface ZZTopicPostCell ()<ZZMyAlertViewDelgate>
@end
@implementation ZZTopicPostCell

-(UIView *)postBackGround{
    if (!_postBackGround) {
        _postBackGround = [[UIView alloc]init];
        _postBackGround.backgroundColor = [UIColor whiteColor];
        _postBackGround.layer.cornerRadius = 5;
        _postBackGround.layer.borderWidth = 0.5;
        _postBackGround.clipsToBounds = YES;
        _postBackGround.layer.borderColor =[[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]CGColor];
    }
    return _postBackGround;
}

-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 12, 30, 30)];
        _headImage.layer.cornerRadius = 5;
        _headImage.layer.masksToBounds = YES;
        _headImage.clipsToBounds = YES;
        _headImage.userInteractionEnabled = NO;
        _headImage.contentMode = UIViewContentModeScaleAspectFill;
        /**
         *  2.0.4隐藏
         *
         *  @param headImageClickedAction: <#headImageClickedAction: description#>
         *
         *  @return <#return value description#>
         */
//        UITapGestureRecognizer*  tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(headImageClickedAction:)];
//        [_headImage  addGestureRecognizer:tap];
    }
    return _headImage;
}

-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.font = ZZContentFont;
        _name.textColor = ZZDarkGrayColor;
    }
    return _name;
}

-(UIImageView *)clockImage{
    if (!_clockImage) {
        _clockImage = [[UIImageView alloc]initWithFrame:CGRectMake(60, 32, 16, 16)];
        _clockImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"clock_14x14" ofType:@"png"]];
        _clockImage.alpha = 0.3;
    }
    return _clockImage;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1];
        _timeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _timeLabel;
}

-(UIImageView *)readImage{
    if (!_readImage) {
        _readImage = [[UIImageView alloc]init];
        
        
        _readImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"replies_14x14" ofType:@"png"]];
        _readImage.alpha = 0.3;
    }
    return _readImage;
}
/**
 *  置顶图片
 *
 *  @return  _topImageView
 */
-(UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 52, 46, 16)];
        _topImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"top" ofType:@"png"]];
        _topImageView.clipsToBounds = YES;
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topImageView;
}
/**
 *  0527 王雷添加的button懒加载
 *
 *  @return _deleteButton
 */
-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [[UIButton  alloc]init];
        _deleteButton.layer.masksToBounds =YES;
        _deleteButton.layer.cornerRadius =5;
        //[_deleteButton  setBackgroundImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"delete_40x40.png" ofType:nil] ] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"delete_40x40.png" ofType:nil]] forState:UIControlStateNormal];
          [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

-(UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        
        _countLabel.frame = CGRectMake(ScreenWidth-45, 11, 65, 16);
        _countLabel.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1];
        _countLabel.font = [UIFont systemFontOfSize:14];

        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = ZZDarkGrayColor;
        [_titleLabel setNumberOfLines:0];
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = ZZLightGrayColor;
        [_contentLabel setNumberOfLines:2];
    }
    return _contentLabel;
}

-(UIImageView *)bigLv{
    if (!_bigLv) {
        _bigLv = [[UIImageView alloc]init];
        _bigLv.layer.cornerRadius = 9;
        _bigLv.clipsToBounds = YES;
    }
    return _bigLv;
}

-(UIImageView *)midLv{
    if (!_midLv) {
        _midLv = [[UIImageView alloc]init];
    }
    return _midLv;
}

-(UIImageView *)sLv{
    if (!_sLv) {
        _sLv = [[UIImageView alloc]init];
    }
    return _sLv;
}

-(UIImageView *)pictureImage1{
    if (!_pictureImage1) {
        _pictureImage1 = [[UIImageView alloc]init];
        _pictureImage1.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImage1.clipsToBounds = YES;
    }
    return _pictureImage1;
}

-(UIImageView *)pictureImage2{
    if (!_pictureImage2) {
        _pictureImage2 = [[UIImageView alloc]init];
        _pictureImage2.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImage2.clipsToBounds = YES;
    }
    return _pictureImage2;
}

-(UIImageView *)pictureImage3{
    if (!_pictureImage3) {
        _pictureImage3 = [[UIImageView alloc]init];
        _pictureImage3.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImage3.clipsToBounds = YES;
    }
    return _pictureImage3;
}
-(UILabel *)identityLabel{
    if (!_identityLabel) {
        _identityLabel = [[UILabel  alloc]init];
        _identityLabel.font = [UIFont boldSystemFontOfSize:11];
        _identityLabel.layer.cornerRadius = 3;
        //_identityLabel.backgroundColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1];
        _identityLabel.textAlignment = NSTextAlignmentLeft;
        _identityLabel.layer.masksToBounds = YES;
        _identityLabel.clipsToBounds = YES;
        _identityLabel.textColor =[UIColor colorWithRed:0.97 green:0.71 blue:0.32 alpha:1];
    }
    return _identityLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.postBackGround];
        [self.postBackGround addSubview:self.headImage];
        [self.postBackGround addSubview:self.name];
        //[self.postBackGround addSubview:self.bigLv];
        //[self.postBackGround addSubview:self.midLv];
        //达人图标加载到 背景图上，在用户等级后面
        //[self.postBackGround  insertSubview:self.sLv aboveSubview:self.headImage];
        [self.postBackGround addSubview:self.clockImage];
        [self.postBackGround addSubview:self.readImage];
        [self.postBackGround addSubview:self.timeLabel];
        [self.postBackGround addSubview:self.countLabel];
        [self.postBackGround addSubview:self.titleLabel];
        [self.postBackGround addSubview:self.contentLabel];
        [self.postBackGround addSubview:self.pictureImage1];
        [self.postBackGround addSubview:self.pictureImage2];
        [self.postBackGround addSubview:self.pictureImage3];
        [self.postBackGround  addSubview:self.identityLabel];
        [self.postBackGround addSubview:self.topImageView];
        [self.postBackGround addSubview:self.deleteButton];
    }
    return self;
    
}
#pragma mark  headImageClickedAction:
-(void)headImageClickedAction:(UITapGestureRecognizer*)tap{
    if([self.delegate  respondsToSelector:@selector(topicpostCellHeadImageClickedWithIndexPath:)]){
        [self.delegate  topicpostCellHeadImageClickedWithIndexPath:[self.delegate.topicView  indexPathForCell:self]];
    }
}

#pragma mark  buttonAction
-(void)deleteButtonAction:(UIButton*)btn{
//    if (CURRENTSYSTEM) {
//        self.deleteIndexPath=  [self.topicView  indexPathForCell:btn.superview.superview];
//    }else{
//        self.deleteIndexPath=  [self.topicView  indexPathForCell:btn.superview.superview.superview];
//    }
    ZZMyAlertView*  alertView = [[ZZMyAlertView  alloc]initWithMessage:@"你确定要删除这个帖子" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
    alertView.tag = 999;
    [alertView  show];
}

#pragma mark   ZZMyAlertViewDelgate
-(void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //223为
    if (alertView.tag==999&&buttonIndex) {
        if ([self.delegate  respondsToSelector:@selector(topicPostCellDeleteButtonActionWithIndexPath:)]) {
             [self.delegate  topicPostCellDeleteButtonActionWithIndexPath:[self.delegate.topicView  indexPathForCell:self]];
        }
       
        
    }
}

-(void)setTopicCellpost:(ZZPost *)topicCellpost{
    _topicCellpost = topicCellpost;
    self.topImageView.hidden = YES;
    self.deleteButton.hidden = YES;
    if (self.topicCellpost.postJudge) {
        self.topImageView.hidden = NO;
    }
    if (self.topicCellpost.postUser.isCurrentUser&&!self.topicCellpost.postJudge) {
        
        self.deleteButton.hidden = NO;
    }
    
    /**
     *  0527 王雷添加的删除按钮
     *
     *  @param deleteButtonAction: <#deleteButtonAction: description#>
     *
     *  @return <#return value description#>
     */
    
    
    [self.headImage  sd_setImageWithURL:[NSURL URLWithString:self.topicCellpost.postUser.mbpImageinfo.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"head_portrait_55x55.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
    //名字
    self.name.text = self.topicCellpost.postUser.nick;
    CGSize size2 = CGSizeMake(ScreenWidth-91, 20);
    NSDictionary* dic2 = [NSDictionary dictionaryWithObjectsAndKeys:self.name.font,NSFontAttributeName, nil];
    CGSize labelSize2 = [self.name.text boundingRectWithSize:size2 options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
    self.name.frame = CGRectMake(60, 10, labelSize2.width, 20);
    self.identityLabel.frame = CGRectMake(60, 32, 70, 10);
    
    self.identityLabel .text = [self.topicCellpost.postUser  getUserIdentify];
    
    
    //时间
    self.timeLabel.text = self.topicCellpost.postDateStr;
    
    self.countLabel.text = [NSString   stringWithFormat:@"%ld",(unsigned long)self.topicCellpost.postReplyCount];
    
    //标题
    if (self.topicCellpost.postJudge) {
        self.titleLabel.text = [NSString stringWithFormat:@"             %@",self.topicCellpost.postTitle];
    }else{
        self.titleLabel.text = self.topicCellpost.postTitle;
    }
    
    CGSize titleSize = CGSizeMake(ScreenWidth-40, 1000);
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName, nil];
    CGSize titleLabelSize = [ self.titleLabel.text boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.titleLabel.frame = CGRectMake(15, 51, titleLabelSize.width, titleLabelSize.height);
    
    
    self.contentLabel.text = nil;
    if (self.topicCellpost.postContent.length) {
        self.contentLabel.text = self.topicCellpost.postContent;
    }else{
        if (self.topicCellpost.postImagesArray.count) {
            ZZMengBaoPaiImageInfo*  mbp = self.topicCellpost.postImagesArray[0];
            self.contentLabel.text = mbp.descContent;
        }
        
    }
    //内容
    CGSize contentSize = CGSizeMake(ScreenWidth-40, 40);
    NSDictionary* contentDic = [NSDictionary dictionaryWithObjectsAndKeys:self.contentLabel.font,NSFontAttributeName, nil];
    CGSize contentLabelSize = [self.contentLabel.text boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil].size;
    if (contentLabelSize.height>40) {
        contentLabelSize.height = 40;
    }
    
    self.contentLabel.frame = CGRectMake(15, 58+titleLabelSize.height, contentLabelSize.width, contentLabelSize.height);
    self.pictureImage1.hidden = YES;
    self.pictureImage2.hidden = YES;
    self.pictureImage3.hidden = YES;
    CGFloat  imageHeight = 0.0;
    //图片显示
    for (int i =0; i<self.topicCellpost.postImagesArray.count; i++) {
        imageHeight = 90;
        UIImageView*  imageView;
        switch (i) {
            case 0:
                imageView = self.pictureImage1;
                imageView.hidden = NO;
                break;
            case 1:
                imageView = self.pictureImage2;
                 imageView.hidden = NO;
                break;
            case 2:
                imageView = self.pictureImage3;
                 imageView.hidden = NO;
                break;
                
        }
        imageView.frame =CGRectMake(15+i*95,62+titleLabelSize.height+contentLabelSize.height, 90, 90);
        ZZMengBaoPaiImageInfo* mbp = self.topicCellpost.postImagesArray[i];
        [imageView  sd_setImageWithURL:[NSURL URLWithString:mbp.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"loading_image_2_320x500.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority] ;
    }
    /**
     *  发帖数
     */
    CGSize contentSize1 = CGSizeMake(MAXFLOAT, 20);
    NSDictionary* contentDic1 = [NSDictionary dictionaryWithObjectsAndKeys:self.countLabel.font,NSFontAttributeName, nil];
    CGSize countLabelSize = [self.countLabel.text boundingRectWithSize:contentSize1 options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic1 context:nil].size;
    self.countLabel.frame = CGRectMake(ScreenWidth-30-countLabelSize.width, 11, countLabelSize.width, countLabelSize.height);
    self.readImage.frame = CGRectMake(ScreenWidth-30-countLabelSize.width-20, 12, 16, 16);
    self.postBackGround.frame = CGRectMake(5, 5, ScreenWidth-10, 60+titleLabelSize.height+contentLabelSize.height+imageHeight+32);
    self.clockImage.frame = CGRectMake(15, self.postBackGround.frame.size.height-21, 12, 12);
    self.timeLabel.frame = CGRectMake(30, self.postBackGround.frame.size.height-20, 100 , 10);
    
    self.deleteButton.frame = CGRectMake(ScreenWidth-30-20, self.postBackGround.frame.size.height-20-8, 24, 24);

}


@end
