//
//  ZZAddImageCollectionViewCell.h
//  萌宝派
//
//  Created by charles on 15/3/23.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZAddImageCollectionViewCell;

@protocol ZZAddImageCollectionViewCellDelegate <NSObject>
/**
 *  删除按钮响应事件
 *
 *  @param addImageCell <#addImageCell description#>
 */
-(void)addImageCellClickDeleteButton:(ZZAddImageCollectionViewCell*)addImageCell;

-(void)addImageCellTapImage:(ZZAddImageCollectionViewCell*)addImageCell;
@end


@interface ZZAddImageCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView* addImage;
@property(nonatomic,strong)UIButton* deleteButton;

@property(nonatomic)id<ZZAddImageCollectionViewCellDelegate> delegate;
@end
