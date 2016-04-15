//
//  ZZUserDetailView.m
//  萌宝派
//
//  Created by charles on 15/8/12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZUserDetailView.h"
#import "ZZSegmentV.h"
#import "UIImageView+WebCache.h"
#import "ZZMyAlertView.h"

@interface ZZUserDetailView ()<ZZSegmentVDelegate,ZZMyAlertViewDelgate>
@property(nonatomic,strong)UIImageView* backGroundIV;
@property(nonatomic,strong)UIImageView* userIV;
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UILabel* nameBackgroundLabel;
@property(nonatomic,strong)UIImageView* bigIV;
@property(nonatomic,strong)UIImageView* middleIV;
@property(nonatomic,strong)UIImageView* smallIV;
@property(nonatomic,strong)UILabel* userStyleLabel;
@property(nonatomic,strong)UIButton* attentionButton;
@property(nonatomic,strong)ZZSegmentV* segmentV;
@end


@implementation ZZUserDetailView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setUser:(ZZUser *)user{
    _user = user;
    ZZLog(@"aaaaaaa%@",self.user);
    [self addSubview:self.backGroundIV];
    [self addSubview:self.userIV];
    [self addSubview:self.nameBackgroundLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.bigIV];
    [self addSubview:self.middleIV];
    [self addSubview:self.smallIV];
    [self addSubview:self.userStyleLabel];

    /**
     *  添加监听
     */
    [user  addObserver:self forKeyPath:@"attention" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    if (user.isCurrentUser){
        self.attentionButton.hidden = YES;
    }
}
#pragma mark eventMethod
/**
 *  监听方法
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (self.user.attention) {
        self.attentionButton.backgroundColor = [UIColor  colorWithRed:0.57 green:0.85 blue:0.37 alpha:1];
        [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        self.attentionButton.backgroundColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1];
        [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    }
}


/**
 *  关注点击事件
 */
-(void)attentionButtoNAction:(UIButton*)btn{
    if ([self.delegate  respondsToSelector:@selector(userDetailViewToAttention:)]) {
        if (self.user.attention) {
            ZZMyAlertView* alertView = [[ZZMyAlertView  alloc]initWithMessage:@"你确定要取消关注嘛" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
            alertView.tag = 203;
            [alertView  show];
            return;
        }
        [self.delegate  userDetailViewToAttention:self];
    }
}

#pragma mark  ZZMyAlertViewDelgate
-(void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //203  取消关注
    if (buttonIndex&&alertView.tag ==203) {
           [self.delegate  userDetailViewToAttention:self];
    }
}
/**
 *  segement点击事件
 */
-(void)segmentVClicked:(ZZSegmentV *)segment item:(NSUInteger)item{
    
    if ([self.delegate respondsToSelector:@selector(userDetailViewToSegment:andItem:)]) {
        [self.delegate userDetailViewToSegment:self andItem:item];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //背景图片
    NSString*   imageName = [self.user getUserPersonalCenterBackGroundImageName];

    self.backGroundIV.image = [UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imageName ofType:nil]];
    self.backGroundIV.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/1.6);
    //用户头像
    [self.userIV sd_setImageWithURL:[NSURL  URLWithString:self.user.mbpImageinfo.smallImagePath] placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource: @"head_portrait_55x55.jpg" ofType:nil] ]   options:SDWebImageRetryFailed| SDWebImageLowPriority];
    self.userIV.frame = CGRectMake(20, self.backGroundIV.height-self.userIV.height/2, 60, 60);
    //用户名字
    self.nameLabel.text = self.user.nick;
    self.nameLabel.frame = CGRectMake(85, self.backGroundIV.height-self.nameLabel.height, 200, 20);
    
    //用户名字背景
    self.nameBackgroundLabel.text = self.user.nick;
    self.nameBackgroundLabel.frame = CGRectMake(86, self.backGroundIV.height-self.nameBackgroundLabel.height, 200, 20);
    
    //大图标

    self.bigIV.image = [UIImage imageNamed:[self.user  getBigLevelImagePathWithLoginTime:self.user.loginTime]];
    self.bigIV.frame = CGRectMake(CGRectGetMaxX(self.userIV.frame)+5, CGRectGetMaxY(self.userIV.frame)-18, 18, 18);
    
    //中图标
    self.middleIV.image = [UIImage imageNamed:[self.user  getSmallLevelImagePathWithLoginTime:self.user.loginTime]];
    self.middleIV.frame = CGRectMake(CGRectGetMaxX(self.bigIV.frame)+2, CGRectGetMaxY(self.userIV.frame)-10, 10, 10);
    
    //小图标
    self.smallIV.image = [UIImage imageNamed:[self.user  getClassImagePathWithDaRenLevel:self.user.superStarLv]];
    self.smallIV.frame = CGRectMake(CGRectGetMaxX(self.userIV.frame)-15, CGRectGetMaxY(self.userIV.frame)-15, 15, 15);
    
    //用户类别
    self.userStyleLabel.text =  [self.user getUserIdentify];
    CGSize size2 = CGSizeMake(100, MAXFLOAT);
    NSDictionary* dic2 = [NSDictionary dictionaryWithObjectsAndKeys:self.userStyleLabel.font,NSFontAttributeName, nil];
    CGSize labelSize2 = [self.userStyleLabel.text boundingRectWithSize:size2 options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
    self.userStyleLabel.frame = CGRectMake(CGRectGetMaxX(self.middleIV.frame), CGRectGetMaxY(self.userIV.frame)-labelSize2.height, labelSize2.width+10, labelSize2.height);
    
    //关注按钮
    self.attentionButton.frame = CGRectMake(ScreenWidth-60, CGRectGetMaxY(self.userIV.frame)-20, 40, 20);
    
    
    UIView* segmentBackground = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-30, 252*ScreenWidth, 30)];
    segmentBackground.backgroundColor = ZZViewBackColor;
    [self addSubview:segmentBackground];
   
