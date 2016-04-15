//
//  ZZExpertViewController.m
//  萌宝派
//
//  Created by charles on 15/4/2.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZExpertViewController.h"
#import "ZZExpertTableViewCell.h"
#import "ZZExpertDetailViewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZExpert.h"
#import "UIImageView+WebCache.h"
#import "ZZAttentionHeadViewController.h"
#import "ZZApplyForExpertViewController.h"
#import "ZZLastCell.h"
#import "ZZTitleSegV.h"
#import "ZZLoadMoreFooter.h"
@interface ZZExpertViewController ()<UITableViewDataSource,UITableViewDelegate,ZZTitleSegVDelegate>

@property(nonatomic,strong)UITableView* leftTableView;
@property(nonatomic,strong)UITableView* rightTableView;
@property (nonatomic, strong)NSMutableArray *superTypes;
@property (nonatomic, strong)NSMutableArray *expertTypes;


@property(nonatomic,strong)NSMutableArray* nameArr;//左边按钮名字
@property(nonatomic,strong)UIButton* writeButton;//达人申请
/**
 *  协议背景试图
 */
@property(nonatomic,strong)UIView* clearView;//协议背景
//
@property(nonatomic,strong)NSIndexPath*  lastSelectIndexpath;//进入子界面时选中的cell
//当前选中了那个seg
@property (nonatomic, assign)NSUInteger selectedItem;
@property (nonatomic, strong)NSMutableDictionary *superDics;
@property (nonatomic, strong)NSMutableDictionary *experDics;
@property (nonatomic)NSUInteger  selectedRow;
@property (nonatomic, strong)ZZLoadMoreFooter *footer;

@property(nonatomic,strong)NSIndexPath*  recentSelectIndexpath;//最近一次选中的左边的cell；
@end

@implementation ZZExpertViewController


#pragma mark  life  cycle
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    if (self.lastSelectIndexpath) {
        [self.rightTableView  reloadRowsAtIndexPaths:@[self.lastSelectIndexpath] withRowAnimation:UITableViewRowAnimationAutomatic ];
        self.lastSelectIndexpath=nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //segmentControll

    [self  setUpTitleSegment];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    [self  setupFooter];
    //关注用户改变
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(attentUserChange:) name:ZZConnectPersonChangeNotification object:nil];
    //达人类型
    [self getTypes];
}
- (void)setUpTitleSegment{
    ZZTitleSegV * segment = [[ZZTitleSegV  alloc]initWithItems:@[@"达人",@"专家"]];
    segment.frame = CGRectMake(0, 0, 130, 30);
    segment.delegate = self;
    self.navigationItem.titleView = segment;
}

