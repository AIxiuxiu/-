//
//  ZZSegmentV.h
//  萌宝派
//
//  Created by zhizhen on 15/8/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZSegmentV;
@protocol ZZSegmentVDelegate <NSObject>

/**
 *  那个item被点击
 *
 *  @param segment <#segment description#>
 *  @param item    <#item description#>
 */
- (void)segmentVClicked:(ZZSegmentV *)segment item:(NSUInteger)item;

@end

@interface ZZSegmentV : UIView
-(instancetype)initWithItems:(NSArray *)items;

@property (nonatomic, weak)id<ZZSegmentVDelegate> delegate;
@end
