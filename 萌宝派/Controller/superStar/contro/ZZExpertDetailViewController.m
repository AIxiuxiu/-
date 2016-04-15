//
//  ZZExpertDetailViewController.m
//  萌宝派
//
//  Created by charles on 15/4/2.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZExpertDetailViewController.h"
#import "ZZExpertIntroduceCell.h"

#import "UIImageView+WebCache.h"
#import "ZZMengBaoPaiRequest.h"

#import "ZZMyAlertView.h"
#import "ZZInfoDetailCell.h"
#import "ZZPost.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ZZWonderDetailViewController.h"
#import "ZZLastCell.h"
#import "AppDelegate.h"
#import "ZZSegmentV.h"
#import "ZZLoadMoreFooter.h"
@interface ZZExpertDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ZZMyAlertViewDelgate,ZZSegmentVDelegate,ZZLoadMoreFooterDelegate>
@property(nonatomic,strong)UITableView* expertTableView;
@property(nonatomic,strong)ZZExpertIntroduceCell* cell;
@property(nonatomic,strong)UIView* blackView;//行程背景
@property(nonatomic,strong)UITextView* journeyTextView;//医生行程介绍
//
@property(nonatomic,strong)UIButton*  attentionButton;//关注按钮

@property(nonatomic,strong)NSMutableArray* ageArray;//同龄星座
@property(nonatomic,strong)NSMutableArray* cityArray;//同城
@property(nonatomic,strong)NSMutableArray*  wonderfulArray;//精彩

@property(nonatomic)int   typeNumber;  ////1：精彩专区  2:同龄   3:同城

//进入子界面回来刷新
@property(nonatomic,strong)NSIndexPath* lastIndexPath;


@property(nonatomic,strong)ZZSegmentV* segmentV;
@property (nonatomic, strong)ZZLoadMoreFooter *footer;
@property (nonatomic) NSUInteger  selectedItem;
//是否可以进行网络请求，
@property (nonatomic)BOOL ageCanRefresh;
@property (nonatomic)BOOL cityCanRefresh;
@property (nonatomic)BOOL wonCanRefresh;

@end

@implementation ZZExpertDetailViewController


#pragma mark  life  cycle

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    if (self.lastIndexPath) {
        [self.expertTableView   reloadRowsAtIndexPaths:@[self.lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.lastIndexPath = nil;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医生介绍";
    [self.view addSubview:self.expertTableView];
    /**
     *  请求
     */
    [self footerRereshing];
    UITapGestureRecognizer*  tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(dismissView)];
    [self.blackView addGestureRecognizer:tap];
    
    [self.view addSubview:self.blackView];
    
    [self.view addSubview:self.journeyTextView];
    
    /**
     *  tableVIew head
     */
    [self setTableHeadView];
    
}
/**
 *  tableView的头
 */
-(void)setTableHeadView{
    UIView* backGroundView = [[UIView alloc]init];
    backGroundView.backgroundColor = [UIColor whiteColor];
    
    
    //背景图片
    UIImageView* userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/1.6)];
    userImage.contentMode = UIViewContentModeScaleAspectFill;
    userImage.clipsToBounds = YES;
    userImage.image = [UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"handAndFoot.jpg" ofType:nil] ];
    [backGroundView  addSubview:userImage];
    //头像图片
    UIImageView* headImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(userImage.frame)-30, 60, 60)];
    headImage.layer.cornerRadius = 5;
    headImage.layer.masksToBounds = YES;
    headImage.clipsToBounds = YES;
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    headImage.userInteractionEnabled = YES;
    [headImage  sd_setImageWithURL:[NSURL URLWithString:self.expertUser.mbpImageinfo.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"head_portrait_55x55.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
    [backGroundView addSubview:headImage];
    //医生行程
    UIButton* moreButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+15, CGRectGetMaxY(headImage.frame)-20, 50, 20)];
    [moreButton setTitle:@"行程" forState:UIControlStateNormal];
    moreButton.layer.cornerRadius = 5;
    moreButton.layer.masksToBounds = YES;
    
    [moreButton  setBackgroundColor:[UIColor colorWithRed:0.35 green:0.75 blue:0.99 alpha:1]];
    moreButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [backGroundView addSubview:moreButton];
    
    // 关注
    UIButton* attentionButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moreButton.frame)+15, CGRectGetMaxY(headImage.frame)-20, 50, 20)];
    self.attentionButton = attentionButton;
    attentionButton.layer.cornerRadius = 5;
    attentionButton.layer.masksToBounds = YES;
    [attentionButton  addTarget:self action:@selector(attentionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    attentionButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];


    
    //背景名字
    UILabel* nameBackground = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+3, CGRectGetMaxY(userImage.frame)-20, 200, 20)];
    nameBackground.text = self.expertUser.nick;
    nameBackground.font = [UIFont boldSystemFontOfSize:18];
    nameBackground.textColor = [UIColor blackColor];
    [backGroundView addSubview:nameBackground];
    //用户名字
    UILabel* userName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+4, CGRectGetMaxY(userImage.frame)-19, 200, 20)];
    userName.text = self.expertUser.nick;
    userName.font = [UIFont boldSystemFontOfSize:18];
    userName.textColor = [UIColor whiteColor];
    [backGroundView addSubview:userName];
    
    backGroundView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(userImage.frame)+30+10);
    
    self.expertTableView.tableHeaderView = backGroundView;
    //当前用户是否被关注了
    [self  getuserIsAttent];
}