- (void)setUpApplyButton{
    //申请达人
    self.writeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    
    [self.writeButton setTitle:@"申请达人" forState:UIControlStateNormal];
    [self.writeButton addTarget:self action:@selector(writeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.writeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    UIBarButtonItem*  writeButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.writeButton];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -10;
    [self.navigationItem setRightBarButtonItems:@[negativeSeperator,writeButtonItem]];
    if ([ZZUser shareSingleUser].isSuperStarUser||[ZZUser  shareSingleUser].permissions!=3) {
        self.writeButton.hidden = YES;
    }
}
//设置tableview的尾部视图
- (void)setupFooter
{
    ZZLoadMoreFooter *footer = [ZZLoadMoreFooter footer];
    footer.backgroundColor = [UIColor  clearColor];
    self.rightTableView.tableFooterView = footer;
    self.footer = footer;
}
#pragma mark  private  methods
- (void)footerRereshing{
    NSUInteger lastId = 0;

    NSMutableArray *array = [self  getTypeDataMarray:self.selectedItem row:self.selectedRow];
    if (array.count) {
        ZZUser *user = [array lastObject];
        lastId = user.userId;
    }
    
    if (self.selectedItem == 0) {
        [self getSuperTypeDatasWithLastId:lastId upDown:2];
    }else{
        [self  getExpertTypeDatasWithLastId:lastId upDown:2];
    }
    
}
- (NSMutableArray *)getCurrentTypes:(NSUInteger)item{
    if (item == 0) {
        return self.superTypes;
    }else{
        return self.expertTypes;
    }
}

- (NSMutableArray *)getTypeDataMarray:(NSUInteger)item row:(NSUInteger)row{
    if (item == 0) {
          ZZPlateTypeInfo *plate = [self  getCurrentTypes:item][row];
        NSMutableArray *marray = [self.superDics  objectForKey:plate.title];
        if (marray == nil) {
            marray = [NSMutableArray  array];
            [self.superDics setObject:marray forKey:plate.title];
        }
        return marray;
    }else{
        ZZPlateTypeInfo *plate = [self  getCurrentTypes:item][row];
        NSMutableArray *marray = [self.experDics  objectForKey:plate.title];
        if (marray == nil) {
            marray = [NSMutableArray  array];
             [self.experDics setObject:marray forKey:plate.title];
        }
        return marray;
    }
}
#pragma mark -ZZTitleSegVDelegate
-(void)titleSegVClicked:(ZZTitleSegV *)segment item:(NSUInteger)item{
    self.selectedItem = item;
    self.footer.canRefresh = YES;
    [self.footer  endRefreshing];
    [self   netLoadLogoEndWithView:self.leftTableView];
    if (self.selectedRow == 1) {
        self.selectedRow = 0;
    }else{
        self.selectedRow = 1;
    }
    [self.leftTableView  reloadData];
    [self.rightTableView  reloadData];
    if ([self  getCurrentTypes:item].count<3) {
        [self  getTypes];
    }else{
        
      
        NSIndexPath *indexPath = [NSIndexPath  indexPathForRow:1 inSection:0];
        [self.leftTableView  selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.leftTableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark    UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.leftTableView]) {
        return [self  getCurrentTypes:self.selectedItem].count;
    }else{
        return [self  getTypeDataMarray:self.selectedItem row:self.selectedRow].count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* celler = @"cell";
    static NSString* celler1 = @"cell1";
    if ([tableView isEqual:self.leftTableView]) {
        UITableViewCell* cell1 = [tableView dequeueReusableCellWithIdentifier:celler1];
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celler1];
           cell1.backgroundColor = [UIColor  clearColor];
            cell1.contentView.backgroundColor = [UIColor  clearColor];
            UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 30)];
            nameLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:1];
            nameLabel.font = [UIFont systemFontOfSize:15];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.adjustsFontSizeToFitWidth = YES;
            [cell1.contentView addSubview:nameLabel];
            nameLabel.tag = 222;
        }
        UILabel* nameLabel = (UILabel*)[cell1.contentView viewWithTag:222];
        ZZPlateTypeInfo *plate = [self getCurrentTypes:self.selectedItem][indexPath.row];
        nameLabel.text = plate.title;
        return cell1;
    }else{
   
            ZZExpertTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:celler];
            if (cell == nil) {
                cell = [[ZZExpertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celler];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.attentionButton.layer.borderWidth = 1;
                cell.attentionButton.layer.borderColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1].CGColor;
            }
        
            ZZUser* userStar = [self  getTypeDataMarray:self.selectedItem row:self.selectedRow][indexPath.row];
            [cell.superStarHeadImageView  sd_setImageWithURL:[NSURL URLWithString:userStar.mbpImageinfo.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"head_portrait_55x55.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
            cell.superStarNameLabel.text = userStar.nick;
       
        
            if (userStar.isCurrentUser) {
                [cell.attentionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                cell.attentionButton.layer.borderColor = [UIColor  lightGrayColor].CGColor;
                [cell.attentionButton setTitle:@"+ 关注" forState:UIControlStateNormal];
                [cell.attentionButton setBackgroundColor:[UIColor clearColor]];
                cell.attentionButton.userInteractionEnabled = NO;
            }else{
                  cell.attentionButton.userInteractionEnabled = YES;
                if (userStar.attention) {
                    [cell.attentionButton setBackgroundColor:[UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1]];
                    [cell.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
                    [cell.attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else{
                    [cell.attentionButton setTitle:@"+ 关注" forState:UIControlStateNormal];
                    [cell.attentionButton setTitleColor:[UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1] forState:UIControlStateNormal];
                    [cell.attentionButton setBackgroundColor:[UIColor clearColor]];
                }
                [cell.attentionButton addTarget:self action:@selector(attentionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.attentionButton.tag = indexPath.row;
            }
            
            return cell;

    }
}

/**
 *  点击跳转
 */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.leftTableView]) {
        if (self.selectedRow == indexPath.row ) {
            return;
        }
        self.selectedRow = indexPath.row;
        self.footer.canRefresh = YES;
        [self.footer  endRefreshing];
        [self.rightTableView  reloadData];
        if ([self.rightTableView  numberOfRowsInSection:0] == 0) {
             [self  footerRereshing];
        }

    }else{
    
        self.lastSelectIndexpath = indexPath;
        if (self.selectedItem == 0) {
            ZZAttentionHeadViewController* attentionView = [[ZZAttentionHeadViewController alloc]init];
            NSArray *array = [self  getTypeDataMarray:self.selectedItem row:self.selectedRow];
            ZZUser* user =array[indexPath.row];
            user.isSuperStarUser = 1;
           attentionView.user = user;
            [self.navigationController pushViewController:attentionView animated:YES];
        }else{
            ZZExpertDetailViewController* expertDetail = [[ZZExpertDetailViewController alloc]init];
              NSArray *array = [self  getTypeDataMarray:self.selectedItem row:self.selectedRow];
            expertDetail.expertUser = array[indexPath.row];
            [self.navigationController pushViewController:expertDetail animated:YES];
        }
        
    }
    
}
#pragma mark - tableView代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView  isEqual:self.leftTableView] || self.footer.isRefreshing || self.footer.canRefresh == NO||scrollView.contentOffset.y<self.footer.height) return;
    
    // 1.差距
    CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
    // 刚好能完整看到footer的高度
    CGFloat sawFooterH = scrollView.height + self.footer.height;
    
    // 2.如果能看见整个footer
    if (delta <= (sawFooterH )) {
        [self.footer  beginRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self footerRereshing];
        });
        
    }
}
#pragma mark - NSNotification

