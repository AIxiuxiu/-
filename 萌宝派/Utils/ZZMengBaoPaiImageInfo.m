//
//  ZZMengBaoPaiImageInfo.m
//  萌宝派
//
//  Created by zhizhen on 14-11-24.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZMengBaoPaiImageInfo.h"

@implementation ZZMengBaoPaiImageInfo
//防止出现图片宽高为0的情况
-(CGFloat)smallImageHeight{
    if (!_smallImageHeight) {
        _smallImageHeight = 60;
    }
    return _smallImageHeight;
}
-(CGFloat)smallImageWidth{
    if (!_smallImageWidth) {
        _smallImageWidth = 60;
    }
    return _smallImageWidth;
}
-(CGFloat)largeImageHeight{
    if (!_largeImageHeight) {
        _largeImageHeight = 120;
    }
    return _largeImageHeight;
}
-(CGFloat)largeImageWidth{
    if (!_largeImageWidth) {
        _largeImageWidth = 120;
    }
    return _largeImageWidth;
}
-(instancetype)initWithMbpImageInfoId:(NSUInteger)mbpImageInfoId
                   andWeChatImagePath:(NSString*)weChatImagePath
                    andSmallImagePath:(NSString*)smallImagePath
                   andSmallImageWidth:(CGFloat)smallImageWidth
                  andSmallImageHeight:(CGFloat)smallImageHeight
                    andLargeImagePath:(NSString*)largeImagePath
                   andLargeImageWidth:(CGFloat)largeImageWidth
                  andLargeImageHeight:(CGFloat)largeImageHeight
                     andImageDescribe:(NSString*)describe{
    self = [super  init];
    if (self) {
        self.mbpImageInfoId = mbpImageInfoId;
        self.weChatImagePath =weChatImagePath;
        
        self.smallImagePath = smallImagePath;
        self.smallImageHeight = smallImageHeight;
        self.smallImageWidth = smallImageWidth;
        
        self.largeImagePath = largeImagePath;
        self.largeImageWidth = largeImageWidth;
        self.largeImageHeight = largeImageHeight;
        
        self.descContent = describe;
    }
    return self;
}

+(NSArray *)getWithArr{
    ZZMengBaoPaiImageInfo* info = [[ZZMengBaoPaiImageInfo alloc]init];
    info.largeImageHeight = 55.0;
    info.largeImagePath = @"户外帮助.jpg";
    info.largeImageWidth = 280.0;
    info.descContent = @"这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地";
    ZZMengBaoPaiImageInfo* info1 = [[ZZMengBaoPaiImageInfo alloc]init];
    info1.largeImageHeight = 90.0;
    info1.largeImagePath = @"户外帮助.jpg";
    info1.largeImageWidth = 280.0;
    info1.descContent = @"这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地";
    ZZMengBaoPaiImageInfo* info2 = [[ZZMengBaoPaiImageInfo alloc]init];
    info2.largeImagePath = @"户外帮助.jpg";
    info2.largeImageHeight = 120.0;
    info2.largeImageWidth = 280.0;
    info2.descContent = @"这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地这是一个神奇的版块，可以谈天，可以说地";
    return @[info,info1,info2];
}
+(NSArray *)getWithImageArr{
    ZZMengBaoPaiImageInfo* info = [[ZZMengBaoPaiImageInfo alloc]init];
    info.largeImagePath = @"户外帮助.jpg";
    info.largeImageHeight = 120.0;
    info.largeImageWidth = 280.0;
    ZZMengBaoPaiImageInfo* info1 = [[ZZMengBaoPaiImageInfo alloc]init];
    info1.largeImagePath = @"户外帮助.jpg";
    info1.largeImageHeight = 90.0;
    info1.largeImageWidth = 280.0;
    ZZMengBaoPaiImageInfo* info2 = [[ZZMengBaoPaiImageInfo alloc]init];
    info2.largeImagePath = @"户外帮助.jpg";
    info2.largeImageHeight = 50.0;
    info2.largeImageWidth = 280.0;
    return @[info,info1,info2];
}
@end