#pragma mark  private  methods
- (void)footerRereshing
{
    NSUInteger  lastId = 0;
    NSArray *currentArray = [self  getCurrentArrayWithItem:self.selectedItem];
    if (currentArray.count) {
        ZZPost* post = [currentArray lastObject];
        lastId = post.postId;
    }
    [self   getMyPublishNetDataWithUpDown:2 andWithLastId:lastId];
}
#pragma mark  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else{
        return [self getCurrentArrayWithItem:self.selectedItem].count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* celler = @"ExpertIntroduceCell";
    static NSString* firstCeller = @"firstCell";
    if (indexPath.section == 0) {
        ZZExpertIntroduceCell* cell = [tableView dequeueReusableCellWithIdentifier:celler];
        if (cell == nil) {
            cell = [[ZZExpertIntroduceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celler];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.expertUser = self.expertUser;
        return cell;
    }else if (indexPath.section == 1){
    
        UITableViewCell*  cell = [tableView  dequeueReusableCellWithIdentifier:firstCeller];
        if (cell == nil) {
            cell= [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstCeller];
          
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor  clearColor];
            [cell.contentView  addSubview:self.segmentV];
        }
        
        return cell;
    }else{
        ZZInfoDetailCell* cell = [ZZInfoDetailCell dequeueReusableCellWithTableView:tableView deleteButton:NO delegate:nil];
        ZZPost* post = [self getCurrentArrayWithItem:self.selectedItem][indexPath.row];
        cell.post = post;
        return cell;
    }
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.cell.expertUser = self.expertUser;
        [self.cell   setNeedsLayout];
        [self.cell  layoutIfNeeded];
        return self.cell.cellHeight;
    }else if (indexPath.section == 1){
        return 40;
    }else{
        return 55;
    }
}


