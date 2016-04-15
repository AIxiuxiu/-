//
//  ZZUser.m
//  萌宝派
//
//  Created by zhizhen on 14-11-5.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZUser.h"

static ZZUser* sharedSingleLoginUser;
@interface ZZUser ()
@property(nonatomic,strong)NSArray* bigLevelImagePaths;
@property(nonatomic,strong)NSArray* smallLevelImagePaths;
@property(nonatomic,strong)NSArray*  classImagePaths;
@end
@implementation ZZUser
-(NSArray *)bigLevelImagePaths{
    if (!_bigLevelImagePaths) {
        _bigLevelImagePaths = @[@"user_level_one_24x24.jpg",@"user_level_two_24x24.jpg",@"user_level_three_24x24.jpg",@"user_level_four_24x24.jpg"];
    }
    return _bigLevelImagePaths;
}
-(NSArray *)smallLevelImagePaths{
    if (!_smallLevelImagePaths) {
        _smallLevelImagePaths = @[@"user_child_level_one_10x10.jpg",@"user_child_level_two_10x10.jpg",@"user_child_level_three_10x10.jpg",@"user_child_level_four_10x10.jpg",@"user_child_level_five_10x10.jpg"];
    }
    return _smallLevelImagePaths;
}
-(NSArray *)classImagePaths{
    if (!_classImagePaths) {
        _classImagePaths = @[@"user_tarento_level_one_10x10.jpg",@"user_tarento_level_two_10x10.jpg",@"user_tarento_level_three_10x10.jpg",@"user_tarento_level_four_10x10.jpg",@"user_tarento_level_five_10x10.jpg"];
    }
    return _classImagePaths;
}
-(instancetype)initWithId:(NSUInteger)userId
                  andNick:(NSString *)nick
             andLoginTime:(NSUInteger)loginTime
          andmbpImageInfo:(ZZMengBaoPaiImageInfo *)mbpImageinfo{
    self = [super  init];
    if (self) {
        self.userId = userId;
        self.nick = nick;
        self.loginTime = loginTime;
        self.mbpImageinfo = mbpImageinfo;
    }
    return self;
}

+(ZZUser*)shareSingleUser{

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedSingleLoginUser = [[self alloc] init];

    });
    
    return sharedSingleLoginUser;
}
//清空user
+(void)cleanUserValue{
    sharedSingleLoginUser =[[ZZUser  alloc]init];
}
+(NSArray*)getIdentifyArray{
    return @[@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"外公",@"外婆",@"叔叔",@"阿姨",@"其他亲属"];
}

-(NSString*)getUserIdentifyByIden:(NSUInteger)iden{
    if (iden<60&&iden>0) {
        
        iden %=30;
        if (iden>[ZZUser  getIdentifyArray].count) {
            iden = [ZZUser  getIdentifyArray].count;
        }
        return [ZZUser   getIdentifyArray][iden-1];
    }else{
        return nil;
    }
}
-(CGFloat)getIntergrLevelWithLoginTime:(NSUInteger)time  andHelpLevel:(NSUInteger)helpLevel{
    CGFloat  allLevel = 0;


    if (time < 40) {
        allLevel = time/8%5;
    }else if (time < 160 && time >= 40){
        allLevel = ((time - 40)/24)%5 + 5;
    }else if (time < 560 && time >= 160){
        allLevel = ((time - 160)/72)%5 + 10;
    }else if (time < 1640 && time >= 560){
        allLevel = ((time - 560)/216)%5 + 15;
    }else{
        allLevel = 20;
    }
    
    if (helpLevel < 20) {
      allLevel += 1.8;
    }else if (helpLevel < 60 && helpLevel > 19){
        allLevel += 1.8*2;
    }else if (helpLevel < 140 && helpLevel > 59){
        allLevel += 1.8*3;
    }else if (helpLevel < 300 && helpLevel > 139){
       allLevel += 1.8*4;
    }else if (helpLevel < 620 && helpLevel > 299){
        allLevel += 1.8*5;
    }else{
        allLevel += 1.8*5;
    }
    
    return allLevel;
}

//大图标
-(NSString*)getBigLevelImagePathWithLoginTime:(NSInteger)loginTime{
    NSUInteger activeNumber;
    
    if (loginTime < 40) {
        activeNumber = (loginTime/8)/5;
    }else if (loginTime < 160 && loginTime >= 40){
        activeNumber = ((loginTime - 40)/24)/5 + 1;
    }else if (loginTime < 560 && loginTime >= 160){
        activeNumber = ((loginTime - 160)/72)/5 + 2;
    }else if (loginTime < 1640 && loginTime >= 560){
        activeNumber = ((loginTime - 560)/216)/5 + 3;
    }else{
        activeNumber = 6;
    }
    NSString*  bigLevelImagePath;
    switch (activeNumber) {
        case 0:
            bigLevelImagePath = self.bigLevelImagePaths[0];
            break;
        case 1:
            bigLevelImagePath = self.bigLevelImagePaths[1];
            break;
        case 2:
            bigLevelImagePath = self.bigLevelImagePaths[2];
            break;
        case 3:
            bigLevelImagePath = self.bigLevelImagePaths[3];
            break;
        case 4:
            bigLevelImagePath = self.bigLevelImagePaths[4];
            break;
        case 6:
            bigLevelImagePath = self.bigLevelImagePaths[4];
            break;
            
    }
    
    return bigLevelImagePath;
}

