//
//  ZZDiaryViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-13.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZDiaryViewController.h"
#import "ZZDiaryTableViewCell.h"
#import "ZZDiaryPublishViewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZDiaryDetailViewController.h"
#import "ZZMyAlertView.h"
#import "ZZLoadMoreFooter.h"
@interface ZZDiaryViewController ()<UITableViewDataSource,UITableViewDelegate,ZZMyAlertViewDelgate,ZZDiaryTableViewCellDelegate,ZZLoadMoreFooterDelegate>
//显示
@property(nonatomic,strong)UITableView*   diaryTableView;//
@property(nonatomic,strong)NSMutableArray* babyArr;
//刷新
@property(nonatomic)NSUInteger lastDiaryId;
@property(nonatomic)NSUInteger  upOrDown;

@property (nonatomic, strong)ZZLoadMoreFooter *footer;
@end

@implementation ZZDiaryViewController
#pragma mark lazy load
-(UITableView *)diaryTableView{
    if (!_diaryTableView) {
        _diaryTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
        _diaryTableView.rowHeight = 355;
        _diaryTableView.backgroundColor = [UIColor  clearColor];
        _diaryTableView.delegate = self;
        _diaryTableView.dataSource = self;
        _diaryTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _diaryTableView;
}

-(NSMutableArray *)babyArr{
    if (!_babyArr) {
        _babyArr = [NSMutableArray  array];
    }
    return _babyArr;
}

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成长日记";
    self.view.backgroundColor = ZZViewBackColor;
    [self.view  addSubview:self.diaryTableView];
    
    UIButton* writeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImage* img3 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"issue_button_30x30.png" ofType:nil]];
    [writeButton setBackgroundImage:img3 forState:UIControlStateNormal];
    [writeButton addTarget:self action:@selector(writeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    writeButton.tag = 1;
    UIBarButtonItem*  writeButtonItem=[[UIBarButtonItem alloc]initWithCustomView:writeButton];
    //navi的右边的button
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -8;//此处修改到边界的距离，请自行测试
    
    [self.navigationItem setRightBarButtonItems:@[negativeSeperator,writeButtonItem]];
    [self setUpTableViewFooter];
    [self footerRereshing];
}
- (void)setUpTableViewFooter{
    ZZLoadMoreFooter *footer = [ZZLoadMoreFooter footer];
    footer.delegate = self;

    self.diaryTableView.tableFooterView = footer;
    self.footer = footer;
}
#pragma mark event response
-(void)writeButtonAction:(UIButton*)btn{
    ZZDiaryPublishViewController*  diaryPubishVC =[[ZZDiaryPublishViewController alloc]init];
    diaryPubishVC.babyInfo = self.babyInfo;
    [self.navigationController   pushViewController:diaryPubishVC animated:YES];
    
}
#pragma mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.babyArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZDiaryTableViewCell *cell = [ZZDiaryTableViewCell  dequeueReusableCellWithTableView:tableView  delegate:self];
  
    cell.diaryInfo = self.babyArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        ZZDiaryDetailViewController* diaryView = [[ZZDiaryDetailViewController alloc]init];
        diaryView.diaryInfo = self.babyArr[indexPath.row];
        [self.navigationController pushViewController:diaryView animated:YES];
    [tableView  deselectRowAtIndexPath:indexPath animated:NO];
  
}
#pragma mark - tableView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.babyArr.count <= 0 || self.footer.isRefreshing || self.footer.canRefresh == NO||scrollView.contentOffset.y<self.footer.height) return;
    
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

#pragma mark - ZZLoadMoreFooterDelegate
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
    [self  footerRereshing];
}

#pragma mark ZZDiaryTableViewCellDelegate
-(void)diaryTableViewCellDelebuttonClicked:(ZZDiaryTableViewCell *)diaryCell  {
    ZZLog(@",,,%@",diaryCell);
    if (diaryCell == nil) {
        return;
    }
    NSIndexPath *indexPath = [self.diaryTableView  indexPathForCell:diaryCell];
    ZZBabyDiaryInfo*  diaryInfo = self.babyArr[indexPath.row];
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postDeleteBabyGrowingLogWithBabyId:self.babyInfo.babyId andDiaryId:diaryInfo.diaryId andBack:^(id obj) {
        if (obj) {
            [self.babyArr   removeObjectAtIndex:indexPath.row];
                [self.diaryTableView   deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }];

}


#pragma mark netRequest
-(void)getNetData{
    __weak  ZZDiaryViewController*  diaryVC = self;
    [self.footer  beginRefreshing];
    [[ZZMengBaoPaiRequest   shareMengBaoPaiRequest]postFindBabyGrowingLogListWithBabyId:self.babyInfo.babyId andDiaryId:self.lastDiaryId andUpDown:self.upOrDown andBack:^(id obj) {
        [diaryVC.footer  endRefreshing];
        if (obj) {
            NSArray *array = obj;
            if (array.count) {
                    NSArray* otherBabyArr = obj;
                    NSMutableArray* rowArr = [NSMutableArray  arrayWithCapacity:otherBabyArr.count];
                    for (ZZBaby* otherBaby in otherBabyArr) {
                        [diaryVC.babyArr addObject:otherBaby];
                        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:diaryVC.babyArr.count-1 inSection:0];
                        [rowArr addObject:indexPath];
                    }
                    [diaryVC.diaryTableView insertRowsAtIndexPaths:rowArr withRowAnimation:UITableViewRowAnimationAutomatic];
  
            }else{
                diaryVC.footer.canRefresh = NO;
            }
        }else{
            [diaryVC.footer requestFailed];
        }
    }];
    
}

#pragma mark private methods
//发布成功后调用
-(void)publishSuccessRefreshWith:(NSArray*)array{
    self.babyInfo.growingCount++;
    self.babyArr = [array  mutableCopy];
    [self.diaryTableView  reloadData];
}

- (void)footerRereshing
{
    self.upOrDown = 2;
    if (self.babyArr.count) {
         ZZBabyDiaryInfo* diary= [self.babyArr lastObject];
        self.lastDiaryId = diary.diaryId;
    }else{
        self.lastDiaryId = 0;
    }
    
    [self   getNetData];
}

-(void)dealloc{
    self.diaryTableView.delegate  = nil;
}
@end
