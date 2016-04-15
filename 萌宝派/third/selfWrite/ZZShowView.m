//
//  ZZShowView.m
//  萌宝派
//
//  Created by zhizhen on 15/8/5.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZShowView.h"

@implementation ZZShowView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.editable = NO;//不可编辑
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super  initWithCoder:aDecoder];
    if (self) {
        self.editable = NO;
    }
    return self;
}
-(BOOL)canBecomeFirstResponder{
    return NO;
}

@end
