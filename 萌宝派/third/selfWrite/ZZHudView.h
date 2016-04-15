//
//  ZZHudView.h
//  萌宝派
//
//  Created by zhizhen on 14-11-5.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZHudView : UIView
@property(nonatomic,strong)UILabel*  contentLabel;


//@property(nonatomic,weak)UIView*  superView;

-(instancetype)initWithContent:(NSString*)content;
-(void)showWithTime:(NSTimeInterval)time;
-(void)showWithNOTimer;
-(void)dismiss;
@end
