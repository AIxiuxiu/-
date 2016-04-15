//
//  ZZHeadImageView.m
//  萌宝派
//
//  Created by 张亮亮 on 15/8/4.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZHeadImageView.h"
#import "ZZUser.h"


@interface ZZHeadImageView()
@property (nonatomic, weak) UIImageView *verifiedView;
@end

@implementation ZZHeadImageView
- (UIImageView *)verifiedView
{
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        verifiedView.contentMode = UIViewContentModeScaleAspectFill;
        verifiedView.clipsToBounds = YES;
        verifiedView.size = CGSizeMake(10, 10);
         [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.cornerRadius =5;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)setUser:(ZZUser *)user
{
    _user = user;
    
    // 1.下载图片
    [self setImageWithURL:user.mbpImageinfo.smallImagePath placeholderImageName:@"head_portrait_55x55.jpg"];
     if (user.isSuperStarUser) {
      self.verifiedView.image =  [ UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:[[ZZUser  shareSingleUser]  getClassImagePathWithDaRenLevel:user.superStarLv] ofType:nil]];
         self.verifiedView.hidden = NO;
     }else{
         self.verifiedView.hidden = YES;
     }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
  
    self.verifiedView.x = self.width - self.verifiedView.width;
    self.verifiedView.y = self.height - self.verifiedView.height;
}
@end
