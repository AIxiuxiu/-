//
//  ZZWonderDetailViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//
#import "TTTAttributedLabel.h"
#import "ZZWonderDetailViewController.h"

#import "ZZMengBaoPaiImageInfo.h"
#import "ZZPostReplyCell.h"
#import "ZZReplayInformation.h"
#import "ZZMyAlertView.h"
#import "UIImageView+WebCache.h"
#import "ZZTextView.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZImageSelect.h"

#import "AppDelegate.h"
#import "ZZHudView.h"
#import "ZZAttentionHeadViewController.h"
#import "MJRefresh.h"
#import "ZZDairyCollectionViewCell.h"
//三方图片加载
#import "MWPhotoBrowser.h"

/**
 *  友盟三方
 */
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "ZZUMSdk.h"
#import "ZZPostView.h"
#import "ZZFunctionView.h"
#import "ZZLoadMoreFooter.h"
#import "ZZReplyFrame.h"
static  const int  ShareTitleLength = 64;
static  const int  ShareContentLength = 128;

@interface ZZWonderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ZZImageSelectDelegate,UMSocialUIDelegate,ZZPostViewDelegate,ZZFunctionViewDelegate,ZZPostReplyCellDelegate,ZZLoadMoreFooterDelegate,MWPhotoBrowserDelegate>

@property(nonatomic,strong)NSMutableArray* contentArr;
@property(nonatomic,strong)NSMutableArray* replayArr;
@property(nonatomic,strong)NSArray* arr;
@property(nonatomic,strong)UIView* kuangView;//选中框
@property(nonatomic,strong)ZZReplayInformation* replayInfo;

@property(nonatomic)int tagNumber;
/**
 *右上角按钮点击出现的功能界面
 */
@property(nonatomic,strong)ZZFunctionView* buttonView;

//
//回复背景
@property(nonatomic)float keyBoardHeight;
@property(nonatomic,strong)UIView* replayView;
@property(nonatomic,strong)ZZTextView* repTextField;
@property(nonatomic,strong)UIButton* sendingButton;
@property(nonatomic,strong)UIImageView*  pictureIV;
//@property(nonatomic,strong)UIView*  blackView;
@property(nonatomic,strong)ZZImageSelect*  imageSelect;
@property(nonatomic,strong)UIImage*  selectImage;

@property(nonatomic,strong)UILabel*  tipNetLabel;//分享时提示label
/**
 *相册
 */
@property(nonatomic,strong)MWPhotoBrowser*  wPhotoBrowser;
/** 相册图片 */
@property(nonatomic,strong)NSMutableArray*  wBrowserPhotos;
@property (nonatomic, strong)ZZLoadMoreFooter *footer;

@property (nonatomic, strong)UIView *inputBackView;
@end


