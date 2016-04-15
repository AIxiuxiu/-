//
//  ZZReplyFrame.m
//  萌宝派
//
//  Created by zhizhen on 15/8/12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZReplyFrame.h"

// cell之间的间距
CGFloat  const ZZReplyCellMargin = 15 ;

// cell的边框宽度
CGFloat  const ZZReplyCellBorderW  = 10;

CGFloat  const ZZReplyCellLine =  5;
static UILabel *cumLabel ;
@implementation ZZReplyFrame
-(void)setReply:(ZZReplayInformation *)reply{
    _reply = reply;
    
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = ZZReplyCellBorderW +ZZReplyCellLine;
    CGFloat iconY = ZZReplyCellBorderW +ZZReplyCellLine;
    self.headIVF= CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 楼层 */
    CGFloat  maxWidth = 60;
    CGFloat floorLabelY = iconY;
    CGSize floorLabelSize = [[NSString  stringWithFormat:@"%ld楼",reply.floor] sizeWithFont:ZZTimeFont maxW:maxWidth];
    CGFloat floorLabelX = ScreenWidth - ZZReplyCellBorderW -floorLabelSize.width-ZZReplyCellLine;
    self.floorLabelF = (CGRect){{floorLabelX, floorLabelY}, floorLabelSize};
  
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.headIVF) + ZZReplyCellMargin;
    CGFloat nameY = iconY;
//    CGSize   nameSize = [self  getiSizeWithAttString:[[NSMutableAttributedString   alloc] initWithString:reply.user.nick] size:CGSizeMake(ScreenWidth - nameX -(25+ZZReplyCellMargin)*3 - ZZReplyCellMargin - floorLabelSize.width, 18)];
 
    CGSize nameSize = [reply.user.nick sizeWithFont:ZZContentFont maxSize:CGSizeMake(ScreenWidth - nameX -(25+ZZReplyCellMargin)*2 - ZZReplyCellLine - ZZReplyCellBorderW - floorLabelSize.width, 18)];
