//
//  ZZHudView.m
//  萌宝派
//
//  Created by zhizhen on 14-11-5.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZHudView.h"
#import "AppDelegate.h"


@implementation ZZHudView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super  initWithFrame:CGRectZero];
    if (self) {
        self.contentLabel = [[UILabel  alloc]init];
        self.contentLabel.font = [UIFont   systemFontOfSize:16];
        self.contentLabel.textColor = [UIColor  whiteColor];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
       // self.contentLabel.backgroundColor = [UIColor  redColor];
        self.backgroundColor = [UIColor  blackColor];
        self.alpha= .7;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self  addSubview:self.contentLabel];
        self.tag = 101;
        UITapGestureRecognizer*  tap = [[UITapGestureRecognizer   alloc]initWithTarget:self action:@selector(dismiss)];
        [self  addGestureRecognizer:tap];
        AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate;
        self.center = app.window.center;
    }
    
    return self;
}
-(instancetype)init{
   
    return [self  initWithFrame:CGRectZero];
}

-(instancetype)initWithContent:(NSString *)content{
    
    ZZHudView*  hudView =[self  initWithFrame:CGRectZero];
    
    hudView.contentLabel.text = content;
    
    return  hudView;
    
}

-(void)showWithTime:(NSTimeInterval)time{
    [self  showWithNOTimer];
    [NSTimer  scheduledTimerWithTimeInterval:time target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}

-(void)showWithNOTimer{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate;
        
        [app.window  addSubview:self];
        [app.window  bringSubviewToFront:self];
        
        [self   setNeedsLayout];
        
    });
   
}



-(void)layoutSubviews{
    [super  layoutSubviews];
    
    CGSize  size = [self.contentLabel.text   sizeWithAttributes:[NSDictionary dictionaryWithObject:self.contentLabel.font forKey:NSFontAttributeName]];
    if (size.width>260) {
        size.width=260;
    }
    
    self.contentLabel.frame =  CGRectMake(10, 10, size.width+20, 20);
    
   AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate;
  self.frame = CGRectMake(0, 0, size.width+40, 40);
//    CGPoint   center = app.window.center;
//    center.y = [UIScreen  mainScreen].bounds.size.height-80 ;
  self.center = app.window.center;
    
}
-(void)dismiss{
 
    
    dispatch_async(dispatch_get_main_queue(), ^{
           [self  removeFromSuperview];
           
    });
}


@end
