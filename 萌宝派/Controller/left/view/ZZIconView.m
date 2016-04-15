//
//  UIIconView.m
//  萌宝派
//
//  Created by 张亮亮 on 15/8/4.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZIconView.h"
#import "ZZUser.h"
@interface ZZIconView ()
@property (nonatomic, weak) UIImageView *userLevelView;
@property (nonatomic, weak) UIImageView *talentLevelView;
@end
@implementation ZZIconView
- (UIImageView *)userLevelView
{
    if (!_userLevelView) {
        UIImageView *userLevelView = [[UIImageView alloc] init];
        userLevelView.contentMode = UIViewContentModeScaleAspectFill;
        userLevelView.clipsToBounds = YES;
        userLevelView.layer.masksToBounds = YES;
        [self addSubview:userLevelView];
        self.userLevelView = userLevelView;
    }
    return _userLevelView;
}
- (UIImageView *)talentLevelView
{
    if (!_talentLevelView) {
        UIImageView *talentLevelView = [[UIImageView alloc] init];
        talentLevelView.contentMode = UIViewContentModeScaleAspectFill;
        talentLevelView.clipsToBounds = YES;
        [self addSubview:talentLevelView];
        self.talentLevelView = talentLevelView;
    }
    return _talentLevelView;
}

-(void)setUser:(ZZUser *)user{
    _user = user;
    self.userLevelView.image  = [ UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:[[ZZUser  shareSingleUser]   getBigLevelImagePathWithLoginTime:user.loginTime] ofType:nil]];
    self.talentLevelView.image = [ UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:[[ZZUser  shareSingleUser]  getSmallLevelImagePathWithLoginTime:user.loginTime] ofType:nil]];
 
}

-(void)layoutSubviews{
    [super  layoutSubviews];
    CGFloat width = self.width;
    CGFloat  height = self.height;
     CGFloat scale = 0.6;
  
    CGFloat userWidth = width/2;
    
    CGFloat wh = MIN(userWidth, height);
    self.userLevelView.layer.cornerRadius = wh/2;
    self.userLevelView.width = wh;
    self.userLevelView.height = wh;
    self.userLevelView.x = 3;

    CGFloat talentHeight = scale * wh;
    CGFloat  talentW = wh *scale;

    CGFloat   talentX = width -talentW ;
    CGFloat   talentY = height -talentHeight;
    self.talentLevelView.frame =CGRectMake(talentX, talentY, talentW, talentHeight);
    
}
@end
