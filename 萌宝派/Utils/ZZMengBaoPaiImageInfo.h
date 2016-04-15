//
//  ZZMengBaoPaiImageInfo.h
//  萌宝派
//
//  Created by zhizhen on 14-11-24.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//
//图片信息
#import <Foundation/Foundation.h>

@interface ZZMengBaoPaiImageInfo : NSObject
@property(nonatomic)NSUInteger  mbpImageInfoId;
@property(nonatomic,strong)NSString*  weChatImagePath;//微信分享图片地址
@property(nonatomic,strong)NSString*  smallImagePath;//小图地址
@property(nonatomic,strong)NSString*  largeImagePath;//大图地址
@property(nonatomic,strong)NSString*  descContent;//内容
//小图宽高
@property(nonatomic)CGFloat  smallImageWidth;//图片宽度
@property(nonatomic)CGFloat  smallImageHeight;//图片高度
//大图宽高
@property(nonatomic)CGFloat   largeImageWidth;//图片宽度
@property(nonatomic)CGFloat   largeImageHeight;//图片高度
//图文图文图文
+(NSArray*)getWithArr;
//图文文文文文
+(NSArray*)getWithImageArr;
-(instancetype)initWithMbpImageInfoId:(NSUInteger)mbpImageInfoId
                   andWeChatImagePath:(NSString*)weChatImagePath
                    andSmallImagePath:(NSString*)smallImagePath
                   andSmallImageWidth:(CGFloat)smallImageWidth
                  andSmallImageHeight:(CGFloat)smallImageHeight
                    andLargeImagePath:(NSString*)largeImagePath
                   andLargeImageWidth:(CGFloat)largeImageWidth
                  andLargeImageHeight:(CGFloat)largeImageHeight
                     andImageDescribe:(NSString*)describe;
@end
