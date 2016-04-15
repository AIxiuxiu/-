//
//  ZZBabyViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZBabyViewController.h"
#import "ZZHeaderView.h"
#import "ZZBabyCell.h"
#import "ZZBabyCreatOrChangeController.h"
#import "ZZDiaryViewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZMyAlertView.h"
#import "ZZSameAgeViewController.h"
@interface ZZBabyViewController ()<UITableViewDataSource,UITableViewDelegate,ZZMyAlertViewDelgate,ZZBabyCellDelegate>
@property(nonatomic,strong)ZZHeaderView* topView;

@property(nonatomic,strong)NSMutableArray* babyArr;
//@property(nonatomic,strong)ZZPlateTypeInfo* plate;
//更新数据
@property(nonatomic,strong)NSIndexPath*  lastIndexpath;

@end

@implementation ZZBabyViewController
#pragma mark  lazy  load
-(ZZHeaderView *)topView{
    if (!_topView) {
        _topView = [[ZZHeaderView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.layer.borderWidth = 0.5;
        _topView.plateType = self.babyPlate;
        _topView.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]CGColor];
        _topView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[ZZHeaderView  getFrameSizeHeightWith:self.babyPlate.content]);
        [_topView.attentionButton  addTarget:self action:@selector(attentionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _topView;
}

-(UITableView *)babyTableView{
    if (!_babyTableView) {
        _babyTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 5,ScreenWidth, ScreenHeight)];
        _babyTableView.backgroundColor = [UIColor clearColor];
        _babyTableView.delegate = self;
        _babyTableView.dataSource = self;
        _babyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _babyTableView;
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
    [self  getNetData];
    self.title = self.babyPlate.title;

    self.view.backgroundColor = ZZViewBackColor;
    UIImage* img1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"arrow_button_40x40.png" ofType:nil]];
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setBackgroundImage:img1 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*  leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationController.title= self.title;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -16;//此处修改到边界的距离，请自行测试
        [self.navigationItem setLeftBarButtonItems:@[negativeSeperator,leftBarButtonItem]];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem: leftBarButtonItem animated:YES];
    }
    
//    self.plate = [[ZZPlateTypeInfo  alloc]initWithPlateId:0 andTitle:@"我的宝宝" andContent:@"这是一个神奇得版块" andType:nil andInterface:nil andPublishCount:0 andMbpImageInfo:nil andAreaType:nil];
//    self.topView.plateType = self.babyPlate;
//    self.topView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[ZZHeaderView  getFrameSizeHeightWith:self.babyPlate.content]);
  
    self.babyTableView.tableHeaderView = self.topView;
    [self.view  addSubview:self.babyTableView];
