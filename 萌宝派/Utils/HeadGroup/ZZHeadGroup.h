//
//  ZZHeadGroup.h
//  萌宝派
//
//  Created by zhizhen on 15/5/26.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZHeadGroup : NSObject
@property(nonatomic,copy)NSString*  name;
@property (nonatomic, assign, getter = isOpened) BOOL opened;
@property(nonatomic,strong)NSArray*  array;
@end
