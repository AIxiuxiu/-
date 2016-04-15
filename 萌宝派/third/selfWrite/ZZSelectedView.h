//
//  ZZSelectedTableView.h
//  聪明宝宝
//
//  Created by zhizhen on 14-9-1.
//  Copyright (c) 2014年 zhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZZSelectedViewDelegate<NSObject>
@required
-(void)getString:(NSString*)str;
@end

@interface ZZSelectedView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray*  datas;
@property(nonatomic,weak)id<ZZSelectedViewDelegate>   delegate;
@property(nonatomic,assign)NSInteger   selectedIndex;

@end
