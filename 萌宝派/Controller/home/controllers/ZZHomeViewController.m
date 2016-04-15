//
//  ZZHomeViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-2.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZHomeViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "ASScroll.h"
#import "ZZRecommendTableViewCell.h"
#import "ZZUprightViewController.h"
#import "ZZBabyViewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "UIImageView+WebCache.h"
#import "ZZAllAreaViewController.h"

#import "MBProgressHUD.h"
#import "ZZPost.h"
#import "ZZWonderDetailViewController.h"
#import "ZZLibCacheTool.h"

#import "ZZMyNewAlertView.h"
#import "ZZTitleSegV.h"
#import "ZZTalentShowView.h"
#import "ZZLoadMoreFooter.h"
@interface ZZHomeViewController ()<UITableViewDataSource,UITableViewDelegate,ZZMyNewAlertViewDelgate,ZZTitleSegVDelegate,ZZLoadMoreFooterDelegate>
/** 广告位 */
@property(nonatomic,strong)ASScroll*  adASScroll;
/** 数据展示 */
@property(nonatomic,strong)UITableView*   attentionTableView;
/** 关注的板块数组 */
@property(nonatomic,strong)NSMutableArray*  attentionPlateArray;
/** 萌宝热度数组 */
@property(nonatomic,strong)NSArray*  recomPlateArray;
/** 广告数组 */
@property(nonatomic,strong)NSArray*  adImagesArray;
/** 最后一次选中的cell */
@property(nonatomic,strong)NSIndexPath*  lastIndexpath;//选中的cell
/** 网络加载标识 */
@property(nonatomic,strong)MBProgressHUD*  waitHud;
/** 选中了那个分区，广场、关注 */
@property (nonatomic)NSUInteger  selectedItem;
/** 达人展示 */
@property (nonatomic, strong)ZZTalentShowView *talentView;
/** tableView的footer */
@property (nonatomic, strong)ZZLoadMoreFooter *footer;
/** 关注板块数组是否请求过 */
@property (nonatomic, getter=isAttCanRefresh )BOOL attCanRefresh;
@end

@implementation ZZHomeViewController

static  NSString*  HotIdentifier = @"HotIdentifier";
static  NSString*  TalentIndetifier = @"TalentIndetifier";

#pragma mark   初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self  initNaviTitleView];
    [self  setupFooter];
    //注册app登陆成功通知
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(appBecomeAvtiveAgain) name:ZZAppDidBecomeActiveNotification object:nil];
    /** 注册关注板块改变通知 */
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(attentionPlateChange:) name:ZZAttentionPlateChangeNotification object:nil];
    [self.footer  beginRefreshing];
    NSDictionary*  dic =[ZZLibCacheTool  selectHomeNetDataWithLibName:@"home/findHomePage"];
        if (dic.count) {//有缓存
            [self  setArraysDataWithDic:dic];
        }else{
            
            [self.waitHud  hudShow];
       }
    [self.view addSubview:self.attentionTableView];
}
//navigation  中间titleview
-(void)initNaviTitleView{
    self.attCanRefresh = YES;//默认yes，可以进行网络请求
    ZZTitleSegV * segment = [[ZZTitleSegV  alloc]initWithItems:@[@"广场",@"关注"]];
    segment.frame = CGRectMake(0, 0, 130, 30);
    segment.delegate = self;
    self.navigationItem.titleView = segment;
}
//设置tableview的尾部视图
- (void)setupFooter
{
    ZZLoadMoreFooter *footer = [ZZLoadMoreFooter footer];
    footer.delegate = self;
    self.attentionTableView.tableFooterView = footer;
    self.footer = footer;
}
//给广告位设置图片
-(void)initShowInterface{
  self.adASScroll = [[ASScroll alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenWidth/2)];
     self.attentionTableView.tableHeaderView = self.adASScroll;
    NSMutableArray*  viewsArray = [NSMutableArray  arrayWithCapacity:self.adImagesArray.count];
  for ( int i = 0; i<self.adImagesArray.count; i++) {
        UIImageView*  imageView = [[UIImageView  alloc]init];
        imageView.userInteractionEnabled = YES;
    ZZPost*  postInfo= self.adImagesArray[i];
      ZZMengBaoPaiImageInfo* mbpImage = postInfo.postImagesArray[0];
       [imageView  sd_setImageWithURL:[NSURL  URLWithString:mbpImage.largeImagePath] placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"loading_image_1_90x90.jpg" ofType:nil]]  options:SDWebImageRetryFailed|SDWebImageLowPriority ];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adJump:)];
      imageView.tag = i;
        [imageView addGestureRecognizer:tapGesture];
        [viewsArray  addObject:imageView];
 }
    self.adASScroll.userInteractionEnabled = YES;
    [self.adASScroll  setArrOfImages:viewsArray];
}


