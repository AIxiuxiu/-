//
//  NSObject+Extension.h
//  萌宝派
//
//  Created by zhizhen on 15/7/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)
/**
 *  计算代码时长，放入block中传进来
 *
 *  @param block 代码块
 */
-(void)codeBlockCostTime:(void (^)(void))block;

- (CGSize)getiSizeWithAttString:(NSAttributedString *)attrStr size:(CGSize)size;

/**
 *  得到合适的大小 返回的数据不能超出限制的数据
 *
 *  @param limitSize  限制的size
 *  @param originSize 原始的size
 *
 *  @return 返回的合适的数据
 */
- (CGSize)sizeWithLimitSize:(CGSize)limitSize originSize:(CGSize)originSize;
@end
