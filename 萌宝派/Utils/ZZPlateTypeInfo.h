//
//  ZZPlateTypeInfo.h
//  萌宝派
//
//  Created by zhizhen on 15-3-17.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//
typedef enum {
    ZZPlateTypeInfoAreaTYpeWon,//精彩专区
    ZZPlateTypeInfoAreaTYpeAge,//同龄
    ZZPlateTypeInfoAreaTYpeCity,//同城
    ZZPlateTypeInfoAreaTYpeCase,//案例
    
}ZZPlateTypeInfoAreaTYpe;
#import <Foundation/Foundation.h>
#import "ZZMengBaoPaiImageInfo.h"
@interface ZZPlateTypeInfo : NSObject
@property(nonatomic)NSUInteger   plateId;
@property(nonatomic,strong)NSString*  title;  //标题
@property(nonatomic,strong)NSString*   content;//内容
@property(nonatomic,strong)NSString*   type;//板块类型
@property(nonatomic,strong)NSString*  interface;//接口
@property(nonatomic)NSUInteger  publishCount;//发帖数量
@property(nonatomic,strong)NSString*  areaType;//区域类型
@property(nonatomic,strong)ZZMengBaoPaiImageInfo*  mbpImageInfo;//图片信息
@property(nonatomic)BOOL  attention;
-(instancetype)initWithPlateId:(NSUInteger)plated
                      andTitle:(NSString*)title
                    andContent:(NSString*)content
                       andType:(NSString*)type
                  andInterface:(NSString*)interface
               andPublishCount:(NSInteger)count
               andMbpImageInfo:(ZZMengBaoPaiImageInfo*)mbpImageInfo
                   andAreaType:(NSString*)areaType;

+(ZZPlateTypeInfoAreaTYpe)plateAreaTypeNumber:(NSString *)areaType;

@end