@implementation ZZWonderDetailViewController
#pragma mark lazy load
-(ZZFunctionView *)buttonView{
    if (!_buttonView) {
        UICollectionViewFlowLayout*  flowLayout = [[UICollectionViewFlowLayout  alloc]init];
        flowLayout.itemSize = CGSizeMake(80, 60);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing =0;
        _buttonView = [[ZZFunctionView  alloc]initWithFrame:CGRectMake(0, -264, ScreenWidth, 60) collectionViewLayout:flowLayout];
        _buttonView.funDelegate = self;
        _buttonView.scrollsToTop = NO;
         _buttonView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:.9];

    }
    return _buttonView;
}
-(UIView *)replayView{
    if (!_replayView) {
        _replayView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-45,ScreenWidth, 45)];
        _replayView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, .5, ScreenWidth, .5)];
        lineLabel.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [_replayView addSubview:lineLabel];
    }
    return _replayView;
}
-(ZZTextView *)repTextField{
    if (!_repTextField) {
        _repTextField =  [[ZZTextView alloc]initWithFrame:CGRectMake(5, 6, ScreenWidth-90, 33)];
        _repTextField.tag = 110;
    
        _repTextField.placeholder = @"没事写两句......";
        _repTextField.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]CGColor];
        _repTextField.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        _repTextField.layer.borderWidth = 0.5;
        _repTextField.layer.cornerRadius = 3 ;
        _repTextField.textContentLength = 1000;
        _repTextField.delegate = self;
        _repTextField.textColor = ZZLightGrayColor;
        _repTextField.font = ZZTitleBoldFont;
        _repTextField.layoutManager.allowsNonContiguousLayout = NO;
        //添加滚动区域
        _repTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _repTextField;
}
-(UITableView *)detailView{
    if (!_detailView) {
        _detailView  = [[UITableView alloc]initWithFrame:CGRectMake(0, ZZNaviHeight, ScreenWidth, ScreenHeight-CGRectGetHeight(self.replayView.frame)-ZZNaviHeight)];
        _detailView.backgroundColor = [UIColor  clearColor];
        _detailView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailView.dataSource = self;
        _detailView.delegate = self;
        _detailView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    
       //[ _detailView addHeaderWithTarget:self action:@selector(he0aderRereshing)];
        _detailView.headerPullToRefreshText = @"下拉可以刷新了";
        _detailView.headerReleaseToRefreshText = @"松开马上刷新了";
        _detailView.headerRefreshingText = @"正在刷新中";
        //footer刷新用
        ZZLoadMoreFooter *footer = [ZZLoadMoreFooter footer];
        footer.delegate = self;
        footer.backgroundColor = [UIColor  clearColor];
        _detailView.tableFooterView = footer;
        self.footer = footer;
 
    }
    
    return _detailView;
}
-(UIImageView *)pictureIV{
    if (!_pictureIV) {
        _pictureIV = [[UIImageView  alloc]initWithFrame:CGRectMake(ScreenWidth-82, 5, 33, 33)];
        _pictureIV.userInteractionEnabled = YES;
        _pictureIV.image = [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"add_image_40x40" ofType:@"png"]];
        _pictureIV.contentMode = UIViewContentModeScaleAspectFill;
        _pictureIV.clipsToBounds = YES;
        UITapGestureRecognizer*  tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(addImage)];
        [_pictureIV  addGestureRecognizer:tap];
    }
                                                                   
  return _pictureIV;
}
-(ZZImageSelect *)imageSelect{
    if (_imageSelect == nil) {
        _imageSelect = [[ZZImageSelect  alloc]init];
        _imageSelect.delegate = self;
        _imageSelect.head = YES;
    }
    return _imageSelect;
}
-(UILabel *)tipNetLabel{
    if (!_tipNetLabel) {
        _tipNetLabel = [[UILabel  alloc]initWithFrame:CGRectMake(20, 70, ScreenWidth -40, 60)];
        _tipNetLabel.backgroundColor = [UIColor  colorWithRed:0 green:0 blue:0 alpha:0.7];
        _tipNetLabel.textColor = [UIColor  whiteColor];
        _tipNetLabel.layer.cornerRadius = 5;
        _tipNetLabel.layer.masksToBounds = YES;
        _tipNetLabel.numberOfLines =2;
        _tipNetLabel.textAlignment = NSTextAlignmentCenter;
        _tipNetLabel.text = @"分享加载中,请稍后";
        _tipNetLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer*  tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tipNetLabelAction)];
        [_tipNetLabel  addGestureRecognizer:tap];
    }
    return _tipNetLabel;
}
-(MWPhotoBrowser *)wPhotoBrowser{
    if (!_wPhotoBrowser) {
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = YES;//  展示操作按钮,就是分享
        //        browser.displayNavArrows = NO;  　//底部显示左右按钮移动
        //        browser.displaySelectionButtons = NO;  //显示选择按钮
        //        browser.alwaysShowControls = NO; //一直显示返回导航栏
        browser.zoomPhotosToFill = YES; //是否可以缩放
        //        browser.enableGrid = NO; //是否可以显示网格状
        //        browser.startOnGrid = NO;  //以网格状开始
        //        browser.enableSwipeToDismiss = NO;//是否能滑动消失
        //        browser.autoPlayOnAppear = NO;   //出现的时候视频播放
        _wPhotoBrowser = browser;
    }
    return _wPhotoBrowser;
}
-(NSMutableArray *)wBrowserPhotos{
    if (!_wBrowserPhotos) {
        _wBrowserPhotos = [NSMutableArray  arrayWithCapacity:self.postIncoming.postImagesArray.count];
    }
    return _wBrowserPhotos;
}
-(NSMutableArray *)replayArr{
    if (_replayArr == nil) {
        _replayArr = [NSMutableArray  array];
    }
    return _replayArr;
}
-(UIView *)inputBackView{
    if (_inputBackView == nil) {
        _inputBackView = [[UIView  alloc]initWithFrame:self.view.bounds];
        _inputBackView.backgroundColor = [UIColor  blackColor];
        _inputBackView.alpha = .15;
        _inputBackView.hidden = YES;
         [self.view  insertSubview:_inputBackView belowSubview:self.replayView];
    }
    return _inputBackView;
}
#pragma mark life cycle
//键盘根据高度调整
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //通知
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];

    [self.detailView addHeaderWithTarget:self action:@selector(headerRereshing)];
   
}