//小图标
-(NSString*)getSmallLevelImagePathWithLoginTime:(NSInteger)loginTime{
    NSUInteger smallNumber;
    //小等级图标
    if (loginTime < 40) {
        smallNumber = (loginTime/8)%5;
    }else if (loginTime < 160 && loginTime >= 40){
        smallNumber = ((loginTime - 40)/24)%5;
    }else if (loginTime < 560 && loginTime >= 160){
        smallNumber = ((loginTime - 160)/72)%5;
    }else if (loginTime < 1640 && loginTime >= 560){
        smallNumber = ((loginTime - 560)/216)%5;
    }else{
        smallNumber = 6;
    }
    NSString*  smallLevelImagePath;
    switch (smallNumber) {
        case 0:
            smallLevelImagePath = self.smallLevelImagePaths[0];
            break;
        case 1:
            smallLevelImagePath = self.smallLevelImagePaths[1];
            break;
        case 2:
            smallLevelImagePath = self.smallLevelImagePaths[2];
            break;
        case 3:
            smallLevelImagePath = self.smallLevelImagePaths[3];
            break;
        case 4:
            smallLevelImagePath = self.smallLevelImagePaths[4];
            break;
        case 6:
            smallLevelImagePath = self.smallLevelImagePaths[4];
            break;
            
    }
    return smallLevelImagePath;
    
}

-(NSString*)getClassImagePathWithHelpLevel:(NSInteger)helpLevel{
    NSUInteger helpNumber;
    //帮助经验图标
    
    if (helpLevel < 20) {
        helpNumber = 1;
    }else if (helpLevel < 60 && helpLevel > 19){
        helpNumber = 2;
    }else if (helpLevel < 140 && helpLevel > 59){
        helpNumber = 3;
    }else if (helpLevel < 300 && helpLevel > 139){
        helpNumber = 4;
    }else if (helpLevel < 620 && helpLevel > 299){
        helpNumber = 5;
    }else{
        helpNumber = 6;
    }
    NSString*  classImagePath;
    switch (helpNumber) {
        case 1:
            classImagePath = self.classImagePaths[0];
            break;
        case 2:
            classImagePath = self.classImagePaths[1];
            break;
        case 3:
            classImagePath = self.classImagePaths[2];
            break;
        case 4:
            classImagePath = self.classImagePaths[3];
            break;
        case 5:
            classImagePath = self.classImagePaths[4];
            break;
        case 6:
            classImagePath = self.classImagePaths[4];
            break;
    }
    return classImagePath;
    
}
-(NSString*)getClassImagePathWithDaRenLevel:(NSInteger)daRenLevel{
 NSString*  classImagePath;
    switch (daRenLevel) {
        case 0:
            classImagePath = self.classImagePaths[0];
            break;
        case 1:
            classImagePath = self.classImagePaths[1];
            break;
        case 2:
            classImagePath = self.classImagePaths[2];
            break;
        case 3:
            classImagePath = self.classImagePaths[3];
            break;
        case 4:
            classImagePath = self.classImagePaths[4];
            break;
      
            default:
             classImagePath = self.classImagePaths[4];
            break;
    }
    return classImagePath;
}

-(NSString*)getUserIdentify{
    
    switch (self.permissions) {
        case 1:
            return @"萌宝管理员";
        
        case 2:
          return @"萌宝小编";
          
        case 3:
            if (self.isSuperStarUser) {
                return [NSString   stringWithFormat:@"%@达人",self.superStarName];
            }else{
                return @"萌宝用户";
            }
     
        case 4:
            return @"萌宝专家";
        case 5:
            return @"在线小编";
        case 6:
            return @"萌宝萌主";
        case 7:
            return @"实习萌主";
            default:
            return @"萌宝用户";
    }
  
}
-(NSString *)getUserPersonalCenterBackGroundImageName{
    switch (self.permissions) {
        case 1:
            return  @"big_bk_four_320x200.jpg";
       
        case 2:
            return @"big_bk_five_320x200.jpg";
        case 3:
            switch (self.status) {
                case 1:
                    return @"big_bk_one_320x200.jpg";
                
                case 2:
                    return @"big_bk_two_320x200.jpg";
             
                case 3:
                    return @"big_bk_three_320x200.jpg";
                  
                default:
                    return @"big_bk_one_320x200.jpg";
                  
            }
            break;
        case 4:
            return @"big_bk_six_320x200.jpg";
       
        default:
           return @"big_bk_one_320x200.jpg";
    }
}

+(void)updateConnectPerson{
    [[NSNotificationCenter  defaultCenter]postNotificationName:ZZConnectPersonChangeNotification object:nil];
}

+(void)updateAttentionPlate:(NSUInteger) plateId  add:(BOOL)addOrDele{
    NSDictionary *userInfo  = @{@"plateId":@(plateId),@"addOrDele":@(addOrDele)};
    [[NSNotificationCenter  defaultCenter]postNotificationName:ZZAttentionPlateChangeNotification object:userInfo];
}

/**
 *  更新帖子收藏信息
 */
+(void)updateStorePost:(NSUInteger) postId areaType:(NSString *)areaType add:(BOOL)addOrDele{
    NSDictionary *userInfo  = @{@"postId":@(postId),@"addOrDele":@(addOrDele),@"areaType":areaType};
    [[NSNotificationCenter  defaultCenter]postNotificationName:ZZStorePostChangeNotification object:userInfo];
}
@end
