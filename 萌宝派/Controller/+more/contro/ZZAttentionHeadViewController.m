//
//  ZZAttentionHeadViewController.m
//  萌宝派
//
//  Created by charles on 15/3/26.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZAttentionHeadViewController.h"
#import "ZZUser.h"
#import "ZZInfoDetailCell.h"
#import "ZZMengBaoPaiImageInfo.h"
#import "ZZLastCell.h"
#import "UIImageView+WebCache.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZPost.h"
#import "UIImageView+WebCache.h"

#import "ZZWonderDetailViewController.h"
//
#import "ZZMyAlertView.h"

#import "ZZLoadMoreFooter.h"
#import "ZZUserDetailView.h"
@interface ZZAttentionHeadViewController ()<UITableViewDataSource,UITableViewDelegate,ZZMyAlertViewDelgate,ZZLoadMoreFooterDelegate,ZZUserDetailViewDelegate>
@property(nonatomic,strong)UILabel*  calculateLabel;//计算高度label
@property(nonatomic,strong)UITableView* userTableView;
@property(nonatomic,assign)float setNum;
@property(nonatomic,strong)NSMutableArray* ageArray;//同龄星座
@property(nonatomic,strong)NSMutableArray* cityArray;//同城
@property(nonatomic,strong)NSMutableArray*  wonderfulArray;//精彩
@property(nonatomic)int   typeNumber;  ////1：精彩专区  2:同龄   3:同城

@property(nonatomic,strong)UIButton*   attentionButton;
//进入子界面回来刷新
@property(nonatomic,strong)NSIndexPath* lastIndexPath;

@property (nonatomic, strong)ZZLoadMoreFooter *footer;
@property (nonatomic) NSUInteger  selectedItem;
//是否可以进行网络请求，
@property (nonatomic)BOOL ageCanRefresh;
@property (nonatomic)BOOL cityCanRefresh;
@property (nonatomic)BOOL wonCanRefresh;
@end

@implementation ZZAttentionHeadViewController

#pragma life cycle

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    if (self.lastIndexPath) {
        [self.userTableView   reloadRowsAtIndexPaths:@[self.lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.lastIndexPath = nil;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"萌宝用户";
    self.typeNumber =1;
    self.automaticallyAdjustsScrollViewInsets = NO;

    /**
     *  tableView的头
     */
    ZZUserDetailView* userDetailView = [[ZZUserDetailView alloc]init];
    userDetailView.user = self.user;
    [userDetailView  setNeedsLayout];
    [userDetailView  layoutIfNeeded];
    userDetailView.delegate = self;
    
    self.userTableView.tableHeaderView = userDetailView;
    /**
     *  加载tableView
     */
    [self.view addSubview:self.userTableView];
    /**
     *  请求
     */
    [self  footerRereshing];
    [self  getuserIsAttent];
   
}

#pragma mark ZZUserDetailViewDelegate
-(void)userDetailViewToAttention:(ZZUserDetailView*)userDetailView{
  
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postUpdateAttentionUserOrPlateWithCode:@"user" andPlatedId:0 andUserId:self.user.userId andAddOrDelete:!self.user.attention andCallback:^(id obj) {
        if (obj) {
            self.user.attention = !self.user.attention;
        }
    }];
}

-(void)userDetailViewToSegment:(ZZUserDetailView*)userDetailView andItem:(NSUInteger)item{
    self.selectedItem = item;
    [self.userTableView  reloadData];
    [self.footer  endRefreshing];
    self.footer.canRefresh = [self  getCurrentCanRefreshItem:item];
    if ([self  getCurrentArrayWithItem:item].count == 0  && [self  getCurrentCanRefreshItem:item]) {
        [self  footerRereshing];
    }
}

#pragma mark  UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self  getCurrentArrayWithItem:self.selectedItem].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        ZZInfoDetailCell* cell = [ZZInfoDetailCell dequeueReusableCellWithTableView:tableView deleteButton:NO delegate:nil];
        ZZPost* post =  [self  getCurrentArrayWithItem:self.selectedItem][indexPath.row];
        cell.post = post;
        return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.lastIndexPath = indexPath;
    ZZWonderDetailViewController*  wonderDetailVC = [[ZZWonderDetailViewController alloc]init];
    ZZPost* post =  [self  getCurrentArrayWithItem:self.selectedItem][indexPath.row];
    wonderDetailVC.postIncoming = post;
    [self.navigationController  pushViewController:wonderDetailVC animated:YES];
}
#pragma mark - tableView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self  getCurrentArrayWithItem:self.selectedItem] .count <= 0 || self.footer.isRefreshing || [self  getCurrentCanRefreshItem:self.selectedItem] == NO||scrollView.contentOffset.y < self.footer.height) return;
    // 1.差距
    CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
    // 刚好能完整看到footer的高度
    CGFloat sawFooterH = scrollView.height + self.footer.height;
    
    // 2.如果能看见整个footer
    if (delta <= (sawFooterH - 0)) {
        [self.footer  beginRefreshing];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ZZNetDely * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 加载更多的微博数据
        [self footerRereshing];
         });
    }
}

