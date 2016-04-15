//
//  ZZLibCacheTool.m
//  萌宝派
//
//  Created by zhizhen on 15/6/25.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZLibCacheTool.h"
#import "ZZLibCacheDB.h"
#import "ZZJsonParse.h"
@implementation ZZLibCacheTool
+ (void)saveCacheData:(NSDictionary*)cache  libName:(NSString*)libName{
    [ZZLibCacheDB  updateOrAddCacheData:cache libName:libName];
}
+ (NSDictionary*)selectHomeNetDataWithLibName:(NSString*)libName{
    NSDictionary*  context = [ZZLibCacheDB   selectHomeNetDataWithLibName:libName];
    if ([context  isKindOfClass:[NSDictionary  class]]&&context.count) {
        NSMutableDictionary*  backDic = [NSMutableDictionary  dictionaryWithCapacity:context.count];
        NSArray*  eredarList = [context  objectForKey:@"eredarList"];
        if ([eredarList isKindOfClass:[NSArray  class]]&&eredarList.count) {
            NSMutableArray*  backEredarArray = [NSMutableArray arrayWithCapacity:eredarList.count];
            for (NSDictionary*  dic in eredarList) {
                ZZUser*  eredar = [ZZJsonParse  parseSuperStarListByDic:dic];
                if (eredar) {
                    [backEredarArray  addObject:eredar];
                }
            }
            [backDic  setObject:backEredarArray forKey:@"eredarList"];
        }
        NSArray*  homeImgList = [context  objectForKey:@"homeImgList"];
        if ([homeImgList isKindOfClass:[NSArray  class]]&&homeImgList.count) {
            NSMutableArray*   backImgArray = [NSMutableArray  arrayWithCapacity:homeImgList.count];
            for (NSDictionary* dic in homeImgList) {
                ZZPost*  mbpImage = [ZZJsonParse  parseImageInfoByDic:dic];
                if (mbpImage) {
                    [backImgArray  addObject:mbpImage];
                }
            }
            [backDic  setObject:backImgArray forKey:@"homeImgList"];
        }
        NSArray*  plateList = [context  objectForKey:@"plateList"];
        if ([plateList  isKindOfClass:[NSArray  class]]&&plateList.count) {
            NSMutableArray*  backPlateArray = [NSMutableArray  arrayWithCapacity:plateList.count];
            for (NSDictionary*  dic in plateList) {
                ZZPlateTypeInfo*  platetype = [ZZJsonParse  parsePlateTypeInfoByDic:dic];
                if (platetype) {
                    [backPlateArray  addObject:platetype];
                }
            }
            [backDic  setObject:backPlateArray forKey:@"plateList"];
        }
        return backDic;
    }else{
        return nil;
    }
}
@end
