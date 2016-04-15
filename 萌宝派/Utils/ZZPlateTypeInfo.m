//
//  ZZPlateTypeInfo.m
//  萌宝派
//
//  Created by zhizhen on 15-3-17.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

static NSString *wonType = @"WONDERFUL";
static NSString *ageType = @"AGEBREAKET";
static NSString *cityType = @"LOCAL";
static NSString *caseType = @"HELP";
#import "ZZPlateTypeInfo.h"

@implementation ZZPlateTypeInfo
-(instancetype)initWithPlateId:(NSUInteger)plated
                      andTitle:(NSString*)title
                    andContent:(NSString*)content
                       andType:(NSString*)type
                  andInterface:(NSString*)interface
               andPublishCount:(NSInteger)count
               andMbpImageInfo:(ZZMengBaoPaiImageInfo*)mbpImageInfo
                   andAreaType:(NSString*)areaType{
    self = [super  init];
    if (self) {
        self.plateId = plated;
        self.title = title;
        self.content = content;
        self.type = type;
        self.interface = interface;
        self.publishCount = count;
        self.mbpImageInfo = mbpImageInfo;
        self.areaType = areaType;
    }
    
    return self;
}

+(ZZPlateTypeInfoAreaTYpe)plateAreaTypeNumber:(NSString *)areaType{
    if ([areaType.lowercaseString  isEqualToString:wonType.lowercaseString]) {
        return ZZPlateTypeInfoAreaTYpeWon;
    }else if([areaType.lowercaseString  isEqualToString:ageType.lowercaseString]){
        return ZZPlateTypeInfoAreaTYpeAge;
    }else if([areaType.lowercaseString  isEqualToString:cityType.lowercaseString]){
        return ZZPlateTypeInfoAreaTYpeCity;
    }else{
        return ZZPlateTypeInfoAreaTYpeCase;
    }
 
}
@end
