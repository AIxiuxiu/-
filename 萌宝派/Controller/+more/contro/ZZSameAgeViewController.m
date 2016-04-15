//
//  ZZSameAgeViewController.m
//  萌宝派
//
//  Created by zhizhen on 15/4/20.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZSameAgeViewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZLastCell.h"
#import "ZZRecommendTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZZUprightViewController.h"
#import "ZZPlateTypeInfo.h"
#import "ZZLoadMoreFooter.h"
@interface ZZSameAgeViewController ()<UITableViewDataSource,UITableViewDelegate,ZZLoadMoreFooterDelegate>
@property(nonatomic,strong)UITableView* plateTableView;//版块tableview
@property(nonatomic,strong)NSArray*  plateTypeArray;//显示的板块数组
@property(nonatomic,strong)NSIndexPath*  lastIndexPath;//选中的cell，pop回来时刷新这个cell的含贴数量
@property (nonatomic, strong)ZZLoadMoreFooter *footer;;
@end

@implementation ZZSameAgeViewController
#pragma mark lazy load
-(UITableView *)plateTableView{
    if (!_plateTableView) {
        _plateTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, ZZNaviHeight, ScreenWidth, ScreenHeight - ZZNaviHeight)];
        _plateTableView.delegate = self;
        _plateTableView.rowHeight = 82;
        _plateTableView.dataSource = self;
        _plateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _plateTableView.backgroundColor = [UIColor  clearColor];
        
    }
    return _plateTableView;
}
-(ZZLoadMoreFooter *)footer{
    if (_footer == nil) {
        _footer = [ZZLoadMoreFooter  footer];
        _footer.delegate = self;
    }
    return _footer;
}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"同龄";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view  addSubview:self.plateTableView];
    [self  getNetDataWithString:@"AGEBREAKET"];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    if (self.lastIndexPath) {
        [self.plateTableView  reloadRowsAtIndexPaths:@[self.lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.lastIndexPath = nil;
    }
}
#pragma mark  ZZLoadMoreFooterDelegate
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
   [self  getNetDataWithString:@"AGEBREAKET"];
}
#pragma mark  UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.plateTypeArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZRecommendTableViewCell* cell = [ZZRecommendTableViewCell  dequeueReusableCellWithTableView:tableView];
    cell.heartIv.hidden = YES;
    cell.plateType  =  self.plateTypeArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        self.lastIndexPath = indexPath;
        ZZUprightViewController* uprightView = [[ZZUprightViewController alloc]init];
        uprightView.plateType = self.plateTypeArray[indexPath.row];
        [self.navigationController pushViewController:uprightView animated:YES];
  
}



#pragma  mark ---------网络请求
-(void)getNetDataWithString:(NSString*)str{
    
    __weak ZZSameAgeViewController*  allAreaVC = self;
   [self.footer  beginRefreshing];
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindALLPlatesByAreaType:str andBack:^(id obj) {
        if (obj) {
            allAreaVC.footer.canRefresh = NO;
            allAreaVC.plateTypeArray = obj;
            [allAreaVC.plateTableView  reloadData];
        }else{
            [allAreaVC.footer  requestFailed];
        }
      

    }];
}

@end
