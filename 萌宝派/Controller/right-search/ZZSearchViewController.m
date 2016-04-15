//
//  ZZSearchViewController.m
//  萌宝派
//
//  Created by zhizhen on 15/5/20.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZSearchViewController.h"
#import "MJRefresh.h"
#import "ZZAttentionTableViewCell.h"
#import "ZZUser.h"
#import "ZZInfoDetailCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "ZZPost.h"
#import "ZZAttentionHeadViewController.h"
#import "ZZWonderDetailViewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZSegmentV.h"
#import "ZZLoadMoreFooter.h"
@interface ZZSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ZZSegmentVDelegate,ZZLoadMoreFooterDelegate>
@property(nonatomic,strong)UITableView* helpTabelView;

@property(nonatomic,strong)UIButton* cancelButton;
@property(nonatomic,strong)UISearchBar* searchBarView;
//
//@property(nonatomic,strong)UISegmentedControl*  segmentC;//用户、案例、话题  搜索切换的tableview
//@property(nonatomic,strong)UILabel*  switchLabel;//标识选中的搜索项
@property(nonatomic,strong)UITableView*  searchTableView;//搜索结果显示tableview

@property(nonatomic,strong)NSMutableArray*  searchMarray;

@property (nonatomic)NSUInteger selectedItem;
//记录退出搜索界面时的字符串
@property(nonatomic,strong)NSString* lastSearchStr;
//
@property (nonatomic, strong)ZZLoadMoreFooter *footer;
@end
@implementation ZZSearchViewController
#pragma mark  lazy load
-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //        _cancelButton.layer.cornerRadius = 12;
        //        _cancelButton.layer.masksToBounds = YES;
        // _cancelButton.backgroundColor = [UIColor  colorWithRed:0.1 green:0.63 blue:0.96 alpha:0.93];
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _cancelButton;
}
//-(UIView *)searchCaseView{
//    if (!_searchCaseView) {
//        _searchCaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
//       _searchCaseView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
//        //_searchCaseView.backgroundColor = [UIColor  redColor];
//    }
//    return _searchCaseView;
//}
-(UISearchBar *)searchBarView{
    if (!_searchBarView) {
        _searchBarView = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 0, ScreenWidth- 110, 28)];
        _searchBarView.barStyle = UIBarStyleDefault;
        _searchBarView.delegate = self;
        _searchBarView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [_searchBarView setBackgroundColor:[UIColor  whiteColor]];
        //        [_searchBarView setBackgroundColor:[UIColor colorWithRed:0.28 green:0.6 blue:0.79 alpha:1]];
        _searchBarView.layer.cornerRadius = _searchBarView.frame.size.height/2;
        _searchBarView.layer.masksToBounds  = YES;
        _searchBarView.placeholder = @"用户、话题、案例";
    
        for (UIView *view in _searchBarView.subviews){
            for (id subview in view.subviews){
                if ( [subview isKindOfClass:[UITextField class]] ){
                    [(UITextField *)subview setValue:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
                    [(UITextField *)subview setFont:[UIFont systemFontOfSize:16]];
                    
                }
                
            }
        }
        
    }
    return _searchBarView;
}


-(UITableView *)searchTableView{
    if (!_searchTableView) {
        _searchTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0,64 + 50, ScreenWidth, ScreenHeight - 64 -50) style:UITableViewStylePlain];
        _searchTableView.tag = 333;
        _searchTableView.showsHorizontalScrollIndicator = NO;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       _searchTableView.backgroundColor = [UIColor  clearColor];
        //        _searchTableView.estimatedSectionHeaderHeight = 10;
        //        _searchTableView.sectionHeaderHeight =5;
        //        _searchTableView.sectionFooterHeight = 5;
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _searchTableView;
}
-(NSMutableArray *)searchMarray{
    if (!_searchMarray ) {
        _searchMarray = [NSMutableArray array];
    }
    return _searchMarray;
}
#pragma mark life cycle
-(void)viewDidLoad{
    [super  viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self  setBarButtonItems];
    [self.view  addSubview:self.searchTableView];
    [self  setUpSegment];
    [self  setupFooter];
  //  [self.view addSubview:self.searchCaseView];
}

- (void)setBarButtonItems{
    //隐藏左边返回按钮
    [self.navigationItem setLeftBarButtonItems:nil];
    self.navigationItem.hidesBackButton = YES;

    UIView* searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth-100, 30)];
    searchView.backgroundColor = [UIColor  redColor];
    searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:self.searchBarView];
    self.navigationItem.titleView = searchView;
    
    UIBarButtonItem* rightCancelButton = [[UIBarButtonItem alloc]initWithCustomView:self.cancelButton];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -10;//此处修改到边界的距离，请自行测试
    [self.navigationItem setRightBarButtonItems:@[negativeSeperator,rightCancelButton] animated:YES];
}

