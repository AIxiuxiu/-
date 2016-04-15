//
//  ZZLeftViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-2.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZLeftViewController.h"
#import "ZZChildVCViewController.h"
#import "ZZNAViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "ZZNickChangeViewController.h"
//
#import "ZZImageSelect.h"
//
#import "ZZIntergralRuleViewController.h"
#import "ZZSettingViewController.h"
#import "ZZStoreUpDetailViewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZAttentionHeadViewController.h"
//
#import "ZZMyAttentionViewController.h"
//
#import "UIImageView+WebCache.h"
//
#import "MBProgressHUD.h"
//
#import "ZZSystemMessageVC.h"
//
#import "ZZPushMessageFmdb.h"
#import "ZZSIzeFitButton.h"

#import "ZZHeadImageView.h"
#import "ZZIconView.h"

#import "ZZStatusViewC.h"
#define ZZLineSeparColor  [UIColor  colorWithRed:0.3 green:0.3 blue:0.3 alpha:1]
#define ZZwhiteColor  [UIColor  colorWithRed:0.88 green:0.88 blue:0.88 alpha:1]
@interface ZZLeftViewController ()<UITableViewDataSource,UITableViewDelegate,DDMenuControllerDelegate,ZZImageSelectDelegate,MBProgressHUDDelegate>

//@property(nonatomic,strong)MBProgressHUD*  hud;

@property(nonatomic,strong)NSIndexPath* lastIndexPath;//记录上次点中的那行，以便下次再进来时刷新
@property(nonatomic,strong)UITableView*  personalTableView;

@property(nonatomic,strong)UIButton* notiButton;

@property(nonatomic,strong)ZZImageSelect*  imageSelect;
@end

@implementation ZZLeftViewController

#pragma mark  lazy load

-(ZZImageSelect *)imageSelect{
    if (_imageSelect == nil) {
        _imageSelect = [[ZZImageSelect  alloc]init];
        _imageSelect.delegate = self;
        _imageSelect.head = YES;
        _imageSelect.headEdit = YES;
    }
    return _imageSelect;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor   clearColor];
    self.navigationController.navigationBarHidden = YES;
   
    [self  initChildViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    [self  getNetData];
    [self  messageCountLabelTextChange];
}
- (void)initChildViews{
    //黑底
    UIView*  backView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.75,ScreenHeight)];
    backView.backgroundColor = [UIColor  colorWithRed:0 green:0 blue:0 alpha:0.85];
    [self.view  addSubview:backView];
    //个人信息
    UILabel* personalLabel = [[UILabel  alloc]initWithFrame:CGRectMake(25, 30, 80, 20)];
    personalLabel.text = @"个人信息";
    personalLabel.font = ZZTitleBoldFont;
    personalLabel.textColor = ZZGrayWhiteColor;
    [self.view  addSubview:personalLabel];
    
   

    //tableView
    CGFloat tableViewX = 10;
    CGFloat tableViewY = 64;
    CGFloat tableViewW = CGRectGetWidth(backView.frame)-tableViewX;
    CGFloat tableViewH = ScreenHeight - 84;
    self.personalTableView = [[UITableView  alloc]initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH)];
   self.personalTableView.backgroundColor = [UIColor  clearColor];
    self.personalTableView.dataSource =self;
    self.personalTableView.delegate = self;
   self.personalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view  addSubview:self.personalTableView];
    
    //底部 系统设置按钮
    UIView*  footView=  [[UIView  alloc]initWithFrame:CGRectMake(0, 0, tableViewW, 45)];
    footView.backgroundColor = [UIColor  clearColor];
    self.personalTableView.tableFooterView = footView;
    //底部分割条
    UIView *lineView = [[UIView  alloc]initWithFrame:CGRectMake(5, 0, tableViewW -10, 1)];
    lineView.backgroundColor = ZZLineSeparColor;
    [footView  addSubview:lineView];
    
    ZZSIzeFitButton *settingButton = [ZZSIzeFitButton  buttonWithType:UIButtonTypeCustom];
      settingButton.margin = 10;
    [settingButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]
                                                              pathForResource:@"setstate_40x40" ofType:@"png"]] forState:UIControlStateNormal];
     [settingButton setTitle:@"系统设置" forState:UIControlStateNormal];
    
    settingButton.sizeFitButtonType = ZZSIzeFitButtonTypeImageLeft;
  
    [settingButton   addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    settingButton.alpha = 0.6;
    settingButton.x += 10;
    settingButton.y = 10;
    [footView  addSubview:settingButton];
    
    // 协议  签订
    AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate ;
    DDMenuController*  menuController = (DDMenuController*)app.window.rootViewController;
    menuController.delegate = self;
    
    //注册通知  登陆成功后获取消息
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(appBecomeAvtiveAgain) name:ZZAppDidBecomeActiveNotification object:nil];
    /**
     *  2.0.4隐藏
     *
     *  @param messageCountLabelTextChange <#messageCountLabelTextChange description#>
     *
     *  @return <#return value description#>
     */
    //收到新的推送
    //公告button
    UIButton* anButton = [[UIButton alloc]initWithFrame:CGRectMake(backView.width -50, 20, 40, 40)];
    [anButton  addTarget:self action:@selector(anButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [anButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle  mainBundle] pathForResource:@"announcement_40x40" ofType:@"png"]] forState:UIControlStateNormal];
    anButton.alpha = 0.5;
    self.notiButton = anButton;
    [self.view addSubview:anButton];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(messageCountLabelTextChange) name:ZZReceiveMessageNotification object:nil];
}

