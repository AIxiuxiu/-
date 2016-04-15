//
//  ZZStoreUpDetailViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZStoreUpDetailViewController.h"

#import "ZZMengBaoPaiRequest.h"
#import "ZZInfoDetailCell.h"
#import "ZZPost.h"
#import "ZZUser.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ZZWonderDetailViewController.h"
#import "ZZMyAlertView.h"

#import "ZZLastCell.h"
#import "ZZSegmentV.h"
#import "ZZLoadMoreFooter.h"
@interface ZZStoreUpDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ZZSegmentVDelegate,ZZInfoDetailCellDelegate,ZZLoadMoreFooterDelegate>

@property(nonatomic)int   typeNumber;  ////1：专区  2:同龄   3:同城  4:案例
//刷新
@property(nonatomic,strong)NSMutableArray* ageArray;//同龄星座
@property(nonatomic,strong)NSMutableArray* cityArray;//同城
@property(nonatomic,strong)NSMutableArray*  wonderfulArray;//精彩
@property(nonatomic,strong)NSMutableArray*  caseArray;
//

@property(nonatomic,strong)UITableView*  postTableView;
//删除
@property(nonatomic,strong)NSIndexPath*  deleteIndexPath;

@property(nonatomic)NSUInteger  selectIndex;//上一次seg的值
//进入子界面回来刷新
@property(nonatomic,strong)NSIndexPath* lastIndexPath;
//
@property (nonatomic, strong)ZZSegmentV *segment;
@property (nonatomic) NSUInteger  selecedItem;
@property (nonatomic, strong)ZZLoadMoreFooter *footer;
//是否可以进行网络请求，
@property (nonatomic)BOOL ageCanRefresh;
@property (nonatomic)BOOL cityCanRefresh;
@property (nonatomic)BOOL caseCanRefresh;
@property (nonatomic)BOOL wonCanRefresh;
@end

@implementation ZZStoreUpDetailViewController
#pragma mark  lazy load
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
-(NSMutableArray *)caseArray{
    if (!_caseArray) {
        _caseArray = [NSMutableArray  array];
    }
    return _caseArray;
}



#pragma mark life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    if (self.lastIndexPath) {
        if (self.number ==5) {
            [self.postTableView  reloadRowsAtIndexPaths:@[self.lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if (self.number ==4) {
            
        }
       self.lastIndexPath = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ZZViewBackColor;
    
    if (self.number == 3) {
    }else if (self.number == 4){
        
        self.title = @"我的收藏";
    }else{
        
        self.title = @"我的发布";
    }
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(storePostChange:) name:ZZStorePostChangeNotification object:nil];
    //创建子视图
    [self  setUpChilds];
    [self  footerRereshing];
}

- (void)setUpChilds
{//注意顺序
    ZZSegmentV  *segment;
    if(self.number==4){
        segment = [[ZZSegmentV  alloc]initWithItems:@[@"话题",@"同龄",@"同城",@"案例"]];
      
    }else{
       segment = [[ZZSegmentV  alloc]initWithItems:@[@"话题",@"同龄",@"同城"]];
    }
    segment.frame = CGRectMake(34, 64 + upDownSpace, ScreenWidth - 34*2, 30);
    segment.delegate = self;
    self.segment = segment;
    [self.view  addSubview:segment];
    
    CGFloat y = CGRectGetMaxY(segment.frame) + 5;
    self.postTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0,y , ScreenWidth, ScreenHeight -y)];
    self.postTableView.rowHeight = 55;
    self.postTableView.backgroundColor = [UIColor clearColor];
    self.postTableView.delegate = self;
    self.postTableView.dataSource = self;
    self.postTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view  addSubview:self.postTableView];
    
    ZZLoadMoreFooter *footer = [ZZLoadMoreFooter footer];

    footer.delegate = self;
    self.postTableView.tableFooterView = footer;
    self.footer = footer;
    
    self.caseCanRefresh = YES;
    self.cityCanRefresh = YES;
    self.wonCanRefresh = YES;
    self.ageCanRefresh = YES;
}