//    
    self.height = self.backGroundIV.height+self.segmentV.height+self.userIV.height/2+10;
    self.segmentV.frame =CGRectMake(34*(ScreenWidth/320), 0, 252*(ScreenWidth/320), 30);
    [segmentBackground addSubview:self.segmentV];
//
    
}
#pragma mark methods
- (void)showAttentionBUtton{
   
    if (self.user.isCurrentUser) {
//        self.attentionButton.alpha = 0.5;
//         [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
//        self.attentionButton.backgroundColor = [UIColor  lightGrayColor];
    }else{
         [self addSubview:self.attentionButton];
        
    }
}
#pragma mark setter andGetter
-(UIImageView *)backGroundIV{
    if (!_backGroundIV) {
        _backGroundIV = [[UIImageView alloc]init];
    }
    return _backGroundIV;
}

-(UIImageView *)userIV{
    if (!_userIV) {
        _userIV = [[UIImageView alloc]init];
        _userIV.layer.cornerRadius = 5;
        _userIV.layer.masksToBounds = YES;
        _userIV.clipsToBounds = YES;
        _userIV.contentMode = UIViewContentModeScaleAspectFill;
        _userIV.userInteractionEnabled = YES;
    }
    return _userIV;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.textColor = [UIColor whiteColor];
        
    }
    return _nameLabel;
}

-(UILabel *)nameBackgroundLabel{
    if (!_nameBackgroundLabel) {
        _nameBackgroundLabel = [[UILabel alloc]init];
        _nameBackgroundLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameBackgroundLabel.textColor = [UIColor blackColor];
        
    }
    return _nameBackgroundLabel;
}

-(UIImageView *)bigIV{
    if (!_bigIV) {
        _bigIV = [[UIImageView alloc]init];
        _bigIV.layer.cornerRadius = 9;
        _bigIV.clipsToBounds = YES;
        
    }
    return _bigIV;
}

-(UIImageView *)middleIV{
    if (!_middleIV) {
        _middleIV = [[UIImageView alloc]init];
        
    }
    return _middleIV;
}

-(UIImageView *)smallIV{
    if (!_smallIV) {
        if (self.user.permissions==3&&self.user.isSuperStarUser){
            _smallIV = [[UIImageView alloc]init];
        }
    }
    return _smallIV;
}
-(UILabel *)userStyleLabel{
    if (!_userStyleLabel) {
        _userStyleLabel = [[UILabel alloc]init];
        _userStyleLabel.font = [UIFont boldSystemFontOfSize:9];
        _userStyleLabel.layer.cornerRadius = 3;
        _userStyleLabel.textAlignment = NSTextAlignmentCenter;
        _userStyleLabel.layer.masksToBounds = YES;
        _userStyleLabel.clipsToBounds = YES;
        _userStyleLabel.textColor = [UIColor colorWithRed:0.97 green:0.71 blue:0.32 alpha:1];
        
    }
    return _userStyleLabel;
}
-(UIButton *)attentionButton{
    if (!_attentionButton) {
        _attentionButton = [[UIButton alloc]init];
       [_attentionButton  addTarget:self action:@selector(attentionButtoNAction:) forControlEvents:UIControlEventTouchUpInside];
        _attentionButton.layer.cornerRadius = 5;
        _attentionButton.layer.masksToBounds = YES;
        _attentionButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _attentionButton;
}

-(ZZSegmentV *)segmentV{
    if (!_segmentV) {
        _segmentV = [[ZZSegmentV  alloc]initWithItems:@[@"话题",@"同龄",@"同城"]];
        //segment
        _segmentV.frame =CGRectMake(34*(ScreenWidth/320), 200, 252*(ScreenWidth/320), 30);
        _segmentV.delegate = self;
    }
    return _segmentV;
}
-(void)dealloc{
    [self removeOberver];
}
/**
 *  取消监听
 */
- (void)removeOberver{
    [self.user  removeObserver:self forKeyPath:@"attention"];
}
@end