#pragma mark  event response
//跳转到系统消息界面
-(void)anButtonAction{
    
    AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate ;
    
    DDMenuController*  menuController = (DDMenuController*)app.window.rootViewController;

    [menuController  showRootController:NO];
   
    ZZSystemMessageVC* systemMessageVc = [[ZZSystemMessageVC  alloc]init];
   [(UINavigationController*)menuController   pushViewController:systemMessageVc animated:YES];
}
//跳转到系统设置界面
-(void)buttonAction{
    
    AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate ;
    
    DDMenuController*  menuController = (DDMenuController*)app.window.rootViewController;
    ZZChildVCViewController*  vc = [[ZZSettingViewController  alloc]init];

    [menuController  showRootController:NO];
    [(UINavigationController*)menuController   pushViewController:vc animated:YES];
}
//头像点击响应事件
-(void)changeHeadImage{
    [self.imageSelect  imageSelectShow];
}
#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger  row = 0 ;
    
    switch (section) {
        case 0:
            row= 4;
            break;
        case 1:
            row = 2;
            break;
        case 2:
            row = 3;
            break;
        
    }
    return row;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString* cellIdentifier = @"cell";
    
    UITableViewCell* cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell ==nil) {
        cell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
     
   }
  
    NSString*  str =nil;
    NSString*  detailStr =nil;
    UIView *rightView ;
    ZZUser* user =[ZZUser  shareSingleUser];
    switch (indexPath.section) {
            //头像、昵称、状态
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    str = @"头像";
                    detailStr = nil;
                    //头像
                    ZZHeadImageView *headImageView = [[ZZHeadImageView  alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
                    headImageView.user = user;
                    //手势  点击换头像
                    UITapGestureRecognizer*  tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(changeHeadImage)];
                    [headImageView  addGestureRecognizer:tap];
                    rightView = headImageView;
                    break;
                }
                case 1:
                {
                    str = @"昵称";
                    detailStr = user.nick;
                    break;
            }
                case 2:
                    str = @"状态";
                    
                    switch (user.status) {
                        case 1:
                            detailStr = @"备孕中";
                            break;
                        case 2:
                            detailStr = @"怀孕中";
                            break;
                        case 3:
                            detailStr = @"已出生";
                            break;
                            default:
                             detailStr = @"未选择";
                            break;
                    }
                    break;
                    case 3:
                    str = @"身份";
                    detailStr = [user   getUserIdentify];
                    break;
            }
            break;
            //等级、金币
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    str = @"等级";
                    detailStr = nil;
            
                    ZZIconView *iconView = [[ZZIconView alloc]initWithFrame:CGRectMake(0, 0, 56, 28)];
                    iconView.user = user;
                    rightView = iconView;

                }
                      break;
                case 1:
                    str = @"金币";
                    detailStr = [NSString   stringWithFormat:@"%ld",user.gold];
                    break;
                    
            }
            
            break;
            //签名
        case 2:
            switch (indexPath.row) {
                case 0:
                    str = @"我的关注";
                    detailStr = [NSString  stringWithFormat:@"%ld",user.attentionCount];
                    break;
                case 1:
                    str = @"我的收藏";
                     detailStr = [NSString  stringWithFormat:@"%ld",user.storeCount];
                    break;
                case 2:
                    str = @"我的发布";
                     detailStr = [NSString  stringWithFormat:@"%ld",user.publishCount];
                    break;
            }
            break;
            //电话、地址
  
    }
    if (indexPath.section ==2) {
         cell.textLabel.text = str;
    }else{
         cell.textLabel.text = [NSString  stringWithFormat:@"     %@",str] ;
    }
   
    cell.textLabel.font = ZZTitleFont;
    cell.textLabel.textColor = contentColor;
    cell.backgroundColor = [UIColor  clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text =  detailStr;
    if ((indexPath.section == 1 && indexPath.row == 1)||(indexPath.section == 0 &&indexPath.row == 3&&user.isSuperStarUser)) {
        cell.detailTextLabel.textColor = ZZGoldYellowColor;
    }else{
        cell.detailTextLabel.textColor = ZZwhiteColor;
    }
    if (indexPath.section ==2) {
        cell.textLabel.textColor =  ZZGrayWhiteColor;
        cell.textLabel.font = ZZTitleBoldFont;
    }
    cell.accessoryView = rightView;
    cell.detailTextLabel.font = ZZTitleFont;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row==0) {
        return 80;
    }else{
        return 50;
    }

}
//头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView*  view = [[UIView  alloc]init];
    view.backgroundColor = [UIColor  clearColor];
    UILabel *  headerLabel = [[UILabel  alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth *0.75 -40, 1)];
    headerLabel.backgroundColor = ZZLineSeparColor;
    [view  addSubview:headerLabel];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![ZZUser  shareSingleUser]){
 
        return;
    }
    self.lastIndexPath = indexPath;
    AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate ;
    
    DDMenuController*  menuController = (DDMenuController*)app.window.rootViewController;
    ZZChildVCViewController*  vc = nil;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    break;
                case 1:
                    vc = [[ZZNickChangeViewController  alloc]init];
                    break;
                case 2:
                    vc = [[ZZStatusViewC  alloc]init];
                    break;
                case 3:
                {//跳转到个人界面
                    
                [menuController  showRootController:NO];
                    ZZAttentionHeadViewController* attentionView = [[ZZAttentionHeadViewController alloc]init];
    
                    attentionView.user = [ZZUser  shareSingleUser];
                    [(UINavigationController*)menuController pushViewController:attentionView animated:YES];
                    return;
                }
                    break;
              
            }
            break;
            case 1:
            switch (indexPath.row) {
                case 0:
                    vc = [[ZZIntergralRuleViewController  alloc]init];
                    break;
                    
                case 1:
                    vc = [[ZZIntergralRuleViewController  alloc]init];
                    vc.number = 1;
                    break;
   
            }
            break;
            
            case 2:
            switch (indexPath.row) {
                case 0:
                    vc = [[ZZMyAttentionViewController  alloc]init];
                    break;
                case 1:
                case 2:
                    vc= [[ZZStoreUpDetailViewController  alloc]init];
                    vc.number = indexPath.row+3;
                    break;
                default:
                    break;
            }
          
            break;
    }
   
    if (vc) {
         [menuController  showRootController:NO];
        [(UINavigationController*)menuController   pushViewController:vc animated:YES];
    }
   
}


