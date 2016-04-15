//
//  ZZReleaseSecondViewController.m
//  萌宝派
//
//  Created by charles on 15/3/22.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZReleaseSecondViewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZUprightViewController.h"
#import "ZZMyAlertView.h"
@interface ZZReleaseSecondViewController ()
@property(nonatomic,strong)ZZPlateTypeInfo*  plateType;
@end

@implementation ZZReleaseSecondViewController
#pragma mark  life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建内容";
}

#pragma mark event response
-(void)sureButtonAction:(UIButton*)btn{
    [self.view endEditing:YES];
    NSString*  publishString = [self  removeWhitespaceAndNewlineCharacterWithOrignString:self.publishString];
    if ((self.imagesMarray.count==0)&&(self.publishString.length<10)) {
      
        ZZMyAlertView*  alertView= [[ZZMyAlertView  alloc]initWithMessage:@"你发布的内容太短或图片不能为空" delegate:nil cancelButtonTitle:@"确定" sureButtonTitle:nil];
        [alertView  show];
        return;
    }else{
     
        btn.userInteractionEnabled = NO;
        [btn  setTitle:@"发布中" forState:UIControlStateNormal];
        [btn  setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postAddNewStarPostWithPlate:self.publishPost.postPlateType andTitle:self.publishPost.postTitle andContent:publishString andImageArray:self.imagesMarray andBack:^(id obj) {
            [btn  setTitle:@"发布" forState:UIControlStateNormal];
            [btn   setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
            btn.userInteractionEnabled = YES;
            if (obj) {
                [self gobackWith:obj];
            }else{
                [self  netLoadFailWithText:@"网络不给力，发布失败" isBack:YES];
            }
        }];
    }
    
}

#pragma mark private methods
-(void)gobackWith:(NSDictionary*)dic{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[ZZUprightViewController class]]) {
            ZZUprightViewController*  uprightVC =(ZZUprightViewController*)temp;
            [uprightVC  publishSuccessRefreshWith:dic];
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

@end