//    self.topView.attentionButton.hidden = YES;
//    self.topView.endLabel.text = @"已有";
//    self.topView.headImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"j_1.jpg" ofType:nil]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    if (self.lastIndexpath) {
        [self.babyTableView  reloadRowsAtIndexPaths:@[self.lastIndexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
     self.lastIndexpath = nil;
}

#pragma mark   event response
-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//关注按钮 点击响应事件
-(void)attentionButtonAction{
  
    if (self.babyPlate.attention) {
        ZZMyAlertView*  myAlert = [[ZZMyAlertView  alloc]initWithMessage:@"你确定要取消关注这个板块嘛" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
        myAlert.tag = 223;
        [myAlert  show];
    }else{
        [self   updateAttentionPlateType];
    }
    
}



#pragma netRequest
//更新板块关注的网络请求
-(void)updateAttentionPlateType{
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postUpdateAttentionUserOrPlateWithCode:@"plate" andPlatedId:self.babyPlate.plateId andUserId:0 andAddOrDelete:!self.babyPlate.attention andCallback:^(id obj) {
        if(obj){
            self.babyPlate.attention =!self.babyPlate.attention;
            [self  changePlateAttentionState];
        }
    }];
}

#pragma mark private methods
-(void)changePlateAttentionState{
    if (self.babyPlate.attention) {
        //绿色按钮
        self.topView.attentionButton.backgroundColor = [UIColor  colorWithRed:0.57 green:0.85 blue:0.37 alpha:1];
        [self.topView.attentionButton setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        //蓝色按钮
        self.topView.attentionButton.backgroundColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1];
        [self.topView.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    }
}

-(void)creatNewBaby:(NSInteger)type{
    ZZBabyCreatOrChangeController*  creatBaby = [[ZZBabyCreatOrChangeController  alloc]init];
    if (type == -1) {
        creatBaby.title = @"创建宝宝";
        [self.navigationController  pushViewController:creatBaby animated:YES];
    }else{
        creatBaby.title = @"修改信息";
        creatBaby.babyInfo = self.babyArr[type];
        [self.navigationController  pushViewController:creatBaby animated:YES];
    }
    
}

-(void)babyInfoJumpToNewControllerWithType:(NSInteger)type  andRow:(NSIndexPath*)indexPath{
    
 
}
//
-(void)publishSuccessRefreshWith:(NSDictionary*)dic{
    [self.babyArr  removeAllObjects];
    NSArray*  array =[dic objectForKey:@"list"];
    for (ZZBaby*  baby in array) {
        [self.babyArr  addObject:baby];
    }
    self.babyPlate.publishCount = [[dic objectForKey:@"babyCount"]integerValue];
    self.topView.number.text = [NSString stringWithFormat:@"%ld",self.babyPlate.publishCount];
    [self.babyTableView  reloadSections:[NSIndexSet  indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark -ZZBabyCellDelegate
-(void)babyCellSectionClicked:(ZZBabyCell *)babyCell type:(NSUInteger)type{
    
    NSIndexPath *indexPath = [self.babyTableView  indexPathForCell:babyCell];
    switch (type) {
        case 111:
        {
            [self  creatNewBaby:indexPath.row];
        }
            break;
        case 112:
        {
            self.lastIndexpath = indexPath;
            ZZDiaryViewController*  diaryVC = [[ZZDiaryViewController alloc]init];
            diaryVC.babyInfo = self.babyArr[indexPath.row];
            [self.navigationController  pushViewController:diaryVC animated:YES];
        }
            break;
        case 113:
        {
            ZZSameAgeViewController*  partnerVC =[[ ZZSameAgeViewController  alloc]init];
            [self.navigationController  pushViewController:partnerVC animated:YES];
        }
            break;
            
    }
}

-(void)babyCellDeleteButtonClicked:(ZZBabyCell *)babyCell{
      NSIndexPath *indexPath = [self.babyTableView  indexPathForCell:babyCell];
    ZZBaby*  baby = self.babyArr[indexPath.row];
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postDeleteBabyWithBabyId:baby.babyId andBack:^(id obj) {
        if (obj) {
            [self.babyArr   removeObjectAtIndex:indexPath.row];
            
            if (self.babyArr.count) {
                [self.babyTableView  deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                [self.babyTableView  reloadData];
            }
            
            self.babyPlate.publishCount -=1;
            self.topView.number.text = [NSString stringWithFormat:@"%ld",self.babyPlate.publishCount];
        }
      
    }];
}
#pragma  mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section) {
        return 1;
    }else{
        return self.babyArr.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        static  NSString*  cellIden = @"footCell";
        UITableViewCell* cell = [tableView  dequeueReusableCellWithIdentifier:cellIden];
        if (cell == nil) {
            cell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIden];
            cell.backgroundColor = [UIColor  clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //加号
            UILabel* addLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(11, 2.5, 30, 30)];
            addLabel1.text = @"+";
            addLabel1.font = [UIFont  boldSystemFontOfSize:30];
            addLabel1.textAlignment = NSTextAlignmentCenter;
            addLabel1.textColor = ZZLightGrayColor;

            UILabel* creatLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 6, ScreenWidth-210, 30)];
            creatLabel.textAlignment = NSTextAlignmentCenter;
            creatLabel.text = @"创建新宝宝";
            creatLabel.font = ZZTitleBoldFont;
            creatLabel.textColor = ZZLightGrayColor;

            //创建新宝宝信息
            UIView*  creatButton = [[UIView  alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 40)];
            creatButton.backgroundColor = [UIColor  whiteColor];
            creatButton.layer.cornerRadius = 20;
            creatButton.layer.masksToBounds = YES;
            creatButton.layer.borderWidth = 0.5;
            creatButton.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]CGColor];
            [creatButton addSubview:addLabel1];
            [creatButton addSubview:creatLabel];
            [cell.contentView addSubview:creatButton];
        }
        return cell;
    }
 
    ZZBabyCell*  cell = [ZZBabyCell dequeueReusableCellWithTableView:tableView];
    cell.delegate = self;
    cell.babyInfo = self.babyArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        return 60;
    }
    return 205;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  == 1) {
        [self  creatNewBaby:-1];
    }
}

#pragma mark   ZZMyAlertViewDelgate
-(void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //223为取消关注   113为删除宝宝

    if (buttonIndex) {
        [self  updateAttentionPlateType];
    }
}
//
#pragma mark  netRequest
-(void)getNetData{
    [[ZZMengBaoPaiRequest   shareMengBaoPaiRequest]postFindBabyPlateInfoAndBack:^(id obj) {
        if (obj) {
            NSArray*  array =[obj objectForKey:@"list"];
         
            for (ZZBaby*  baby  in array) {
                [self.babyArr  addObject:baby];
            }
            self.babyPlate.publishCount = [[obj objectForKey:@"babyCount"]integerValue];
            BOOL  attention = [[obj  objectForKey:@"attention"]boolValue];
            if (self.babyPlate.attention!=attention) {
                self.babyPlate.attention =attention;
                [self  changePlateAttentionState];
            }
            self.topView.number.text = [NSString stringWithFormat:@"%ld",self.babyPlate.publishCount];
            [self.babyTableView  reloadSections:[NSIndexSet  indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
       
    }];
}


@end
