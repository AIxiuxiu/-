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


@interface ZZMoreCaseViewContorller ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray*  caseMarray;
@property(nonatomic,strong)UITableView* caseTableView;

@property(nonatomic,strong)NSIndexPath*  lastIndexPath;

@property(nonatomic,strong)NSArray* caseCountArr;

@end

@implementation ZZMoreCaseViewContorller


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
        _caseTableView = [[UITableView alloc]initWithFrame:CGRectMake2(0, 69, AutoSizex, AutoSizey-75) style:UITableViewStylePlain];
        _caseTableView.backgroundColor = [UIColor clearColor];
        _caseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _caseTableView.dataSource = self;
        _caseTableView.delegate = self;
        _caseTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _caseTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _caseTableView.footerRefreshingText = @"正在加载中";
    }
    return _caseTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相关案例";
    [self.view addSubview:self.caseTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self   getNetDataWith:0  andUpDown:0];
}
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
     [self.caseTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    if (self.lastIndexPath) {
        [self.caseTableView   reloadRowsAtIndexPaths:@[self.lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.lastIndexPath = nil;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super   viewWillDisappear:animated];
    [self.caseTableView   removeFooter];
}

- (void)footerRereshing
{
    NSUInteger  lastId = 0;
    if (self.caseMarray.count) {
        ZZPost* post = [self.caseMarray lastObject];
        lastId = post.postId;
    }
    [self   getNetDataWith:lastId andUpDown:2];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.caseMarray.count;

  //  return self.caseCountArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* celler = @"cell";
    ZZInfoDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:celler];
    if (cell == nil) {
        cell = [[ZZInfoDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celler];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    ZZPost*  post = self.caseMarray[indexPath.row];
    cell.titleLabel.text = post.postTitle;
    cell.timeLabel.text = post.postDateStr;
    cell.postType.text =  [NSString   stringWithFormat:@"【%@】",post.postPlateType.title] ;
    cell.replayLabel.text = [NSString   stringWithFormat:@"%ld",post.postReplyCount];
   // cell.image.image = [UIImage imageNamed:@"head_portrait_55x55.jpg"];
  
    
        [cell.image  sd_setImageWithURL:[NSURL  URLWithString:post.postUser.mbpImageinfo.smallImagePath] placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"head_portrait_55x55.jpg" ofType:nil]]   options:SDWebImageRetryFailed|SDWebImageLowPriority];
    if ( post.postUser.permissions==3 &&post.postUser.isSuperStarUser) {
        cell.darenLevelIV.frame = CGRectMake1(cell.image.frame.origin.x/AutoSizeScalex+cell.image.frame.size.width/AutoSizeScalex-10, cell.image.frame.origin.y/AutoSizeScaley+cell.image.frame.size.height/AutoSizeScaley+10, 10, 10);
        cell.darenLevelIV.image  = [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:[post.postUser  getClassImagePathWithDaRenLevel:post.postUser.superStarLv] ofType:nil]] ;
                                    
        }else{
        cell.darenLevelIV.frame = CGRectZero;
    }

//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor whiteColor];
//    ZZCase* caseInfo = self.caseCountArr[indexPath.row];
//    cell.titleLabel.text = caseInfo.caseTitle;
//    cell.timeLabel.text = caseInfo.caseDateStr;
//    cell.postType.text = caseInfo.caseTypeName;
//    cell.replayLabel.text = [NSString stringWithFormat:@"%ld",caseInfo.caseReplyCount];
//    cell.image.image = [UIImage imageNamed:@"head_portrait_55x55.jpg"];

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*AutoSizeScaley;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZWonderDetailViewController*  wonderDvc = [[ZZWonderDetailViewController  alloc]init];
    wonderDvc.postIncoming = self.caseMarray[indexPath.row];
    [self.navigationController  pushViewController:wonderDvc animated:YES];
}
-(void)getNetDataWith:(NSUInteger)lastCaseId  andUpDown:(int)upDown{
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindCaseByCaseId:lastCaseId andPlateType:self.caseType andUpDown:upDown andBack:^(id obj) {
        if (upDown) {
            [self.caseTableView   footerEndRefreshing];
        }
        NSArray*  array = obj;
        if (array.count) {
            NSMutableArray* marray = [NSMutableArray  arrayWithCapacity:array.count];
            for (ZZPost* post in array) {
                [marray  addObject:[NSIndexPath  indexPathForRow:self.caseMarray.count inSection:0]];
                    [self.caseMarray  addObject:post];
        
            }
            
            [self.caseTableView  insertRowsAtIndexPaths:marray withRowAnimation:UITableViewRowAnimationAutomatic];
           
        }
    }];
}



@end
