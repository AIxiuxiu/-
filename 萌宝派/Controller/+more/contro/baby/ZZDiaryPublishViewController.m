//
//  ZZDiaryPublishViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-13.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZDiaryPublishViewController.h"
#import "ZZDiaryPublishCell.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZDiaryViewController.h"
#import "ZZTextViewPublishContentCell.h"
#import "ZZImageSelect.h"
#import "ZZImageAndDescribe.h"
#import "ZZMyAlertView.h"
#import "ZZBaby.h"
#import "ZZPost.h"

static  const  NSUInteger  imageCount = 10;

@interface ZZDiaryPublishViewController ()<UITableViewDataSource,UITableViewDelegate,ZZImageSelectDelegate,ZZDiaryPublishCellDelegate>

@property (nonatomic,strong)UIView* bkView;

@property(nonatomic,strong)UILabel* imageNumLabel;

@property(nonatomic,strong)NSIndexPath* imageIndex;

@property(nonatomic,strong)NSIndexPath* editingCellIndenxpath;
@property(nonatomic,strong)ZZImageSelect*   imageSelect ;
@end

@implementation ZZDiaryPublishViewController
#pragma mark lazy load
-(UIView *)bkView{
    if (!_bkView) {
        _bkView = [[UIView alloc]init];
    
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
        _imageNumLabel = [[UILabel alloc]init];
        _imageNumLabel.textColor = ZZLightGrayColor;
        _imageNumLabel.textAlignment = NSTextAlignmentCenter;
        _imageNumLabel.font = ZZContentFont;
        [self  updateImageCountLabel];
    }
    return _imageNumLabel;
}

