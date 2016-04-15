//
//  ZZJsonParse.m
//  萌宝派
//
//  Created by zhizhen on 14-10-23.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZJsonParse.h"
#import "ZZMengBaoPaiImageInfo.h"
#import "ZZMengBaoPaiRequest.h"
@implementation ZZJsonParse
#pragma  mark -----------板块详情
+(ZZPlateTypeInfo*)parsePlateTypeInfoByDic:(NSDictionary*)dic{
    if ([dic  isKindOfClass:[NSDictionary  class]]&&dic.count) {
        ZZPlateTypeInfo*   plateTypeInfo = [[ZZPlateTypeInfo  alloc]init];
        plateTypeInfo.plateId = [[dic objectForKey:@"id"]integerValue];
        plateTypeInfo.content =[self  removeWhitespaceAndNewlineCharacterWithOrignString:[dic  objectForKey:@"context"]];
        plateTypeInfo.title = [dic   objectForKey:@"title"];
        plateTypeInfo.type = [dic  objectForKey:@"type"];
        plateTypeInfo.interface =  [ZZJsonParse  removeTheFirstOrLastCharacterWithSpecifiedString:@"/" andOrignStr:[dic  objectForKey:@"connector"]] ;
        plateTypeInfo.publishCount = [[dic  objectForKey:@"count"]integerValue];
        NSString*  areaType = [dic  objectForKey:@"plateParentType"];
        if (areaType.length) {
             plateTypeInfo.areaType = areaType;
        }
       
        //
        ZZMengBaoPaiImageInfo*  mbpII = [[ZZMengBaoPaiImageInfo  alloc]init];
        mbpII.smallImagePath = [ZZJsonParse   stringReplacOfString:[dic   objectForKey:@"smallImg"]   ];
        mbpII.smallImageHeight = [[dic  objectForKey:@"smallImgHeight"]floatValue];
        mbpII.smallImageWidth = [[dic  objectForKey:@"smallImgWidth"]floatValue];
        
        mbpII.largeImagePath = [ZZJsonParse  stringReplacOfString:[dic  objectForKey:@"bigImg"]];
        mbpII.largeImageHeight = [[dic  objectForKey:@"bigImgHeight"]floatValue];
        mbpII.largeImageWidth = [[dic  objectForKey:@"smallImgWidth"]floatValue];
        
      //  mbpII.smallImagePath = @"3.jpg";
    
        plateTypeInfo.mbpImageInfo = mbpII;
        return plateTypeInfo;
    }else{
        return nil;
    }
}
#pragma  mark -----------登录用户信息
+(void)parseLoginUserInfoByDic:(NSDictionary*)dic{
    if ([dic  isKindOfClass:[NSDictionary  class]]) {
        ZZUser*  user = [ZZUser  shareSingleUser];
        user.nick = [dic  objectForKey:@"nike"];
        user.loginTime = [[dic  objectForKey:@"loginTimes"]integerValue];
        user.gold = [[dic  objectForKey:@"gold"]integerValue];
        user.status = [[dic  objectForKey:@"userStatus"]integerValue];
        user.permissions = [[dic  objectForKey:@"authority"]integerValue];
        //
        user.isSuperStarUser = [[dic  objectForKey:@"eredar"]boolValue];
        user.superStarLv = [[dic  objectForKey:@"eredarRank"]integerValue];
        user.superStarType = [[dic  objectForKey:@"eredarType"]intValue];
        user.superStarName = [dic objectForKey:@"eredarName"];
        user.isCurrentUser = YES;
        ZZMengBaoPaiImageInfo*  mbpII =
        [[ZZMengBaoPaiImageInfo  alloc]initWithMbpImageInfoId:0
                                           andWeChatImagePath:[ZZJsonParse  stringReplacOfString:[dic  objectForKey:@"userWeiXinHeadImg"]]
                                            andSmallImagePath:[ZZJsonParse  stringReplacOfString:[dic  objectForKey:@"userSmallHeadImg"]]
                                           andSmallImageWidth:[[dic  objectForKey:@"smallImgWidth"]floatValue]
                                          andSmallImageHeight:[[dic  objectForKey:@"smallImgHeight"]floatValue]
                                            andLargeImagePath:[ZZJsonParse  stringReplacOfString:[dic  objectForKey:@"userBigHeadImg"]]
                                           andLargeImageWidth:[[dic  objectForKey:@"bigImgWidth"]floatValue]
                                          andLargeImageHeight:[[dic  objectForKey:@"bigImgHeight"]floatValue]
                                             andImageDescribe:nil];
        
        user.mbpImageinfo = mbpII;
        
        user.publishCount = [[dic  objectForKey:@"publishCount"]integerValue];
        user.attentionCount = [[dic objectForKey:@"attentionCount"]integerValue];
        user.storeCount  =[[dic  objectForKey:@"storeCount"]integerValue];
    }

}
#pragma  mark -----------更新登录用户信息
+(void)parseUpdateLoginUserInfoByDic:(NSDictionary*)dic{
    if ([dic  isKindOfClass:[NSDictionary  class]]) {
        ZZUser*  user = [ZZUser  shareSingleUser];
        user.nick = [dic  objectForKey:@"nike"];
        user.loginTime = [[dic  objectForKey:@"loginTimes"]integerValue];
        user.gold = [[dic  objectForKey:@"gold"]integerValue];
        user.status = [[dic  objectForKey:@"userStatus"]integerValue];//
        //
        user.isSuperStarUser = [[dic  objectForKey:@"eredar"]boolValue];
        user.superStarLv = [[dic  objectForKey:@"eredarRank"]integerValue];
        user.superStarType = [[dic  objectForKey:@"eredarType"]intValue];
        user.superStarName = [dic objectForKey:@"eredarName"];
        user.isCurrentUser = YES;
        ZZMengBaoPaiImageInfo*  mbpII =
        [[ZZMengBaoPaiImageInfo  alloc]initWithMbpImageInfoId:0
                                           andWeChatImagePath:[ZZJsonParse  stringReplacOfString:[dic  objectForKey:@"userWeiXinHeadImg"]]
                                            andSmallImagePath:[ZZJsonParse  stringReplacOfString:[dic  objectForKey:@"userSmallHeadImg"]]
                                           andSmallImageWidth:[[dic  objectForKey:@"smallImgWidth"]floatValue]
                                          andSmallImageHeight:[[dic  objectForKey:@"smallImgHeight"]floatValue]
                                            andLargeImagePath:[ZZJsonParse  stringReplacOfString:[dic  objectForKey:@"userBigHeadImg"]]
                                           andLargeImageWidth:[[dic  objectForKey:@"bigImgWidth"]floatValue]
                                          andLargeImageHeight:[[dic  objectForKey:@"bigImgHeight"]floatValue]
                                             andImageDescribe:nil];
  
        user.mbpImageinfo = mbpII;
    }
}
#pragma mark 同龄同城竖版解析方法
//
+(ZZPost*)parseSameAgeVerticalVersionPostInfoByDic:(NSDictionary*)dic{
     if ([dic  isKindOfClass:[NSDictionary  class]]) {
         //图片
         NSString*  bigImg = [dic  objectForKey:@"bigImg"];
         NSMutableArray*  marray = nil;
         if (bigImg.length) {
             NSArray*   bigImagePathArray = [bigImg  componentsSeparatedByString:@"^#^" ];
             NSArray*   smallImagePathArray = [[dic  objectForKey:@"smallImg"]  componentsSeparatedByString:@"^#^" ];
             NSUInteger   min = bigImagePathArray.count>smallImagePathArray.count?smallImagePathArray.count:bigImagePathArray.count;
             
          marray =  [NSMutableArray  arrayWithCapacity:min];
             for (int i = 0; i<min; i++) {
                 NSArray*  bigImageInfoArray = [bigImagePathArray[i]  componentsSeparatedByString:@","];
                 NSArray*  smallImageInfoArray = [smallImagePathArray[i]  componentsSeparatedByString:@","];
                  ZZMengBaoPaiImageInfo* imageInfo = nil;
                 
                 
                 /*
                 if (bigImageInfoArray.count==4) {
                     imageInfo = [[ZZMengBaoPaiImageInfo alloc]initWithMbpImageInfoId:0
                                                                   andWeChatImagePath:nil
                                                                    andSmallImagePath:[ZZJsonParse stringReplacOfString:smallImageInfoArray[1]] andSmallImageWidth:[smallImageInfoArray[2] floatValue]
                                                                  andSmallImageHeight:[smallImageInfoArray[3] floatValue]
                                                                    andLargeImagePath:[ZZJsonParse stringReplacOfString:bigImageInfoArray[1]] andLargeImageWidth:[bigImageInfoArray[2] floatValue]
                                                                  andLargeImageHeight:[bigImageInfoArray[3] floatValue]
                                                                     andImageDescribe:bigImageInfoArray[0]];
                 }else{
                     imageInfo = [[ZZMengBaoPaiImageInfo alloc]init];
                     if (smallImageInfoArray.count==3) {
                         imageInfo.smallImagePath =[ZZJsonParse stringReplacOfString:smallImageInfoArray[0]];
                         imageInfo.smallImageWidth =[smallImageInfoArray[1] floatValue];
                         imageInfo.smallImageHeight =[smallImageInfoArray[2] floatValue];
                         
                     }
                     if (bigImageInfoArray.count==3) {
                         imageInfo.largeImagePath =[ZZJsonParse stringReplacOfString:bigImageInfoArray[0]];
                         imageInfo.largeImageWidth =[bigImageInfoArray[1] floatValue];
                         imageInfo.largeImageHeight =[bigImageInfoArray[2] floatValue];
                     }
//                 WithMbpImageInfoId:0
//                 andWeChatImagePath:nil
//                 andSmallImagePath: andSmallImageWidth:
//                 andSmallImageHeight:
//                 andLargeImagePath:[ZZJsonParse stringReplacOfString:bigImageInfoArray[0]] andLargeImageWidth:[bigImageInfoArray[1] floatValue]
//                 andLargeImageHeight:[bigImageInfoArray[2] floatValue]
//                 andImageDescribe:nil];
                 }
               */
                 /*
                  张亮亮 0511 修改
                  */
                 if (bigImageInfoArray.count>=3&&smallImageInfoArray.count>=3) {
                     NSUInteger  bigArrayCount = bigImageInfoArray.count;
                     NSUInteger  smallArrayCount = smallImageInfoArray.count;
                     
                     
                     NSMutableString*  desc ;
                     for (int i = 0; i<bigArrayCount-3; i++) {
                         if (!desc) {
                             desc = [NSMutableString  string];
                             
                         }
                         
                         [desc  appendString:bigImageInfoArray[i]];
                     }
                     imageInfo = [[ZZMengBaoPaiImageInfo alloc]initWithMbpImageInfoId:0
                                                                   andWeChatImagePath:nil
                                                                    andSmallImagePath:[ZZJsonParse stringReplacOfString:smallImageInfoArray[smallArrayCount-3]] andSmallImageWidth:[smallImageInfoArray[smallArrayCount-2] floatValue]
                                                                  andSmallImageHeight:[smallImageInfoArray[smallArrayCount-1] floatValue]
                                                                    andLargeImagePath:[ZZJsonParse stringReplacOfString:bigImageInfoArray[bigArrayCount-3]] andLargeImageWidth:[bigImageInfoArray[bigArrayCount-2] floatValue]
                                                                  andLargeImageHeight:[bigImageInfoArray[bigArrayCount-1] floatValue]
                                                                     andImageDescribe:desc];
                 }
                 
                 if(imageInfo){
                      [marray  addObject:imageInfo];
                 }
                
             }
 
         }
         //用户头像
         NSString*  userSmallHeadImg = [dic  objectForKey:@"userSmallHeadImg"];
         ZZMengBaoPaiImageInfo* userMbp =nil;
         if (userSmallHeadImg.length) {
             userMbp = [[ZZMengBaoPaiImageInfo  alloc]initWithMbpImageInfoId:0
                                                          andWeChatImagePath:nil
                                                           andSmallImagePath:[ZZJsonParse  stringReplacOfString:[dic
                                                                                                                 objectForKey:@"userSmallHeadImg"]]
                                                          andSmallImageWidth:[[dic  objectForKey:@"smallImgWidth"] floatValue]
                                                         andSmallImageHeight:[[dic  objectForKey:@"smallImgHeight"]floatValue]
                                                           andLargeImagePath:nil
                                                          andLargeImageWidth:0.0
                                                         andLargeImageHeight:0.0
                                                            andImageDescribe:nil];
         }
         //用户
     ZZUser*  user = [[ZZUser  alloc]initWithId:[[dic  objectForKey:@"userId"]integerValue]
                                        andNick:[dic  objectForKey:@"nike"]
                                   andLoginTime:[[dic  objectForKey:@"loginTimes"] integerValue]
                                andmbpImageInfo:userMbp];
         user.attention = [[dic  objectForKey:@"attent"]boolValue];
         user.permissions = [[dic  objectForKey:@"authority"]integerValue];
         user.isCurrentUser = [[dic  objectForKey:@"validCurrentUser"]boolValue];
         user.status = [[dic  objectForKey:@"userStatus"]integerValue];
         //用户达人信息
         user.isSuperStarUser = [[dic  objectForKey:@"eredar"]boolValue];
         user.superStarLv = [[dic  objectForKey:@"eredarRank"]integerValue];
         user.superStarType = [[dic  objectForKey:@"eredarType"]intValue];
        user.superStarName = [dic objectForKey:@"eredarName"];
         //帖子信息
         ZZPost*  post = [[ZZPost  alloc]initWithId:[[dic  objectForKey:@"id"]integerValue]
                                           andTitle:[dic  objectForKey:@"title"]
                                         andContent:[dic  objectForKey:@"context"]
                                     andImagesArray:marray
                                         andDateStr:[self  stringDateWithStr:[dic  objectForKey:@"date"] andDateFormatStr:@"MM-dd HH:mm"]
                                            andUser:user
                                      andReplyCount:[[dic  objectForKey:@"relpys"]integerValue]
                                       andPlateType:nil
                                           andJudge:[[dic  objectForKey:@"stick"]boolValue]
                                         andStoreUp:[[dic  objectForKey:@"store"]boolValue]];
         /*
          张亮亮  0513  加点赞
          */
         post.postCurrentUserSpot = [[dic  objectForKey:@"currentUserSpot"]boolValue];
         post.postSportCount  = [[dic  objectForKey:@"spotCount"]integerValue];
         
         
         // 详情不会返回板块信息
         NSString*  portConnector = [dic  objectForKey:@"portConnector"];
         if (portConnector.length) {
             ZZPlateTypeInfo*  plyte =[[ ZZPlateTypeInfo alloc]init];
             plyte.interface =[ZZJsonParse  removeTheFirstOrLastCharacterWithSpecifiedString:@"/" andOrignStr:[dic  objectForKey:@"portConnector"]];
             plyte.areaType =[dic  objectForKey:@"areaType"];
             plyte.plateId = [[dic  objectForKey:@"areaId"]integerValue];//为区域id
             plyte.title = [dic  objectForKey:@"plateName"];
             plyte.type = [dic  objectForKey:@"type"];
             
             post.postPlateType = plyte;
         }
        
         return post;
         
     }else{
         return nil;
     }
}
/*
#pragma mark 精彩竖版解析方法
+(ZZPost *)parseWonderFulPostInfoByDic:(NSDictionary *)dic{
    NSArray* bigImgArray = [[dic objectForKey:@"bigImg"] componentsSeparatedByString:@"^#^"];
    NSArray* smallImgArray = [[dic objectForKey:@"smallImg"] componentsSeparatedByString:@"^#^"];
    
    NSInteger min = bigImgArray.count>smallImgArray.count?smallImgArray.count:bigImgArray.count;
    NSMutableArray*  marray = [NSMutableArray arrayWithCapacity:min];
    for (int i = 0; i<min; i++) {
        NSArray* bigImageInfoArray = [bigImgArray[i] componentsSeparatedByString:@","];
        NSArray*  smallImageInfoArray = [smallImgArray[i]  componentsSeparatedByString:@","];
        ZZMengBaoPaiImageInfo* imageInfo = nil;
        if (bigImageInfoArray.count==4) {
            imageInfo = [[ZZMengBaoPaiImageInfo alloc]initWithMbpImageInfoId:0
                                                          andWeChatImagePath:nil
                                                           andSmallImagePath:[ZZJsonParse stringReplacOfString:smallImageInfoArray[1]] andSmallImageWidth:[smallImageInfoArray[2] floatValue]
                                                         andSmallImageHeight:[smallImageInfoArray[3] floatValue]
                                                           andLargeImagePath:[ZZJsonParse stringReplacOfString:bigImageInfoArray[1]] andLargeImageWidth:[bigImageInfoArray[2] floatValue]
                                                         andLargeImageHeight:[bigImageInfoArray[3] floatValue]
                                                            andImageDescribe:bigImageInfoArray[0]];
        }else{
            imageInfo = [[ZZMengBaoPaiImageInfo alloc]initWithMbpImageInfoId:0
                                                          andWeChatImagePath:nil
                                                           andSmallImagePath:[ZZJsonParse stringReplacOfString:smallImageInfoArray[0]] andSmallImageWidth:[smallImageInfoArray[1] floatValue]
                                                         andSmallImageHeight:[smallImageInfoArray[2] floatValue]
                                                           andLargeImagePath:[ZZJsonParse stringReplacOfString:bigImageInfoArray[0]] andLargeImageWidth:[bigImageInfoArray[1] floatValue]
                                                         andLargeImageHeight:[bigImageInfoArray[2] floatValue]
                                                            andImageDescribe:nil];
        }
        
        
        
        [marray  addObject:imageInfo];
    }
    
    NSString*  userSmallHeadImg = [dic  objectForKey:@"userSmallHeadImg"];
    ZZMengBaoPaiImageInfo* userImageInfo =nil;
    //用户头像解析
    if (userSmallHeadImg.length) {
       userImageInfo = [[ZZMengBaoPaiImageInfo alloc]initWithMbpImageInfoId:0 andWeChatImagePath:nil andSmallImagePath:[ZZJsonParse  stringReplacOfString:[dic objectForKey:@"userSmallHeadImg"]]
                                                                                 andSmallImageWidth:[[dic objectForKey:@"smallImgWidth"]floatValue] andSmallImageHeight:[[dic objectForKey:@"smallImgHeight"]floatValue] andLargeImagePath:nil andLargeImageWidth:0.0 andLargeImageHeight:0.0 andImageDescribe:nil];
        

    }
    
    //用户解析
    ZZUser* user = [[ZZUser alloc]initWithId:[[dic objectForKey:@"userId"]integerValue] andNick:[dic objectForKey:@"nick"] andLoginTime:[[dic objectForKey:@"loginTimes"]integerValue] andmbpImageInfo:userImageInfo];
    
    //整个帖子的解析
    ZZPost* post = [[ZZPost alloc]initWithId:[[dic objectForKey:@"id"]integerValue] andTitle:[dic objectForKey:@"title"] andContent:[dic objectForKey:@"context"] andImagesArray:marray andDateStr:[self  stringDateWithStr:[dic  objectForKey:@"date"] andDateFormatStr:@"MM-dd HH:mm"] andUser:user andReplyCount:[[dic objectForKey:@"relpys"]integerValue] andPlateType:nil andJudge:[[dic  objectForKey:@"stick"]boolValue] andStoreUp:[[dic  objectForKey:@"store"]boolValue]];
    return post;
}
 */
