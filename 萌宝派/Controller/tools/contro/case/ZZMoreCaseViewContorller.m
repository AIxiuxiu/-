//
//  ZZMoreCaseViewContorller.m
//  萌宝派
//
//  Created by charles on 15/4/7.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZMoreCaseViewContorller.h"
#import "ZZInfoDetailCell.h"

#import "ZZMengBaoPaiRequest.h"
#import "ZZPost.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ZZWonderDetailViewController.h"

#import "ZZMengBaoPaiRequest.h"
#import "ZZLoadMoreFooter.h"

@interface ZZMoreCaseViewContorller ()<UITableViewDataSource,UITableViewDelegate,ZZLoadMoreFooterDelegate>
@property(nonatomic,strong)NSMutableArray*  caseMarray;
@property(nonatomic,strong)UITableView* caseTableView;

@property(nonatomic,strong)NSIndexPath*  lastIndexPath;

@property(nonatomic,strong)NSArray* caseCountArr;

@property (nonatomic, strong)ZZLoadMoreFooter *footer;
@end

@implementation ZZMoreCaseViewContorller

#pragma mark  lazy  load
-(NSMutableArray *)caseMarray{
    if (!_caseMarray) {
        _caseMarray = [NSMutableArray  array];
    }
    return _caseMarray;
}

-(NSArray *)caseCountArr{
    if (!_caseCountArr) {
        _caseCountArr = [NSArray array];
    }
    return _caseCountArr;
}

-(UITableView *)caseTableView{
    if (!_caseTableView) {
        _caseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ZZNaviHeight, ScreenWidth, ScreenHeight-ZZNaviHeight) style:UITableViewStylePlain];
        _caseTableView.backgroundColor = [UIColor clearColor];
        _caseTableView.rowHeight = 55;
        _caseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _caseTableView.dataSource = self;
        _caseTableView.delegate = self;
    }
    return _caseTableView;
}

#pragma mark  life  cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"相关案例";
    [self.view addSubview:self.caseTableView];
    [self  setupFooter];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self footerRereshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    if (self.lastIndexPath) {
        [self.caseTableView   reloadRowsAtIndexPaths:@[self.lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.lastIndexPath = nil;
    }
}

//设置tableview的尾部视图
- (void)setupFooter
{
    ZZLoadMoreFooter *footer = [ZZLoadMoreFooter footer];
    footer.canRefresh = YES;
 
    footer.delegate = self;
    self.caseTableView.tableFooterView = footer;
    self.footer = footer;
}
#pragma mark  private  methods
- (void)footerRereshing
{
    NSUInteger  lastId = 0;
    if (self.caseMarray.count) {
        ZZPost* post = [self.caseMarray lastObject];
        lastId = post.postId;
    }
    [self   getNetDataWith:lastId andUpDown:2];
}
#pragma mark - tableView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.caseMarray.count <= 0 || self.footer.isRefreshing || self.footer.canRefresh == NO||scrollView.contentOffset.y<self.footer.height) return;
    
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

#pragma mark -ZZLoadMoreFooterDelegate
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
    [self  footerRereshing];
}
#pragma mark  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.caseMarray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZInfoDetailCell *cell = [ZZInfoDetailCell  dequeueReusableCellWithTableView:tableView deleteButton:NO delegate:nil];
   cell.post = self.caseMarray[indexPath.row];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.lastIndexPath = indexPath;
    ZZWonderDetailViewController*  wonderDvc = [[ZZWonderDetailViewController  alloc]init];
    wonderDvc.postIncoming = self.caseMarray[indexPath.row];
    [self.navigationController  pushViewController:wonderDvc animated:YES];
}

#pragma mark  netRequest
-(void)getNetDataWith:(NSUInteger)lastCaseId  andUpDown:(int)upDown{
    [self.footer  beginRefreshing];
    weakSelf(caseVC);
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindCaseByCaseId:lastCaseId andPlateType:self.caseType andUpDown:upDown andBack:^(id obj) {
        [caseVC.footer  endRefreshing];
        if (obj) {
            NSArray*  array = obj;
            if (array.count) {
                NSMutableArray* marray = [NSMutableArray  arrayWithCapacity:array.count];
                for (ZZPost* post in array) {
                    [marray  addObject:[NSIndexPath  indexPathForRow:self.caseMarray.count inSection:0]];
                    [self.caseMarray  addObject:post];
                    
                }
                
                [self.caseTableView  insertRowsAtIndexPaths:marray withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }else{
                caseVC.footer.canRefresh = NO;
            }
        }else{
            [caseVC.footer  requestFailed];
        }
       
    }];
}

-(void)dealloc{
    self.caseTableView.delegate = nil;
}

@end
