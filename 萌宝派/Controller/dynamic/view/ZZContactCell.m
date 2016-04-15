//
//  ZZContactCell.m
//  萌宝派
//
//  Created by charles on 15/3/11.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZContactCell.h"

#import "ZZRongChat.h"
@interface ZZContactCell ()
/***  头像*/
@property(nonatomic,strong)UIImageView* headImage;
/***  昵称*/
@property(nonatomic,strong)UILabel* nickLabel;
/***  昵称*/
@property(nonatomic,strong)UILabel* contentLabel;

@property(nonatomic,strong)UILabel* lineLabel;
@property(nonatomic,strong)UILabel*  countLabel;
@property(nonatomic,strong)UILabel*  timeLabel;
@end
@implementation ZZContactCell
-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
         _headImage.layer.cornerRadius = 25;
        _headImage.layer.masksToBounds = YES;
        _headImage.clipsToBounds = YES;
        _headImage.layer.borderColor = ZZLightGrayColor.CGColor;
        _headImage.layer.borderWidth = 0.5;
        _headImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImage;
}
-(UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 120, 20)];

        _nickLabel.font = ZZContentFont;
        _nickLabel.textColor = ZZDarkGrayColor;
    }
    return _nickLabel;
}
-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel  alloc]initWithFrame:CGRectMake(10, 59, ScreenWidth - 20, 1)];
        _lineLabel.backgroundColor= ZZViewBackColor;
    }
    return _lineLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 33, ScreenWidth - 100, 15)];
  
        _contentLabel.font = ZZTimeFont;
        _contentLabel.textColor = ZZLightGrayColor;
    }
    return _contentLabel;
}
-(UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel  alloc]initWithFrame:CGRectMake(40, 5, 25, 20)];
        _countLabel.backgroundColor = [UIColor  colorWithRed:1 green:0.1 blue:0.2 alpha:1];
        _countLabel.layer.masksToBounds = YES;
        _countLabel.layer.cornerRadius = 10;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = ZZTimeFont;
        _countLabel.textColor = [UIColor  whiteColor];
    }
    return _countLabel;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel  alloc]initWithFrame:CGRectMake(ScreenWidth -100, 10, 80, 15)];
        _timeLabel.font = ZZTimeFont;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor  =[UIColor  colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    return _timeLabel;
}
static NSString *cellIden = @"ZZContactCell";
+ (ZZContactCell *)dequeueReusableCellWithTableView:(UITableView *)tableView{
    ZZContactCell*    cell = [tableView  dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[ZZContactCell  alloc  ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
       [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.nickLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView  addSubview:self.countLabel];
        [self.contentView  addSubview:self.timeLabel];
        [self.contentView  addSubview:self.lineLabel];
    }
    return self;
    
}
-(void)setConversation:(RCConversation *)conversation{
    _conversation = conversation;
    RCUserInfo* userInfo   = [[ZZRongChat  sharedZZRongChat]getZZUserInfoWithUserId:self.conversation.targetId];
    self.nickLabel.text = userInfo.name;
    // model.unreadMessageCount
    if (self.conversation.unreadMessageCount) {
        self.countLabel.hidden= NO;
        if (self.conversation.unreadMessageCount<100) {
            self.countLabel.text =[NSString   stringWithFormat:@"%d",self.conversation.unreadMessageCount] ;
        }else{
            self.countLabel.text =[NSString   stringWithFormat:@"%@",@"99+"] ;
        }
        
    }else{
        self.countLabel.hidden = YES;
    }
    [self.headImage  setImageWithURL:userInfo.portraitUri placeholderImageName:@"head_portrait_55x55.jpg"];
    
    
    if ([self.conversation.lastestMessage  isKindOfClass:[ RCTextMessage  class]]) {
        RCTextMessage*  textMessage =(RCTextMessage*) self.conversation.lastestMessage;
        self.contentLabel.text =textMessage.content;
    }else if ([self.conversation.lastestMessage  isKindOfClass:[RCVoiceMessage  class] ]){
        self.contentLabel.text =@"[语音]";
    }else if ([self.conversation.lastestMessage  isKindOfClass: [RCImageMessage  class] ]){
        self.contentLabel.text =@"[图片]";
    }else if ([self.conversation.lastestMessage  isKindOfClass: [RCLocationMessage  class] ]){
        self.contentLabel.text =@"[位置]";
    }else if ([self.conversation.lastestMessage  isKindOfClass: [RCRichContentMessage  class] ]){
        self.contentLabel.text =@"[图文]";
    }else {
        self.contentLabel.text =@"";
    }
    
    if (self.conversation.receivedTime>self.conversation.sentTime) {
        self.timeLabel.text = [self  stringDateWithStr:self.conversation.receivedTime];
    }else{
        self.timeLabel.text = [self  stringDateWithStr:self.conversation.sentTime];
    }

}


//日期转换为指定的格式
-(NSString*)stringDateWithStr:(long  long)time {
    NSDate* date = [NSDate  dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    //  [df setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    [df setDateFormat:@"MM-dd HH:mm"];
    NSString*  dates = [df  stringFromDate:date];
    
    return dates;
}
@end
