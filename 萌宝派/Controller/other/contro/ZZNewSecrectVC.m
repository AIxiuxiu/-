//
//  ZZNewSecrectVC.m
//  萌宝派
//
//  Created by charles on 15/8/6.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZNewSecrectVC.h"
#import "ZZMengBaoPaiRequest.h"

@interface ZZNewSecrectVC ()
@property (strong, nonatomic) IBOutlet UITextField *secrectTF;
@end

@implementation ZZNewSecrectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新密码";
    [self  setUpBackIV];
    self.navigationItem.hidesBackButton = YES;
    [self setNaviRightButton];
}
- (void) setUpBackIV{
    UIImageView *iv = [[UIImageView  alloc]initWithFrame:[UIScreen  mainScreen].bounds];
    iv.userInteractionEnabled = YES;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.image =  [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"渐变色3.jpg" ofType:nil]];
    [self.view  insertSubview:iv atIndex:0];
}
-(void)setNaviRightButton{
    UIButton *t = [UIButton buttonWithType:UIButtonTypeCustom];
    [t setFrame:CGRectMake(0, 0, 40, 40)];
    [t setTitle:@"提交" forState:UIControlStateNormal];
    t.titleLabel.font = [UIFont systemFontOfSize:15];
    [t setBackgroundColor:[UIColor clearColor]];
    [t setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:t];
    [t addTarget:self action:@selector(commitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:rightBtn];
}
-(void)commitButton:(UIButton*)btn{
    
    if([self.secrectTF.text isPassWordWithMin:ZZMiMaMinLenth max:ZZMiMaMaxLenth] == YES){
        [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postUpdatePWDWithRegisterPhone:self.phoneNum andNewPassword:self.secrectTF.text andBack:^(id obj) {
            if (obj) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }else{
        [self.secrectTF  shakeAnimation];
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
