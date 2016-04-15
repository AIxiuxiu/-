//
//  UIImage+Extension.h
//  萌宝派
//
//  Created by zhizhen on 15/8/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
// 加载最原始的图片，没有渲染
+ (instancetype)imageWithOriginalName:(NSString *)imageName;


+ (UIImage *)resizedImage:(NSString *)name;

+ (UIImage*)imageWithStretchableName:(NSString *)imageName;

@end
