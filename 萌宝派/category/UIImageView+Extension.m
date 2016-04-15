//
//  UIImageView+Extension.m
//  萌宝派
//
//  Created by zhizhen on 15/7/22.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (Extension)
-(void)setImageWithURL:(NSString*)url placeholderImageName:(NSString*)imageName{
      [self  sd_setImageWithURL:[NSURL URLWithString:url]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imageName ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
}
@end
