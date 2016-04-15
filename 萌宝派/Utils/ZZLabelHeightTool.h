//
//  ZZLabelHeightTool.h
//  萌宝派
//
//  Created by zhizhen on 15/9/6.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface ZZLabelHeightTool : NSObject
singleton_interface(ZZLabelHeightTool);
- (CGSize )sizeWithAttStr:(NSAttributedString *)attStr limitSize:(CGSize )size;
@end