//取消通知
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.detailView  removeHeader];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帖子详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tagNumber = 1;
    //右上角按钮
    [self  initRightBarButton];
    [self   getNetPostDetailInfoData];
}

//初始化右上角按钮
-(void)initRightBarButton{
    //右Button
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 2, 26, 26)];

    [rightButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]  pathForResource:@"more_button_40x40" ofType:@"png"]] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(someButtons:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*  rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItems:@[rightBarButtonItem]];
}

// 初始化帖子
-(void)initWithPost{
        __weak typeof(self) weakWonderVc = self;
    ZZPostView *postView = [[ZZPostView alloc]init];
    postView.post = weakWonderVc.postIncoming;
    postView.delegate = weakWonderVc;
    weakWonderVc.detailView.tableHeaderView = postView;
    
}

//回复条创建
-(void)initWithReplayView{
    
    __weak typeof(self)  weakWonderVc = self;
    //发送按钮
    UIButton*  sendButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-46, 6, 40, 33)];
    sendButton.layer.borderWidth = 0.5;
    sendButton.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
    sendButton.layer.cornerRadius = 3;
    sendButton.layer.masksToBounds = YES;
   
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
     [sendButton   setTitle:@"发送中" forState:UIControlStateSelected];
    sendButton.titleLabel.font = [UIFont  systemFontOfSize:13];
    [sendButton setTitleColor:ZZLightGrayColor forState:UIControlStateNormal];
    [sendButton setBackgroundColor:[UIColor whiteColor]];
    [sendButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [weakWonderVc.replayView addSubview:sendButton];
    
    //图片按钮
    [weakWonderVc.replayView addSubview:weakWonderVc.pictureIV];
    [weakWonderVc.replayView addSubview:weakWonderVc.repTextField];
    [weakWonderVc.view addSubview:weakWonderVc.replayView];
}

#pragma mark ---------------------NSNotification----------------------
//通知里的方法
-(void)keyboardAppear:(NSNotification *)notification{
    //获取键盘的高度
    NSDictionary* userInfo = notification.userInfo;
    NSValue* value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    self.keyBoardHeight = keyboardFrame.size.height;
    //计算输入框的frame
    CGRect inputFrame = self.replayView.frame;
    inputFrame.origin.y = self.view.bounds.size.height - keyboardFrame.size.height - inputFrame.size.height;
    //
    [self  someButtons:nil];
    //3.设置动画
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationDurationUserInfoKey]intValue];
    self.inputBackView.hidden = NO;
 

    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.replayView.frame = inputFrame;
    } completion:^(BOOL finished) {
        if (self.repTextField.text.length) {
            [self textViewDidChange:self.repTextField];
        }
        
    }];
}

-(void)keyboardDisappear:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;

    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
    self.inputBackView.hidden = YES;
  
    [UIView  animateWithDuration:duration delay:0 options:options animations:^{
        self.replayView.frame = CGRectMake(0, ScreenHeight-45, ScreenWidth, 45);
//        self.repTextField.frame = CGRectMake(5, 6, ScreenWidth-90, 33);
    } completion:nil];
}

