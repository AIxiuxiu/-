//
//  ZZMessageImageViewController.m
//  萌宝派
//
//  Created by charles on 15/3/23.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZMessageImageViewController.h"
#import "ZZTextView.h"
#import "ZZAddImageCollectionViewCell.h"
#import "ZZPost.h"
#import "ZZMyAlertView.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZUprightViewController.h"
#import "ZZImageSelect.h"

static  const int  imageCount = 10;
@interface ZZMessageImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ZZAddImageCollectionViewCellDelegate,ZZImageSelectDelegate>

@property(nonatomic,strong)ZZTextView* contentView;
@property(nonatomic,strong)UICollectionView* imageCollectCiew;
@property(nonatomic,assign)NSIndexPath* itemCount;
@property(nonatomic,strong)NSMutableArray* imageArr;

@property(nonatomic,strong)UIView* bkView;

@property(nonatomic,strong)UICollectionViewFlowLayout* flowLayout;
@property (nonatomic, strong)UIView *lineView;
@property(nonatomic,strong)UILabel* imageNumLabel;
@property(nonatomic,strong)ZZImageSelect  *imageSelect;
@end

@implementation ZZMessageImageViewController
#pragma mark  lazy load
-(UIView *)bkView{
    if (!_bkView) {
          _bkView = [[UIView alloc]initWithFrame:CGRectMake(10, 74, ScreenWidth-20, ScreenHeight - 84)];
        _bkView.backgroundColor = [UIColor whiteColor];
        _bkView.layer.masksToBounds = YES;
        _bkView.layer.cornerRadius = 5;
        _bkView.layer.borderWidth = .5;
        _bkView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    }
    return _bkView;
}

-(UILabel *)imageNumLabel{
    if (!_imageNumLabel) {
            _imageNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageCollectCiew.frame)+4, ScreenWidth-40, 30)];
        _imageNumLabel.textColor = ZZLightGrayColor;
        _imageNumLabel.textAlignment = NSTextAlignmentCenter;
        _imageNumLabel.font = ZZContentFont;
        [self updateImageNumLabelText];
    }
    return _imageNumLabel;
}

//collection初始化
-(NSMutableArray *)imageArr{
    if (!_imageArr) {
        if (self.publishPost.postImagesArray.count) {
              _imageArr = [self.publishPost.postImagesArray mutableCopy];
        }else{
              _imageArr = [NSMutableArray array];
        }
    }
    return _imageArr;
}

-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //内容大小
        _flowLayout.itemSize = CGSizeMake(64, 112);
        //横向滑动
        [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //相对collectionview的位置
        _flowLayout.minimumLineSpacing = 7;
    }
    return _flowLayout;
}

-(UICollectionView *)imageCollectCiew{
    if (!_imageCollectCiew) {
  
        _imageCollectCiew = [[UICollectionView alloc]initWithFrame:CGRectMake(5,CGRectGetMaxY(self.lineView.frame)+15, ScreenWidth-30, 140) collectionViewLayout:self.flowLayout];
        _imageCollectCiew.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _imageCollectCiew.backgroundColor = [UIColor  clearColor];
        _imageCollectCiew.delegate = self;
        _imageCollectCiew.dataSource = self;
       
    }
    return _imageCollectCiew;
}

-(ZZImageSelect *)imageSelect{
    if (_imageSelect == nil) {
        _imageSelect = [[ZZImageSelect  alloc]init];
        _imageSelect.delegate = self;
     
    }
    return _imageSelect;
}

-(ZZTextView *)contentView{
    if (!_contentView) {
        if (ScreenHeight == 480 ) {
            _contentView = [[ZZTextView alloc]initWithFrame:CGRectMake(10, 8, ScreenWidth-40, 150)];
        }else{
            _contentView = [[ZZTextView alloc]initWithFrame:CGRectMake(10, 8, ScreenWidth-40, 220-50)];
        }
        _contentView.layer.borderColor = [UIColor  clearColor].CGColor;
        _contentView.font = ZZContentFont;
        _contentView.textContentLength = 4000;
        _contentView.placeholder = @" 请输入内容，1-2000字。(可选)";
        _contentView.text = self.publishPost.postContent;
    }
    return _contentView;
}