#pragma mark   网络请求

- (void)footerRereshing
{
    NSUInteger  lastId = 0;
    NSArray *currentArray = [self  getCurrentArrayWithItem:self.selectedItem];
    if (currentArray.count ) {
        ZZPost  *post = [currentArray  lastObject];
        lastId = post.postId;
    }
    [self   getMyPublishNetDataWithUpDown:2 andWithLastId:lastId];
}
-(void)getMyPublishNetDataWithUpDown:(int)upDown  andWithLastId:(NSUInteger)lastId{

    [self.footer  beginRefreshing];
    NSUInteger  item = self.selectedItem;
    __weak  ZZAttentionHeadViewController*  attentionHeadVC = self;
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindAttentionUserMorePublishListWithUserId:self.user.userId andPostId:lastId andUpDOwn:upDown andTypeNumber:item andBack:^(id obj) {
         if (item == attentionHeadVC.selectedItem) {
             [attentionHeadVC.footer  endRefreshing];
             if (obj) {//数据请求成功
                 NSArray *array = obj;
                 if (array.count) {
                     NSMutableArray * mArray = [attentionHeadVC  getCurrentArrayWithItem:item];
                     [mArray  addObjectsFromArray:array];
                     [attentionHeadVC.userTableView  reloadData];
                 }else{
                     [attentionHeadVC  setCurrentCanRefreshItem:item];
                     attentionHeadVC.footer.canRefresh = NO;
                 }
             }else{
                 [attentionHeadVC.footer  requestFailed];
             }
         }
     

    }];
}
- (void)getuserIsAttent{
    weakSelf(attentVC);
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindThisUserAttention:self.user.userId andBack:^(id obj) {
        if (obj) {
            attentVC.user.attention = [[obj objectForKey:@"validAttentionUser"]boolValue];
            attentVC.user.isCurrentUser = [[obj  objectForKey:@"validCurrentUser"]boolValue];
        }
        [(ZZUserDetailView *)attentVC.userTableView.tableHeaderView  showAttentionBUtton];
    }];
}
#pragma mark -private methods
//当前正在显示的数组
- (NSMutableArray *)getCurrentArrayWithItem:(NSUInteger )item{
    weakSelf(store);
    if (item == 0) {
        return store.wonderfulArray;
    }else if (item == 1){
        return store.ageArray;
    }else{
        return store.cityArray;
    }
}
- (BOOL )getCurrentCanRefreshItem:(NSUInteger )item{
    weakSelf(store);
    if (item == 0) {
        return store.wonCanRefresh;
    }else if (item == 1){
        return store.ageCanRefresh;
    }else{
        return store.cityCanRefresh;
    }
}

- (void)setCurrentCanRefreshItem:(NSUInteger )item{
    weakSelf(store);
    switch (item) {
        case 0:
            store.wonCanRefresh = NO;
            break;
        case 1:
            store.ageCanRefresh = NO;
            break;
        case 2:
            store.cityCanRefresh = NO;
            break;
    }
}
#pragma mark lazy load
-(NSMutableArray *)ageArray{
    if (!_ageArray) {
        _ageArray = [NSMutableArray  array];
    }
    return _ageArray;
}

-(NSMutableArray *)cityArray{
    if (!_cityArray) {
        _cityArray = [NSMutableArray  array];
        
    }
    return _cityArray;
}

-(NSMutableArray *)wonderfulArray{
    if (!_wonderfulArray) {
        _wonderfulArray = [NSMutableArray  array];
    }
    return _wonderfulArray;
}

-(UITableView *)userTableView{
    if (_userTableView == nil) {
        _userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, (ScreenHeight-64)) style:UITableViewStylePlain];
        _userTableView.backgroundColor = [UIColor clearColor];
        _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _userTableView.dataSource = self;
        _userTableView.delegate = self;
        ZZLoadMoreFooter *footer = [ZZLoadMoreFooter footer];
       
        footer.delegate = self;
        self.wonCanRefresh = YES;
        self.ageCanRefresh = YES;
        self.cityCanRefresh = YES;
        _userTableView.tableFooterView = footer;
        self.footer = footer;
    }
    return _userTableView;
}

#pragma mark -ZZLoadMoreFooterDelegate
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
    [self  footerRereshing];
}
-(void)dealloc{
    self.userTableView.delegate = nil;
}

@end