-(UITableView *)publishTableView{
    if(!_publishTableView){
     
        _publishTableView = [[UITableView  alloc]init];
        _publishTableView.backgroundColor = [UIColor  clearColor];
        _publishTableView.delegate =self;
       _publishTableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
        _publishTableView.dataSource = self;
        _publishTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
       _publishTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _publishTableView;
}

-(NSMutableArray *)imagesMarray{
    if (!_imagesMarray) {
        if (self.publishPost.postImagesArray.count) {
             _imagesMarray = [self.publishPost.postImagesArray  mutableCopy];
        }else{
            _imagesMarray = [NSMutableArray  arrayWithCapacity:2];
        }
       
    }
    return _imagesMarray;
}
-(ZZImageSelect *)imageSelect{
    if (_imageSelect == nil) {
        _imageSelect = [[ZZImageSelect  alloc]init];
        _imageSelect.delegate = self;
    }
    return _imageSelect;
}
//-(ZZSelectImageView *)selectIV{
//    if (!_selectIV) {
//        _selectIV = [[ZZSelectImageView  alloc]init];
//        _selectIV.delegate = self;
//    }
//    return _selectIV;
//}

#pragma mark life  cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日记发布";
    
    [self.bkView  addSubview:self.publishTableView];
    [self.bkView  addSubview:self.imageNumLabel];
    [self.view addSubview:self.bkView];
   // [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(textViewBeginEdit:) name:UITextViewTextDidBeginEditingNotification object:nil];
  
    UIButton* btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btn1  setTitle:@"发布" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
       [btn1   setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
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
    self.publishString = self.publishPost.postContent;
    self.automaticallyAdjustsScrollViewInsets = NO;
     [self  updateRelationViewFrameWithFrame:CGRectMake(10, 74, ScreenWidth -20, ScreenHeight -84)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(keyboardWillApear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(keyboardWillDisApear:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(textViewBeginEdit:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(textViewEndEdit:) name:UITextViewTextDidEndEditingNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super  viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
}

#pragma mark private methods
/**
 *  更新相关view的frame  bkView、imageNumLabel、publishTableView
 *
 *  @param viewFrame  bkView的frame
 */
-(void)updateRelationViewFrameWithFrame:(CGRect)viewFrame{
    //CGRectMake2(10, 74, AutoSizex-20, AutoSizey-84)
    //CGRectMake2(0,10, 300, AutoSizey-84-40)
    //CGRectMake1(10, self.bkView.bounds.size.height/AutoSizeScaley-30, 280, 30)
    self.bkView.frame = viewFrame;
    self.publishTableView.frame = CGRectMake(0, 0, CGRectGetWidth(viewFrame), CGRectGetHeight(viewFrame)-30);
    self.imageNumLabel.frame = CGRectMake(10, CGRectGetHeight(viewFrame)-30, CGRectGetWidth(viewFrame)-20, 30);
}

//更新图片数量
-(void)updateImageCountLabel{
    if (self.imagesMarray.count == 0) {
        self.imageNumLabel.text =  [NSString  stringWithFormat:@"可选择%ld张图片",imageCount];
    }else{
        
        self.imageNumLabel.text = [NSString stringWithFormat:@"已选%ld张，还可添加%ld张",self.imagesMarray.count,imageCount-self.imagesMarray.count];
        
    }
}

- (NSIndexPath*)btnActionForUserSetting:(id) sender {
    
    NSIndexPath *indexPath = [self.publishTableView indexPathForSelectedRow];
    
    return indexPath;
}

//发布成功，调用方法
-(void)gogobackWith:(NSArray*)array{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[ZZDiaryViewController class]]) {
            ZZDiaryViewController*  uprightVC =(ZZDiaryViewController*)temp;
            [uprightVC  publishSuccessRefreshWith:array];
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

#pragma mark event response
//返回按钮事件，重写
-(void)goBack{
    self.publishPost.postContent = self.publishString;
    self.publishPost.postImagesArray = self.imagesMarray;
    
    [self.navigationController popViewControllerAnimated:YES];
}

//提交按钮
-(void)sureButtonAction:(UIButton*)btn{
    [self.view endEditing:YES];
    NSUInteger imageCount= self.imagesMarray.count;
 
    
    if (imageCount==0) {
        ZZMyAlertView*  alertView= [[ZZMyAlertView  alloc]initWithMessage:@"请添加图片，最少一张" delegate:nil cancelButtonTitle:@"确定" sureButtonTitle:nil];
        [alertView  show];
        return;
    }else{
        btn.userInteractionEnabled = NO;
        [btn  setTitle:@"发布中" forState:UIControlStateNormal];
           [btn  setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [[ZZMengBaoPaiRequest shareMengBaoPaiRequest]postAddBabyGrowingLogWithBabyId:self.babyInfo.babyId andImageArray:self.imagesMarray andBack:^(id obj) {
            [btn  setTitle:@"发布" forState:UIControlStateNormal];
               [btn   setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
            btn.userInteractionEnabled = YES;
            if (obj) {
                [self gogobackWith:obj];
            }
           
            
        }];
        
    }
    
}

//   图片响应事件
-(void)changeIVimage:(UITapGestureRecognizer*)tap{
    CGPoint  point = [tap  locationInView:self.publishTableView];
    NSIndexPath* indexpath1 = [self.publishTableView  indexPathForRowAtPoint:point];
    self.setectTag =indexpath1.row;
    NSIndexPath*  indexpath;
    if (self.babyInfo) {
        indexpath = [NSIndexPath   indexPathForRow:self.setectTag inSection:0];
    }else{
        indexpath = [NSIndexPath   indexPathForRow:self.setectTag inSection:1];
    }
    
    [self.publishTableView  scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

#pragma  mark  NSNotification
//键盘显现
-(void)keyboardWillApear:(NSNotification*)noti{

    NSDictionary *userInfo = noti.userInfo;
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    CGRect bkFrame =  CGRectMake(10, 74, ScreenWidth -20, ScreenHeight -84);
    CGRect backViewFrame = CGRectMake(CGRectGetMinX(bkFrame), CGRectGetMinY(bkFrame), CGRectGetWidth(bkFrame), CGRectGetHeight(bkFrame)-keyboardFrame.size.height);
 
   
    [UIView  animateKeyframesWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue] delay:0 options:[userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue] animations:^{
       
        [self  updateRelationViewFrameWithFrame:backViewFrame];

    } completion:^(BOOL finished) {
        if (self.editingCellIndenxpath) {
            [self.publishTableView  scrollToRowAtIndexPath:self.editingCellIndenxpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }];

}

//textview结束编辑
-(void)textViewEndEdit:(NSNotification*)noti{
    
    UITextView*  textView = (UITextView*)noti.object;
   
    if (textView==nil) {
        return;
    }
    if (self.editingCellIndenxpath==nil) {
        return;
    }
    
    NSIndexPath* indexPath = self.editingCellIndenxpath;
    
    if (self.babyInfo) {
        ZZImageAndDescribe*  imageStr = self.imagesMarray[indexPath.row];
        imageStr.decribeStr = textView.text;
    }else{
        if (indexPath.section) {
            ZZImageAndDescribe*  imageStr = self.imagesMarray[indexPath.row];
            imageStr.decribeStr = textView.text;
        }else{
            self.publishString = textView.text;
        }
    }
    
}

//textview开始编辑
-(void)textViewBeginEdit:(NSNotification*)noti{
    UITextView*  textView = (UITextView*)noti.object;
    if ( textView == nil ) {
        return;
    }
  
   UITableViewCell* diaryCell =(UITableViewCell*)[UITableViewCell  viewByChildView:textView];
    if (diaryCell == nil) {
        return;
    }
    NSIndexPath* indexPath = [self.publishTableView indexPathForCell:diaryCell];
    if(indexPath == nil){
        return;
    }
    self.editingCellIndenxpath = indexPath;
    if (self.babyInfo) {
        ZZImageAndDescribe*  imageStr = self.imagesMarray[indexPath.row];
        textView.text = imageStr.decribeStr;
    }else{
        if (indexPath.section) {
            ZZImageAndDescribe*  imageStr = self.imagesMarray[indexPath.row];
            textView.text = imageStr.decribeStr;
        }else{
            textView.text = self.publishString;
        }
    }
    
    [self.publishTableView  scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
 
}

//键盘消失
-(void)keyboardWillDisApear:(NSNotification*)noti{
    NSDictionary *userInfo = noti.userInfo;


    CGRect bkFrame =  CGRectMake(10, 74, ScreenWidth -20, ScreenHeight -84);
    
    [UIView  animateKeyframesWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue] delay:0 options:[userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue] animations:^{
        
        [self  updateRelationViewFrameWithFrame:bkFrame];
        
    } completion:nil];
}

#pragma mark  --------UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.babyInfo) {//c此时发表宝宝日记
        return 1;
    }else{
        return 2;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.babyInfo) {//c此时发表宝宝日记
        if (self.imagesMarray.count == 10) {
            return 10;
        }else{
            return self.imagesMarray.count+1;
        }
    }else{
        if (section) {
            if (self.imagesMarray.count == 10) {
                return 10;
            }else{
                return self.imagesMarray.count+1;
            }
        }else{
            return 1;
        }
    }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 122;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString*  diaryPublishCellIden = @"diaryPublishCell";
    static  NSString*  textViewPublishContent = @"textViewPublishContentCell";
    if (!self.babyInfo&&(indexPath.section==0)) {
        ZZTextViewPublishContentCell*  textCell = [tableView  dequeueReusableCellWithIdentifier:textViewPublishContent];
        if (textCell == nil) {
            textCell = [[ZZTextViewPublishContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textViewPublishContent];
            textCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        textCell.inputTextView.text = self.publishString;
        return textCell;
    }else{
        ZZDiaryPublishCell*  cell = [tableView  dequeueReusableCellWithIdentifier:diaryPublishCellIden];
        if (cell==nil) {
            cell = [[ZZDiaryPublishCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:diaryPublishCellIden];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
   
        if (indexPath.row == self.imagesMarray.count) {
            cell.addImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]  pathForResource:@"add_range_64x112" ofType:@"png"]];
            cell.inputTextView.hidden = YES;;
            cell.addImageView.frame = CGRectMake(ScreenWidth/2-42, 5,64, 112);
            cell.inputTextView.text = nil;
        
        }else{
            ZZImageAndDescribe* imageAndStr = self.imagesMarray[indexPath.row];
            cell.addImageView.image = imageAndStr.showImage;
            cell.inputTextView.text = imageAndStr.decribeStr;
            cell.inputTextView.hidden = NO;
            //cell.inputTextView.editable = YES;
            cell.inputTextView.frame = CGRectMake(20+64, 5, ScreenWidth-50-64, 112);
            cell.addImageView.frame = CGRectMake(10, 5, 64, 112);
        }
        return cell;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.babyInfo ||indexPath.section) {
            return YES;
    }else {
        return NO;
    }

}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//       self.imageIndex = nil;
//    [self.view endEditing:YES];
//    
//    if (indexPath.row == self.imagesMarray.count) {
//     
//        [self.imageSelect  imageSelectShow];
//    }else{
//        self.imageIndex = indexPath;
//       
//    }
//    
//}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == self.imagesMarray.count && self.imagesMarray.count != 10) {
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.imageSelect  deleteImage:indexPath];
//        [self.imagesMarray  removeObjectAtIndex:indexPath.row];
//     
//        if (self.imagesMarray.count == 9) {
//            if (self.babyInfo) {
//                   [self.publishTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.imagesMarray.count inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }else{
//                   [self.publishTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.imagesMarray.count inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }
//         
//            
//        }else{
//            
//            [self.publishTableView  beginUpdates];
//            [self.publishTableView  deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.publishTableView  endUpdates];
//        }
//        
//        [self  updateImageCountLabel];
 
    }
}
#pragma mark    ZZImageSelectDelegate
-(void)imageSelect:(NSObject *)imageSelect images:(NSArray *)images{
 
    for (UIImage *image in images) {
        ZZImageAndDescribe* imageStr = [[ZZImageAndDescribe  alloc]init];
        imageStr.showImage = image;
        
        [self.imagesMarray addObject:imageStr];
    }
    [self.publishTableView  reloadData];
    [self  updateImageCountLabel];
    if (self.babyInfo) {
        [self.publishTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.publishTableView numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }else{
        [self.publishTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.publishTableView numberOfRowsInSection:1]-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
#pragma mark    ZZDiaryPublishCellDelegate
-(void)diaryPublishCellTapImageAction:(ZZDiaryPublishCell *)diaryPC{
    [self.view  endEditing:YES];
    NSIndexPath *indexPath = [self.publishTableView  indexPathForCell:diaryPC];
    if (indexPath.row == self.imagesMarray.count) {
        self.imageSelect.maxCount = imageCount - self.imagesMarray.count;
        [self.imageSelect  imageSelectShow];
    }else{
        [self.imageSelect imageFullScreen:indexPath];
    }
}

-(UIImageView *)imageSelect:(NSObject *)imageSelect atIndexPath:(NSIndexPath *)indexPath{
    ZZDiaryPublishCell  *diaryPublishCell = (ZZDiaryPublishCell*)[self.publishTableView  cellForRowAtIndexPath:indexPath];
    
    return diaryPublishCell.addImageView;
}

-(void)imageSelect:(NSObject *)imageSelect deleteAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.imagesMarray  removeObjectAtIndex:indexPath.row];
    [self.publishTableView  reloadData];
    [self updateImageCountLabel];
}
#pragma  mark ZZSelectImageViewDelegate


-(void)selectImage:(UIImage*)image{
    
    if (self.imageIndex) {
        ZZImageAndDescribe* imageStr = self.imagesMarray[self.imageIndex.row];
        imageStr.showImage = image;
        [UIView  animateWithDuration:0.5 animations:^{
              [self.publishTableView reloadRowsAtIndexPaths:@[self.imageIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        } completion:^(BOOL finished) {
            if (self.babyInfo) {
                [self.publishTableView scrollToRowAtIndexPath:self.imageIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }else{
                [self.publishTableView scrollToRowAtIndexPath:self.imageIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }];
   
      
        
    }else{
        ZZImageAndDescribe* imageStr = [[ZZImageAndDescribe  alloc]init];
        imageStr.showImage = image;
        
        [self.imagesMarray addObject:imageStr];
        
        if (self.imagesMarray.count < 10) {
            if (self.babyInfo) {
                
                [UIView  animateWithDuration:0.5 animations:^{
               [self.publishTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.imagesMarray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];;
                } completion:^(BOOL finished) {
                    [self.publishTableView  scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }];
            }else{
                
                [UIView  animateWithDuration:0.5 animations:^{
                    [self.publishTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.imagesMarray.count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
                } completion:^(BOOL finished) {
                     [self.publishTableView  scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }];
                
                //[self.publishTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.imagesMarray.count-1 inSection:1 ]atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
            
        }else{
            if (self.babyInfo) {
                  [self.publishTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.imagesMarray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                  [self.publishTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.imagesMarray.count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
          
            
        }
        if (self.babyInfo) {
            [self.publishTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.publishTableView numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }else{
            [self.publishTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.publishTableView numberOfRowsInSection:1]-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    }
    
    [self  updateImageCountLabel];
}

@end
