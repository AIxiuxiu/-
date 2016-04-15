//
//  ZZHeaderView.h
//  萌宝派
//
//  Created by zhizhen on 15-3-12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPlateTypeInfo.h"
@interface ZZHeaderView : UIView
@property(nonatomic,strong)UIImageView* headImage;
@property(nonatomic,strong)UILabel* topicName;

@property(nonatomic,strong)UILabel* number;
@property(nonatomic,strong)UIButton* attentionButton;
@property(nonatomic,strong)UILabel* contentLabel;
@property(nonatomic,strong)ZZPlateTypeInfo*  plateType;
@property(nonatomic,strong)UIImageView* publishIV;
+(CGFloat)getFrameSizeHeightWith:(NSString*)str;
@end