#pragma mark  private methods
//当前正在显示的数组
- (NSMutableArray *)getCurrentArrayWithItem:(NSUInteger )item{
    weakSelf(store);
    if (item == 0) {
        return store.wonderfulArray;
    }else if (item == 1){
        return store.ageArray;
    }else if (item == 2){
        return store.cityArray;
    }else{
        return store.caseArray;
    }
}

- (BOOL )getCurrentCanRefreshItem:(NSUInteger )item{
     weakSelf(store);
    if (item == 0) {
        return store.wonCanRefresh;
    }else if (item == 1){
        return store.ageCanRefresh;
    }else if (item == 2){
        return store.cityCanRefresh;
    }else{
        return store.caseCanRefresh;
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
        case 3:
            store.caseCanRefresh = NO;
            break;
       
    }
}
- (void)footerRereshing
{
    NSUInteger  lastId = 0;
    NSArray *currentArray = [self  getCurrentArrayWithItem:self.selecedItem];
    if (currentArray.count ) {
        ZZPost  *post = [currentArray  lastObject];
        lastId = post.postId;
    }
    [self   getNetDataWithUpDown:2 andWithLastId:lastId];
}


#pragma mark  -ZZLoadMoreFooterDelegate
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
    [self  footerRereshing];
}
#pragma mark  ZZSegmentVDelegate
//segment切换时调用
-(void)segmentVClicked:(ZZSegmentV *)segment item:(NSUInteger)item{
    self.selecedItem = item;
    [self.postTableView  reloadData];
    [self.footer  endRefreshing];
    self.footer.canRefresh = [self  getCurrentCanRefreshItem:item];
    if ([self  getCurrentArrayWithItem:item].count == 0  && [self  getCurrentCanRefreshItem:item]) {
        [self  footerRereshing];
    }
    
}
#pragma mark  UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self getCurrentArrayWithItem:self.selecedItem].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BOOL  canDelete = NO;
    if (self.number == 5) {
        canDelete = YES;
    }
    ZZInfoDetailCell *infoCell = [ZZInfoDetailCell  dequeueReusableCellWithTableView:tableView  deleteButton:canDelete  delegate:self];
    infoCell.post = [self  getCurrentArrayWithItem:self.selecedItem][indexPath.row];

    return infoCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.lastIndexPath = indexPath;
    ZZWonderDetailViewController*  wonderDetailVC = [[ZZWonderDetailViewController alloc]init];
    ZZPost* post = [self  getCurrentArrayWithItem:self.selecedItem][indexPath.row];

    if (self.number==4) {
        post.postStoreUp = YES;
    }
    wonderDetailVC.postIncoming = post;
    [self.navigationController  pushViewController:wonderDetailVC animated:YES];
    
    [tableView  deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - tableView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self  getCurrentArrayWithItem:self.selecedItem].count <= 0 || self.footer.isRefreshing || self.footer.canRefresh == NO||scrollView.contentOffset.y<self.footer.height) return;
    
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

