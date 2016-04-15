//
//  ZZDynamicHeadView.h
//  萌宝派
//
//  Created by zhizhen on 15/5/26.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHeadGroup.h"
@protocol ZZDynamicHeadViewDelegate <NSObject>

@optional
- (void)clickHeadViewWithSection:(NSUInteger)section;

@end
@interface ZZDynamicHeadView : UITableViewHeaderFooterView
@property(nonatomic,strong)UILabel*  numlabel;
@property(nonatomic,strong)UIButton*  clickButton;
@property(nonatomic,strong)ZZHeadGroup*  headGroup;
@property(nonatomic,strong)UILabel*  lineLabel;
@property(nonatomic,strong)UILabel*  unReadCountLabel;
@property (nonatomic, weak) id<ZZDynamicHeadViewDelegate> delegate;
+ (instancetype)headViewWithTableView:(UITableView *)tableView;
@end