-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
   
    if (self.lastIndexpath  ) {
        if (self.selectedItem == 1 &&  self.lastIndexpath.row < self.attentionPlateArray.count) {//关注
            [self.attentionTableView  reloadRowsAtIndexPaths:@[self.lastIndexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else if(self.selectedItem == 0){//广场
            [self.attentionTableView   reloadRowsAtIndexPaths:@[self.lastIndexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        self.lastIndexpath = nil;
    }
}
#pragma  mark  --------event response
//添加关注板块
- (void)addPlate{
   // __weak typeof(self) home = self;
    weakSelf(home);
    ZZAllAreaViewController* allView = [[ZZAllAreaViewController alloc]init];
    [home.navigationController pushViewController:allView animated:YES];
}

//广告位 图片响应事件
-(void)adJump:(UITapGestureRecognizer*)tap{

    ZZWonderDetailViewController*  wonderDvc = [[ZZWonderDetailViewController  alloc]init];
    ZZPost*  post = self.adImagesArray[tap.view.tag];
    wonderDvc.postIncoming = post;
    [self.navigationController  pushViewController:wonderDvc animated:YES];
}
#pragma mark -- privateMethods
- (void)headerRefresh{
    NSUInteger  lastId =0;
    if (self.attentionPlateArray.count) {
        ZZPlateTypeInfo *plate = [self.attentionPlateArray firstObject];
        lastId = plate.plateId;
    }else{
        [self  footerFresh];
        return;
    }
    [self  getAttentionPlateWithId:lastId upDown:1];
}
- (void)footerFresh{
    NSUInteger  lastId = 0;
    if (self.attentionPlateArray.count) {
        ZZPlateTypeInfo *plate = [self.attentionPlateArray  lastObject];
        lastId = plate.plateId;
    }
    [self  getAttentionPlateWithId:lastId upDown:2];
}
- (void)setArraysDataWithDic:(NSDictionary *)dic{
    __weak  typeof(self) home = self;
    home.talentView.talentArray = [dic  objectForKey:@"eredarList"];
    home.recomPlateArray = [dic  objectForKey:@"plateList"];
    home.adImagesArray = [dic  objectForKey:@"homeImgList"];
    [home  initShowInterface];
}
#pragma  mark  -ZZLoadMoreFooterDelegate
-(void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer{
   // [self   getAttentionPlateByNet];
    [self  footerFresh];
}
#pragma  mark  -ZZTitleSegVDelegate
-(void)titleSegVClicked:(ZZTitleSegV *)segment item:(NSUInteger)item{
    self.selectedItem = item;
   
    [self.attentionTableView reloadData];
    if (self.isAttCanRefresh&&item ) {
        self.footer.canRefresh = YES;
        [self.footer endRefreshing];
    }else{
        self.footer.canRefresh = NO;
    }
    if ( item &&self.attentionPlateArray.count == 0 && self.isAttCanRefresh) {
      //  [self getAttentionPlateByNet];
        [self  footerFresh];
    }
   
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.selectedItem) {//关注
        return 1;
    }
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.selectedItem) {//关注
        return self.attentionPlateArray.count;
    }else{
        if (section == 0) {//达人展示
            return 1;
        }else if(section == 1){//萌宝热度
            return 1;
        }else{
            return self.recomPlateArray.count;
        }
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //  关注
    if (self.selectedItem) {//关注
        ZZRecommendTableViewCell*    cell = [ZZRecommendTableViewCell  dequeueReusableCellWithTableView:tableView];
        cell.plateType  =  self.attentionPlateArray[indexPath.row];
        cell.heartIv.hidden = NO;
        return cell;
    }else{
        if (indexPath.section == 0) {//达人推荐
           UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:TalentIndetifier];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TalentIndetifier];
                cell.backgroundColor = [UIColor  clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView  addSubview:self.talentView];
            }
            return cell;
        }else if (indexPath.section == 1){//萌宝热度
           UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:HotIdentifier];
            if (cell ==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HotIdentifier];
                cell.contentView.backgroundColor = [UIColor  whiteColor];
                cell.backgroundColor = [UIColor  clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel*  tipLabel = [[UILabel  alloc]initWithFrame:CGRectMake(15, 8, 70, 20)];
                tipLabel.font = [UIFont boldSystemFontOfSize:14];
                tipLabel.text = @"萌宝热度";
                tipLabel.textAlignment= NSTextAlignmentLeft;
                tipLabel.textColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1];
                [cell.contentView  addSubview:tipLabel];
                
                UILabel* line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
                line1.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
                [cell.contentView addSubview:line1];
                
                return cell;
            }
            return cell;
        }else{//萌宝热度
             ZZRecommendTableViewCell*    cell = [ZZRecommendTableViewCell  dequeueReusableCellWithTableView:tableView];
            cell.plateType = self.recomPlateArray[indexPath.row];
            cell.heartIv.hidden = YES;
            return cell;
        }
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedItem) {//关注
        return 82;
    }else{
        if (indexPath.section == 0) {
            return 145;
        }else if(indexPath.section == 1){
            return 35;
        }else{
            return 82;
        }
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (self.selectedItem == 0&&indexPath.section == 2) {//萌宝热度下推荐
          self.lastIndexpath = indexPath;
        ZZPlateTypeInfo*   plateType = self.recomPlateArray[indexPath.row];
        if ([plateType.type  isEqualToString:@"MYBABY"]) {
            ZZBabyViewController*  babyVc =[[ZZBabyViewController  alloc]init];
            babyVc.babyPlate = plateType;
            [self.navigationController  pushViewController:babyVc animated:YES];
        }else{
            ZZUprightViewController* uprightView = [[ZZUprightViewController alloc]init];
            uprightView.plateType = self.recomPlateArray[indexPath.row];
            [self.navigationController pushViewController:uprightView animated:YES];
        }
    }
    if (self.selectedItem==1 && indexPath.section==0) {//关注
  self.lastIndexpath = indexPath;
        ZZPlateTypeInfo*   plateType = self.attentionPlateArray[indexPath.row];
        if ([plateType.type  isEqualToString:@"MYBABY"]) {
            ZZBabyViewController*  babyVc =[[ZZBabyViewController  alloc]init];
            babyVc.babyPlate = plateType;
            [self.navigationController  pushViewController:babyVc animated:YES];
        }else{
            ZZUprightViewController* uprightView = [[ZZUprightViewController alloc]init];
            uprightView.plateType = self.attentionPlateArray[indexPath.row];
            [self.navigationController pushViewController:uprightView animated:YES];
        }
    }
}
#pragma mark - tableView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.attentionPlateArray.count <= 0 || self.footer.isRefreshing ||  self.selectedItem == 0||scrollView.contentOffset.y<self.footer.height) return;
    
    // 1.差距
    CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
    // 刚好能完整看到footer的高度
    CGFloat sawFooterH = scrollView.height + self.footer.height;
    
    // 2.如果能看见整个footer
    if (delta <= (sawFooterH - 0)) {
        [self.footer  beginRefreshing];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ZZNetDely * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self footerFresh];
          });
    }
}

