//
//  ZZFunctionView.h
//  萌宝派
//
//  Created by zhizhen on 15/8/11.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFunctionOb.h"
@class ZZPost,ZZFunctionView;
@protocol ZZFunctionViewDelegate <NSObject>

- (void)functionViewItemDidSelect:(ZZFunctionView *)functionView funType:(ZZFunctionObType)type;

@end
@interface ZZFunctionView : UICollectionView
@property (nonatomic, strong)ZZPost *post;

@property (nonatomic, weak) id<ZZFunctionViewDelegate>  funDelegate;
@end
