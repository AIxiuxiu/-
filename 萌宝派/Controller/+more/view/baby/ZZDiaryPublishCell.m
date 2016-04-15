//
//  ZZDiaryPublishCell.m
//  萌宝派
//
//  Created by zhizhen on 15-3-13.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZDiaryPublishCell.h"


@interface  ZZDiaryPublishCell()

@end
@implementation ZZDiaryPublishCell

-(UIImageView *)addImageView{
    if (!_addImageView) {
        _addImageView = [[UIImageView  alloc]init];
        _addImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]  pathForResource:@"add_range_64x112" ofType:@"png"]];
        _addImageView.userInteractionEnabled = YES;
        _addImageView.contentMode =UIViewContentModeScaleAspectFill;
        _addImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(imageTap:)];
        [_addImageView  addGestureRecognizer:tap];
    }
    return _addImageView;
}

-(ZZTextView *)inputTextView{
    if (!_inputTextView) {
        _inputTextView = [[ZZTextView  alloc]init];
        _inputTextView.font = ZZContentFont;
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.textContentLength = 1000;
        _inputTextView.placeholder = @"请输入内容，1-500字。(可选)";
        _inputTextView.layer.cornerRadius = 5;
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    }
    return _inputTextView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super  initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView   addSubview:self.addImageView];
        [self.contentView   addSubview:self.inputTextView];
 
    }
    return self;
}

-(void)layoutSubviews{
    [super  layoutSubviews];
    [self.inputTextView  setNeedsLayout];
}
/**
 *  图片点击
 *
 *  @param tap <#tap description#>
 */
-(void)imageTap:(UITapGestureRecognizer*)tap{
    if ([self.delegate  respondsToSelector:@selector(diaryPublishCellTapImageAction:)]) {
        [self.delegate  diaryPublishCellTapImageAction:self];
    }
}


@end
