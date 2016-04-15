//
//  ZZMasterCollectionViewCell.h
//  萌宝派
//
//  Created by zhizhen on 15/4/10.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZUser.h"
@interface ZZMasterCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView*  headImageView;//
@property(nonatomic,strong)UIImageView* masterImageView;
@property(nonatomic,strong)UILabel*   nameLabel;
@property(nonatomic,strong)UILabel*  masterTypeLabel;

@property(nonatomic,strong)ZZUser*  masterUser;
@end
