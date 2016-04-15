//
//  ZZTextViewPublishContentCell.m
//  萌宝派
//
//  Created by 张亮亮 on 15/5/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZTextViewPublishContentCell.h"

@implementation ZZTextViewPublishContentCell
-(ZZTextView *)inputTextView{
    if (!_inputTextView) {
        _inputTextView = [[ZZTextView  alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth-40, 112)];
        _inputTextView.font = ZZContentFont;
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.textContentLength = 4000;
        _inputTextView.placeholder = @"请输入内容，1-2000字。(可选)";
        _inputTextView.layer.cornerRadius = 5;
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    }
    return _inputTextView;
}-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.contentView   addSubview:self.inputTextView];
        
    }
    return self;
}
@end