//    CGSize nameSize = [reply.user.nick sizeWithFont:ZZContentFont maxW:(ScreenWidth - nameX -(25+ZZReplyCellMargin)*3 - ZZReplyCellMargin - floorLabelSize.width)];

    self.nickLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 回复按钮 */
    CGSize  buttonSize = CGSizeMake(25, 25);
    CGFloat replyButtonX = CGRectGetMinX(self.floorLabelF)-2-buttonSize.width;
    CGFloat replyButtonY = iconY-3;
    self.replyButtonF = (CGRect){{replyButtonX, replyButtonY}, buttonSize};
    
    /** delete按钮 */
    CGFloat deleteButtonX = CGRectGetMinX(self.replyButtonF)-ZZReplyCellLine - ZZReplyCellBorderW -buttonSize.width;
    CGFloat deleteButtonY = replyButtonY;
    self.deleteButtonF = (CGRect){{deleteButtonX, deleteButtonY}, buttonSize};
    
    /** 权限 */
    CGFloat permissX = nameX;
    CGFloat permissY = CGRectGetMaxY(self.nickLabelF) + ZZReplyCellLine;
    CGSize permissSize = [[reply.user getUserIdentify] sizeWithFont:ZZTimeFont maxW:(ScreenWidth - nameX -150)];
    self.permissLabelF = (CGRect){{permissX, permissY}, permissSize};
    
    CGFloat y = CGRectGetMaxY(self.permissLabelF);
    
    if (reply.replayContent.length) {
        /** 正文 */
      
        CGFloat contentX = permissX;
        CGFloat contentY = CGRectGetMaxY(self.permissLabelF)+ ZZReplyCellLine;
      
        CGSize contentSize = [reply  getiSizeWithAttString:reply.attributedContent size:CGSizeMake(ScreenWidth - permissX -ZZReplyCellBorderW- ZZReplyCellLine, 10000)];
        self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
        
        y = CGRectGetMaxY(self.contentLabelF);
        
    }
  
    
    if (reply.imageInfo && reply.isDelete == NO) {
        /** 图片 */
        //最大宽高
        CGFloat maxW = ScreenWidth / 2;
        CGFloat maxH = ScreenHeight / 3;
    
        CGFloat contentIVX = permissX;
        CGFloat contentIVY = y + ZZReplyCellLine;
       
        CGSize imageSize = [self  sizeWithLimitSize:CGSizeMake(maxW, maxH) originSize:CGSizeMake(reply.imageInfo.smallImageWidth, reply.imageInfo.smallImageHeight)];
        self.contentIVF = (CGRect){{contentIVX, contentIVY}, imageSize};
        y = CGRectGetMaxY(self.contentIVF);
   
    }
 
    if (reply.relReplayPost) {
     ZZReplayInformation *rlReply =   reply.relReplayPost;
        CGFloat replyWidth = ScreenWidth - ZZReplyCellBorderW -ZZReplyCellLine- nameX;
        
        CGFloat replyIconWH = 20;
        CGFloat replyIconX = ZZReplyCellBorderW ;
        CGFloat replyIconY = ZZReplyCellBorderW ;
        self.replyHeadIVF= CGRectMake(replyIconX, replyIconY, replyIconWH, replyIconWH);
        
        /** 昵称 */
        CGFloat replyNameX = CGRectGetMaxX(self.replyHeadIVF) + ZZReplyCellMargin;
        CGFloat replyNameY = iconY;
        CGSize replyNameSize = [rlReply.user.nick sizeWithFont:ZZContentFont maxW:(replyWidth - replyNameX -ZZReplyCellBorderW*2 - iconWH)];
        self.replyNickLabelF = (CGRect){{replyNameX, replyNameY}, replyNameSize};
        
        maxWidth =  (replyWidth - CGRectGetMaxX(self.replyNickLabelF) -ZZReplyCellBorderW - ZZReplyCellLine < maxWidth) ? (replyWidth - CGRectGetMaxX(self.replyNickLabelF) -ZZReplyCellBorderW - ZZReplyCellLine < maxWidth):maxWidth;
        
        /** 楼层 */
        CGFloat replyFloorLabelY = replyIconY;
        CGSize replyFloorLabelSize = [[NSString  stringWithFormat:@"%ld楼",rlReply.floor]sizeWithFont:ZZTimeFont maxW:maxWidth];
        CGFloat replyFloorLabelX = replyWidth - ZZReplyCellBorderW -replyFloorLabelSize.width-ZZReplyCellLine;
        self.replyFloorLabelF = (CGRect){{replyFloorLabelX, replyFloorLabelY}, replyFloorLabelSize};
        
            /** 正文 */
            CGFloat replyContentX = replyNameX;
            CGFloat replyContentY = CGRectGetMaxY(self.replyNickLabelF)+ ZZReplyCellLine;
            CGSize replyContentSize = [rlReply  getiSizeWithAttString:rlReply.attributedContent size:CGSizeMake(replyWidth - replyContentX -ZZReplyCellBorderW-ZZReplyCellLine, MAXFLOAT)];
            self.replyContentLabelF = (CGRect){{replyContentX, replyContentY}, replyContentSize};
        
        CGFloat replyViewX = nameX;
        CGFloat replyViewY = y  + ZZReplyCellLine;
        CGFloat  replyViewH = CGRectGetMaxY(self.replyContentLabelF)+ZZReplyCellLine;
        self.replyViewF = CGRectMake(replyViewX,replyViewY, replyWidth, replyViewH+2);
        
            y = CGRectGetMaxY(self.replyViewF);
       
    }
  /** 时间 */
    CGFloat contentIVX = nameX;
    CGFloat contentIVY = y+ZZReplyCellLine;
    self.timeButtonF = CGRectMake(contentIVX, contentIVY, 0, 20);
    
    /** 举报按钮 */
    CGFloat reportButtonW = 20;
    CGFloat reportButtonH = reportButtonW;
    CGFloat reportButtonX = ScreenWidth-ZZReplyCellMargin -reportButtonW;
    CGFloat reportButtonY = CGRectGetMinY(self.timeButtonF);
    self.reportButtonF = CGRectMake(reportButtonX, reportButtonY, reportButtonW, reportButtonH);
    
    self.cellHeight = (NSUInteger) CGRectGetMaxY(self.timeButtonF)+ZZReplyCellLine+1;
    
    self.whiteBackViewF = CGRectMake(ZZReplyCellLine, ZZReplyCellLine, ScreenWidth - 2*ZZReplyCellLine, self.cellHeight-ZZReplyCellLine);
}
/**
 *  将HWStatus模型转为HWStatusFrame模型
 */
+ (NSArray *)replyFramesWithReplys:(NSArray *)replys
{
    NSMutableArray *frames = [NSMutableArray array];
    for (ZZReplayInformation *reply in replys) {
        ZZReplyFrame *r = [[ZZReplyFrame alloc] init];
        r.reply = reply;
        [frames addObject:r];
    }
    return frames;
}

@end
