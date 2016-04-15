//
//  ZZFunctionView.m
//  萌宝派
//
//  Created by zhizhen on 15/8/11.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZFunctionView.h"
#import "ZZFunctionCollCell.h"
#import "ZZMyAlertView.h"
@interface ZZFunctionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ZZMyAlertViewDelgate>
@property (nonatomic, strong)NSArray *functionobArray;
@end
@implementation ZZFunctionView
static  NSString*  functionCellIden = @"FunctionCell";
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super  initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self   registerClass:[ZZFunctionCollCell  class] forCellWithReuseIdentifier:functionCellIden];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}
-(void)setPost:(ZZPost *)post{
    if (_post) {
        [self  removeOberver];
    }
    _post = post;

    self.functionobArray = [ZZFunctionOb  getPostDetailFunctionArrayWithPost:post];
    [post  addObserver:self forKeyPath:@"postStoreUp" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [post  addObserver:self forKeyPath:@"postOrderSort" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self  reloadData];
}
#pragma mark ----UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.functionobArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZFunctionCollCell*  cell = [collectionView  dequeueReusableCellWithReuseIdentifier:functionCellIden forIndexPath:indexPath];
    ZZFunctionOb*  functionOb = self.functionobArray[indexPath.item];
    cell.nameLabel.text = functionOb.fNameStr;
    cell.nameIv.image = [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:functionOb.fImageNameStr ofType:nil]];
    [cell  setNeedsLayout];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![self.funDelegate  respondsToSelector:@selector(functionViewItemDidSelect:funType:)]) {
        return;
    }
    ZZFunctionOb*  functionOb = self.functionobArray[indexPath.item];
    
    switch (functionOb.functionObType) {
        case ZZFunctionObTypeCollection:
        {
            if(self.post.postStoreUp ){
                ZZMyAlertView*  myAlert = [[ZZMyAlertView  alloc]initWithMessage:@"你确定要取消收藏这个帖子嘛" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
                myAlert.tag = 333;
                [myAlert  show];
                return;
            }else{
                [self  callFunDelegateMethod:ZZFunctionObTypeCollection];
            }
        }
            break;
            
        case ZZFunctionObTypeShare:
        {//分享
            [self  callFunDelegateMethod:ZZFunctionObTypeShare];
        }
            break;
            
        case ZZFunctionObTypeReport:
        {//举报
            
            ZZMyAlertView*  myAlert = [[ZZMyAlertView  alloc]initWithMessage:@"你确定要举报这个帖子嘛" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
            myAlert.tag = 444;
            [myAlert  show];
            return;
        }
            break;
            
        case ZZFunctionObTypeOrder:
        {//序列：正序，倒序
            
            [self  callFunDelegateMethod:ZZFunctionObTypeOrder];
            //            [[ZZMengBaoPaiRequest shareMengBaoPaiRequest]postFindStarConstellationPostReplyWithPlate:self.postIncoming.postPlateType andPostId:self.postIncoming.postId andUpdown:0 andReplyId:0 andSort:!self.sort+1 andBack:^(id obj) {
            //                if(obj){
            //                    self.sort = !self.sort;
            //                    [self  functionChangeRefreshWithFunctionType:ZZFunctionObTypeOrder];
            //                    self.replayArr = obj ;
            //                    [self.detailView  reloadData];
            //                }
            //
            //            }];
        }
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.functionobArray.count<4) {
        return UIEdgeInsetsMake(0, 40*(4-self.functionobArray.count), 0, 40*(4-self.functionobArray.count));
    }
    return  UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - ZZMyAlertViewDelgate
-(void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {//点击确定按钮
        if(alertView.tag == 333){//取消收藏
            [self  callFunDelegateMethod:ZZFunctionObTypeCollection];
        }else if (alertView.tag == 444){//确定举报
            [self  callFunDelegateMethod:ZZFunctionObTypeReport];
        }
    }
}
//kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"postStoreUp"])
    {
        ZZFunctionOb *first = self.functionobArray[0];
        if (self.post.postStoreUp) {
            first.fNameStr =@"已收藏";
        }else{
            first.fNameStr =@"收藏";
        }
        [self  reloadItemsAtIndexPaths:@[[NSIndexPath  indexPathForItem:0 inSection:0]]];
    }else if ([keyPath isEqualToString:@"postOrderSort"]){
        ZZFunctionOb *first = [self.functionobArray lastObject];
        if (self.post.postOrderSort) {
            first.fNameStr =@"正序";
        }else{
            first.fNameStr =@"倒序";
        }
         [self  reloadItemsAtIndexPaths:@[[NSIndexPath  indexPathForItem:self.functionobArray.count-1 inSection:0]]];
    }
}
//调用协议方法
- (void)callFunDelegateMethod:(ZZFunctionObType)type{
    [self.funDelegate  functionViewItemDidSelect:self funType:type];
}

-(void)dealloc{
    [self  removeOberver];
}
- (void)removeOberver{
    [_post  removeObserver:self forKeyPath:@"postStoreUp"];
    [_post  removeObserver:self forKeyPath:@"postOrderSort"];
}
@end