//设置标题
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        headView.backgroundColor = [UIColor whiteColor];
        UILabel* headLabel = [[UILabel alloc]init];
        headLabel.textColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1];
        headLabel.text = @"名医介绍";
        headLabel.font = [UIFont boldSystemFontOfSize:16];
        headLabel.frame = CGRectMake(10, 15, 100, 20);
        [headView addSubview:headLabel];
        
        UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, ScreenWidth, 0.5)];
        lineLabel.backgroundColor = [UIColor  colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [headView addSubview:lineLabel];
        UILabel* topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
        topLine.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [headView addSubview:topLine];
        UILabel* lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0,5, ScreenWidth, 0.5)];
        lineLabel2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [headView addSubview:lineLabel2];
        return headView;
    }else{
        return nil;
    }
    
}
//标题高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 45;
    }else{
        return 0;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        self.lastIndexPath = indexPath;
        ZZWonderDetailViewController*  wonderDetailVC = [[ZZWonderDetailViewController alloc]init];
        ZZPost* post = [self getCurrentArrayWithItem:self.selectedItem][indexPath.row];
        wonderDetailVC.postIncoming = post;
        [self.navigationController  pushViewController:wonderDetailVC animated:YES];
    }
   
}
#pragma mark   ZZMyAlertViewDelgate
-(void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //203  取消关注
    if (buttonIndex&&alertView.tag ==203) {
        __weak  ZZExpertDetailViewController*  expertVC = self;
        [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postUpdateAttentionUserOrPlateWithCode:@"user" andPlatedId:0 andUserId:self.expertUser.userId andAddOrDelete:!self.expertUser.attention andCallback:^(id obj) {
            if (obj) {
                expertVC.expertUser.attention = !expertVC.expertUser.attention;
                if (expertVC.expertUser.attention) {
                    expertVC.attentionButton.backgroundColor = [UIColor  colorWithRed:0.57 green:0.85 blue:0.37 alpha:1];
                    [ expertVC.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
                }else{
                    expertVC.attentionButton.backgroundColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1];
                    [ expertVC.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
                }
            }
        }];
    }
}
#pragma mark  event response

- (void)segmentVClicked:(ZZSegmentV *)segment item:(NSUInteger)item{
    self.selectedItem = item;
    [self.expertTableView  reloadData];
    [self.footer  endRefreshing];
    self.footer.canRefresh = [self  getCurrentCanRefreshItem:item];
    if ([self  getCurrentArrayWithItem:item].count == 0  && [self  getCurrentCanRefreshItem:item]) {
        [self  footerRereshing];
    }
    
}

-(void)attentionButtonAction{
    if (self.expertUser.attention) {
        ZZMyAlertView* alertView = [[ZZMyAlertView  alloc]initWithMessage:@"你确定要取消关注嘛" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
        alertView.tag = 203;
        [alertView  show];
        return;
    }
    __weak  ZZExpertDetailViewController*  expertVC = self;
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postUpdateAttentionUserOrPlateWithCode:@"user" andPlatedId:0 andUserId:self.expertUser.userId andAddOrDelete:!self.expertUser.attention andCallback:^(id obj) {
        if (obj) {
            expertVC.expertUser.attention = !expertVC.expertUser.attention;
            if (expertVC.expertUser.attention) {
                expertVC.attentionButton.backgroundColor = [UIColor  colorWithRed:0.57 green:0.85 blue:0.37 alpha:1];
                [ expertVC.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
            }else{
                expertVC.attentionButton.backgroundColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1];
                [ expertVC.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
            }
        }
    }];
    
}
-(void)moreButtonAction{
    
    [[ZZMengBaoPaiRequest shareMengBaoPaiRequest] postExpertJourneyByuserId:self.expertUser.userId andBack:^(id obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            self.journeyTextView.text = obj;
        }
    }];
    self.blackView.hidden = NO;
    [UIView  animateWithDuration:0.2 animations:^{
        self.journeyTextView.frame = CGRectMake(0, ScreenHeight-150, ScreenWidth, 150);
    }];
    
}
//手势事件
-(void)dismissView{
    
    self.blackView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.journeyTextView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 150);
        
    }];
    
}

#pragma mark  netRequest