#pragma mark 回复解析
+(ZZReplayInformation*)parseSameAgePostReplyInfoByDic:(NSDictionary*)dic{
    if ([dic  isKindOfClass:[NSDictionary class]]) {
        //回复的信息
        ZZReplayInformation*  reply = [[ZZReplayInformation  alloc]init];
        reply.replayId =[[dic  objectForKey:@"id"]integerValue];
        reply.isDelete = [[dic objectForKey:@"deleteTag"]boolValue];
        if (reply.isDelete == NO) {
            reply.replayContent = [dic  objectForKey:@"context"];
            //回复的图片信息
            NSString*  bigImagePath =[ dic  objectForKey:@"bigImg"];
            if (bigImagePath.length) {
                ZZMengBaoPaiImageInfo*  mbp =
                [[ZZMengBaoPaiImageInfo  alloc]initWithMbpImageInfoId:0
                                                   andWeChatImagePath:[ZZJsonParse  stringReplacOfString:[dic  objectForKey:@"weixinImg"]   ]
                                                    andSmallImagePath:[ZZJsonParse  stringReplacOfString: [dic  objectForKey:@"smallImg"]]
                                                   andSmallImageWidth:[[dic  objectForKey:@"smallImgWidth"]floatValue]
                                                  andSmallImageHeight:[[dic  objectForKey:@"smallImgHeight"]floatValue]
                                                    andLargeImagePath:[ZZJsonParse  stringReplacOfString:[dic  objectForKey:@"bigImg"]]
                                                   andLargeImageWidth:[[dic  objectForKey:@"bigImgWidth"]floatValue]
                                                  andLargeImageHeight:[[dic  objectForKey:@"bigImgHeight"]floatValue]
                                                     andImageDescribe:nil];
                reply.imageInfo=mbp;
            }

        }
        reply.isCurrentUser = [[dic objectForKey:@"isCurrentUser"]boolValue];
        reply.replayTime = [self  stringDateWithStr:[dic  objectForKey:@"date"] andDateFormatStr:@"MM-dd HH:mm"] ;
        
        reply.floor = [[dic  objectForKey:@"floor"]integerValue];
        reply.replays = [[dic  objectForKey:@"replys"]integerValue];

      
        //回复的回复
        NSString*  otherNick = [dic  objectForKey:@"otherNike"];
        if (otherNick.length) {
            ZZReplayInformation*  relReply =[[ZZReplayInformation alloc]init];
       
           
            relReply.isDelete = [[dic   objectForKey:@"otherDeleteTag"]boolValue];
            if (relReply.isDelete == NO) {
                 relReply.replayContent = [dic  objectForKey:@"otherContext"];
            }
            relReply.floor = [[dic  objectForKey:@"otherFloor"]integerValue];
            
            ZZUser*  user =[[ ZZUser  alloc]init];
            user.userId = [[dic  objectForKey:@"otherUserId"]integerValue];
            user.nick = [dic  objectForKey:@"otherNike"];
            
            //
            NSString*  headImagePath = [dic  objectForKey:@"otherUserSmallHeadImg"];
            if (headImagePath.length) {
                ZZMengBaoPaiImageInfo*  mbp =     [[ZZMengBaoPaiImageInfo  alloc]initWithMbpImageInfoId:0
                                                                                     andWeChatImagePath:nil
                                                                                      andSmallImagePath:[ZZJsonParse  stringReplacOfString:[dic  objectForKey:@"otherUserSmallHeadImg"]]
                                                                                     andSmallImageWidth:[[dic  objectForKey:@"otherUserSmallImgWidth"]floatValue]
                                                                                    andSmallImageHeight:[[dic  objectForKey:@"otherUserSmallImgHeight"]floatValue]
                                                                                      andLargeImagePath:nil
                                                                                     andLargeImageWidth:0.0
                                                                                    andLargeImageHeight:0.0
                                                                                       andImageDescribe:nil];
                user.mbpImageinfo = mbp;
            }
    
            relReply.user = user;
            
            reply.relReplayPost =relReply;
        }
        //回复的用户
        ZZUser*  user =[[ ZZUser  alloc]init];
        user.userId = [[dic  objectForKey:@"userId"]integerValue];
        user.nick = [dic  objectForKey:@"nike"];
        user.permissions = [[dic  objectForKey:@"authority"]integerValue];
        //
        user.isSuperStarUser = [[dic  objectForKey:@"eredar"]boolValue];
        user.superStarLv = [[dic  objectForKey:@"eredarRank"]integerValue];
        user.superStarType = [[dic  objectForKey:@"eredarType"]intValue];
        user.superStarName = [dic objectForKey:@"eredarName"];
        //回复的用户头像
        NSString*  headImagePath = [dic  objectForKey:@"userSmallHeadImg"];
        if (headImagePath.length) {
            ZZMengBaoPaiImageInfo*  mbp =     [[ZZMengBaoPaiImageInfo  alloc]initWithMbpImageInfoId:0
                                                                                 andWeChatImagePath:nil
                                                                                  andSmallImagePath:[ZZJsonParse  stringReplacOfString:[dic  objectForKey:@"userSmallHeadImg"]]
                                                                                 andSmallImageWidth:[[dic  objectForKey:@"userSmallImgWidth"]floatValue]
                                                                                andSmallImageHeight:[[dic  objectForKey:@"userSmallImgHeight"]floatValue]
                                                                                  andLargeImagePath:nil
                                                                                 andLargeImageWidth:0.0
                                                                                andLargeImageHeight:0.0
                                                                                   andImageDescribe:nil];
            user.mbpImageinfo = mbp;
        }
        reply.user =user;
        return reply;
    }else{
        return nil;
    }
    
}


