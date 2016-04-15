//
//  ZZSettingViewController.m
//  BaoBao康_登入界面
//
//  Created by sky on 14-9-19.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZSettingViewController.h"
#import "UIImageView+WebCache.h"
#import <StoreKit/StoreKit.h>
#import "ZZHudView.h"
#import "ZZMyAlertView.h"
#import "ZZMengBaoPaiRequest.h"
#import "AppDelegate.h"

#import "ZZLoginSatus.h"
//#import "ZZShareSdkShare.h"
#import "ZZRongChat.h"
#import "ZZUMSdk.h"
#import "ZZAPPPublishRuleVC.h"
@interface ZZSettingViewController ()<ZZMyAlertViewDelgate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UILabel*cacheLabel;

@property(nonatomic,strong)UITableView*  listTableView;
@end

@implementation ZZSettingViewController
#pragma mark lazy load
-(UILabel *)cacheLabel{
    if (!_cacheLabel) {
        _cacheLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0,100, 20)];
        _cacheLabel.textAlignment = NSTextAlignmentRight;
        float tmpSize = [[SDImageCache sharedImageCache] getSize];
        NSString *clearCacheName = tmpSize >= 1024 ? [NSString stringWithFormat:@"(%.2fM)",tmpSize/1024/1024] : [NSString stringWithFormat:@"(%.2fK)",tmpSize/1024];
        _cacheLabel.text=clearCacheName;
        _cacheLabel.textColor = ZZGreenColor;
        
    }
    return _cacheLabel;
}

-(UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, ZZNaviHeight, ScreenWidth, ScreenHeight-ZZNaviHeight) style:UITableViewStyleGrouped];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.rowHeight = 44;
        _listTableView.estimatedSectionHeaderHeight = 20;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.sectionHeaderHeight = 10;
        _listTableView.sectionFooterHeight = 5;
        
    }
    return _listTableView;
}

#pragma mark  life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"系统设置";
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    [self.view  addSubview:self.listTableView];