#pragma mark  private methods
//开始进入刷新状态
- (void)headerRereshing{
  NSUInteger  replayFirstId = 0;
    if (self.replayArr.count) {
        ZZReplyFrame* replyFrame = [self.replayArr firstObject];
       replayFirstId = replyFrame.reply.replayId;
    }
    [self   getNetReplyInfoDataWithReplayId:replayFirstId andUpDown:1];
}

- (void)footerRereshing{
    NSUInteger  replayLastId = 0;
    if (self.replayArr.count) {
        ZZReplyFrame* replyFrame = [self.replayArr lastObject];
        replayLastId = replyFrame.reply.replayId;
    }
    [self   getNetReplyInfoDataWithReplayId:replayLastId andUpDown:2 ];
}

//网络加载提示label点击响应事件
-(void)tipNetLabelAction{
    [self.tipNetLabel  removeFromSuperview];
}
#pragma mark  event response
//navigation按钮事件
-(void)someButtons:(UIButton*)btn{
    //self.detailView.
    //scrollView 停止滑动
    
    if(btn){//右上角按钮响应事件
        [self.detailView setContentOffset:self.detailView.contentOffset animated:NO];
        [self.repTextField  resignFirstResponder];
        if (self.tagNumber%2 == 1) {
            [UIView animateWithDuration:0.2 animations:^{
                
                self.buttonView.frame = CGRectMake(0, 64, ScreenWidth, 60);
            }];
            
        }else{
            
            [UIView animateWithDuration:0.2 animations:^{
                self.buttonView.frame = CGRectMake(0, -114,ScreenWidth, 60);
            }];
            
        }
        self.tagNumber+=1;
    }else{
        if (self.tagNumber!=1) {
            [UIView animateWithDuration:0.2 animations:^{
                self.buttonView.frame = CGRectMake(0, -114, ScreenWidth, 60);
            }];
            self.tagNumber = 1;
        }
    }
  
}