- (void)attentUserChange:(NSNotification *)noti{
   
     NSMutableArray *superArray = [self  getTypeDataMarray:0 row:0];
    [superArray  removeAllObjects];
    
    NSMutableArray *expertArray = [self  getTypeDataMarray:1 row:0];
    [expertArray  removeAllObjects];
    
    if (self.selectedRow == 0) {
        [self.rightTableView  reloadData];
    }
}
#pragma mark  netRequest
/**
 *  达人和专家的类型请求
 */
-(void)getTypes{
    NSUInteger type = self.selectedItem;
    NSUInteger count = [self  getCurrentTypes:type].count;
    [self  netLoadLogoStartWithView:self.leftTableView];
    [[ZZMengBaoPaiRequest shareMengBaoPaiRequest]postFindSuperStarTypeByType:type+1 andBack:^(id obj) {
        
        if (type == self.selectedItem) {
            [self  netLoadLogoEndWithView:self.leftTableView];
        }
        if (obj&&[self  getCurrentTypes:type].count == count) {
            if (type == 0 ) {
                [self.superTypes  addObjectsFromArray:obj];
                [self  setUpApplyButton];
            }else {
                [self.expertTypes  addObjectsFromArray:obj];
            }
            if (self.selectedItem == type) {
                [self.leftTableView  reloadData];
                self.selectedRow = 0;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                 [self.leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition: UITableViewScrollPositionNone];
                [self  tableView:self.leftTableView didSelectRowAtIndexPath:indexPath];
            }
        }
  
    }];
}


- (void)getSuperTypeDatasWithLastId:(NSUInteger)lastId upDown:(NSUInteger)upDown{
    NSUInteger row = self.selectedRow;
    NSUInteger type = self.selectedItem;
    if (row<2) {
        [self.footer  beginRefreshing];
        [[ZZMengBaoPaiRequest shareMengBaoPaiRequest]postFindEreDarAttentionByRecommend:row andUserId:lastId andUpDown:upDown andBack:^(id obj) {
            
            if (type == self.selectedItem && row == self.selectedRow) {
                [self.footer  endRefreshing];
                if (obj) {
                    NSArray *array = obj;
                    if (array.count) {
                        NSMutableArray *array = [self  getTypeDataMarray:type row:row];
                        [array  addObjectsFromArray:obj];
                        [self.rightTableView  reloadData];
                    }else{
                        self.footer.canRefresh = NO;
                    }
                  
                }
               
            }
        }];
        }else{
            ZZPlateTypeInfo * plate = [self  getCurrentTypes:type][row];
            [[ZZMengBaoPaiRequest shareMengBaoPaiRequest] postFindSuperStarByType:[plate.type  integerValue]  anduserId:lastId andUpDown:upDown andBack:^(id obj) {
                if (type == self.selectedItem && row == self.selectedRow) {
                    [self.footer  endRefreshing];
                    if (obj) {
                        NSArray *array = obj;
                        if (array.count) {
                            NSMutableArray *array = [self  getTypeDataMarray:type row:row];
                            [array  addObjectsFromArray:obj];
                            [self.rightTableView  reloadData];
                        }else{
                            self.footer.canRefresh = NO;
                        }
                        
                    }
                    
                }
            }];
        }
   
}
- (void)getExpertTypeDatasWithLastId:(NSUInteger)lastId upDown:(NSUInteger)upDown{
    NSUInteger row = self.selectedRow;
    NSUInteger type = self.selectedItem;
    if (row<2) {
        [self.footer  beginRefreshing];
        [[ZZMengBaoPaiRequest shareMengBaoPaiRequest] postFindRecommendExpertByUserId:lastId andRecommend:row andUpDown:upDown andCity:0 andBack:^(id obj){
            
            if (type == self.selectedItem && row == self.selectedRow) {
                [self.footer  endRefreshing];
                if (obj) {
                    NSArray *array = obj;
                    if (array.count) {
                        NSMutableArray *array = [self  getTypeDataMarray:type row:row];
                        [array  addObjectsFromArray:obj];
                        [self.rightTableView  reloadData];
                    }else{
                        self.footer.canRefresh = NO;
                    }
                    
                }
                
            }
        }];
    }else{
        [self.footer  beginRefreshing];
        ZZPlateTypeInfo * plate = [self  getCurrentTypes:type][row];
        [[ZZMengBaoPaiRequest shareMengBaoPaiRequest] postFindExpertByUserId:lastId andUpDown:upDown andType:[plate.type integerValue] andCity:[plate.type integerValue] andBack:^(id obj){
            if (type == self.selectedItem && row == self.selectedRow) {
                [self.footer  endRefreshing];
                if (obj) {
                    NSArray *array = obj;
                    if (array.count) {
                        NSMutableArray *array = [self  getTypeDataMarray:type row:row];
                        [array  addObjectsFromArray:obj];
                        [self.rightTableView  reloadData];
                    }else{
                        self.footer.canRefresh = NO;
                    }
                    
                }
                
            }
        }];
    }


}
#pragma mark  event response

