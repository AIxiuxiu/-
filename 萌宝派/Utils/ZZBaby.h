//
//  ZZBaby.h
//  聪明宝宝
//
//  Created by ZZWangtao on 14-8-25.
//  Copyright (c) 2014年 ZZWangtao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZZMengBaoPaiImageInfo.h"

typedef NS_ENUM(NSInteger, ZZAgeShowType){
    
    ZZAgeShowTypeDay = 1,
   
    ZZAgeShowTypeMonth = 2,
    
    ZZAgeShowTypeYear = 3,
    
    ZZAgeShowTypeWeek = 4,
};


typedef NS_ENUM(NSInteger, ZZFashionState){
    
    ZZFashionStateConstellation = 1,     //星座
    
    ZZFashionStateZodiac = 2,            //生肖

};

@interface ZZBaby : NSObject

@property(nonatomic)NSUInteger  babyId;       //宝宝ID
@property(nonatomic,strong)NSString* nick;//宝宝名字
@property(nonatomic,strong)NSString*   birthday;//宝宝生日
@property(nonatomic,strong)NSString* area;//所在地
@property(nonatomic,assign)NSUInteger sex;//性别         1男  2女
@property(nonatomic,strong)ZZMengBaoPaiImageInfo* imageInfo;//图片信息
@property(nonatomic,strong)NSString* birthDate;//日志时期
@property(nonatomic)NSInteger ageCount;
@property(nonatomic)NSInteger growingCount;

@property(nonatomic,strong)NSMutableArray*   babyRecordInfoArray;//  宝宝记录信息数组
//@property(nonatomic,strong)ZZUser*  creatUser;    //宝宝的创建者
//@property(nonatomic,strong)NSArray*  attentionUsers;//宝宝的关注数组
//@property(nonatomic)BOOL  isInfoOpen;//是否公开宝宝信息

@property(nonatomic,strong)NSArray*  babyImages;//宝宝相册照片对象
//本地


@property(nonatomic,assign)ZZFashionState  fashionState ;//星座还是生肖   ****
@property(nonatomic,strong)NSString* constellation;//星座
@property(nonatomic,assign)ZZAgeShowType  ageShowType;//显示的是日龄  月龄  还是年龄
@property(nonatomic,strong)NSString* mumKnow;
@property(nonatomic,strong)NSArray* advice;//每日建议  ／／大改
@property(nonatomic)BOOL  changed;


+(NSArray*)getAdvicesByIndex:(NSUInteger)index    andType:(NSInteger)type;

//@property(nonatomic,strong)NSDictionary*  recordDic;//记录字典

//通过生日 和显示的年龄类型  得到一个对应的数字
-(NSInteger)getAgeFromBirthday:(NSString*)date  byAgeShowType:(ZZAgeShowType)ageShowType;
//通过生日和 选择的是星座还是生肖 对应返回对应的星座或生肖
-(NSString*)getFashionStateFromBirthday:(NSDate*)date  byFashionState:(ZZFashionState)fashionState;
//得到生日的string显示
-(NSString*)getBirthdayString:(NSDate*)birthday;
//得到记录时间的string显示
-(NSString*)getRecodeDateString:(NSDate*)recodeDate;
//-(NSArray*)getPointByRecord:(NSDictionary*)dic;

//得到mum  do you  know?
-(NSString*)getMumKnowByBabyBirthday:(NSDate*)birDate;
//得到建议信息数组
-(NSArray*)getAdvicesByBabyBirthday:(NSDate*)birDate  andSex:(NSInteger)sex;
//求记录最大最小值
-(NSInteger)getMaxRecordWithIndex:(NSInteger)index;
-(NSInteger)getMinRecordWithIndex:(NSInteger)index;

////得到宝宝几岁
//-(NSString*)getBabyNoteByDate:(NSDate*)date;

//时间  早上  下午 凌晨
-(NSString*)getGreetingString;
@end
