//
//  ZZAPPPublishRuleVC.m
//  萌宝派
//
//  Created by zhizhen on 15/6/26.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZAPPPublishRuleVC.h"
#import "ZZShowView.h"
@implementation ZZAPPPublishRuleVC
-(void)viewDidLoad{
    [super  viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"发帖规则";
    NSError*  readError ;
    NSString*  agreeContent = [NSString  stringWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"萌宝派发帖规则2" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&readError];
    ZZShowView* rulesTV =[[ZZShowView alloc]initWithFrame:CGRectMake(10, 74, ScreenWidth-20, ScreenHeight -84)];
    rulesTV.backgroundColor=[UIColor whiteColor];
    rulesTV.layer.cornerRadius = 5;
    rulesTV.textContainerInset = UIEdgeInsetsMake(7.5, 3, 7.5, 0);
    rulesTV.layer.masksToBounds = YES;
    rulesTV.bounces=NO;
    rulesTV.textColor = ZZLightGrayColor;
    rulesTV.font = ZZContentFont;
    rulesTV.attributedText = [rulesTV  getAttributedStringWithText:agreeContent paragraphSpacing:3 lineSpace:0 stringCharacterSpacing:0 textAlignment:NSTextAlignmentLeft font:rulesTV.font color:rulesTV.textColor];
    [self.view  addSubview:rulesTV];
}
@end