#pragma mark 宝宝基本信息
+(ZZBaby*)parseBabyInfoByDic:(NSDictionary*)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        ZZBaby* babyinfo = [[ZZBaby alloc]init];
        babyinfo.babyId = [[dic objectForKey:@"babyId"]integerValue];
        babyinfo.nick = [dic objectForKey:@"babyNick"];
        babyinfo.sex = [[dic objectForKey:@"babySex"]integerValue];
        babyinfo.birthday = [dic objectForKey:@"brithday"];
        babyinfo.imageInfo = [[ZZMengBaoPaiImageInfo alloc]initWithMbpImageInfoId:0 andWeChatImagePath:nil andSmallImagePath:[ZZJsonParse stringReplacOfString:[dic objectForKey:@"babySmallHeadImg"]] andSmallImageWidth:[[dic objectForKey:@"smallImgWidth"]floatValue] andSmallImageHeight:[[dic objectForKey:@"smallImgHeight"]floatValue] andLargeImagePath:[ZZJsonParse stringReplacOfString:[dic objectForKey:@"babyBigHeadImg"]] andLargeImageWidth:[[dic objectForKey:@"bigImgWidth"]floatValue] andLargeImageHeight:[[dic objectForKey:@"bigImgHeight"]floatValue] andImageDescribe:nil];
        babyinfo.ageCount = [[dic objectForKey:@"ageCount"]integerValue];
        babyinfo.growingCount = [[dic objectForKey:@"growingCount"]integerValue];
        return babyinfo;
    }else
        return nil;
    
}
#pragma mark 宝宝日志信息
+(ZZBabyDiaryInfo*)parseBabyDiaryByDic:(NSDictionary*)dic{
    if ([dic  isKindOfClass:[NSDictionary  class]]) {
        ZZBabyDiaryInfo* diaryinfo = [[ZZBabyDiaryInfo alloc]init];
    
            NSString* bigImg = [dic objectForKey:@"bigImg"];
            NSString* smallImg = [dic objectForKey:@"smallImg"];
            //大小图解析
            NSArray* bigImgInfo =  [bigImg componentsSeparatedByString:@"^#^"];
            NSArray* smallImgInfo =  [smallImg componentsSeparatedByString:@"^#^"];
        NSString*  contentInfo = [dic  objectForKey:@"context"];
        if ([contentInfo isKindOfClass:[NSString class]]) {
            
        }else{
            contentInfo = @"";
        }
       
        NSArray* contentArray  = [contentInfo   componentsSeparatedByString:@"^#^"];
//            //图的描述
//            NSString* imageStr = [dic objectForKey:@"context"] ;
//            if ([imageStr isKindOfClass:[NSString class]]) {
//                
//            }else{
//                imageStr = @"";
//            }
//            NSArray* imageStrArr = [imageStr componentsSeparatedByString:@"^#^"];
        
            NSMutableArray*  marray = [NSMutableArray arrayWithCapacity:bigImgInfo.count];
            for (int i = 0; i<bigImgInfo.count; i++) {
//                NSString* imgStr  ;
//                if (![imageStrArr[i] isKindOfClass:[NSString class]]||[imageStrArr[i] isEqualToString:@"null"]) {
//                    imgStr = @"";
//                }else{
//                    imgStr = imageStrArr[i];
//                }
                NSArray* bigImgInfoArray = [bigImgInfo[i] componentsSeparatedByString:@","];
                NSArray* smallImgInfoArray = [smallImgInfo[i] componentsSeparatedByString:@","];
                ZZMengBaoPaiImageInfo* imageInfo = nil;
                /*
                 张亮亮 0511 修改
                 */
                if (bigImgInfoArray.count>=3&&smallImgInfoArray.count>=3) {
                    NSUInteger  bigArrayCount = bigImgInfoArray.count;
                    NSUInteger  smallArrayCount = smallImgInfoArray.count;
                    
                    
                    NSString*  desc ;
                    if (![contentArray[i] isKindOfClass:[NSString class]]||[contentArray[i] isEqualToString:@"null"]) {
                        desc = @"";
                    }else{
                        desc = contentArray[i];
                    }
                    imageInfo = [[ZZMengBaoPaiImageInfo alloc]initWithMbpImageInfoId:0
                                                                  andWeChatImagePath:nil
                                                                   andSmallImagePath:[ZZJsonParse stringReplacOfString:smallImgInfoArray[smallArrayCount-3]] andSmallImageWidth:[smallImgInfoArray[smallArrayCount-2] floatValue]
                                                                 andSmallImageHeight:[smallImgInfoArray[smallArrayCount-1] floatValue]
                                                                   andLargeImagePath:[ZZJsonParse stringReplacOfString:bigImgInfoArray[bigArrayCount-3]] andLargeImageWidth:[bigImgInfoArray[bigArrayCount-2] floatValue]
                                                                 andLargeImageHeight:[bigImgInfoArray[bigArrayCount-1] floatValue]
                                                                    andImageDescribe:desc];
                }
                
                if(imageInfo){
                    [marray  addObject:imageInfo];
                }
                

            }
            NSString* dateStr = [dic objectForKey:@"date"];
            diaryinfo.diaryDate = dateStr;
            diaryinfo.diaryImagesAray = marray;
        diaryinfo.diaryId = [[dic  objectForKey:@"id"]integerValue];
        return diaryinfo;
    }else{
        return nil;
    }
}
#pragma mark  关注用户
+(ZZUser*)parseAttentionUserByDic:(NSDictionary*)dic{
    if ([dic  isKindOfClass:[NSDictionary  class]]) {
        ZZUser*  user = [[ZZUser  alloc]init];
      //  user.attentionCount = [[dic  objectForKey:@"attentionCount"]integerValue];
        user.permissions = [[dic  objectForKey:@"authority"]integerValue];
        user.loginTime = [[dic  objectForKey:@"loginTimes"]integerValue];
        user.nick = [dic  objectForKey:@"nike"];
        user.status = [[dic  objectForKey:@"userStatus"]integerValue];
        user.userId = [[dic  objectForKey:@"userId"]integerValue];
        user.isCurrentUser = [[dic  objectForKey:@"validCurrentUser"]boolValue];
        //
        user.isSuperStarUser = [[dic  objectForKey:@"eredar"]boolValue];
        user.superStarLv = [[dic  objectForKey:@"eredarRank"]integerValue];
        user.superStarType = [[dic  objectForKey:@"eredarType"]intValue];
        user.superStarName = [dic  objectForKey:@"eredarName"];

        //
        user.uToken = [dic  objectForKey:@"attentionToken"];
        NSString*  smallHeadImg = [dic  objectForKey:@"userSmallHeadImg"];
        if (smallHeadImg.length) {
            ZZMengBaoPaiImageInfo* mbp = [[ZZMengBaoPaiImageInfo alloc]init];
            mbp.smallImagePath = [ZZJsonParse stringReplacOfString:smallHeadImg];
            mbp.smallImageWidth = [[dic  objectForKey:@"smallImgWidth"]floatValue];
            mbp.smallImageHeight = [[dic  objectForKey:@"smallImgHeight"]floatValue];
            user.mbpImageinfo = mbp;
        }
        return user;
    }else{
        return nil;
    }
}