#pragma mark --UIAlertViewDelegate
/**版本更新确定按钮*/
-(void)myNewAlertView:(ZZMyNewAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self  jumpToAppStoreWithAppID:0];
    }
}

#pragma mark - net
//关注板块的数据
-(void)getAttentionPlateWithId:(NSUInteger)lastId upDown:(NSUInteger)upDown{
    __weak typeof(self) selfVc = self;
    [self.footer beginRefreshing];
    NSUInteger  thisItem = self.selectedItem;
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindHomePageAttentionLastId:lastId andUpDown:upDown CallBack:^(id obj) {
   
        [selfVc.footer  endRefreshing];
        if (thisItem == selfVc.selectedItem) {
            if (obj) {
                NSArray *array = obj;
                if (array.count) {
                    if (upDown == 1) {
                        NSIndexSet *indexSet = [NSIndexSet  indexSetWithIndexesInRange:NSMakeRange(0, array.count)];
                        [selfVc.attentionPlateArray  insertObjects:array atIndexes:indexSet];
                    }else{
                           [selfVc.attentionPlateArray  addObjectsFromArray:array];
                    }
                 
                    [selfVc.attentionTableView  reloadData];
                }else{
                    if (upDown == 2) {
                        selfVc.footer.canRefresh = NO;
                        selfVc.attCanRefresh = NO;
                        if (lastId == 0) {
                            MBProgressHUD *hud =   [MBProgressHUD  showMessage:@"定制关注" toView:selfVc.footer isDimback:NO];
                            [hud addTarget:selfVc action:@selector(addPlate)];
                        }
                    }
                  
                }
            }else{
                if (upDown == 2) {
                    [selfVc.footer  requestFailed];
                }
                
            }
        }
       
    }];

}
/**
 *  获取首页－广场 的网络数据
 */
