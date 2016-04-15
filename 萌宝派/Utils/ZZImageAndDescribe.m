//
//  ZZImageAndDescribe.m
//  萌宝派
//
//  Created by zhizhen on 15-3-16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZImageAndDescribe.h"

@implementation ZZImageAndDescribe
-(instancetype)initWithImageADId:(NSUInteger)imageADId
                        andImage:(UIImage*)image
                   andDecribeStr:(NSString*)str{
    self = [super  init];
    if (self) {
        self.imageADId = imageADId;
        self.showImage = image;
        self.decribeStr = str;
    }
    return self;
}
@end
