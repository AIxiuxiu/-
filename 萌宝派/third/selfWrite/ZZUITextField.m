//
//  ZZUITextField.m
//  BaoBao康_登入界面
//
//  Created by charles on 14-8-26.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZUITextField.h"

@implementation ZZUITextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.borderStyle =  UITextBorderStyleRoundedRect;

    }
    return self;
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
}
//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );
    
    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    
    return inset;
    
}
@end
