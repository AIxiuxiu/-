//
//  ZZImageSelect.h
//  萌宝派
//
//  Created by zhizhen on 15/7/20.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZImageSelect;
@protocol ZZImageSelectDelegate <NSObject>
/**
 *  图片选完后回调
 *
 *  @param imageSelect <#imageSelect description#>
 *  @param images      <#images description#>
 */
-(void)imageSelect:(ZZImageSelect *)imageSelect images:(NSArray*)images;

@optional //可选实现的方法
/**
 *  根据indexPath获取相应的imageview
 *
 *  @param imageSelect <#imageSelect description#>
 *  @param indexPath   <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UIImageView*)imageSelect:(ZZImageSelect*)imageSelect  atIndexPath:(NSIndexPath *)indexPath;

/**
 *  删除某张图片
 *
 *  @param imageSelect <#imageSelect description#>
 *  @param indexPath   <#indexPath description#>
 */
-(void)imageSelect:(ZZImageSelect*)imageSelect  deleteAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface ZZImageSelect : NSObject
// 拍照的个数限制
@property (assign,nonatomic) NSUInteger maxCount;
/**
 *  代理对象
 */
@property (nonatomic,weak)UIViewController<ZZImageSelectDelegate> *delegate;

/**
 *  调用系统的相册相机，一次选择一张图片，支持剪切
 */
@property(nonatomic,getter=isHead)BOOL head;

/**
 *  调用系统的相机相册时，是否可以编辑
 */
@property(nonatomic)BOOL  headEdit;
/**
 *  选择相机、照片库加载
 */
-(void)imageSelectShow;

/**
 *  查看全屏图
 */
-(void)imageFullScreen:(NSIndexPath*)indexpath;

/**
 *  删除某张图片
 */
-(void)deleteImage:(NSIndexPath*)indexpath;
@end
