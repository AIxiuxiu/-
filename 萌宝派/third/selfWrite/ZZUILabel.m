//
//  ZZUILabel.m
//  BaoBao康_登入界面
//
//  Created by charles on 14-8-26.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZUILabel.h"

@implementation ZZUILabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor grayColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
