//
//  ZZSignatureViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-6.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZSignatureViewController.h"
#import "ZZTextView.h"
@interface ZZSignatureViewController ()
@property(nonatomic,strong)ZZTextView* signatureTextView;
@property(nonatomic,strong)UILabel*  tipslabel;
@end

@implementation ZZSignatureViewController

-(ZZTextView *)signatureTextView{
    if (!_signatureTextView) {
        _signatureTextView = [[ZZTextView alloc]initWithFrame:CGRectMake(15, 78, 290, 150)];
        _signatureTextView.layer.borderWidth = 0.5;
        _signatureTextView.layer.borderColor = [[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1]CGColor];
        _signatureTextView.font = [UIFont systemFontOfSize:16];
       
    }
    return _signatureTextView;
}

-(UILabel *)tipslabel{
    if (!_tipslabel) {
        _tipslabel = [[UILabel  alloc]initWithFrame:CGRectMake(15, 233, 290, 20)];
        _tipslabel.text = @"亲，留下你的个性签名吧";
        _tipslabel.textColor = [UIColor   colorWithRed:0.68 green:0.68 blue:0.68 alpha:1];
        _tipslabel.font = [UIFont systemFontOfSize:14];
    }
    return _tipslabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    
    self.title = @"修改签名";
    [self.view  addSubview:self.signatureTextView];
    [self.view  addSubview:self.tipslabel];
    [self.signatureTextView  becomeFirstResponder];
    
    
}
-(void)sureButtonAction{
  
}- (void)didReceiveMemoryWarning {
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
