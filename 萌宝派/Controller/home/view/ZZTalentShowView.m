//
//  ZZTalentShowView.m
//  萌宝派
//
//  Created by zhizhen on 15/8/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZTalentShowView.h"
#import "ZZMasterCollectionViewCell.h"
#import "ZZAttentionHeadViewController.h"
#import "DDMenuController.h"
@interface ZZTalentShowView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation ZZTalentShowView
static  NSString*  fiveCellIndetifier = @"fiveCell";
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super  initWithFrame:frame];
    if (self) {
     
        [self  setChildView];
        [self.collectionView   registerClass:[ZZMasterCollectionViewCell  class] forCellWithReuseIdentifier:fiveCellIndetifier];
        self.frame = frame;
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super  setFrame:frame];
    CGFloat width = frame.size.width;
    self.titleLabel.frame = CGRectMake(0, upDownSpace, width, 20);
    
    CGFloat y = CGRectGetMaxY(self.titleLabel.frame) + upDownSpace;
    CGFloat height = frame.size.height - y;
    self.collectionView.frame = CGRectMake(0, y, width, height);
}
- (void)setChildView{
    //大人推荐label
    UILabel*   label = [[UILabel  alloc]init];
    label.text = @"达人推荐";
    label.textColor = [UIColor  grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = label;
    [self  addSubview:label];
    //collectionview
    UICollectionViewFlowLayout*  flowlayout = [[UICollectionViewFlowLayout  alloc]init];
    flowlayout.itemSize = CGSizeMake(57, 75);
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    flowlayout.minimumLineSpacing = 5 * ScreenWidth/320;
    // attentionCVFlowlayout.minimumInteritemSpacing = 3;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView  alloc]initWithFrame:CGRectZero collectionViewLayout:flowlayout];
    self.collectionView.backgroundColor = [UIColor  clearColor];
    self.collectionView.scrollsToTop = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}
-(void)setTalentArray:(NSArray *)talentArray{
    _talentArray = talentArray;
    [self.collectionView  reloadData];
}
#pragma mark --UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.talentArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZMasterCollectionViewCell*  collectionCell = [collectionView   dequeueReusableCellWithReuseIdentifier:fiveCellIndetifier forIndexPath:indexPath];
    //collectionCell.backgroundColor = [UIColor  greenColor];
    collectionCell.masterUser = self.talentArray[indexPath.item];
    
    /*
     张亮亮  0511   添加
     [collectionCell  setNeedsLayout];
     */
    [collectionCell  setNeedsLayout];
    
    
    return collectionCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DDMenuController *rooViewC = (DDMenuController *)[[[UIApplication  sharedApplication]keyWindow] rootViewController];
    UITabBarController *tabBar = (UITabBarController *)rooViewC.rootViewController;
    UINavigationController * navi = (UINavigationController *)tabBar.selectedViewController;
    ZZAttentionHeadViewController* headView = [[ZZAttentionHeadViewController alloc]init];
    headView.user = self.talentArray[indexPath.item];
    [navi pushViewController:headView animated:YES];
    [collectionView  deselectItemAtIndexPath:indexPath animated:YES];
}


@end
