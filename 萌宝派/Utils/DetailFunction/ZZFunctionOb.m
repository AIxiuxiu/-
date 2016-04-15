//
//  ZZFunctionOb.m
//  萌宝派
//
//  Created by zhizhen on 15/5/18.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZFunctionOb.h"

@implementation ZZFunctionOb
+(NSMutableArray*)getPostDetailFunctionArrayWithPost:(ZZPost*)post{
//    -(NSArray *)labelArr{
//        if (!_labelArr) {
//            _labelArr = @[@"收藏",@"分享",@"举报",@"正序"];
//        }
//        return _labelArr;
//    }
//    
//    -(NSArray *)imageArr{
//        if (!_imageArr) {
//            _imageArr = @[@"collect_40x40",@"share_selected_40x40",@"report_40x40",@"order_40x40"];
//        }
//        return _imageArr;
//    }
    NSMutableArray*  backArray = [NSMutableArray  arrayWithCapacity:4];
    //收藏  不是本人发的才有
    if (!post.postUser.isCurrentUser) {
        ZZFunctionOb*  collectionFunctionOb = [[ZZFunctionOb  alloc]init];
        collectionFunctionOb.fImageNameStr = @"collect_40x40.png";
        if (post.postStoreUp) {
            collectionFunctionOb.fNameStr = @"已收藏";
        }else {
            collectionFunctionOb.fNameStr = @"收藏";
        }
        collectionFunctionOb.functionObType = ZZFunctionObTypeCollection;
        [backArray  addObject:collectionFunctionOb];
    }

    //分享
    ZZFunctionOb*  shareFunctionOb = [[ZZFunctionOb alloc]init];
    shareFunctionOb.fImageNameStr =@"share_selected_40x40.png";
    shareFunctionOb.fNameStr = @"分享";
    shareFunctionOb.functionObType = ZZFunctionObTypeShare;
    [backArray  addObject:shareFunctionOb];
    //举报  案例没有举报
    if (![post.postPlateType.areaType  isEqualToString:@"HELP"]) {
        ZZFunctionOb*   reportFunctionOb = [[ZZFunctionOb  alloc]init];
        reportFunctionOb.fImageNameStr = @"report_40x40.png";
        reportFunctionOb.fNameStr = @"举报";
        reportFunctionOb.functionObType = ZZFunctionObTypeReport;
        [backArray  addObject:reportFunctionOb];
    }
    //顺序
    ZZFunctionOb*  orderFunctionOb = [[ZZFunctionOb  alloc]init];
    orderFunctionOb.fImageNameStr = @"order_40x40.png";
    orderFunctionOb.fNameStr =@"倒序";
    orderFunctionOb.functionObType = ZZFunctionObTypeOrder;
    [backArray  addObject:orderFunctionOb];
    return backArray;
}

@end
