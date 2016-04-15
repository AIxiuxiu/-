//
//  ZZMyDateView.h
//  聪明宝宝
//
//  Created by zhizhen on 14-9-2.
//  Copyright (c) 2014年 zhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"


@protocol ZZMyDateViewDelegate <NSObject>

-(void)getDateStr:(NSString*)str;

@end
#pragma mark – *****************  width>=140  and  height >= 114 *****************
@interface ZZMyDateView : UIImageView<MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate>

@property(nonatomic,strong)MXSCycleScrollView*yearScrollView;
@property(nonatomic,strong)MXSCycleScrollView*monthScrollView;
@property(nonatomic,strong)MXSCycleScrollView*dayScrollView;
@property(nonatomic,weak)id<ZZMyDateViewDelegate>  delegate;

@property(nonatomic,copy)NSString*  birthday;

-(instancetype)initWithFrame:(CGRect)frame  andString:(NSString*)str;
@end
