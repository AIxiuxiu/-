//
//  ZZUprightViewController.m
//  萌宝派
//
//  Created by charles on 15/3/10.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZUprightViewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZTopicPostCell.h"
#import "ZZWonderDetailViewController.h"
#import "ZZReleaseViewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZPost.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ZZMyAlertView.h"
#import "AppDelegate.h"
#import "ZZAttentionHeadViewController.h"
#import "ZZLoadMoreFooter.h"
@interface ZZUprightViewController ()<UITableViewDataSource,UITableViewDelegate,ZZMyAlertViewDelgate,ZZLoadMoreFooterDelegate>

@property(nonatomic,strong)UIView* stickView;

//@property(nonatomic,strong)NSMutableArray* stickContent;
@property(nonatomic,strong)NSMutableArray* commonContent;

//
@property(nonatomic,strong)NSIndexPath*  lastIndexPath;
@property (nonatomic, strong)ZZLoadMoreFooter *footer;
@end

@implementation ZZUprightViewController


#pragma mark lazy load
-(NSMutableArray *)commonContent{
    if (!_commonContent) {
        _commonContent = [NSMutableArray  array];
    }
    return _commonContent;
}

-(UITableView *)topicView{
    if (!_topicView) {
        _topicView = [[UITableView alloc]initWithFrame:CGRectMake(0, ZZNaviHeight, ScreenWidth, ScreenHeight-ZZNaviHeight) style:UITableViewStylePlain];
        _topicView.backgroundColor = [UIColor  clearColor];
        _topicView.delegate = self;
        _topicView.dataSource = self;
        _topicView.separatorStyle = UITableViewCellSeparatorStyleNone;
          _topicView.tableHeaderView = self.topView;
        _topicView.tableFooterView = self.footer;
   
    }
    
    return _topicView;
}