-(void)getSquareDataByNet{
     __weak typeof(self) selfVc = self;
    [self.footer  beginRefreshing];
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindHomePageAndCallBack:^(id obj) {
        [self.waitHud hudHide];
        if (obj) {
            selfVc.footer.canRefresh = NO;
            [selfVc  setArraysDataWithDic:obj];
            [selfVc.attentionTableView  reloadData];
            /**
             *  判断引导动画出现只出现一次
             */
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSInteger isTouchNumber = [userDefaults integerForKey:@"isTouchNumber"];
                if (!isTouchNumber) {
                AppDelegate* appView =(AppDelegate*)[UIApplication sharedApplication].delegate;
                    [appView addLeadActionView:1];
                }else{
                    [selfVc   checkVersion];
                }
                
            });
        }
    }];
}

-(void)checkVersion{
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindVersionAndBack:^(id obj) {
        NSDictionary* dic = obj;
        if (dic && [dic isKindOfClass:[NSDictionary  class]]) {
            NSString  *version = [dic  objectForKey:@"version"];
            if ([[NSString  currentVersion]isOlderVersionThan:version]) {
                  NSString  *cause = [dic  objectForKey:@"cause"];
                ZZMyNewAlertView *alert = [[ZZMyNewAlertView  alloc]initWithMessage:cause delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"更新"];
                alert.textAlignment = NSTextAlignmentLeft;
                alert.title =  [NSString  stringWithFormat:@"萌宝派新版本（%@）上线了",version ];
                [alert  show];
            }
        }
  
    }];
}
#pragma Notification
//app又进入前台
-(void)appBecomeAvtiveAgain{
  [self  getSquareDataByNet];
  
}
- (void)attentionPlateChange:(NSNotification *)noti{
    NSDictionary *dic = noti.object;
    NSUInteger plateId = [dic[@"plateId"]integerValue];
    BOOL addOrDelete = [dic[@"addOrDele"] boolValue];
    if (addOrDelete) {
        [self.attentionPlateArray  removeAllObjects];
        if (self.selectedItem) {
             [self.attentionTableView  reloadData];
        }
       
        [self  footerFresh];
    }else{
        for (ZZPlateTypeInfo *plate in self.attentionPlateArray) {
            if (plate.plateId == plateId) {
                [self.attentionPlateArray  removeObject:plate];
                break;
            }
        }
        if (self.selectedItem) {
            [self.attentionTableView  reloadData];
        }
    }
}
-(void)dealloc{
    [self.waitHud hudHide];
    [[NSNotificationCenter  defaultCenter]removeObserver:self ];
    self.attentionTableView.delegate = nil;
 
}

#pragma mark  lazy load

-(MBProgressHUD *)waitHud{
    if (!_waitHud) {
        _waitHud = [[MBProgressHUD  alloc]initWithMengBaoPaiWindow];
        _waitHud.labelText = @"加载中...";
    }
    return _waitHud;
}


-(UITableView *)attentionTableView{
    if (!_attentionTableView) {
        _attentionTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, ZZNaviHeight, ScreenWidth,ScreenHeight-ZZNaviHeight-ZZTabBarHeight )];
        _attentionTableView.delegate = self;
        _attentionTableView.dataSource = self;
        _attentionTableView.tag = 202;
        _attentionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _attentionTableView.backgroundColor = [UIColor  colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    }
    return _attentionTableView;
}

-(ZZTalentShowView *)talentView{
    if (_talentView == nil) {
        _talentView = [[ZZTalentShowView  alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth, 135)];
        _talentView.backgroundColor = [UIColor  whiteColor];
    }
    return _talentView;
}

-(NSMutableArray *)attentionPlateArray{
    if (_attentionPlateArray == nil) {
        _attentionPlateArray = [NSMutableArray  array];
    }
    return _attentionPlateArray;
}
//-(void)setAttentionPlateArray:(NSArray *)attentionPlateArray{
//    _attentionPlateArray = attentionPlateArray;
//    __weak   typeof (self) home = self;
//    if (attentionPlateArray.count == 0) {
//        MBProgressHUD *hud =   [MBProgressHUD  showMessage:@"定制关注" toView:home.footer isDimback:NO];
//        [hud addTarget:home action:@selector(addPlate)];
//    }
//}
@end
