//
//  ZZSecurityButton.m
//  TalentService
//
//  Created by zhizhen on 15/7/29.
//  Copyright (c) 2015年 zhizhen. All rights reserved.
//

#import "ZZSecurityButton.h"
@interface ZZSecurityButton ()
@property (nonatomic) NSInteger changeSecond;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIColor *customerColor;
/**
 *  验证持续时间
 */
@property (nonatomic) NSUInteger second;

@end
@implementation ZZSecurityButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super  initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = YES;
      
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    }
    return self;
}


-(void)setSecond:(NSUInteger)second{
    _second = second;
    self.changeSecond = second;
}

//计时器方法
-(void)timerFireMethod:(NSTimer *)theTimer {
    self.changeSecond--;
    if (self.changeSecond < 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
       self.enabled = YES;
        self.changeSecond = self.second;
        if (self.customerColor) {
            self.backgroundColor = self.customerColor;
        }
       [self  setTitle:@"重新获取" forState:UIControlStateNormal];
    }else{
     //  self.titleLabel.text =[NSString  stringWithFormat: @"还剩%ld秒",self.changeSecond];
       
        [self  setButtonTitle];
    }
}
- (void)setButtonTitle{
     [self  setTitle:[NSString  stringWithFormat: @"还剩%ld秒",self.changeSecond] forState:UIControlStateDisabled];
}
//销毁当前按钮
- (void) clearButton{
    [self.timer invalidate];
     self.timer = nil;
}

- (void) stop{
    self.changeSecond = 0;
}
- (void) startWithSecond:(NSUInteger)second{
    self.second = second;
  self.enabled = NO;
     [self  setButtonTitle];
    if (self.backgroundColor) {
        self.customerColor = self.backgroundColor;
    }
    self.backgroundColor = [UIColor  grayColor];
    if (self.timer == nil) {//没有定时器，创建一个，创建后直接开始执行
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:)  userInfo:nil repeats:YES];
    }else{//开启定时器
        [self.timer setFireDate:[NSDate distantPast]];
    }
}
-(void)dealloc{
    ZZLog(@"%@",[self  class]);
}
@end