-(ZZHeaderView *)topView{
    if (!_topView) {
       _topView = [[ZZHeaderView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.layer.borderWidth = 0.5;
        _topView.plateType = self.plateType;
        _topView.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]CGColor];
        _topView.frame = CGRectMake(0, 0, ScreenWidth,[ZZHeaderView  getFrameSizeHeightWith:self.plateType.content]);
        [_topView.attentionButton  addTarget:self action:@selector(attentionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _topView;
}

-(ZZLoadMoreFooter *)footer{
    if (_footer == nil) {
        _footer = [ZZLoadMoreFooter footer];
        _footer.backgroundColor = [UIColor  clearColor];
       
        _footer.delegate = self;
        _footer.hidden = YES;
    }
    return _footer;
}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.plateType.title;
    [self  getNetDataWithPostId:0 andUpDown:0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.topicView];
    ZZUser*  loginUser = [ZZUser  shareSingleUser];
    if ([self.plateType.type  isEqualToString:@"BABYACTIVITY"]) {//活动不能发布
        
    }else if ([self.plateType.type isEqualToString:@"MENGPO"]&&(loginUser.permissions != 1&&loginUser.permissions != 2)){//攻略  萌宝管理员与小编发布
        
    }else if([self.plateType.type isEqualToString:@"TALENT"]&&((loginUser.permissions ==3 && loginUser.isSuperStarUser == 0)&&loginUser.permissions!=1&&loginUser.permissions!=2)){//达人荟，不是达人不能发
        
    }else{
        [self  initRightButton];
    }
    
    self.topView.attentionButton.hidden = YES;
}
//初始化 右上角按钮
-(void)initRightButton{
    UIButton* writeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    UIImage* img3 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"issue_button_30x30.png" ofType:nil]];
    [writeButton setBackgroundImage:img3 forState:UIControlStateNormal];
    [writeButton addTarget:self action:@selector(writeButton:) forControlEvents:UIControlEventTouchUpInside];
    writeButton.tag = 1;
    UIBarButtonItem*  writeButtonItem=[[UIBarButtonItem alloc]initWithCustomView:writeButton];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
   negativeSeperator.width = -10;//此处修改到边界的距离，请自行测试
    //navi的右边的button
    [self.navigationItem setRightBarButtonItems:@[negativeSeperator,writeButtonItem]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    if (self.lastIndexPath&&self.lastIndexPath.row<self.commonContent.count) {
       [self.topicView   reloadRowsAtIndexPaths:@[self.lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    self.lastIndexPath = nil;
   [self.topicView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //self.topicView.scrollEnabled = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super  viewWillDisappear:animated];
    [self.topicView  removeHeader];

   
}

#pragma mark  private methods
//开始进入刷新状态
- (void)headerRereshing
{
    NSUInteger  postId = 0;
    if (self.commonContent.count) {
        for (ZZPost*  post in self.commonContent) {
            if (post.postId > postId) {
                postId = post.postId;
            }
        }
    }
    [self   getNetDataWithPostId:postId andUpDown:1];
}

- (void)footerRereshing
{
   NSUInteger  postId = 0;
    if (self.commonContent.count) {
        ZZPost*  lastPost = [self.commonContent  lastObject];
        postId = lastPost.postId;
    }
    [self   getNetDataWithPostId:postId andUpDown:2];
}



//更新板块关注的网络请求
-(void)updateAttentionPlateType{
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postUpdateAttentionUserOrPlateWithCode:@"plate" andPlatedId:self.plateType.plateId andUserId:0 andAddOrDelete:!self.plateType.attention andCallback:^(id obj) {
        if(obj){
            self.plateType.attention =!self.plateType.attention;
            [self  changePlateAttentionState];
        }
    }];
}
//
-(void)changePlateAttentionState{
    
        __weak  typeof(self)  uprightVC = self;

    if (uprightVC.plateType.attention) {
        //绿色按钮
        uprightVC.topView.attentionButton.backgroundColor = [UIColor  colorWithRed:0.57 green:0.85 blue:0.37 alpha:1];
        [uprightVC.topView.attentionButton setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        //蓝色按钮
        uprightVC.topView.attentionButton.backgroundColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1];
        [uprightVC.topView.attentionButton setTitle:@"+关注" forState:UIControlStateNormal];
    }
}
//
-(void)publishSuccessRefreshWith:(NSDictionary*)dic{
    self.plateType.publishCount = [[dic  objectForKey:@"count"] integerValue];
    self.topView.number.text = [NSString   stringWithFormat:@"%ld",self.plateType.publishCount];
    self.plateType.attention = [[dic  objectForKey:@"attention"]boolValue];
    self.commonContent = [[dic  objectForKey:@"list"]  mutableCopy];
    [self.topicView  reloadSections:[NSIndexSet  indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark--------UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.footer.hidden = self.commonContent.count==0;
        return self.commonContent.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* celler = @"TopicpostCell";
    
    ZZPost*  post = self.commonContent[indexPath.row];
        ZZTopicPostCell* cell = [tableView dequeueReusableCellWithIdentifier:celler];
        if (cell == nil) {
            cell = [[ZZTopicPostCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celler];
            cell.delegate = self;
            cell.backgroundColor = ZZViewBackColor;
        }
     cell.topicCellpost = post;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZPost* post = self.commonContent[indexPath.row];
   
    
    //标题
    NSString* titleString = nil;
    if (post.postJudge) {
        titleString = [NSString stringWithFormat:@"             %@",post.postTitle];
    }else{
        titleString = post.postTitle;
    }
    CGSize labelSize1 = [titleString boundingRectWithSize:CGSizeMake(ScreenWidth-40, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
        NSString* str = nil;
        if (!post.postContent.length) {
           
            if (post.postImagesArray.count) {
           ZZMengBaoPaiImageInfo *     mbp=   post.postImagesArray[0];
                str = mbp.descContent;
            }
            
        }else{
            str = post.postContent;
        }

    
    CGSize labelSize2 = [str boundingRectWithSize:CGSizeMake(ScreenWidth-40, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    if (labelSize2.height>40) {
        labelSize2.height = 40;
    }
    if (post.postImagesArray.count) {
        //90是图片高度
        return labelSize1.height+labelSize2.height+90+75+22;
    }else{
        //没有图片
        return labelSize1.height+labelSize2.height+75+22;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.lastIndexPath = indexPath;
    ZZWonderDetailViewController*  wonderDvc = [[ZZWonderDetailViewController  alloc]init];
    ZZPost*  post = self.commonContent[indexPath.row];
//    post.postPlateType = self.plateType;
    wonderDvc.postIncoming = post;
    [self.navigationController  pushViewController:wonderDvc animated:YES];
}

#pragma mark - tableView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.commonContent.count <= 0 || self.footer.isRefreshing || self.footer.canRefresh == NO||scrollView.contentOffset.y<self.footer.height) return;
    
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

#pragma mark  委托回调方法
//删除按钮
-(void)topicPostCellDeleteButtonActionWithIndexPath:(NSIndexPath *)deleteIndexpath{
    ZZPost* post = nil;
    post = self.commonContent[deleteIndexpath.row];
    
    [[ZZMengBaoPaiRequest shareMengBaoPaiRequest]postDeleteStarConstellationPostWithPlate:post.postPlateType PostId:post.postId andBack:^(id obj) {
        if (obj) {
            if (self.commonContent.count>deleteIndexpath.row) {
                [self.commonContent removeObjectAtIndex:deleteIndexpath.row];
                [self.topicView beginUpdates];
                [self.topicView deleteRowsAtIndexPaths:@[deleteIndexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.topicView  endUpdates];
            }
        }
        
    }];
}
//头像点击
-(void)topicpostCellHeadImageClickedWithIndexPath:(NSIndexPath *)clickIndexpath{
    ZZPost* post = self.commonContent[clickIndexpath.row];
    ZZAttentionHeadViewController*  attentionHeadVC = [[ZZAttentionHeadViewController alloc]init];
    attentionHeadVC.user = post.postUser;
    [self.navigationController  pushViewController:attentionHeadVC animated:YES];
}

#pragma mark   ZZMyAlertViewDelgate
-(void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //223为
    if (alertView.tag==223) {//取消板块关注
        if (buttonIndex) {
            [self  updateAttentionPlateType];
        }
        
    }
}
#pragma mark -ZZLoadMoreFooterDelegate
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
    [self  footerRereshing];
}

#pragma mark event response
//button响应事件方法
-(void)writeButton:(UIButton*)button{
        ZZReleaseViewController* releaseView = [[ZZReleaseViewController alloc]init];
        //releaseView.postType = @"212";
        releaseView.plateType = self.plateType;
    [self.navigationController pushViewController:releaseView animated:YES];
    
    
}

//关注按钮 点击响应事件
-(void)attentionButtonAction{

    if (self.plateType.attention) {
        ZZMyAlertView*  myAlert = [[ZZMyAlertView  alloc]initWithMessage:@"你确定要取消关注这个板块嘛" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
        myAlert.tag = 223;
        [myAlert  show];
    }else{
        [self   updateAttentionPlateType];
    }
  
}

#pragma mark netRequest
//网络请求
-(void)getNetDataWithPostId:(NSUInteger)postId  andUpDown:(NSUInteger)upDown{
    if (upDown == 0) {
        self.topView.userInteractionEnabled = NO;
        self.topicView.bounces = NO;
        [self  netLoadLogoStartWithView:self.view];
    }
    [self.footer  beginRefreshing];
    __weak  typeof(self)  uprightVC = self;
        [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindStarConstellationPostListsWithPlate:self.plateType andPostId:postId andUpDown:upDown andBack:^(id obj) {
            if (upDown == 0) {
                [uprightVC  netLoadLogoEndWithView:uprightVC.view];
                uprightVC.topicView.bounces = YES;
                uprightVC.topView.userInteractionEnabled = YES;
            }
            [uprightVC.footer  endRefreshing];
            if (uprightVC.topicView.isHeaderRefreshing) {
                [uprightVC.topicView  headerEndRefreshing];
            }
       
            //
            if (obj) {
                NSArray *arr = obj;
                if (arr.count) {
                    NSUInteger  count = [[obj  objectForKey:@"count"] integerValue];
                
                    NSArray* array = [obj  objectForKey:@"list"] ;
                    if(array.count){
                        switch (upDown) {
                            case 0:
                            {
                                BOOL  attention = [[obj  objectForKey:@"attention"]boolValue];
                                if (uprightVC.plateType.publishCount!=count) {
                                    uprightVC.plateType.publishCount =count;
                                    uprightVC.topView.number.text = [NSString  stringWithFormat:@"%ld",count];
                                }
                                uprightVC.topView.attentionButton.hidden = NO;
                                if (uprightVC.plateType.attention!=attention) {
                                    uprightVC.plateType.attention =attention;
                                    [uprightVC  changePlateAttentionState];
                                }
                                uprightVC.commonContent = [array  mutableCopy];
                                [uprightVC.topicView  reloadData];
                                break;
                            }
                            case 1:
                            {
                                NSInteger  index = 0;
                                for (  int i = 0; i<uprightVC.commonContent.count; i++) {
                                    ZZPost*  post = uprightVC.commonContent[i];
                                    if (!post.postJudge) {
                                        index=i;
                                        break;
                                    }
                                }
                                
                                /*
                                 张亮亮 0514  修改逻辑
                                 */
                                NSMutableArray*  refreshArray = [NSMutableArray  arrayWithCapacity:array.count];
                                for (int i = array.count; i>0; i--) {
                                    ZZPost*  post = array[i-1];
                                    [refreshArray  addObject:[NSIndexPath  indexPathForRow: index+i-1 inSection:0]];
                                    [uprightVC.commonContent  insertObject:post atIndex:index];
                                }
                                [uprightVC.topicView  beginUpdates];
                                [uprightVC.topicView   insertRowsAtIndexPaths:refreshArray withRowAnimation:UITableViewRowAnimationAutomatic];
                                [uprightVC.topicView  endUpdates];
                                
                            }
                                
                                break;
                            case 2:
                            {
                                NSMutableArray*  refreshArray = [NSMutableArray  arrayWithCapacity:array.count];
                                for (int i = 0; i<array.count; i++) {
                                    ZZPost*  post = array[i];
                                    [refreshArray  addObject:[NSIndexPath  indexPathForRow:uprightVC.commonContent.count inSection:0]];
                                    [uprightVC.commonContent  addObject:post];
                                }
                                [uprightVC.topicView  beginUpdates];
                                [uprightVC.topicView   insertRowsAtIndexPaths:refreshArray withRowAnimation:UITableViewRowAnimationAutomatic];
                                [uprightVC.topicView  endUpdates];
                                
                            }
                                break;
                                
                        }
                        
                    }else{
                        if (upDown == 2) {
                            self.footer.canRefresh = NO;
                        }
                    }
                    
                    /**
                     
                     *判断引导动画出现只出现一次
                     */
                    static dispatch_once_t onceToken;
                    dispatch_once(&onceToken, ^{
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        NSInteger isUprightNumber = [userDefaults integerForKey:@"isUprightNumber"];
                        
                        if (!isUprightNumber) {
                            __weak    AppDelegate* appView =(AppDelegate*)[UIApplication sharedApplication].delegate;
                            if (self.navigationItem.rightBarButtonItems) {
                                [appView addLeadActionView:6];
                            }else{
                                [appView addLeadActionView:5];
                            }
                            
                        }
                    });

                }
            }else{//请求失败
                if (upDown == 0) {//第一次数据加载失败
                    [uprightVC
                     netLoadFailWithText:@"加载失败,点击重新加载"  isBack:NO];
                }else if(upDown == 1){
                    [uprightVC.footer  requestFailed];
                }
            }
            
        } ];
    
}
-(void)action{
      __weak  typeof(self)  uprightVC = self;
    
    [uprightVC  getNetDataWithPostId:0 andUpDown:0];
}


-(void)dealloc{
    self.topicView.delegate = nil;
}
@end