#pragma mark  专家列表
+(ZZExpert*)parseExpertListByDic:(NSDictionary*)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        ZZExpert* expertInfo = [[ZZExpert alloc]init];
        expertInfo.attention = [[dic objectForKey:@"attention"]boolValue];
        expertInfo.isCurrentUser = [[dic objectForKey:@"currentUser"]boolValue];
        expertInfo.nick = [dic objectForKey:@"realName"];
        expertInfo.userId = [[dic objectForKey:@"userId"]integerValue];
        expertInfo.introduction = [dic objectForKey:@"abstracting"];
        expertInfo.hospital = [dic objectForKey:@"address"];
        expertInfo.skill = [dic objectForKey:@"beGoodAt"];
        expertInfo.city = [[dic objectForKey:@"city"]intValue];
        expertInfo.caseCount = [[dic objectForKey:@"caseCount"]integerValue];
        expertInfo.chatCount = [[dic objectForKey:@"chatCount"]integerValue];
        expertInfo.helpCount = [[dic objectForKey:@"helpCount"]integerValue];
        expertInfo.online = [[dic objectForKey:@"online"]boolValue];
        NSString*  smallHeadImg = [dic  objectForKey:@"userSmallHeadImg"];
        if (smallHeadImg.length) {
            ZZMengBaoPaiImageInfo* mbp = [[ZZMengBaoPaiImageInfo alloc]initWithMbpImageInfoId:0 andWeChatImagePath:nil andSmallImagePath:[ZZJsonParse stringReplacOfString:smallHeadImg] andSmallImageWidth:[[dic objectForKey:@"smallImgWidth"]floatValue] andSmallImageHeight:[[dic objectForKey:@"smallImgHeight"]floatValue]  andLargeImagePath:[ZZJsonParse stringReplacOfString:[dic  objectForKey:@"userBigHeadImg"]] andLargeImageWidth:[[dic objectForKey:@"bigImgWidth"]floatValue]  andLargeImageHeight:[[dic objectForKey:@"bigImgHeight"]floatValue] andImageDescribe:nil];
            expertInfo.mbpImageinfo = mbp;
        }
        return expertInfo;
    }else{
        return nil;
    }
    
}