#pragma mark    ZZInfoDetailCellDelegate
-(void)infoDetailCellClickedDeleteButton:(ZZInfoDetailCell *)infoCell{
    NSIndexPath *delePath = [self.postTableView  indexPathForCell:infoCell];
    ZZPost *post = [self  getCurrentArrayWithItem:self.selecedItem][delePath.row];
    [[self  getCurrentArrayWithItem:self.selecedItem]removeObjectAtIndex:delePath.row];
    [self.postTableView  deleteRowsAtIndexPaths:@[delePath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postDeleteStarConstellationPostWithPlate:post.postPlateType PostId:post.postId andBack:^(id obj) {
  
    }];
}

#pragma mark - NSNotification
- (void)storePostChange:(NSNotification *)noti{
    NSDictionary *dic = noti.object;
    NSUInteger postId = [dic[@"postId"]integerValue];
    NSString  *areaType = dic[@"areaType"];
    BOOL addOrDelete = [dic[@"addOrDele"] boolValue];
    ZZPlateTypeInfoAreaTYpe areaTypeNumber = [ZZPlateTypeInfo  plateAreaTypeNumber: areaType];
    NSUInteger item = 0;
    switch (areaTypeNumber) {
        case ZZPlateTypeInfoAreaTYpeWon:
            item = 0;
            break;
        case ZZPlateTypeInfoAreaTYpeAge:
            item = 1;
            break;
        case ZZPlateTypeInfoAreaTYpeCity:
            item = 2;
            break;
        case ZZPlateTypeInfoAreaTYpeCase:
            item = 3;
            break;
    }
    
    NSMutableArray *marray = [self  getCurrentArrayWithItem:item];
    if (addOrDelete) {
    
    }else{
        for (ZZPost *post in marray) {
            if (post.postId == postId) {
                [marray  removeObject:post];
               
                break;
            }
        }
        if (self.selecedItem == item) {
            [self.postTableView  reloadData];
        }
    }
    
}
#pragma mark  netRequest
-(void)getNetDataWithUpDown:(int)upDown  andWithLastId:(NSUInteger)lastId{
    // 4为收藏   5为发布
    if (self.number == 4) {
        [self  getMyStoreNetDataWithUpDown:upDown andWithLastId:lastId];
    }
    if (self.number ==5) {
        [self  getMyPublishNetDataWithUpDown:upDown andWithLastId:lastId];
    }
}
//我的发布
-(void)getMyPublishNetDataWithUpDown:(int)upDown  andWithLastId:(NSUInteger)lastId{

     NSUInteger  index = self.selecedItem ;//记录网络请求时 类型值
    [self.footer  beginRefreshing];
     __weak  ZZStoreUpDetailViewController*  storeVC = self;
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindAttentionUserMorePublishListWithUserId:0 andPostId:lastId andUpDOwn:upDown andTypeNumber:index andBack:^(id obj) {
        if (index == storeVC.selecedItem) {
               [storeVC.footer  endRefreshing];
            if (obj) {
                NSArray*  array = obj;
                if(array.count ){
                    NSMutableArray *marray = [storeVC  getCurrentArrayWithItem:index ];
                    [marray addObjectsFromArray:array];
                    [storeVC.postTableView   reloadData];
                }else{
                    storeVC.footer.canRefresh = NO;
                    [storeVC  setCurrentCanRefreshItem:index];
                }
            }else{
                [storeVC.footer  requestFailed];
            }
        }
    }];
}
//网络请求我的收藏
-(void)getMyStoreNetDataWithUpDown:(int)upDown  andWithLastId:(NSUInteger)lastId{
    NSUInteger  index = self.selecedItem ;//记录网络请求时 类型值
    [self.footer  beginRefreshing];
    __weak  ZZStoreUpDetailViewController*  storeVC = self;
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindMyStorePostTithPostId:lastId andUpDown:upDown andTypeNumber:index andBack:^(id obj) {
        if (index == storeVC.selecedItem) {
            [storeVC.footer  endRefreshing];
            if (obj) {
                NSArray*  array = obj;
                if(array.count ){
                    NSMutableArray *marray = [storeVC  getCurrentArrayWithItem:index ];
                    [marray addObjectsFromArray:array];
                    [storeVC.postTableView   reloadData];
                }else{
                    storeVC.footer.canRefresh = NO;
                    [storeVC  setCurrentCanRefreshItem:index];
                }
            }else{
                [storeVC.footer  requestFailed];
            }
        }
    }];
}
-(void)dealloc{
    self.postTableView.delegate = nil;
    [[NSNotificationCenter  defaultCenter]removeObserver:self];
    
}
@end