/**
 *  达人协议
 */
-(void)writeButtonAction{
    self.clearView = [[UIView  alloc]initWithFrame:self.view.frame];
    self.clearView.tag = 225;
    
    self.clearView.backgroundColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.8];
    
    //self.clearView.alpha = .5;
    
    UITapGestureRecognizer*  tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(registrationViewResignFistResponder)];
    
    [self.clearView   addGestureRecognizer:tap];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.clearView];
    
    
    UIView* starView = [[UIView alloc]initWithFrame:CGRectMake(30, (ScreenHeight) -400, ScreenWidth-60, 245)];
    starView.center = self.view.center;
    starView.backgroundColor = [UIColor whiteColor];
    starView.layer.cornerRadius = 5;
    starView.layer.masksToBounds = YES;
    [self.clearView addSubview:starView];
    
    
    UILabel* welcome = [[UILabel alloc]initWithFrame:CGRectMake((starView.width-200)/2, 15, 200, 20)];
    welcome.text = @"达人使用及服务协议";
    welcome.textColor = [UIColor  colorWithRed:0.0 green:153.0/255.0 blue:1.0 alpha:1.0];
    welcome.textAlignment=NSTextAlignmentCenter;
    welcome.font = [UIFont systemFontOfSize:18];
    [starView addSubview:welcome];
    
    NSError* readError ;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"达人协议.txt" ofType:nil];
    NSString*  content = [NSString   stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&readError];
    //协议内容
    UITextView* agreementView=[[UITextView alloc]initWithFrame:CGRectMake(15, 50, (starView.width-30), 140)];
    agreementView.backgroundColor=[UIColor whiteColor];
    agreementView.showsVerticalScrollIndicator=NO;
    agreementView.layer.cornerRadius = 2;
    agreementView.layer.borderWidth = 0.5;
    agreementView.layer.borderColor = [UIColor  lightGrayColor].CGColor;
    agreementView.layer.masksToBounds = YES;
    agreementView.showsHorizontalScrollIndicator=NO;
    agreementView.bounces=NO;
    agreementView.textColor=[UIColor  colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4];
    agreementView.text = content;
    agreementView.textColor = contentColor;
     agreementView.textContainerInset = UIEdgeInsetsMake(7.5, 3, 7.5, 0);
    agreementView.editable = NO;
    agreementView.font = [UIFont  systemFontOfSize:14];
    [starView addSubview:agreementView];
    
    

    
    UIButton* agreementButton = [[UIButton alloc]initWithFrame:CGRectMake((starView.width-120)/2 , 203, 120, 30)];
    agreementButton.layer.cornerRadius = 5;
    agreementButton.layer.masksToBounds = YES;
    
    agreementButton.titleLabel.font =  [UIFont  boldSystemFontOfSize:20];
    [agreementButton  setBackgroundColor:[UIColor  colorWithRed:0.45 green:0.8 blue:0.21 alpha:0.92]];
    [agreementButton setTitle:@"同\t\t意" forState:UIControlStateNormal];
    [agreementButton addTarget:self action:@selector(agreementAction) forControlEvents:UIControlEventTouchUpInside];
    [starView addSubview:agreementButton];
    

}
/**
 *  达人协议
 */