#pragma mark  达人和专家的类型
+(ZZPlateTypeInfo*)parseSuperStarAndExpertTypeByDic:(NSDictionary*)dic{
    ZZPlateTypeInfo* superStarAndExpertUser = [[ZZPlateTypeInfo alloc]init];
    superStarAndExpertUser.title = [dic objectForKey:@"name"];
    superStarAndExpertUser.type = [dic objectForKey:@"eredarType"];
    return superStarAndExpertUser;
}

#pragma mark  按类型查达人
+(ZZUser*)parseSuperStarListByDic:(NSDictionary*)dic{
    ZZMengBaoPaiImageInfo* imageInfo = [[ZZMengBaoPaiImageInfo alloc]initWithMbpImageInfoId:0 andWeChatImagePath:0 andSmallImagePath:[ZZJsonParse stringReplacOfString:[dic objectForKey:@"userSmallHeadImg"]] andSmallImageWidth:[[dic objectForKey:@"smallImgWidth"]floatValue] andSmallImageHeight:[[dic objectForKey:@"smallImgHeight"]floatValue] andLargeImagePath:[ZZJsonParse stringReplacOfString:[dic objectForKey:@"userBigHeadImg"]] andLargeImageWidth:[[dic objectForKey:@"bigImgWidth"]floatValue] andLargeImageHeight:[[dic objectForKey:@"bigImgHeight"]floatValue] andImageDescribe:nil];
    ZZUser* superStarInfo = [[ZZUser alloc]initWithId:[[dic objectForKey:@"id"]integerValue] andNick:[dic objectForKey:@"nike"] andLoginTime:[[dic objectForKey:@"loginTimes"]integerValue] andmbpImageInfo:imageInfo];
    superStarInfo.attention = [[dic objectForKey:@"attention"]boolValue];
    superStarInfo.permissions = [[dic objectForKey:@"authority"]integerValue];
    superStarInfo.superStarLv = [[dic objectForKey:@"eredarRank"]integerValue];
    superStarInfo.superStarType = [[dic objectForKey:@"eredarType"]intValue];
    superStarInfo.status = [[dic objectForKey:@"userStatus"]integerValue];
    superStarInfo.isCurrentUser = [[dic  objectForKey:@"currentUser"]boolValue];
    superStarInfo.superStarName = [dic  objectForKey:@"eredarName"];
    superStarInfo.isSuperStarUser = [[dic  objectForKey:@"eredar"]boolValue];
    return superStarInfo;
}

