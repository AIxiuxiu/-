//
//  ZZStatusViewC.m
//  萌宝派
//
//  Created by 张亮亮 on 15/8/4.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZStatusViewC.h"
#import "ZZMengBaoPaiRequest.h"
#import "AppDelegate.h"
@interface ZZStatusViewC ()
@property (weak, nonatomic) IBOutlet UIButton *prepare;
@property (weak, nonatomic) IBOutlet UIButton *huaiyun;
@property (weak, nonatomic) IBOutlet UIButton *baby;

@property(nonatomic,strong)UIButton*  selectedButton;
@end

@implementation ZZStatusViewC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = ZZViewBackColor;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(sureButtonAction)];
    rightBar.tintColor = [UIColor  whiteColor];
    //  rightBar.width = 10;
    [self.navigationItem  setRightBarButtonItem:rightBar animated:YES];
  

    if (self.number!=2) {
        self.title = @"状态修改";
        [self  buttonAction:[self  getCurrentButton]];
     
    }else{
        [self.navigationItem setLeftBarButtonItems:nil];
        self.navigationItem.hidesBackButton = YES;
        self.title = @"选择状态";
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
   
    [self  setButtonsBackImage];
    // Do any additional setup after loading the view from its nib.
}

- (void) setButtonsBackImage{
    [self.prepare  setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bk_one_320x120" ofType:@"jpg"]] forState:UIControlStateNormal];
    [self.huaiyun setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bk_two_320x120" ofType:@"jpg"]] forState:UIControlStateNormal];
    [self.baby setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bk_three_320x120" ofType:@"jpg"]] forState:UIControlStateNormal];
    
    [self.prepare  setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bk_one_s_320x120" ofType:@"jpg"]] forState:UIControlStateSelected];
    [self.huaiyun  setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bk_two_s_320x120" ofType:@"jpg"]] forState:UIControlStateSelected];
    [self.baby  setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bk_three_s_320x120" ofType:@"jpg"]] forState:UIControlStateSelected];
}

- (IBAction)buttonAction:(UIButton *)sender {
    self.selectedButton.selected = NO;
    self.selectedButton = sender;
    sender.selected = YES;
  
        self.navigationItem.rightBarButtonItem.enabled = [self  getCurrentButton] != self.selectedButton;
  
}

-(void)sureButtonAction{
    self.navigationItem.rightBarButtonItem
    .enabled = NO;
    
    if (self.selectedButton) {
        if (self.number ==2) {
            [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postAddIndentityWtihInt:self.selectedButton.tag andBack:^(id obj) {
                if (obj) {
                    AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate;
                    
                    [app  gotoBWindowAndController:2];
                    
                }
            }];
        }else{
            [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postUpdateUserinfoWithNick:nil andStatus:self.selectedButton.tag andImage:nil andBack:^(id obj) {
                
                
                if (obj) {
                    
                    
                }else{
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                }
                
            }];
        }
        
        
    }
    
}

- (UIButton *)getCurrentButton{
    NSUInteger  status = [ZZUser  shareSingleUser].status;
    if ( status == 1) {
        return  self.prepare;
    }else if(status ==2){
        return self.huaiyun;
    }else if(status  == 3){
        return self.baby;
    }else{
        return nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