#pragma mark - ZZImageSelectDelegate
-(void)imageSelect:(ZZImageSelect *)imageSelect images:(NSArray *)images{
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postUpdateUserinfoWithNick:nil andStatus:0 andImage:images[0]  andBack:^(id obj) {
        if (obj) {
            [self  sendUserHeadImageChangeNoti];
            [self.personalTableView  reloadRowsAtIndexPaths:@[[NSIndexPath  indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

#pragma mark - DDMenuControllerDelegate
-(void)menuController:(DDMenuController *)controller willShowViewController:(UIViewController *)controller1{
    if (self.lastIndexPath) {
        [self  getNetData];
        self.lastIndexPath = nil;
   
    }
}

#pragma mark - －－－－－－－网络请求
-(void)getNetData{
    __block UITableView*  tableView= self.personalTableView;
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postQueryUserInfoWithTokenAndBack:^(id obj) {
    
        if (obj) {
            [self  sendUserHeadImageChangeNoti];
        
            [tableView  reloadData];
        }else{
            //[self getNetData];
        }
      
    }];
}

#pragma mark Notification
-(void)messageCountLabelTextChange{
      UIView*  view = [self.notiButton  viewWithTag:999];
    NSUInteger count =[ZZPushMessageFmdb  selectDataWithFlag:1];
    if (count) {
        if (!view) {
            UILabel*  label = [[UILabel  alloc]initWithFrame:CGRectMake(25, 5, 10, 10)];
            label.backgroundColor = [UIColor  colorWithRed:0.8 green:0 blue:0 alpha:1];
            label.font = [UIFont  systemFontOfSize:8];
            label.textColor = [UIColor  whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 5;
            label.layer.masksToBounds = YES;
            label.tag = 999;
            label.text = [NSString  stringWithFormat:@"%d",count];
            [self.notiButton  addSubview:label];
        }else{
            UILabel*  label = (UILabel*)view;
            label.text = [NSString  stringWithFormat:@"%d",count];
        }
        
    }else{
        [view  removeFromSuperview];
    }
}
//头像改变发送通知
-(void)sendUserHeadImageChangeNoti{
    [[NSNotificationCenter defaultCenter]postNotificationName:ZZChangeUserHeadImageNotification object:nil];
}

//app又进入前台
-(void)appBecomeAvtiveAgain{
    [self  getNetData];
    
}

-(void)dealloc{
     [[NSNotificationCenter  defaultCenter]removeObserver:self ];
    
}

@end
