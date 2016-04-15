//
//  UIView+ZLL.h
//  萌宝派
//
//  Created by zhizhen on 15/6/15.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZLL)

//设置frame
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
/**
 *  根据子view  得到superview的class为当前类的实例
 *
 *  @param view 子view
 *
 *  @return 子view的superview的class为当前类
 */
+(UIView*)viewByChildView:(UIView*)view;

/**
 *  设置当前view的圆角
 *
 *  @param redius 圆角弧度
 */
-(void)setLayerCornerRadius:(CGFloat) redius;

/**
 *  设置view的内容模式
 *
 *  @param viewContentMode 要设置为那种类型
 */
-(void)setViewContentMode:(UIViewContentMode)viewContentMode;

- (NSMutableAttributedString *)getAttributedStringWithText:(NSString *)text paragraphSpacing:(CGFloat)paragraphSpacing lineSpace:(CGFloat)lineSpace stringCharacterSpacing:(CGFloat)stringCharacterSpacing  textAlignment:(NSTextAlignment) textAlignment font:(UIFont *)font  color:(UIColor *)color;

/**
 *  设置抖动动画
 *
 *  @param offsetX     x轴移动位置，默认十个点
 *  @param duration    时长，默认.06
 *  @param repeatCount 重复次数，默认3次
 */
- (void)shakeAnimation:(CGFloat)offsetX duration:(CGFloat)duration repeatCount:(NSUInteger)repeatCount;

- (void)shakeAnimation;
@end
