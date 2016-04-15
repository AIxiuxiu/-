//
//  ZZCaseCollViewController.m
//  萌宝派
//
//  Created by zhizhen on 15/4/13.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZCaseCollViewController.h"
#import "ZZCaseTypeCollectionViewCell.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZPlateTypeInfo.h"
#import "ZZMoreCaseViewContorller.h"
@interface ZZCaseCollViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView*  caseTypeCollectionView;//案例显示的
//@property(nonatomic,strong)UILabel*  caseExplainLabel;//宝宝状况分析
@property(nonatomic,strong)NSArray*  caseTypeArray;
@property(nonatomic)BOOL  isShowCaseAll;//yes 显示all  no显示7个
@property(nonatomic,strong)UITextView* explainTextView;// 案例说明
@property(nonatomic,strong)UIView*  sureBackView;
@property(nonatomic,strong)UIButton*  sureButton;
@property(nonatomic,strong)NSIndexPath*  selectedIndexpath;
@end

@implementation ZZCaseCollViewController

#pragma mark lazy load
-(UICollectionView *)caseTypeCollectionView{
    if (!_caseTypeCollectionView) {
        UICollectionViewFlowLayout*  flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing =0;
        flowLayout.itemSize = CGSizeMake(ScreenWidth/4, 40);
        _caseTypeCollectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(0, 100,ScreenWidth, 80) collectionViewLayout:flowLayout];
        _caseTypeCollectionView.bounces = NO;
        _caseTypeCollectionView.showsVerticalScrollIndicator = NO;
        _caseTypeCollectionView.delegate = self;
        _caseTypeCollectionView.dataSource = self;
        
        _caseTypeCollectionView.backgroundColor = [UIColor  whiteColor];
      //  _caseTypeCollectionView.userInteractionEnabled = NO;
    }
    return _caseTypeCollectionView;
}

-(UITextView *)explainTextView{
    if (!_explainTextView) {
        _explainTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 120)];
       // _explainTextView.layer.borderWidth = .1;
        _explainTextView.textColor = ZZLightGrayColor;
        _explainTextView.layer.masksToBounds = YES;
