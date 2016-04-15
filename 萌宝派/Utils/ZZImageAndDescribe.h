//
//  ZZImageAndDescribe.h
//  萌宝派
//
//  Created by zhizhen on 15-3-16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//
//发布宝宝日记时：：：图片 和图片说明
#import <Foundation/Foundation.h>

@interface ZZImageAndDescribe : NSObject
@property(nonatomic)NSUInteger  imageADId;
@property(nonatomic,strong)UIImage*  showImage;
@property(nonatomic,strong)NSString*  decribeStr;

-(instancetype)initWithImageADId:(NSUInteger)imageADId
                        andImage:(UIImage*)image
                   andDecribeStr:(NSString*)str;
@end