#pragma mark  案例类型
+(ZZPlateTypeInfo*)parseCaseTypeByDic:(NSDictionary*)dic{
    if ([dic  isKindOfClass:[NSDictionary  class]]) {
        ZZPlateTypeInfo* caseType = [[ZZPlateTypeInfo alloc]init];
        caseType.content = [dic  objectForKey:@"context"];
        caseType.title = [dic objectForKey:@"name"];
        caseType.type = [dic objectForKey:@"type"];
        caseType.areaType = @"HELP";
        caseType.interface = @"caseThroughTrain/caseThroughTrain";
        return caseType;
    }else{
        return nil;
    }
    
}

#pragma mark  案例列表

+(ZZPost*)parseCaseListByDic:(NSDictionary*)dic{
    
    if ([dic  isKindOfClass:[NSDictionary  class]]) {
        
        //图片
        NSString*  bigImg = [dic  objectForKey:@"bigImg"];
        NSMutableArray*  marray = nil;
        if (bigImg.length) {
            NSArray*   bigImagePathArray = [bigImg  componentsSeparatedByString:@"^#^" ];
            NSArray*   smallImagePathArray = [[dic  objectForKey:@"smallImg"]  componentsSeparatedByString:@"^#^" ];
            NSUInteger   min = bigImagePathArray.count>smallImagePathArray.count?smallImagePathArray.count:bigImagePathArray.count;
            
            marray =  [NSMutableArray  arrayWithCapacity:min];
            for (int i = 0; i<min; i++) {
                NSArray*  bigImageInfoArray = [bigImagePathArray[i]  componentsSeparatedByString:@","];
                NSArray*  smallImageInfoArray = [smallImagePathArray[i]  componentsSeparatedByString:@","];
                ZZMengBaoPaiImageInfo* imageInfo = nil;
                /*
                 张亮亮 0511 修改
                 */
                if (bigImageInfoArray.count>=3&&smallImageInfoArray.count>=3) {
                    NSUInteger  bigArrayCount = bigImageInfoArray.count;
                    NSUInteger  smallArrayCount = smallImageInfoArray.count;
                    
                    
                    NSMutableString*  desc ;
                    for (int i = 0; i<bigArrayCount-3; i++) {
                        if (!desc) {
                            desc = [NSMutableString  string];
                            
                        }
                        
                        [desc  appendString:bigImageInfoArray[i]];
                    }
                    imageInfo = [[ZZMengBaoPaiImageInfo alloc]initWithMbpImageInfoId:0
                                                                  andWeChatImagePath:nil
                                                                   andSmallImagePath:[ZZJsonParse stringReplacOfString:smallImageInfoArray[smallArrayCount-3]] andSmallImageWidth:[smallImageInfoArray[smallArrayCount-2] floatValue]
                                                                 andSmallImageHeight:[smallImageInfoArray[smallArrayCount-1] floatValue]
                                                                   andLargeImagePath:[ZZJsonParse stringReplacOfString:bigImageInfoArray[bigArrayCount-3]] andLargeImageWidth:[bigImageInfoArray[bigArrayCount-2] floatValue]
                                                                 andLargeImageHeight:[bigImageInfoArray[bigArrayCount-1] floatValue]
                                                                    andImageDescribe:desc];
                }
                
                if(imageInfo){
                    [marray  addObject:imageInfo];
                }
                
            }
            
        }

        
        ZZPost*  post = [[ZZPost  alloc]init];
        post.postImagesArray = marray;
       post.postTitle = [dic  objectForKey:@"title"];
        post.postStoreUp = [[dic  objectForKey:@"store"]boolValue];
        post.postContent= [NSString   stringWithFormat:@"Q:%@\n\nA:%@",[dic  objectForKey:@"question"],[dic  objectForKey:@"context"]];
        post.postDateStr = [self  stringDateWithStr:[dic  objectForKey:@"date"] andDateFormatStr:@"MM-dd"];
        post.postId = [[dic  objectForKey:@"id"]integerValue];
        post.postReplyCount = [[dic  objectForKey:@"replys"]integerValue];
        
        ZZUser*  user = [[ZZUser  alloc]init];
        user.userId = [[dic  objectForKey:@"userId"]integerValue];
        user.nick = [dic  objectForKey:@"nike"];
        user.status = [[dic  objectForKey:@"userStatus"]integerValue];
        user.attention = [[dic   objectForKey:@"attent"]boolValue];
        user.permissions = [[dic  objectForKey:@"authority"]integerValue];
        //
//        user.isSuperStarUser = [[dic  objectForKey:@"eredar"]boolValue];
//        user.superStarLv = [[dic  objectForKey:@"eredarRank"]integerValue];
//        user.superStarType = [[dic  objectForKey:@"eredarType"]intValue];
//        user.superStarName = [dic  objectForKey:@"eredarName"];
        user.mbpImageinfo = [[ZZMengBaoPaiImageInfo  alloc]initWithMbpImageInfoId:0 andWeChatImagePath:nil andSmallImagePath:[ self    stringReplacOfString:[dic  objectForKey:@"userSmallHeadImg"]] andSmallImageWidth:0 andSmallImageHeight:0 andLargeImagePath:[ self    stringReplacOfString:[dic  objectForKey:@"userBigHeadImg"]] andLargeImageWidth:0 andLargeImageHeight:0 andImageDescribe:nil];
        post.postUser = user;
        
        //
        ZZPlateTypeInfo* caseType = [[ZZPlateTypeInfo alloc]init];
        caseType.content = [dic  objectForKey:@"context"];
        caseType.title = [dic objectForKey:@"name"];
        caseType.type = [dic objectForKey:@"type"];
        caseType.areaType = @"HELP";
        caseType.interface = @"caseThroughTrain/caseThroughTrain";
        post.postPlateType = caseType;
        return post;
    }
    
    return nil;
}