-(void)agreementAction{
    [self.clearView removeFromSuperview];
        ZZApplyForExpertViewController* applyForExpert = [[ZZApplyForExpertViewController alloc]init];
    NSMutableArray *marray = [self.superTypes  mutableCopy];
    [marray  removeObjectsAtIndexes:[NSIndexSet  indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
    applyForExpert.superTypes = marray;
        [self.navigationController pushViewController:applyForExpert animated:YES];
}

/**
 *  注册界面背景 手势点击事件

 */
-(void)registrationViewResignFistResponder{
    [self.clearView removeFromSuperview];
}

/**
 *  添加关注或者删除关注

 */
-(void)attentionButtonAction:(UIButton*)btn{

    NSArray *array = [self getTypeDataMarray:self.selectedItem row:self.selectedRow];
    ZZUser* userInfo = array[btn.tag];
    
    if (userInfo.attention) {
        
        [[ZZMengBaoPaiRequest shareMengBaoPaiRequest] postUpdateAttentionUserOrPlateWithCode:@"user" andPlatedId:0 andUserId:userInfo.userId andAddOrDelete:NO andCallback:^(id obj) {
            if (obj) {
                [btn setTitle:@"+ 关注" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1] forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor clearColor]];
                  userInfo.attention = !userInfo.attention;
            }
            
        }];
      
    }else{
        [[ZZMengBaoPaiRequest shareMengBaoPaiRequest] postUpdateAttentionUserOrPlateWithCode:@"user" andPlatedId:0 andUserId:userInfo.userId andAddOrDelete:YES andCallback:^(id obj) {
            if (obj) {
                [btn setBackgroundColor:[UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1]];
                [btn setTitle:@"已关注" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                userInfo.attention = !userInfo.attention;
            }
        }];
        
    }
    
}
-(void)dealloc{

    if(_rightTableView){
        _rightTableView.delegate = nil;
    }
    
   [[NSNotificationCenter  defaultCenter]removeObserver:self];

}

#pragma mark setter andGetter

-(UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,59, ScreenHeight-49-64) style:UITableViewStylePlain];
          _leftTableView.rowHeight = 40;
        _leftTableView.backgroundColor = [UIColor clearColor];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.tag = 101;
        _leftTableView.scrollsToTop = NO;

    }
    return _leftTableView;
}
-(UITableView *)rightTableView{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(59, 64,ScreenWidth- 59, ScreenHeight-49-64) style:UITableViewStylePlain];
        _rightTableView.rowHeight =  50;
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.tag = 201;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.scrollsToTop = YES;
        //空出下方空白   tabbar
 
    }
    return _rightTableView;
}

-(NSMutableArray *)superTypes{
    if (_superTypes == nil) {
        _superTypes = [NSMutableArray   array];
        
        ZZPlateTypeInfo  *plate = [[ZZPlateTypeInfo  alloc]init];
        plate.title = @"已关注";
        plate.type = @"";
         [_superTypes  addObject:plate];
        
        ZZPlateTypeInfo  *plate1 = [[ZZPlateTypeInfo  alloc]init];
        plate1.title = @"推荐";
        plate1.type = @"";
         [_superTypes  addObject:plate1];
       
    }
    return _superTypes;
}

-(NSMutableArray *)expertTypes{
    if (_expertTypes == nil) {
        _expertTypes = [NSMutableArray   array];
        
        ZZPlateTypeInfo  *plate = [[ZZPlateTypeInfo  alloc]init];
        plate.title = @"已关注";
        plate.type = @"";
        [_expertTypes  addObject:plate];
        
        ZZPlateTypeInfo  *plate1 = [[ZZPlateTypeInfo  alloc]init];
        plate1.title = @"推荐";
        plate1.type = @"";
        [_expertTypes  addObject:plate1];
    }
    return _expertTypes;
}

-(NSMutableDictionary *)superDics{
    if (_superDics == nil) {
        _superDics = [NSMutableDictionary  dictionary];
    }
    return _superDics;
}
-(NSMutableDictionary *)experDics{
    if (_experDics == nil) {
        _experDics = [NSMutableDictionary  dictionary];
    }
    return _experDics;
}
@end