//发送按钮响应事件
-(void)buttonAction:(UIButton*)btn{
    
    [self.repTextField resignFirstResponder];
    
   
    
    NSString*  inputStr= [self  removeWhitespaceAndNewlineCharacterWithOrignString:self.repTextField.text];
    if (inputStr.length||self.selectImage) {
        btn.selected = YES;
        btn.userInteractionEnabled = NO;
    }else{
        ZZMyAlertView*  alertView = [[ZZMyAlertView  alloc]initWithMessage:@"你还没有填写内容或发图片" delegate:nil cancelButtonTitle:@"确定" sureButtonTitle:nil];
        [btn   setTitle:@"发送" forState:UIControlStateNormal];
        [alertView  show];
        return;
    }
    if (inputStr.length == 0) {
        if ([self.replayInfo.replayContent  isEqualToString:@"😘发了一张图"]) {
            inputStr = @"😝跟了一张图";
        }else{
            inputStr = @"😘发了一张图";
        }
    }
    
    [[ZZMengBaoPaiRequest shareMengBaoPaiRequest]postAddStarConstellationPostReplyWithPlate:self.postIncoming.postPlateType andPostId:self.postIncoming.postId andReply:self.replayInfo andContent:inputStr andImage:self.selectImage andSort:self.postIncoming.postOrderSort+1 andBack:^(id obj) {
        if (obj) {
            self.repTextField.text = nil;
            self.repTextField.placeholder = @"没事写两句......";
        
            self.replayInfo = nil;
            self.selectImage = nil;
        
            self.pictureIV.image = [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"add_image_40x40" ofType:@"png"]];
            self.replayArr =[[ ZZReplyFrame    replyFramesWithReplys:obj  ]mutableCopy];
            [self.detailView  reloadData];
            if (self.postIncoming.postOrderSort) {
                [self.detailView   scrollToRowAtIndexPath:[NSIndexPath  indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }else{
                NSInteger row = [self.detailView  numberOfRowsInSection:0]-1;
                [self.detailView   scrollToRowAtIndexPath:[NSIndexPath  indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
       
         
        }
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
    }];
}

//回复框  图片手势响应事件
-(void)addImage{
    [self  someButtons:nil];
    [self.imageSelect  imageSelectShow];
}

#pragma mark - ZZLoadMoreFooterDelegate

-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
    [self  footerRereshing];
}
#pragma mark  UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.replayArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZPostReplyCell *cell = [ZZPostReplyCell dequeueReusableCellWithTableView:tableView];
    cell.delegate = self;
    cell.replyFrame= self.replayArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
  ZZReplyFrame *replyFrame =  self.replayArr[indexPath.row];

    return replyFrame.cellHeight;
    
}

#pragma mark ----UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
   // textView.scrollEnabled =NO;
    CGRect textFrame=[[textView layoutManager]usedRectForTextContainer:[textView textContainer]];

    //int titleHeight =textView.contentSize.height/AutoSizeScaley ;
   int titleHeight =textFrame.size.height + 17;
    if (titleHeight>83) {
        titleHeight = 84;
       
    }
    int  textViewHieght =self.repTextField.frame.size.height;
  
   if (textViewHieght ==titleHeight||textViewHieght==titleHeight-1||titleHeight ==textViewHieght-1) {
////        if (titleHeight<84) {
      // [self.repTextField  textViewDidChange:self.repTextField];
////        }
    }else{

        CGRect  frame = self.replayView.frame;
        frame.size.height = (titleHeight+12);
        frame.origin.y -=(titleHeight-textViewHieght);
        [UIView  animateWithDuration:0 animations:^{
      
            self.replayView.frame= frame;
        } completion:^(BOOL finished) {
         
//            if (textView.frame.size.height>textFrame.size.height) {
//                CGPoint offset = textView.contentOffset;
//                offset.y = 0;
//                [UIView animateWithDuration:.3 animations:^{
//                    [textView setContentOffset:offset];
//                }];
//            }
        }];
    }
    
  //  [self.repTextField  textViewDidChange:self.repTextField];
    
}
#pragma mark -ZZPostReplyCellDelegate

-(void)postReplyButtonAction:(ZZPostReplyCell *)postReplyCell buttonType:(ZZPostReplyCellButtonType)postReplyType{
     ZZReplayInformation*  reply = postReplyCell.replyFrame.reply;
    switch (postReplyType) {
        case ZZPostReplyCellButtonTypeDelete:
        {
            NSIndexPath *indexPath = [self.detailView  indexPathForCell:postReplyCell];
          
            [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postDeleteStarConstellationPostReplyWithPlate:self.postIncoming.postPlateType andReplyId:reply.replayId andBack:^(id obj) {
                if (obj) {
                    reply.isDelete = 1;
                    ZZReplyFrame *replyFrame = [[ZZReplyFrame alloc]init];
                    replyFrame.reply = reply;
                    [self.replayArr   replaceObjectAtIndex:indexPath.row withObject:replyFrame];
                    [self.detailView   reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }
                
            }];
        }
            break;
        case ZZPostReplyCellButtonTypeReply:
        {
            self.replayInfo = reply;
            self.repTextField.placeholder = [NSString   stringWithFormat:@"回复 %@ 的发言",reply.user.nick];
            [self.repTextField   becomeFirstResponder];
        }
           
            break;
        case ZZPostReplyCellButtonTypeReport:
        {
           
            [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postReportPostOrPostReplyWithPlate:self.postIncoming.postPlateType andPostId:0 andReply:reply.replayId andBack:^(id obj) {
                
                
            }];
        }
            break;
        default:
            break;
    }
}
-(void)postReplyCellContentIVTap:(ZZPostReplyCell *)postReplyCell imageView:(UIImageView *)iv{
    
    [self.wBrowserPhotos  removeAllObjects];
    //相册图片
    [self.wBrowserPhotos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:postReplyCell.replyFrame.reply.imageInfo.largeImagePath ]]];
    [self.wPhotoBrowser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.wPhotoBrowser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication  sharedApplication].keyWindow.rootViewController presentViewController:nc animated:YES completion:nil];

}
#pragma mark -MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.wBrowserPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.wBrowserPhotos.count)
        return [self.wBrowserPhotos objectAtIndex:index];
    return nil;
}