- (void)getuserIsAttent{
    weakSelf(expertVC);
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindThisUserAttention:self.expertUser.userId andBack:^(id obj) {
        if (obj) {
            expertVC.expertUser.attention = [[obj objectForKey:@"validAttentionUser"]boolValue];
            expertVC.expertUser.isCurrentUser = [[obj  objectForKey:@"validCurrentUser"]boolValue];
        }
        if (expertVC.expertUser.isCurrentUser == NO) {
            if (expertVC.expertUser.attention) {
                expertVC.attentionButton.backgroundColor = [UIColor  colorWithRed:0.57 green:0.85 blue:0.37 alpha:1];
                [ expertVC.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
            }else{
                expertVC.attentionButton.backgroundColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1];
                [ expertVC.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
            }
            [expertVC.expertTableView.tableHeaderView addSubview:expertVC.attentionButton];
        }
        
    }];
}
-(void)getMyPublishNetDataWithUpDown:(int)upDown  andWithLastId:(NSUInteger)lastId{
    [self.footer beginRefreshing];
    NSUInteger  item = self.selectedItem;
    __weak  ZZExpertDetailViewController*  expertVC = self;
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindAttentionUserMorePublishListWithUserId:self.expertUser.userId andPostId:lastId andUpDOwn:upDown andTypeNumber:self.typeNumber andBack:^(id obj) {
        [expertVC.footer endRefreshing];
        
        if (item == expertVC.selectedItem) {
            if (obj) {
                NSArray* array = obj;
                if (array.count) {
                    NSMutableArray* mArray = [expertVC getCurrentArrayWithItem:item];
                    [mArray  addObjectsFromArray:array];
                    [expertVC.expertTableView reloadData];
                }else{
                    [expertVC  setCurrentCanRefreshItem:item];
                    expertVC.footer.canRefresh = NO;
                }
            }else {
                [expertVC.footer requestFailed];
            }
        }

    }];
}

#pragma mark  lazy  load
-(ZZSegmentV *)segmentV{
    if (!_segmentV) {
        _segmentV = [[ZZSegmentV  alloc]initWithItems:@[@"话题",@"同龄",@"同城"]];
        _segmentV.frame =CGRectMake(34*(ScreenWidth/320), 2.5, 252*(ScreenWidth/320), 30);
        _segmentV.delegate = self;
    }
    return _segmentV;
}
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
-(UIView *)blackView{
    if (!_blackView) {
        _blackView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        _blackView.backgroundColor = [UIColor  blackColor];
        _blackView.alpha = .2;
        _blackView.hidden = YES;
    }
    return _blackView;
}
-(UITextView *)journeyTextView{
    if (!_journeyTextView) {
        _journeyTextView = [[UITextView alloc]init];
        _journeyTextView.backgroundColor = [UIColor whiteColor];
        [_journeyTextView setEditable:NO];
        _journeyTextView.layer.cornerRadius = 5;
        _journeyTextView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 100);
        _journeyTextView.textColor = [UIColor colorWithRed:.34 green:.34 blue:.34 alpha:1];
        _journeyTextView.font = [UIFont boldSystemFontOfSize:15];
    }
    return _journeyTextView;
}
-(UITableView *)expertTableView{
    if (!_expertTableView) {
        _expertTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _expertTableView.tag = 111;
        _expertTableView.backgroundColor = [UIColor clearColor];
        _expertTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _expertTableView.dataSource = self;
        _expertTableView.delegate = self;
        ZZLoadMoreFooter *footer = [ZZLoadMoreFooter footer];
      
        footer.delegate = self;
        self.wonCanRefresh = YES;
        self.ageCanRefresh = YES;
        self.cityCanRefresh = YES;
        _expertTableView.tableFooterView = footer;
        self.footer = footer;
    }
    return _expertTableView;
}
-(ZZExpertIntroduceCell *)cell{
    if (!_cell) {
        _cell = [[ZZExpertIntroduceCell  alloc]init];
    }
    return _cell;
}
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
  
    if ([self  getCurrentArrayWithItem:self.selectedItem] .count <= 0 || self.footer.isRefreshing || [self getCurrentArrayWithItem:self.selectedItem] == NO||scrollView.contentOffset.y<self.footer.height) return;
    // 1.差距
    CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
    // 刚好能完整看到footer的高度
    CGFloat sawFooterH = scrollView.height + self.footer.height;
    
    // 2.如果能看见整个footer
    if (delta <= (sawFooterH - 0)) {
        [self.footer  beginRefreshing];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( ZZNetDely * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        [self footerRereshing];
          });
    }
}


#pragma mark -ZZLoadMoreFooterDelegate
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
    [self  footerRereshing];
}

-(void)dealloc{
    self.expertTableView.delegate = nil;
    ZZLog( @",,,,%@",[self  class]);
}
@end
