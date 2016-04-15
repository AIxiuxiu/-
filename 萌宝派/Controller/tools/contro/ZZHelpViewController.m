//
//  ZZHelpViewController.m
//  萌宝派
//
//  Created by charles on 15/3/12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZHelpViewController.h"

#import "ZZDynamicViewController.h"
#import "ZZOutdoorViewController.h"

#import "ZZTabBarViewController.h"
#import "ZZMengBaoPaiRequest.h"

#import "ZZBabyAdviceListVC.h"


#import "ZZVaccinationTimeVC.h"

//#import "ZZAttentionTableViewCell.h"
//#import "ZZUser.h"
//#import "UIImageView+WebCache.h"
//#import "ZZInfoDetailCell.h"
//#import "ZZPost.h"
//
//#import "ZZLastCell.h"
//
//#import "MJRefresh.h"
//
#import "ZZCaseCollViewController.h"
#import "ZZAttentionHeadViewController.h"
#import "ZZWonderDetailViewController.h"
//
#import "ZZTollsCollectionViewCell.h"
#import "ZZToolSHeadCrv.h"
@interface ZZHelpViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//@property(nonatomic,strong)NSArray* postArr;
//@property(nonatomic,strong)NSArray* imageArr;

//
@property(nonatomic,strong)UICollectionView*  helpToolsCV;

//记录退出搜索界面时的字符串
@property(nonatomic,strong)NSString* lastSearchStr;
@end

@implementation ZZHelpViewController


#pragma mark  lazy  load
-(UICollectionView *)helpToolsCV{
    if (!_helpToolsCV) {
        
        CGFloat lrMargin = 20;
        CGFloat width = ScreenWidth - 2*lrMargin;
        CGFloat  height = (ScreenHeight- 70 - 50- 3*120);
      
        UICollectionViewFlowLayout*  flowlayout = [[UICollectionViewFlowLayout  alloc]init];
        flowlayout.itemSize = CGSizeMake(width/2, 92+height/9);
        flowlayout.minimumLineSpacing = 0;
        flowlayout.minimumInteritemSpacing = 0;
        flowlayout.headerReferenceSize = CGSizeMake(width, 28 + height/3);
        flowlayout.footerReferenceSize = CGSizeMake(width, 1);
        _helpToolsCV = [[UICollectionView  alloc]initWithFrame:CGRectMake(lrMargin, 69, width, ScreenHeight - 69-49) collectionViewLayout:flowlayout];
        _helpToolsCV.dataSource = self;
        _helpToolsCV.backgroundColor = [UIColor   clearColor];
        _helpToolsCV.delegate = self;
    }
    return _helpToolsCV;
}
static  NSString * tollsCellIden = @"TollsCell";
static  NSString *  tollsHeadViewIden = @"TollsHeadView";
static  NSString*  tollsFooterViewIden = @"TollsFooterView";
#pragma mark  life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"工具";
    [self.helpToolsCV  registerClass:[ZZTollsCollectionViewCell  class] forCellWithReuseIdentifier:tollsCellIden];
    [self.helpToolsCV  registerClass:[ZZToolSHeadCrv  class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:tollsHeadViewIden];
    [self.helpToolsCV  registerClass:[UICollectionReusableView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:tollsFooterViewIden];
    [self.view  addSubview:self.helpToolsCV];


}

#pragma mark   UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSUInteger item=0;
    switch (section) {
        case 0:
            item = 2;
            break;
        case 1:
            item = 2;
            break;
   
    }
    return item;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZTollsCollectionViewCell*  cell = [collectionView   dequeueReusableCellWithReuseIdentifier:tollsCellIden forIndexPath:indexPath];
   
    cell.indexpath = indexPath;
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView*  headView ;
    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:tollsHeadViewIden forIndexPath:indexPath];
        NSString*  titleText;
        ZZToolSHeadCrv*  headCrv = (ZZToolSHeadCrv*)headView;
        switch (indexPath.section) {
            case 0:
                titleText = @"实用工具";
                break;

            case 1:
                titleText = @"知识工具";
                break;
           
        }
        headCrv.titleLabel.text = titleText;

    }
    else if([kind isEqual:UICollectionElementKindSectionFooter])
    {
        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:tollsFooterViewIden forIndexPath:indexPath];
        headView.backgroundColor = [UIColor  colorWithRed:0.78 green:0.8 blue:0.8 alpha:1];

    }
    return headView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:
                {
                    ZZCaseCollViewController*  caseVC = [[ZZCaseCollViewController alloc]init];
                    [self.navigationController pushViewController:caseVC animated:YES];
                }
                    break;
              case 1:
                {
                  
                    ZZOutdoorViewController* outdoorView = [[ZZOutdoorViewController alloc]init];
                    
                    //[self  presentViewController:outdoorView animated:YES completion:nil];
                    [self.navigationController pushViewController:outdoorView animated:YES];
                }
                    break;
            }
            
        }
            break;
//            
//        case 1:{
//            ZZBabyListViewController*  babyListVC = [[ZZBabyListViewController  alloc]init];
//            [self.navigationController  pushViewController:babyListVC animated:YES];
//              }
//            break;
        case 1:{
            switch (indexPath.row) {
                case 0:
                {
                    ZZBabyAdviceListVC*  babyAdviceVC = [[ZZBabyAdviceListVC  alloc]init];
                    [self.navigationController  pushViewController:babyAdviceVC animated:YES];
                }
                    break;
                  case 1:
                {
                    ZZVaccinationTimeVC*  vaccVC = [[ZZVaccinationTimeVC  alloc]init];
                    [self.navigationController  pushViewController:vaccVC animated:YES];
                }
                               }
            }
            break;
    }
}
@end
