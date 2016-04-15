//
//  ZZAddImageCollectionViewCell.m
//  萌宝派
//
//  Created by charles on 15/3/23.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZAddImageCollectionViewCell.h"

@implementation ZZAddImageCollectionViewCell
-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc]init];
//        _deleteButton.frame = CGRectMake1(self.frame.size.width/AutoSizeScalex-45, -5, 50, 50);
        [_deleteButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]  pathForResource:@"cancel_button_60x60" ofType:@"png"]] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _deleteButton;
}
-(UIImageView *)addImage{
    if (!_addImage) {
        _addImage = [[UIImageView alloc]init];
        _addImage.backgroundColor = [UIColor  clearColor];
        _addImage.contentMode = UIViewContentModeScaleAspectFill;
        _addImage.clipsToBounds = YES;
        _addImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(imageTap:)];
        [_addImage  addGestureRecognizer:tap];
    }
    return _addImage;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super  initWithFrame:frame];
    if (self) {
        [self.contentView  addSubview:self.addImage];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

-(void)layoutSubviews{
    [super  layoutSubviews];
      self.deleteButton.frame = CGRectMake(self.frame.size.width-45, -5, 50, 50);
    self.addImage.frame = self.bounds;
}
/**
 *  删除按钮响应事件
 *
 *  @param btn <#btn description#>
 */
-(void)deleteButtonAction:(UIButton*)btn{
    if ([self.delegate  respondsToSelector:@selector(addImageCellClickDeleteButton:)]) {
        [self.delegate  addImageCellClickDeleteButton:self];
    }
}
/**
 *  图片点击
 *
 *  @param tap <#tap description#>
 */
-(void)imageTap:(UITapGestureRecognizer*)tap{
    if ([self.delegate  respondsToSelector:@selector(addImageCellTapImage:)]) {
        [self.delegate  addImageCellTapImage:self];
    }
}
@end