#pragma mark   life cycle
static  NSString* addImageCellIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建内容";
    [self.view addSubview:self.bkView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.bkView addSubview:self.contentView];
    
    UIView* line = [[UIView alloc]init];
    line.frame = CGRectMake(5, CGRectGetMaxY(self.contentView.frame)+15, ScreenWidth-30, 0.5);
    line.backgroundColor = ZZGrayWhiteColor;
    self.lineView = line;
    [self.bkView addSubview:line];
    
    //加载collectionView
    [self.bkView  addSubview:self.imageCollectCiew];
    //注册collectionViewcell
    [self.imageCollectCiew  registerClass:[ZZAddImageCollectionViewCell  class] forCellWithReuseIdentifier:addImageCellIdentifier];
    [self.bkView addSubview:self.imageNumLabel];
    
    UIButton* btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btn1  setTitle:@"发布" forState:UIControlStateNormal];
    [btn1   setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    btn1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    //btn1.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn1 addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*  rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -5;//此处修改到边界的距离，请自行测试
        [self.navigationItem setRightBarButtonItems:@[negativeSeperator,rightBarButtonItem]];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem: rightBarButtonItem animated:NO];
    }
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark  event  response
//返回按钮事件，重写
-(void)goBack{
    
    self.publishPost.postContent = self.contentView.text;
    self.publishPost.postImagesArray = self.imageArr;
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)sureButtonAction:(UIButton*)btn{
    [self.contentView   resignFirstResponder];
    NSString*  str = [self  removeWhitespaceAndNewlineCharacterWithOrignString:self.contentView.text];
    if (str.length == 0) {
        ZZMyAlertView*  alertView = [[ZZMyAlertView  alloc]initWithMessage:@"你还没有填写内容" delegate:nil cancelButtonTitle:@"确定" sureButtonTitle:nil];
        [alertView  show];
        return;
    }
    
    btn.userInteractionEnabled = NO;
    
    [btn  setTitle:@"发布中" forState:UIControlStateNormal];
       [btn   setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postAddNewStarPostWithPlate:self.publishPost.postPlateType  andTitle:self.publishPost.postTitle andContent:self.contentView.text andImageArray:self.imageArr andBack:^(id obj) {
        [btn  setTitle:@"发布" forState:UIControlStateNormal];
           [btn   setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        btn.userInteractionEnabled = YES;
        if (obj) {
            [self  gobackWith:obj];
        }else{
            [self  netLoadFailWithText:@"网络不给力，发布失败" isBack:YES];
        }
    }];
}

#pragma mark ---UICollectionViewDelegate


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.imageArr.count == imageCount ? imageCount:(self.imageArr.count+1);
//    if (self.imageArr.count == 10) {
//        return 10;
//    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZAddImageCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:addImageCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row == self.imageArr.count ) {
        
        cell.addImage.image = [UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]  pathForResource:@"add_range_64x112" ofType:@"png"]];
        cell.deleteButton .hidden = YES;
   }else{
        
        cell.deleteButton.hidden = NO;
        //cell.backgroundColor = [UIColor  clearColor];
        cell.addImage.image = self.imageArr[indexPath.item];
   }
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.imageArr.count==0) {
        return UIEdgeInsetsMake(0, ScreenWidth/2-52+7, 0, 0);
    }
    return  UIEdgeInsetsMake(0, 7, 0, 0);
}

//collectionView点击事件
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self.contentView   resignFirstResponder];

//    }
//}

#pragma  mark ZZImageSelectViewDelegate
/**
 *  显示大图
 *
 *  @param imageSelect <#imageSelect description#>
 *  @param indexPath   <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(UIImageView *)imageSelect:(NSObject *)imageSelect atIndexPath:(NSIndexPath *)indexPath{
    ZZAddImageCollectionViewCell* cell = (ZZAddImageCollectionViewCell*)[self.imageCollectCiew  cellForItemAtIndexPath:indexPath];
    return cell.addImage;
}

-(void)imageSelect:(NSObject *)imageSelect deleteAtIndexPath:(NSIndexPath *)indexPath{
    [self.imageArr removeObjectAtIndex:indexPath.row];
    [self.imageCollectCiew reloadData];

    [self  updateImageNumLabelText];
}

-(void)imageSelect:(NSObject *)imageSelect images:(NSArray *)images{
    [self.imageArr  addObjectsFromArray:images];
   //[self.imageArr  insertObjects:images atIndexes:<#(NSIndexSet *)#>]
    //[self.imageCollectCiew  insertItemsAtIndexPaths:indexpaths];
    
    [self.imageCollectCiew  reloadData];
    [self  updateImageNumLabelText];
    [self.imageCollectCiew  scrollToItemAtIndexPath:[NSIndexPath  indexPathForItem:[self.imageCollectCiew  numberOfItemsInSection:0]-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}

#pragma  mark ZZAddImageCollectionViewCellDelegate
//删除按钮响应
-(void)addImageCellClickDeleteButton:(ZZAddImageCollectionViewCell *)addImageCell{
    NSIndexPath* indexpath  = [self.imageCollectCiew indexPathForCell:addImageCell];
    [self.imageSelect  deleteImage:indexpath];
//    [self.imageArr removeObjectAtIndex:indexpath.row];
//    [self.imageCollectCiew deleteItemsAtIndexPaths:@[indexpath]];
//    
//    [self  updateImageNumLabelText];
}
-(void)addImageCellTapImage:(ZZAddImageCollectionViewCell *)addImageCell{
   [self.contentView   resignFirstResponder];
    NSIndexPath* indexpath  = [self.imageCollectCiew indexPathForCell:addImageCell];
    
        if (indexpath.row == self.imageArr.count) {
            self.imageSelect.maxCount = imageCount - self.imageArr.count;
           [self.imageSelect imageSelectShow];
        }else{
             [self.imageSelect  imageFullScreen:indexpath];
        }
   
}
#pragma mark private methods
//发布成功后返回刷新数据
-(void)gobackWith:(NSDictionary*)dic{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[ZZUprightViewController class]]) {
            ZZUprightViewController*  uprightVC =(ZZUprightViewController*)temp;
            
            [uprightVC  publishSuccessRefreshWith:dic];
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
}
/**
 *  更新图片数量提示信息
 */
-(void)updateImageNumLabelText{
    if (self.imageArr.count == 0) {
        self.imageNumLabel.text = [NSString  stringWithFormat:@"可选择%d张图片",imageCount];
    }else{
        self.imageNumLabel.text = [NSString stringWithFormat:@"已选%ld张，还可添加%ld张",self.imageArr.count,imageCount-self.imageArr.count];
    }
}
@end