#pragma mark -ZZFunctionViewDelegate
-(void)functionViewItemDidSelect:(ZZFunctionView *)functionView funType:(ZZFunctionObType)type{
    [self  someButtons:nil];
    weakSelf(wonerVc)
    switch (type) {
                    case ZZFunctionObTypeCollection:
                    {//收藏
                        [[ZZMengBaoPaiRequest shareMengBaoPaiRequest]postUpdateStoreUpPostWithPostId:self.postIncoming.postId andPlateType:self.postIncoming.postPlateType andAddOrDelete:!self.postIncoming.postStoreUp andBack:^(id obj) {
                            if (obj) {
                                wonerVc.postIncoming.postStoreUp =!wonerVc.postIncoming.postStoreUp;
                            }
                            
                        }];
                    
                    }
                        break;
            
                    case ZZFunctionObTypeShare:
                    {//分享
            
                        [wonerVc  changeShareImage:nil];
                    }
                        break;
            
                    case ZZFunctionObTypeReport:
                    {//举报
                        [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postReportPostOrPostReplyWithPlate:self.postIncoming.postPlateType andPostId:self.postIncoming.postId andReply:0 andBack:^(id obj) {
                            
                        }];
                        
                    }
                        break;
            
                    case ZZFunctionObTypeOrder:
                    {//序列：正序，倒序
                       self.postIncoming.postOrderSort = !self.postIncoming.postOrderSort;
                        [self.replayArr  removeAllObjects];
                        [self.detailView  reloadData];
                        [self.footer  endRefreshing];
                   
                        [self  footerRereshing];

                    }
                        break;
    }
}
#pragma mark ZZPostViewDelegate
-(void)postViewTapHeadImage:(ZZPostView *)postView{
    
    ZZAttentionHeadViewController* headView = [[ZZAttentionHeadViewController alloc]init];
    headView.user = self.postIncoming.postUser;
    [self.navigationController pushViewController:headView animated:YES];
}
-(void)postViewClickSpotButton:(ZZPostView *)postView{
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postUpdateSpotPostWithPlate:self.postIncoming.postPlateType andPostId:self.postIncoming.postId andAddOrDelete:self.postIncoming.postCurrentUserSpot andBack:^(id obj) {
        
    }];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self  someButtons:nil];
    if ( self.footer.isRefreshing||scrollView.contentOffset.y < self.footer.height) return;
    
    // 1.差距
    CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
    // 刚好能完整看到footer的高度
    CGFloat sawFooterH = scrollView.height + self.footer.height;
    
    // 2.如果能看见整个footer
    if (delta <= (sawFooterH - 0)) {
        [self.footer  beginRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ZZNetDely * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        [self footerRereshing];
         });
    }
}

#pragma mark  ZZImageSelectDelegate
-(void)imageSelect:(ZZImageSelect *)imageSelect images:(NSArray *)images{
    self.selectImage = images[0];
    self.pictureIV.image = self.selectImage;
}


#pragma mark  三方分享
/**
 *  分享事件
 *
 *  @param sender <#sender description#>
 */
