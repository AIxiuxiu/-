//
//  ZZMyAttentionViewController.m
//  萌宝派
//
//  Created by zhizhen on 15/4/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZMyAttentionViewController.h"
#import "ZZAttentionTableViewCell.h"
#import "ZZMengBaoPaiRequest.h"
#import "UIImageView+WebCache.h"
#import "ZZAttentionHeadViewController.h"
#import "MJRefresh.h"
#import "ZZLoadMoreFooter.h"
@interface ZZMyAttentionViewController ()<UITableViewDelegate,UITableViewDataSource,ZZLoadMoreFooterDelegate>
@property(nonatomic,strong)UITableView*  attentionUserTabeView;
@property(nonatomic,strong)NSMutableArray*  attentionUserMArray;

@property(nonatomic,strong)NSIndexPath* lastIndexPath;//进入下一级子界面返回后刷新选中cell
@property (nonatomic, strong)ZZLoadMoreFooter  *footer;

@end

@implementation ZZMyAttentionViewController
#pragma mark   lazy  load
-(NSMutableArray *)attentionUserMArray{
    if (!_attentionUserMArray) {
        _attentionUserMArray = [NSMutableArray array];
    }
    return _attentionUserMArray;
}
-(UITableView *)attentionUserTabeView{
    if (!_attentionUserTabeView) {
        
        _attentionUserTabeView = [[UITableView  alloc]initWithFrame:CGRectMake(0, ZZNaviHeight, ScreenWidth, ScreenHeight - ZZNaviHeight)];
        _attentionUserTabeView.backgroundColor = [UIColor  clearColor];
        _attentionUserTabeView.rowHeight = 80;
        _attentionUserTabeView.delegate = self;
        _attentionUserTabeView.dataSource = self;
        _attentionUserTabeView.separatorStyle = UITableViewCellSeparatorStyleNone;

        
    }
    return _attentionUserTabeView;
}
#pragma mark  ZZLoadMoreFooterDelegate
//点击重新加载
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
    [self  footerRereshing];
}
#pragma mark  UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return self.attentionUserMArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZAttentionTableViewCell *cell = [ZZAttentionTableViewCell dequeueReusableCellWithTableView:tableView];
    ZZUser* user = self.attentionUserMArray[indexPath.row];
    cell.user = user;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    ZZUser*  user = self.attentionUserMArray[indexPath.row];
    user.attention = YES;
    self.lastIndexPath = indexPath;
    ZZAttentionHeadViewController*  attentionHeadVC = [[ZZAttentionHeadViewController  alloc]init];
    attentionHeadVC.user = user;
    [self.navigationController  pushViewController:attentionHeadVC animated:YES];
}


#pragma mark  private  methods
//refresh
- (void)footerRereshing
{
    NSUInteger  lastId = 0;
    if (self.attentionUserMArray.count) {
        ZZUser* user = [self.attentionUserMArray lastObject];
        lastId = user.userId;
    }
    [self   getNetDataWithUserId:lastId andUpDown:2];
}

//设置tableview的尾部视图
- (void)setupFooter
{
    ZZLoadMoreFooter *footer = [ZZLoadMoreFooter footer];
 
    footer.delegate = self;
    self.attentionUserTabeView.tableFooterView = footer;
    self.footer = footer;
}
#pragma mark  life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    self.view.backgroundColor = ZZViewBackColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self  setupFooter];//设置footerview
    [self.view  addSubview:self.attentionUserTabeView];
    [self   footerRereshing];
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    if (self.lastIndexPath) {
        ZZUser*  lastUser = self.attentionUserMArray[self.lastIndexPath.row];
        if (!lastUser.attention) {
            [self.attentionUserMArray   removeObjectAtIndex:self.lastIndexPath.row];
                [self.attentionUserTabeView   deleteRowsAtIndexPaths:@[self.lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.attentionUserTabeView  deselectRowAtIndexPath:self.lastIndexPath animated:NO];
        self.lastIndexPath = nil;
    }
    
//    [self.attentionUserTabeView addFooterWithTarget:self action:@selector(footerRereshing)];
}


#pragma mark netRequest
-(void)getNetDataWithUserId:(NSUInteger)userId  andUpDown:(int)upDown{

  
    __weak  ZZMyAttentionViewController* myAttentionVC = self;
  
    [self.footer  beginRefreshing];
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindMyAttentionByUserId:userId andUpDown:upDown andBack:^(id obj) {
        [myAttentionVC.footer  endRefreshing];
        NSArray*  array = obj;
        if (array) {
            myAttentionVC.footer.canRefresh = NO;
            if (array.count) {
                [myAttentionVC.attentionUserMArray addObjectsFromArray:array];
                [myAttentionVC.attentionUserTabeView  reloadData];
            }
          
        }else{
            [myAttentionVC.footer  requestFailed];
        }
    }];
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