#pragma mark  金币解析
+(ZZGoldRecord*)parseGoldListByDic:(NSDictionary*)dic{
    if (dic) {
        ZZGoldRecord* goldRecord = [[ZZGoldRecord alloc]init];
        goldRecord.goldContext = [dic objectForKey:@"context"];
        goldRecord.goldDate = [dic objectForKey:@"date"];
        goldRecord.goldId = [[dic objectForKey:@"id"]integerValue];
        goldRecord.goldTitle = [dic objectForKey:@"title"];
        goldRecord.goldNum = [[dic objectForKey:@"goldCount"]integerValue];
        return goldRecord;
    }else{
        return nil;
    }
    
}

#pragma mark  消息解析
+(ZZMessage*)parseMessageListByDic:(NSDictionary*)dic{
    if (dic) {
        ZZMessage* messageInfo = [[ZZMessage alloc]init];
        //消息回复人的信息
        ZZUser* userInfo = [[ZZUser alloc]init];
        userInfo.userId = [[dic  objectForKey:@"userId"]integerValue];
        userInfo.nick = [dic  objectForKey:@"nike"];
        userInfo.status = [[dic  objectForKey:@"userStatus"]integerValue];
        userInfo.attention = [[dic   objectForKey:@"attent"]boolValue];
        userInfo.permissions = [[dic  objectForKey:@"authority"]integerValue];        userInfo.mbpImageinfo = [[ZZMengBaoPaiImageInfo  alloc]initWithMbpImageInfoId:0 andWeChatImagePath:nil andSmallImagePath:[ self    stringReplacOfString:[dic  objectForKey:@"userSmallHeadImg"]] andSmallImageWidth:0 andSmallImageHeight:0 andLargeImagePath:[ self    stringReplacOfString:[dic  objectForKey:@"userBigHeadImg"]] andLargeImageWidth:0 andLargeImageHeight:0 andImageDescribe:nil];
        userInfo.isSuperStarUser = [[dic objectForKey:@"eredar"]boolValue];
        userInfo.superStarType = [[dic objectForKey:@"eredarType"]intValue];
        userInfo.superStarLv = [[dic objectForKey:@"eredarRank"]integerValue];
        userInfo.superStarName = [dic objectForKey:@"eredarName"];
        ZZReplayInformation* replayInfo = [[ZZReplayInformation alloc]init];
        //头像
        replayInfo.user = userInfo;
        //内容
        replayInfo.replayContent = [dic objectForKey:@"replyContext"];
        replayInfo.replayTime = [dic objectForKey:@"date"];
        messageInfo.replayInfo = replayInfo;
        
        //帖子的信息
        ZZPost* postInfo = [[ZZPost alloc]init];
        postInfo.postId = [[dic objectForKey:@"id"]integerValue];
        postInfo.postTitle = [dic objectForKey:@"title"];
        ZZPlateTypeInfo* plateType = [[ZZPlateTypeInfo alloc]init];
        plateType.interface = [ZZJsonParse  removeTheFirstOrLastCharacterWithSpecifiedString:@"/" andOrignStr:[dic objectForKey:@"portName"]];
        plateType.areaType = [dic objectForKey:@"areaType"];
        plateType.type = [dic objectForKey:@"plateType"];
        postInfo.postPlateType = plateType;
        //本用户解析
        ZZUser*  user = [ZZUser  shareSingleUser];
        user.isCurrentUser = YES;
        user.userId = [[dic objectForKey:@"publishUserId"]integerValue];
        postInfo.postUser = user;
        
        messageInfo.postInfo = postInfo;
        messageInfo.messageId = [[dic  objectForKey:@"messageId"]integerValue];
        return messageInfo;
    }else{
        return nil;
    }
}

#pragma mark   广告图片解析
+(ZZPost*)parseImageInfoByDic:(NSDictionary*)dic{
    if ([dic  isKindOfClass:[NSDictionary  class]]) {
        NSMutableArray*  marray = [NSMutableArray arrayWithCapacity:3];
        ZZMengBaoPaiImageInfo*  mbpImage = [[ZZMengBaoPaiImageInfo  alloc]init];
        mbpImage.largeImagePath = [self  stringReplacOfString:[dic objectForKey:@"bigImg"]];
        mbpImage.largeImageWidth = [[dic  objectForKey:@"bigImgWidth"]floatValue];
        mbpImage.largeImageHeight = [[dic  objectForKey:@"bigImgHeight"]floatValue];
        
        mbpImage.smallImagePath = [self  stringReplacOfString:[dic  objectForKey:@"smallImg"]];
        mbpImage.smallImageWidth = [[dic  objectForKey:@"smallImgWidth"]floatValue];
        mbpImage.smallImageHeight = [[dic  objectForKey:@"smallImgHeight"]floatValue];
        [marray addObject:mbpImage];
        
        //用户头像
        NSString*  userSmallHeadImg = [dic  objectForKey:@"userSmallHeadImg"];
        ZZMengBaoPaiImageInfo* userMbp =nil;
        if (userSmallHeadImg.length) {
            userMbp = [[ZZMengBaoPaiImageInfo  alloc]initWithMbpImageInfoId:0
                                                         andWeChatImagePath:nil
                                                          andSmallImagePath:[ZZJsonParse  stringReplacOfString:[dic
                                                                                                                objectForKey:@"userSmallHeadImg"]]
                                                         andSmallImageWidth:[[dic  objectForKey:@"smallImgWidth"] floatValue]
                                                        andSmallImageHeight:[[dic  objectForKey:@"smallImgHeight"]floatValue]
                                                          andLargeImagePath:nil
                                                         andLargeImageWidth:0.0
                                                        andLargeImageHeight:0.0
                                                           andImageDescribe:nil];
        }
        
        
        
        //用户
        ZZUser*  user = [[ZZUser  alloc]initWithId:[[dic  objectForKey:@"userId"]integerValue]
                                           andNick:[dic  objectForKey:@"nike"]
                                      andLoginTime:[[dic  objectForKey:@"loginTimes"] integerValue]
                                   andmbpImageInfo:userMbp];
        user.attention = [[dic  objectForKey:@"attent"]boolValue];
        user.permissions = [[dic  objectForKey:@"authority"]integerValue];
        user.isCurrentUser = [[dic  objectForKey:@"validCurrentUser"]boolValue];
        user.status = [[dic  objectForKey:@"userStatus"]integerValue];
        //用户达人信息
        user.isSuperStarUser = [[dic  objectForKey:@"eredar"]boolValue];
        user.superStarLv = [[dic  objectForKey:@"eredarRank"]integerValue];
        user.superStarType = [[dic  objectForKey:@"eredarType"]intValue];
        user.superStarName = [dic objectForKey:@"eredarName"];
        //帖子信息
        
        ZZPost*  post = [[ZZPost  alloc]initWithId:[[dic  objectForKey:@"id"]integerValue]
                                          andTitle:[dic  objectForKey:@"title"]
                                        andContent:[dic  objectForKey:@"context"]
                                    andImagesArray:marray
                                        andDateStr:[self  stringDateWithStr:[dic  objectForKey:@"date"] andDateFormatStr:@"MM-dd HH:mm"]
                                           andUser:user
                                     andReplyCount:[[dic  objectForKey:@"relpys"]integerValue]
                                      andPlateType:nil
                                          andJudge:[[dic  objectForKey:@"stick"]boolValue]
                                        andStoreUp:[[dic  objectForKey:@"store"]boolValue]];
        /*
         张亮亮  0513  加点赞
         */
        post.postCurrentUserSpot = [[dic  objectForKey:@"currentUserSpot"]boolValue];
        post.postSportCount  = [[dic  objectForKey:@"spotCount"]integerValue];
        
        
        // 详情不会返回板块信息
        NSString*  portConnector = [dic  objectForKey:@"portConnector"];
        if (portConnector.length) {
            ZZPlateTypeInfo*  plyte =[[ ZZPlateTypeInfo alloc]init];
            plyte.interface =[ZZJsonParse  removeTheFirstOrLastCharacterWithSpecifiedString:@"/" andOrignStr:[dic  objectForKey:@"portConnector"]];
            plyte.areaType =[dic  objectForKey:@"areaType"];
            plyte.plateId = [[dic  objectForKey:@"areaId"]integerValue];//为区域id
            plyte.title = [dic  objectForKey:@"plateName"];
            plyte.type = [dic  objectForKey:@"type"];
            
            post.postPlateType = plyte;
        }
        
        return post;

    }else{
        return nil;
    }
}