-(void)changeShareImage:(UIButton*)sender
{
   
    NSString*  title =[self.postIncoming.postTitle  subStringFromTitleOrcontentWithLength:ShareTitleLength];
//    
    NSString*  content =[self.postIncoming.postContent  subStringFromTitleOrcontentWithLength:ShareContentLength];

   
    NSString *imagePath = nil;
    if (self.postIncoming.postImagesArray.count) {
        ZZMengBaoPaiImageInfo*  mbp = [self.postIncoming.postImagesArray  firstObject];
        imagePath = mbp.largeImagePath;
    }else{
        imagePath = self.postIncoming.postPlateType.mbpImageInfo.largeImagePath;
    }
    UIImage *image = nil;
    NSData* imageData = nil;
    
    if (imagePath.length) {
        image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imagePath];
        if (!image) {
            image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imagePath];
        }
        
    }
    if (image == nil) {
        image = [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"icon.png" ofType:nil]];
    }
     imageData = UIImageJPEGRepresentation(image, 0.5);

    if (!content.length) {
        if (self.postIncoming.postImagesArray.count) {
            ZZMengBaoPaiImageInfo*  mbp = [self.postIncoming.postImagesArray  firstObject];
            content = [mbp.descContent  subStringFromTitleOrcontentWithLength:ShareContentLength];
         
        }
        if (!content.length) {
            content = @"";
        }
    }
    NSString*  url =[NSString  stringWithFormat:@"%@/index.jsp?id=%ld&type=%@&areaType=%@",[ZZMengBaoPaiRequest  shareMengBaoPaiRequest].baseUrl,(unsigned long)self.postIncoming.postId,self.postIncoming.postPlateType.type,self.postIncoming.postPlateType.areaType];

    /**
     *  微信设置要分享的链接和title
     */
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    /**
     *  微博设置要分享的链接
     */
    //[[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:url];
    
    /**
     *  QQ设置要分享的链接
     */
    [UMSocialData defaultData].extConfig.qqData.url = url;
    
    //[UMSocialData defaultData].extConfig.qzoneData.url = url;
    
    [UMSocialData defaultData].extConfig.qqData.title = title;
    
    //[UMSocialData defaultData].extConfig.qzoneData.title = title;
    /**
     *  分享列表
     */


    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"556e722967e58e98be002ba7"
                                      shareText:content
                                     shareImage:imageData
                                shareToSnsNames:[ZZUMSdk sharedZZUMSdk].shareArray
                                       delegate:self];
    
  
}

/**
 *  不会跳出新浪链接窗口
 *
 *  @return <#return value description#>
 */
//-(BOOL)isDirectShareInIconActionSheet
//{
//    return YES;
//}
/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
  
    [self.tipNetLabel removeFromSuperview];
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop];
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        ZZHudView*  hudView =[[ ZZHudView  alloc]init];
        hudView.contentLabel.text = @"分享成功";
        [hudView  showWithTime:1];
     
    }else{
        ZZHudView*  hudView =[[ ZZHudView  alloc]init];
        hudView.contentLabel.text = @"分享失败";
        [hudView  showWithTime:2];
    }
}
/**
 关闭当前页面之后
 
 @param fromViewControllerType 关闭的页面类型
 
 */
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType{
    
   
    [self.tipNetLabel removeFromSuperview];
}

/**
 点击分享列表页面，之后的回调方法，你可以通过判断不同的分享平台，来设置分享内容。
 @param platformName 点击分享平台
 
 @prarm socialData   分享内容
 */
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    NSString*  title =self.postIncoming.postTitle ;
    
    //[self    subStringFromTitleOrcontentWithText:self.postIncoming.postTitle andLength:30] ;
   
    NSString*  url =[NSString  stringWithFormat:@"%@/index.jsp?id=%ld&type=%@&areaType=%@",[ZZMengBaoPaiRequest  shareMengBaoPaiRequest].baseUrl,(unsigned long)self.postIncoming.postId,self.postIncoming.postPlateType.type,self.postIncoming.postPlateType.areaType];
        
    
    if ([platformName  isEqualToString:@"sina"]) {
          socialData.shareText = [NSString   stringWithFormat:@"%@\n%@\n",title,url];
    }
    [self.view   addSubview:self.tipNetLabel];
}

#pragma mark  网络请求
-(void)getNetPostDetailInfoData{
    __weak typeof(self) weakWonderVc = self;
    [weakWonderVc  netLoadLogoStartWithView:weakWonderVc.view];
   [ [ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindStarConstellationPostDetialInfoWithPlate:weakWonderVc.postIncoming.postPlateType andPostId:weakWonderVc.postIncoming.postId andUserId:weakWonderVc.postIncoming.postUser.userId andBack:^(id obj) {
       [weakWonderVc  netLoadLogoEndWithView:weakWonderVc.view];
       if (obj) {
           ZZPost*  postDetail = obj;
           postDetail.postId = weakWonderVc.postIncoming.postId;
          
           postDetail.postPlateType = weakWonderVc.postIncoming.postPlateType;
       weakWonderVc.postIncoming.postUser.attention = postDetail.postUser.attention;
        
           postDetail.postUser = weakWonderVc.postIncoming.postUser;
           weakWonderVc.postIncoming = postDetail;
         [weakWonderVc  footerRereshing];
           [weakWonderVc initWithPost];
           //注册CollectionCell
           weakWonderVc.buttonView.post = postDetail;
           [weakWonderVc.buttonView  reloadData];
//           weakWonderVc.detailView.tableHeaderView =  weakWonderVc.headDetail;
           [weakWonderVc.view addSubview:weakWonderVc.detailView];
              [weakWonderVc.view  addSubview:weakWonderVc.buttonView];
      
           
             [weakWonderVc initWithReplayView];
       }else{
           [weakWonderVc  netLoadFailWithText:@"加载失败,点击重新加载"  isBack:NO];
       }
       static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
       NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
       NSInteger isDetailNumber = [userDefaults integerForKey:@"isDetailNumber"];
       if (!isDetailNumber) {
           __weak AppDelegate* appView =(AppDelegate*)[UIApplication sharedApplication].delegate;
           [appView addLeadActionView:3];
       }
       });
    }];
}

