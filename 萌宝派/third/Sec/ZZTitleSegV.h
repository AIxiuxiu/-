//
//  ZZTitleSegV.h
//  萌宝派
//
//  Created by zhizhen on 15/8/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTitleSegV;
@protocol ZZTitleSegVDelegate <NSObject>

/**
 *  那个item被点击
 *
 *  @param segment <#segment description#>
 *  @param item    <#item description#>
 */
- (void)titleSegVClicked:(ZZTitleSegV *)segment item:(NSUInteger)item;

@end
@interface ZZTitleSegV : UIView
-(instancetype)initWithItems:(NSArray *)items;
@property (nonatomic, weak)id<ZZTitleSegVDelegate> delegate;
@end