#pragma mark   在线专家
+(ZZExpert*)parseOnLineExpetByDic:(NSDictionary*)dic{
    if ([dic  isKindOfClass:[NSDictionary  class]]) {
        ZZExpert*  expert = [[ZZExpert  alloc]init];
        expert.introduction = [dic  objectForKey:@"abstracting"];
        expert.nick = [dic  objectForKey:@"realName"];
        expert.permissions = [[dic  objectForKey:@"authorityRelationId"]intValue];
        expert.skill = [dic  objectForKey:@"beGoodAt"];
        expert.token = [dic  objectForKey:@"token"];
        expert.userId = [[dic  objectForKey:@"userId"]integerValue];
        expert.uToken = [dic  objectForKey:@"rongyunServiceId"];
        expert.loginTime = [[dic  objectForKey:@"loginTimes"]integerValue];
        //头像
        NSString*  userBigHeadImg  = [dic  objectForKey:@"userBigHeadImg"];
        if (userBigHeadImg.length) {
            ZZMengBaoPaiImageInfo*  mbp  =[[ZZMengBaoPaiImageInfo  alloc]initWithMbpImageInfoId:0 andWeChatImagePath:nil andSmallImagePath:[self  stringReplacOfString:[dic  objectForKey:@"userSmallHeadImg"] ]andSmallImageWidth:[[dic  objectForKey:@"smallImgWidth"]floatValue] andSmallImageHeight:[[dic  objectForKey:@"smallImgHeight"]floatValue] andLargeImagePath:[self  stringReplacOfString:[dic  objectForKey:@"userBigHeadImg"]] andLargeImageWidth:[[dic objectForKey:@"bigImgWidth"]floatValue] andLargeImageHeight:[[dic objectForKey:@"bigImgHeight"]floatValue] andImageDescribe:nil];
            expert.mbpImageinfo = mbp;
        }
        return expert;
    }else{
        return nil;
    }
}
#pragma mark   解析code为0时
+(NSString*)parseNetGetFailInfoByDic:(NSDictionary*)dic{
  
    NSString*  tip ;
    if ([dic  isKindOfClass:[NSDictionary  class]]&&dic.count) {
        NSString*  str = [dic  objectForKey:@"presentation"];
        if ([str  isKindOfClass:[NSString  class]]&&str.length) {
            tip = str;
        }
    }
    return tip;
}

+(ZZUser*)parseUserNickAndImageUrlByDic:(NSDictionary*)dic{
    if ([dic  isKindOfClass:[NSDictionary  class]]) {
        ZZUser*  user = [[ZZUser  alloc]init];
        user.nick = [dic  objectForKey:@"nike"];
        user.mbpImageinfo = [[ZZMengBaoPaiImageInfo  alloc]initWithMbpImageInfoId:0 andWeChatImagePath:nil andSmallImagePath:[self  stringReplacOfString:[dic  objectForKey:@"userSmallHeadImg"]] andSmallImageWidth:0 andSmallImageHeight:0 andLargeImagePath:[self  stringReplacOfString:[dic  objectForKey:@"userBigHeadImg"]] andLargeImageWidth:0 andLargeImageHeight:0 andImageDescribe:nil];
        return user;
    }else{
        return nil;
    }
}
#pragma mark 公用方法
//图片路径处理
+(NSString*)stringReplacOfString:(NSString*)str{
    
    if (str.length>0) {
//<<<<<<< .mine
//        //if ([str1 rangeOfString:str].location != NSNotFound)  str1 中是否存在str2
//        NSString* backStr =[NSString   stringWithFormat:@"%@%@",[[ZZMengBaoPaiRequest  shareMengBaoPaiRequest].baseUrl  stringByReplacingOccurrencesOfString:@"babyIos" withString:@"image" ], [[str  stringByReplacingOccurrencesOfString:@"//" withString:@"/"]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  ];
//=======
       if ([str rangeOfString:@"upload"].location == NSNotFound) // str1 中是否存在str2
       {
           
        NSString* backStr =[NSString   stringWithFormat:@"%@%@",[[ZZMengBaoPaiRequest  shareMengBaoPaiRequest].baseUrl  stringByReplacingOccurrencesOfString:@"iosAndroid" withString:@"image" ], [[str  stringByReplacingOccurrencesOfString:@"//" withString:@"/"]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  ];

        return  backStr;
    }else{
        NSString* backStr =[NSString   stringWithFormat:@"%@/%@",[[ZZMengBaoPaiRequest  shareMengBaoPaiRequest].baseUrl  stringByReplacingOccurrencesOfString:@"iosAndroid" withString:@"smart" ], [[str  stringByReplacingOccurrencesOfString:@"//" withString:@"/"]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  ];
        return  backStr;
        
    }
    
    }else{
        return nil;
    }
    
}
//去除首位得指定字符
+(NSString*)removeTheFirstOrLastCharacterWithSpecifiedString:(NSString*)str  andOrignStr:(NSString*)orignStr{
    return [orignStr  stringByTrimmingCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:str]];
}
//日期转换为指定的格式
+(NSString*)stringDateWithStr:(NSString*)dateStr    andDateFormatStr:(NSString*)dateFormat{
    
    if (dateStr.length) {
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        if (dateFormat.length<7) {
            [df setDateFormat:@"yyyy-MM-dd"];
        }else{
            [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        }
        NSDate*  date = [df dateFromString:dateStr];
        [df setDateFormat:dateFormat];
        NSString*  dates = [df  stringFromDate:date];
        return dates;
    }else{
        return nil;
    }
    
}

//移除内容前后的空格和回车
+(NSString*)removeWhitespaceAndNewlineCharacterWithOrignString:(NSString*)string{
    return [string   stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
}
@end