//    [self initUP];
//   
//    [self initDown];
}
#pragma mark  UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger  row=0;
    switch (section) {
        case 0:
            row = 1;
            break;
       case 1:
            row = 3;
            break;
        case 2:
            row = 3;
            break;
        case 3:
            row = 1;
            break;
      
    }
    return row;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static  NSString*  cellIdentifier = @"settingCell";
    UITableViewCell*  cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        UILabel*  lineLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        lineLabel.tag = 999;
        lineLabel.backgroundColor = ZZViewBackColor;
        [cell.contentView  addSubview:lineLabel];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = ZZDarkGrayColor;
        cell.textLabel.font = ZZTitleFont;
    }
    
   // cell.backgroundColor = [UIColor  redColor];
    NSString*  str = nil;
    switch (indexPath.section) {
        case 0:
            str = @"清除缓存";
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                   str = @"使用说明";
                    break;
                case 1:
                   str = @"关于萌宝派";
                    break;
                case 2:
                   str = @"意见反馈";
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
          
                case 0:
                  str = @"去评分";
                    break;
                case 1:
                    str = @"免责声明";
                    break;
                case 2:
                    str = @"APP发帖规则";
                    break;
            }
            break;
        case 3:
            str = nil;
            break;
        
    }
    cell.textLabel.text = str;
    if (indexPath.section == 1 || indexPath.section == 2 ) {
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
         cell.accessoryType = UITableViewCellAccessoryNone;
    }
  
    UIView*  view = [cell.contentView   viewWithTag:999];
    if (indexPath.section && indexPath.row) {
        view.hidden = NO;
    }else{
        view.hidden = YES;
    }
    if (indexPath.section ==0) {
        cell.accessoryView = self.cacheLabel;
      
    }

    
    UIView*  buttonView=  [cell.contentView  viewWithTag:888];
    if (buttonView) {
        [buttonView  removeFromSuperview];
    }
    if (indexPath.section == 3) {
//        UIButton*  logOutButton = [[UIButton  alloc]initWithFrame:CGRectMake(91, 4, 138, 36.5)];
//        [logOutButton  setTitle:@"注\t\t销" forState:UIControlStateNormal];
//        logOutButton.layer.cornerRadius=5;
//        logOutButton.layer.masksToBounds = YES;
//        logOutButton.backgroundColor=[UIColor whiteColor];
//        [logOutButton setTitleColor:[UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1] forState:UIControlStateNormal];
//        [logOutButton  addTarget:self action:@selector(logOutButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        logOutButton.titleLabel.font=[UIFont boldSystemFontOfSize:20];
//        logOutButton.tag = 888;
//        [cell.contentView  addSubview:logOutButton];
        UILabel*  label = [[UILabel  alloc]initWithFrame:CGRectMake(110, 4, ScreenWidth - 220, 36.5)];
        label.text =@"注\t\t销" ;
        label.tag = 888;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = ZZTextGreenColor;
        label.font = ZZButtonBoldFont;
        [cell.contentView  addSubview:label];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            ZZMyAlertView* alert =[[ ZZMyAlertView  alloc]initWithMessage:@"确定清除缓存吗？" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
            alert.tag = 1;
            [alert  show];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    ZZExplainViewController* explain = [[ZZExplainViewController alloc]init];
                    
                    [self.navigationController pushViewController:explain animated:YES];
                }
                    break;
                case 1:
                {
                    ZZAboutAppViewController* about = [[ZZAboutAppViewController alloc]init];
                    
                    [self.navigationController pushViewController:about animated:YES];
                }
                    break;
     
                case 2:
                {
                    ZZOpinionVIewController*vc=[[ZZOpinionVIewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                      [self  jumpToAppStoreWithAppID:0];
                  
                }
                    break;
          
                case 1:
                {
                    ZZResponsibilityViewController*vc=[[ZZResponsibilityViewController alloc]init];
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                    
                case 2:
                {
                    ZZAPPPublishRuleVC*  apppublishVC = [[ZZAPPPublishRuleVC  alloc]init];
                    [self.navigationController  pushViewController:apppublishVC animated:YES];
                }
                    break;
                    
            }
        }
            break;

        case 3:
        {
            ZZMyAlertView* myAlertView =[[ ZZMyAlertView  alloc]initWithMessage:@"你确定要退出当前账号嘛" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
            myAlertView.tag = 765;
            [myAlertView  show];
           
        }
            
            break;
   
    }
}


//-(void)logOutButtonAction{
//    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postLoginOutAndBack:^(id obj) {
//        AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate;
//        [app  gotoBWindowAndController:1];
//    }];
//}

#pragma mark  ZZMyAlertViewDelgate
-(void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //765 为退出当前账号提示框
    if (alertView.tag == 765 &&buttonIndex) {
        [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postLoginOutAndEnterBackGround:YES AndBack:^(id obj) {
            [[ZZRongChat  sharedZZRongChat]rongChatDisConnectServer];
            AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate;
            [app  gotoBWindowAndController:1];
            [ZZUser   cleanUserValue];
            [[ZZUMSdk sharedZZUMSdk]umThirdShareCancel];
        }];
       
//        [[ZZShareSdkShare  sharedZZShareSdkShare]shareSdkShareCancel];
     
    }else{
        if (alertView.tag == 1&&buttonIndex) {
            float tmpSize = [[SDImageCache sharedImageCache] getSize];
            
            NSString *clearCacheName = tmpSize >= 1024 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize/1024/1024] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize/1024];
            
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            ZZMyAlertView* alert1 = [[ZZMyAlertView alloc]initWithMessage:clearCacheName delegate:self cancelButtonTitle:nil sureButtonTitle:@"确定"];
            alert1.tag=2;
            [alert1 show];
        }else if(alertView.tag == 2&&buttonIndex){
            float tmpSize = [[SDImageCache sharedImageCache] getSize];
            
            NSString *clearCacheName = tmpSize >= 1024 ? [NSString stringWithFormat:@"(%.2fM)",tmpSize/1024/1024] : [NSString stringWithFormat:@"   (%.2fK)",tmpSize/1024];
            self.cacheLabel.text = clearCacheName;
        }
        
    }
}


@end