-(void)action{
  __weak typeof(self) weakWonderVc = self;
    [weakWonderVc  getNetPostDetailInfoData];
}
-(void)getNetReplyInfoDataWithReplayId:(NSUInteger)replayId andUpDown:(NSUInteger)upDown  {
    __weak typeof(self)  weakWonderVc = self;
    NSUInteger  currentSort = self.postIncoming.postOrderSort;
    [self.footer  beginRefreshing];
    [[ZZMengBaoPaiRequest shareMengBaoPaiRequest]postFindStarConstellationPostReplyWithPlate:weakWonderVc.postIncoming.postPlateType andPostId:weakWonderVc.postIncoming.postId andUpdown:upDown andReplyId:replayId andSort:self.postIncoming.postOrderSort+1 andBack:^(id obj) {
        [weakWonderVc.detailView  headerEndRefreshing];
        if (currentSort != weakWonderVc.postIncoming.postOrderSort) {//是否还是请求时的时序
            return ;
        }
        
        [weakWonderVc.footer  endRefreshing];
        if (obj) {//请求成功
            NSArray*  array = obj;
            if(array.count){
                array = [ZZReplyFrame  replyFramesWithReplys:array];
                ZZReplyFrame*  replyFrame = [array  firstObject];
                weakWonderVc.postIncoming.postReplyCount = replyFrame.reply.replays;
                if (upDown == 1) {
                    NSMutableArray*  refreshArray = [NSMutableArray  arrayWithCapacity:array.count];
                    for (NSUInteger i = array.count; i>0; i--) {
                        ZZReplayInformation*  reply = array[i-1];
                        [refreshArray  addObject:[NSIndexPath  indexPathForRow:i-1 inSection:0]];
                        [weakWonderVc.replayArr  insertObject:reply atIndex:0];
                    }
                    [weakWonderVc.detailView  beginUpdates];
                    [weakWonderVc.detailView   insertRowsAtIndexPaths:refreshArray withRowAnimation:UITableViewRowAnimationAutomatic];
                    [weakWonderVc.detailView  endUpdates];
                   
                }else{
                    NSMutableArray*  refreshArray = [NSMutableArray  arrayWithCapacity:array.count];
                    for (int i = 0; i<array.count; i++) {
                        ZZReplayInformation*  reply = array[i];
                        [refreshArray  addObject:[NSIndexPath  indexPathForRow:weakWonderVc.replayArr.count inSection:0]];
                        [weakWonderVc.replayArr  addObject:reply];
                    }
                    [weakWonderVc.detailView  beginUpdates];
                    [weakWonderVc.detailView   insertRowsAtIndexPaths:refreshArray withRowAnimation:UITableViewRowAnimationAutomatic];
                    [weakWonderVc.detailView  endUpdates];
                }
                
            }
        }else{
            if (upDown == 2) {
                [weakWonderVc.footer  requestFailed];
            }
        }
        
      
    }];
}

-(void)dealloc{
    self.detailView.delegate = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.repTextField.text.length == 0) {
        self.repTextField.placeholder = @"没事写两句......";
        
        self.replayInfo = nil;
    }
    [self.view  endEditing:YES];
}

@end