//        _explainTextView.layer.borderColor = [UIColor  colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor;
        _explainTextView.layer.cornerRadius = 5;
        [_explainTextView setEditable:NO];
         _explainTextView.font = ZZContentFont;

    }
    return _explainTextView;
}
-(UIView *)sureBackView{
    if (!_sureBackView) {
        _sureBackView = [[UIView  alloc]init];
        _sureBackView.backgroundColor = [UIColor  clearColor];
        [_sureBackView  addSubview:self.sureButton];
        [_sureBackView  addSubview:self.explainTextView];
    }
    return _sureBackView;
}
-(UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 140, 120, 30)];
        _sureButton.centerX = ScreenWidth/2;
        [_sureButton setBackgroundColor:ZZGreenColor];
        [_sureButton setTitle:@"相关案例" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _sureButton.layer.cornerRadius = 15;
        [_sureButton addTarget:self action:@selector(nextCaseView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

static  NSString* caseTypeIdentier = @"caseTypeCollectionCell";
#pragma mark  life  cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.caseTypeCollectionView   registerClass:[ZZCaseTypeCollectionViewCell  class] forCellWithReuseIdentifier:caseTypeIdentier];
    self.title  = @"急症室";

    self.automaticallyAdjustsScrollViewInsets = NO;
 
   
    [self  getCaseTypeData];

}
#pragma mark   UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.isShowCaseAll) {
        return (self.caseTypeArray.count/4+1)*4;
    }else{
        return 8;
    }
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZCaseTypeCollectionViewCell*  cell = [collectionView  dequeueReusableCellWithReuseIdentifier:caseTypeIdentier forIndexPath:indexPath];
    if (self.isShowCaseAll) {
        if (indexPath.row<self.caseTypeArray.count) {
            ZZPlateTypeInfo* plateType = self.caseTypeArray[indexPath.row];
            cell.caseTypeNamelabel.text = plateType.title;
            
            cell.caseTypeNamelabel.textColor =[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
            cell.backView.hidden = NO;
        }else{
            cell.caseTypeNamelabel.text = @"";
            cell.backView.hidden = YES;
            if (indexPath.row ==[collectionView  numberOfItemsInSection:0]-1) {
                cell.caseTypeNamelabel.text = @"收起";
                cell.caseTypeNamelabel.textColor = ZZGreenColor;
            }
        }
    }else{
        
        if (indexPath.row<self.caseTypeArray.count&&indexPath.row<7) {
            ZZPlateTypeInfo* plateType = self.caseTypeArray[indexPath.row];
            cell.caseTypeNamelabel.text = plateType.title;
            cell.caseTypeNamelabel.textColor = ZZLightGrayColor;
               cell.backView.hidden = NO;
        }else{
             cell.caseTypeNamelabel.text = @"";
            cell.backView.hidden = YES;
             if (indexPath.row ==[collectionView  numberOfItemsInSection:0]-1) {
            cell.caseTypeNamelabel.text = @"更多";
            cell.caseTypeNamelabel.textColor = ZZGreenColor;
             }
        }
    }
   
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectedIndexpath) {
        ZZCaseTypeCollectionViewCell* cell = (ZZCaseTypeCollectionViewCell*)[self.caseTypeCollectionView cellForItemAtIndexPath:self.selectedIndexpath];
        
        cell.caseTypeNamelabel.textColor = ZZLightGrayColor;
    }
    ZZCaseTypeCollectionViewCell* cell = (ZZCaseTypeCollectionViewCell*)[self.caseTypeCollectionView  cellForItemAtIndexPath:indexPath];

    

    if (self.isShowCaseAll) {
        
        if (indexPath.row<self.caseTypeArray.count) {

        
            cell.caseTypeNamelabel.textColor = [UIColor whiteColor];

            ZZPlateTypeInfo* plateType = self.caseTypeArray[indexPath.row];
            self.selectedIndexpath = indexPath;
            self.sureBackView.frame = CGRectMake(0, self.caseTypeCollectionView.frame.size.height+self.caseTypeCollectionView.frame.origin.y+5, ScreenWidth, 180);
            self.explainTextView.text = plateType.content;
            self.sureBackView.hidden = NO;
        }else{
         
            self.selectedIndexpath = nil;
            self.sureBackView.hidden = YES;
            if (indexPath.row ==[collectionView  numberOfItemsInSection:0]-1) {
                
                self.isShowCaseAll = NO;
                self.caseTypeCollectionView.frame =CGRectMake(0, 100, ScreenWidth,80);
                [self.caseTypeCollectionView  reloadData];
                
            }
        }
    }else{
        
        if (indexPath.row<self.caseTypeArray.count&&indexPath.row<7) {

         
            cell.caseTypeNamelabel.textColor = [UIColor whiteColor];

            ZZPlateTypeInfo* plateType = self.caseTypeArray[indexPath.row];
               self.selectedIndexpath = indexPath;
            self.sureBackView.frame = CGRectMake(0, self.caseTypeCollectionView.frame.size.height+self.caseTypeCollectionView.frame.origin.y+5, ScreenWidth, 180);
            self.explainTextView.text = plateType.content;
            self.sureBackView.hidden = NO;
        }else{
            self.selectedIndexpath = nil;
            self.sureBackView.hidden = YES;
            if (indexPath.row ==[collectionView  numberOfItemsInSection:0]-1) {
                
                self.isShowCaseAll = YES;
                self.caseTypeCollectionView.frame =CGRectMake(0, 100, ScreenWidth, (self.caseTypeArray.count/4+1)*40);
                [self.caseTypeCollectionView  reloadData];
            }
        }
    }
    
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  event response
-(void)nextCaseView:(UIButton*)btn{
    ZZMoreCaseViewContorller* moreCaseView = [[ZZMoreCaseViewContorller alloc]init];
    moreCaseView.caseType = self.caseTypeArray[self.selectedIndexpath.row];
    //    NSLog(@"是不是啊%ld",moreCaseView.caseType);
    [self.navigationController pushViewController:moreCaseView animated:YES];
}
//
-(void)caseNetPostSuccessActionWith:(ZZCaseCollViewController*)vc{
    
    UILabel* babyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 72, 120, 20)];
    babyLabel.text = @"宝宝状况分析";
    babyLabel.font = ZZTitleBoldFont;
    babyLabel.textColor = ZZDarkGrayColor;
    [vc.view  addSubview:babyLabel];
    [vc.view  addSubview:vc.caseTypeCollectionView];
    [vc.view  addSubview:vc.sureBackView];
    vc.sureBackView.hidden = YES;
}
#pragma mark  netRequest
-(void)getCaseTypeData{
    self.tipsLabel.frame = CGRectMake(100, 70, 120, 30);
    self.tipsLabel.centerX = ScreenWidth/2;
    [self.view  addSubview:self.tipsLabel];
    [self   netStartRefresh   ];
      __weak typeof(self) selfVc = self;
    [[ZZMengBaoPaiRequest shareMengBaoPaiRequest] postFindCaseTypeBack:^(id obj) {
        [selfVc  netStopRefresh];
        [selfVc.tipsLabel  removeFromSuperview];
        if (obj ) {
     
            //_caseTypeCollectionView.userInteractionEnabled = YES;
            [selfVc  caseNetPostSuccessActionWith:selfVc];
            selfVc.caseTypeArray = obj;
           
          //  [self.caseTypeCollectionView  reloadData];
         
        }else{
            [selfVc  showAlert:@"数据加载失败"];
        }
    }];
}
#pragma mark   private methods
//  提醒显示
-(void)showAlert:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"谢谢" otherButtonTitles:nil, nil];
    [alert show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