//设置tableview的尾部视图
- (void)setupFooter
{
    ZZLoadMoreFooter *footer = [ZZLoadMoreFooter footer];
    footer.canRefresh = YES;

    footer.delegate = self;
    self.searchTableView.tableFooterView = footer;
    self.footer = footer;
}
- (void)setUpSegment{
    ZZSegmentV *segment = [[ZZSegmentV  alloc]initWithItems:@[@"用户",@"话题",@"案例"]];
    segment.frame = CGRectMake(30, 64, ScreenWidth - 60, 50);
    segment.delegate = self;
    [self.view  addSubview:segment];
}
//#pragma mark event response
//- (void)segmentedControlChangedValue:(UISegmentedControl*)segmentedControl {
//    
//    NSString*  str= [self.segmentC  titleForSegmentAtIndex:self.segmentC.selectedSegmentIndex];
//    self.switchLabel.text = str;
//    
//    [UIView  animateWithDuration:0.2 animations:^{
//       // CGRectMake(5, 12, (ScreenWidth-320)/3+60, 26)
//        self.switchLabel.frame=CGRectMake(self.segmentC.selectedSegmentIndex*(ScreenWidth-110)/3+(ScreenWidth-290)/6, 7, 60, 26);
//        
//    }];
//    self.searchTag = self.segmentC.selectedSegmentIndex+1;
//    [self.searchMarray  removeAllObjects];
//    [self.searchTableView  reloadData];
//    [self  getNetDataWithId:0 andUpDown:0];
//}

-(void)cancelButtonAction:(UIButton*)btn{
    [self.searchBarView  resignFirstResponder];
    [self.navigationController  popViewControllerAnimated:YES];
}
#pragma mark -ZZLoadMoreFooterDelegate
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
    [self  footerRereshing];
}
#pragma mark -ZZSegmentVDelegate
-(void)segmentVClicked:(ZZSegmentV *)segment item:(NSUInteger)item{
    self.selectedItem = item;
    self.footer.canRefresh = YES;
    self.searchMarray = [NSMutableArray  array];
    [self.searchTableView  reloadData];
    [self  footerRereshing];
}
#pragma mark  UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchMarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedItem == 0){
        ZZAttentionTableViewCell *cell = [ZZAttentionTableViewCell dequeueReusableCellWithTableView:tableView];
        cell.user = self.searchMarray[indexPath.row];
        return cell;
    }else{
        ZZInfoDetailCell  *cell = [ZZInfoDetailCell  dequeueReusableCellWithTableView:tableView deleteButton:NO delegate:nil];
  
        cell.post = self.searchMarray[indexPath.row];
      
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectedItem == 0) {
        return 80;
    }
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.searchBarView  resignFirstResponder];
    if (self.selectedItem == 0) {
        ZZAttentionHeadViewController*  attentionHVc = [[ZZAttentionHeadViewController  alloc]init];
        attentionHVc.user = self.searchMarray[indexPath.row];
        [self.navigationController  pushViewController:attentionHVc animated:NO];
    }else{
        ZZWonderDetailViewController* wonderVc = [[ZZWonderDetailViewController  alloc]init];
        wonderVc.postIncoming = self.searchMarray[indexPath.row];
        [self.navigationController  pushViewController:wonderVc animated:NO];
    }
    
    [tableView  deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - tableView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.searchMarray.count <= 0 || self.footer.isRefreshing || self.footer.canRefresh == NO||scrollView.contentOffset.y<self.footer.height) return;
    
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

#pragma mark ------------------searchBar的协议方法--------------------
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

    self.searchBarView.text = self.lastSearchStr;
    self.lastSearchStr = nil;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar; {
    [searchBar resignFirstResponder];
    [self   footerRereshing];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self  footerRereshing];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.lastSearchStr = self.searchBarView.text;
    return YES;
}

#pragma mark  netRequest
//sousuo
-(void)getNetDataWithId:(NSUInteger)lastId  andUpDown:(int)upDown  text:(NSString *)text{
  
    __weak typeof(self) selfVc = self;
    [self.footer  beginRefreshing];
    NSUInteger  index = self.selectedItem;//记录网络请求时 类型值
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postSearchByType:self.selectedItem+1 andSearchContent:text andId:lastId andUpDown:upDown andBack:^(id obj) {
        [selfVc.footer  endRefreshing];
        if (index != selfVc.selectedItem && ![[selfVc.searchBarView.text  removeWhitespaceAndNewlineCharacter]  isEqualToString:text]) {
            return ;
        }
        if (obj) {
             NSArray*  array = obj;
            if (array.count) {
             
                [selfVc.searchMarray addObjectsFromArray:array];
                [selfVc.searchTableView  reloadData];
           
                
            }else{
                selfVc.footer.canRefresh = NO;
            }
        }else{
            [selfVc.footer  requestFailed];
        }
       

    }];
}
#pragma mark  private  methods
//刷新
- (void)footerRereshing
{
   
      NSString*  serchStr =[self.searchBarView.text  removeWhitespaceAndNewlineCharacter];
    if ([self.lastSearchStr isEqualToString:serchStr]) {
                 
    }else{
        self.footer.canRefresh = YES;
        
        [self.searchMarray  removeAllObjects];
        [self.searchTableView  reloadData];
    }
    if (serchStr.length == 0) {
        return;
    }
    NSUInteger  lastId = 0;
    if (self.searchMarray.count) {
        if (self.selectedItem == 0) {
            ZZUser* user = [self.searchMarray lastObject];
            lastId = user.userId;
        }else
        {
            ZZPost* post = [self.searchMarray lastObject];
            lastId = post.postId;
        }
    }
    self.lastSearchStr = serchStr ;
    [self   getNetDataWithId:lastId andUpDown:2  text:serchStr];
}

-(void)dealloc{
    self.searchTableView.delegate = nil;
}
@end
