//
//  ZZGoldListViewController.m
//  萌宝派
//
//  Created by charles on 15/4/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZGoldListViewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZGoldListTableViewCell.h"
#import "MJRefresh.h"
#import "ZZLastCell.h"
#import "ZZLoadMoreFooter.h"
@interface ZZGoldListViewController ()<UITableViewDataSource,UITableViewDelegate,ZZLoadMoreFooterDelegate>
@property(nonatomic,strong)UITableView* goldListTableView;
@property(nonatomic,strong)NSMutableArray* goldList;//金币列表
//
@property (nonatomic, strong)ZZLoadMoreFooter *footer;
@end

@implementation ZZGoldListViewController
#pragma mark  lazy  load
-(NSMutableArray *)goldList{
    if (!_goldList) {
        _goldList = [NSMutableArray array];
    }
    return _goldList;
}
-(UITableView *)goldListTableView{
    if (!_goldListTableView) {
        _goldListTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, ZZNaviHeight , ScreenWidth -20, ScreenHeight-ZZNaviHeight) style:UITableViewStylePlain];
        _goldListTableView.backgroundColor = [UIColor  clearColor];
        _goldListTableView.rowHeight = 50;
        _goldListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goldListTableView.delegate = self;
        _goldListTableView.dataSource = self;
        _goldListTableView.layer.cornerRadius = 5;
        _goldListTableView.layer.masksToBounds = YES;

    }
    return _goldListTableView;
}

#pragma mark  life  cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"金币记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view  addSubview:self.goldListTableView];
    [self  setupFooter];
    [self footerRereshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super  viewWillDisappear:animated];
}

//设置tableview的尾部视图
- (void)setupFooter
{
    ZZLoadMoreFooter *footer = [ZZLoadMoreFooter footer];
    footer.delegate = self;
 
    self.goldListTableView.tableFooterView = footer;
    self.footer = footer;
}
#pragma mark   private methods
//refresh
- (void)footerRereshing
{
    NSUInteger  lastId = 0;
    if (self.goldList.count) {
        ZZGoldRecord* goldRecord = [self.goldList lastObject];
        lastId = goldRecord.goldId;
    }
    [self   getNetGoldListDataWithId:lastId andUpDown:2];
}
#pragma mark   -ZZLoadMoreFooterDelegate
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
    [self footerRereshing];
}
#pragma mark    UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goldList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ZZGoldListTableViewCell* cell = [ZZGoldListTableViewCell  dequeueReusableCellWithTableView:tableView];
 
    cell.goldRecord = self.goldList[indexPath.row];
    return cell;
}



#pragma mark - tableView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.goldList.count <= 0 || self.footer.isRefreshing || self.footer.canRefresh == NO||scrollView.contentOffset.y<self.footer.height) return;
    
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

#pragma mark  netRequest

-(void)getNetGoldListDataWithId:(NSUInteger)goldId andUpDown:(int)upDown{

    __weak  ZZGoldListViewController*  goldVC = self;
    [self.footer  beginRefreshing];
    [[ZZMengBaoPaiRequest shareMengBaoPaiRequest] postFindGoldListWithId:goldId andUpDown:upDown andBack:^(id obj) {
        [goldVC.footer  endRefreshing];
        NSArray*  array = obj;
        if (array) {
            if (array.count) {
              
                [goldVC.goldList addObjectsFromArray:array];
                [goldVC.goldListTableView  reloadData];
            }else{
                goldVC.footer.canRefresh = NO;
            }
        }else{
            [goldVC.footer  requestFailed];
        }
        
    }];
}

-(void)dealloc{
    self.goldListTableView.delegate = nil;
}
@end
