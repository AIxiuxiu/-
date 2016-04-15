//
//  ZZAllAreaViewController.m
//  萌宝派
//
//  Created by zhizhen on 15/4/9.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZAllAreaViewController.h"
#import "ZZLastCell.h"
#import "ZZRecommendTableViewCell.h"
#import "ZZPlateTypeInfo.h"
#import "UIImageView+WebCache.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZUprightViewController.h"
#import "ZZBabyViewController.h"
#import "ZZSegmentV.h"
#import "ZZLoadMoreFooter.h"
@interface ZZAllAreaViewController ()<UITableViewDataSource,UITableViewDelegate,ZZSegmentVDelegate,ZZLoadMoreFooterDelegate>
//
//@property(nonatomic,strong)UIView*   switchView;

@property(nonatomic)NSUInteger  selectIndex;//上一次seg的值

@property(nonatomic,strong)UITableView* plateTableView;//版块tableview
@property(nonatomic,strong)NSIndexPath*  lastIndexPath;//选中的cell，pop回来时刷新这个cell的含贴数量
@property(nonatomic,strong)NSArray*  wonderArray;//请求到的精彩专区的板块数组
@property(nonatomic,strong)NSArray*   ageArray;//请求到的同龄的板块数组
@property(nonatomic,strong)NSArray*   cityArray;//请求到的同城的板块数组

@property (nonatomic, strong)ZZSegmentV *segment;

@property(nonatomic) NSUInteger  selectedItem;
@property (nonatomic, strong)ZZLoadMoreFooter *footer;
@end

@implementation ZZAllAreaViewController
#pragma mark  lazy load
-(ZZSegmentV *)segment{
    if (_segment == nil) {
        _segment = [[ZZSegmentV  alloc]initWithItems:@[@"话题",@"同龄",@"同城"]];
        _segment.frame = CGRectMake(34, 64 + upDownSpace, ScreenWidth - 34*2, 30);
        _segment.delegate = self;
    }
    return _segment;
}
-(UITableView *)plateTableView{
    if (!_plateTableView) {
        CGFloat y = CGRectGetMaxY(self.segment.frame)
        +upDownSpace;
        CGFloat  height = ScreenHeight -y;
        _plateTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, y,ScreenWidth, height)];
        _plateTableView.rowHeight = 82;
        _plateTableView.delegate = self;
        _plateTableView.dataSource = self;
        _plateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _plateTableView.backgroundColor = [UIColor  clearColor];
        _plateTableView.tableFooterView = self.footer;
        
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
#pragma life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    if (self.lastIndexPath) {
        [self.plateTableView  reloadRowsAtIndexPaths:@[self.lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.lastIndexPath = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制关注";
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view  addSubview:self.segment];
    [self.view  addSubview:self.plateTableView];

}

#pragma mark event response


#pragma mark private methods
/**
 *  根据seg选中的状态，返回当前显示的array
 *
 *  @return <#return value description#>
 */
- (NSArray *)getCurrentShowArray{
    if (self.selectedItem == 0) {
        return self.wonderArray;
    }else if (self.selectedItem == 1){
        return self.ageArray;
    }else{
        return self.cityArray;
    }
}
- (void)setCurrentShowArray:(NSArray *)array  item:(NSUInteger)item{
    if (item == 0) {
        self.wonderArray = array;
    }else if (item == 1){
        self.ageArray = array;
    }else{
        self.cityArray = array;
    }
}
- (NSString *)getCurrentNetDataType{
    if (self.selectedItem == 0) {
        return @"WONDERFUL";
    }else if (self.selectedItem == 1){
        return @"AGEBREAKET";
    }else{
        return @"LOCAL";
    }
}
#pragma mark  ZZLoadMoreFooterDelegate
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
    [self  getNetData];
}
#pragma mark  ZZSegmentVDelegate

-(void)segmentVClicked:(ZZSegmentV *)segment item:(NSUInteger)item{
    self.selectedItem = item;
    self.footer.canRefresh = NO;
    [self.plateTableView  reloadData];
    if ([self  getCurrentShowArray].count == 0) {
        [self getNetData];
    }
    
}
#pragma mark  UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self getCurrentShowArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        ZZRecommendTableViewCell* cell = [ZZRecommendTableViewCell  dequeueReusableCellWithTableView:tableView];
     cell.heartIv.hidden = YES;
        cell.plateType  =  [self getCurrentShowArray][indexPath.row];
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        self.lastIndexPath = indexPath;
        NSArray *selecedArray = [self getCurrentShowArray];
        ZZPlateTypeInfo*   plateType  =  selecedArray[indexPath.row];
        if (!self.selectedItem&&[plateType.type  isEqualToString:@"MYBABY"]) {
            ZZBabyViewController*  babyVc =[[ZZBabyViewController  alloc]init];
            babyVc.babyPlate = plateType;
            [self.navigationController  pushViewController:babyVc animated:YES];
      
        }else{
            ZZUprightViewController* uprightView = [[ZZUprightViewController alloc]init];
            uprightView.plateType = plateType;
            [self.navigationController pushViewController:uprightView animated:YES];
        }
    
    [tableView  deselectRowAtIndexPath:indexPath animated:NO];
}



#pragma  mark ---------网络请求
-(void)getNetData{
    
    __weak ZZAllAreaViewController*  allAreaVC = self;
    NSInteger selected = self.selectedItem;
    
    [self.footer  beginRefreshing];
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindALLPlatesByAreaType:[self   getCurrentNetDataType] andBack:^(id obj) {
        if(obj){
            allAreaVC.footer.canRefresh = NO;
            [allAreaVC  setCurrentShowArray:obj  item:selected] ;
      
            [allAreaVC.plateTableView  reloadData];
        }else{
            [allAreaVC.footer  requestFailed];
       
        }
    }];
}



@end
