//
//  ZZResponsibilityViewController.m
//  萌宝派
//
//  Created by sky on 14-10-22.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZResponsibilityViewController.h"
#import "ZZShowView.h"
@interface ZZResponsibilityViewController ()

@end

@implementation ZZResponsibilityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
//    self.view.layer.cornerRadius = 5;
//    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.view.layer.shadowRadius = 1;
//    self.view.layer.shadowOffset = CGSizeMake(0, 1);
//    self.view.layer.shadowOpacity = 0.3;
    self.title = @"免责声明";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initUI];
}
-(void)initUI{
    
    NSError*  readError ;
    NSString*  agreeContent = [NSString  stringWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"萌宝派免责声明" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&readError];
  
    
    CGFloat  height = ScreenHeight -84;

    ZZShowView* rulesTV =[[ZZShowView alloc]initWithFrame:CGRectMake(10, 74, ScreenWidth-20, height)];
    rulesTV.backgroundColor=[UIColor whiteColor];
  
    rulesTV.layer.cornerRadius = 5;
    
    rulesTV.layer.masksToBounds = YES;
    rulesTV.bounces=NO;
    rulesTV.textColor = ZZLightGrayColor;
    rulesTV.font = ZZContentFont;
    NSAttributedString * attStr = [rulesTV  getAttributedStringWithText:agreeContent paragraphSpacing:0 lineSpace:3 stringCharacterSpacing:0 textAlignment:NSTextAlignmentLeft font:rulesTV.font color:rulesTV.textColor ];
    rulesTV.attributedText = attStr;
    CGSize size = [rulesTV  sizeThatFits:CGSizeMake(ScreenWidth-20, 10000)];
    if (height>size.height) {
        rulesTV.height = size.height;
    }else{
        rulesTV.contentSize = size;
    }
    
    [self.view  addSubview:rulesTV];
//    UIScrollView* grayBK = [[UIScrollView alloc]initWithFrame:CGRectMake2(10,  74, 300, AutoSizey-84)];
//    grayBK.backgroundColor = [UIColor whiteColor];
//    grayBK.layer.cornerRadius = 5;
//    grayBK.layer.shadowColor = [UIColor blackColor].CGColor;
//    grayBK.layer.shadowRadius = 1;
//    grayBK.layer.shadowOffset = CGSizeMake(0, 1);
//    grayBK.layer.shadowOpacity = 0.3;
//    [self.view addSubview:grayBK];
//      grayBK.showsVerticalScrollIndicator = NO;
//     grayBK.contentSize = CGSizeMake1(300, 568-100);
////    //免责声明
////    UIButton* appName = [[UIButton alloc]initWithFrame:CGRectMake(90, 30, 120, 30)];
////    [appName setTitle:@"免责声明" forState:UIControlStateNormal];
////    appName.layer.cornerRadius = 5;
////    appName.layer.masksToBounds = YES;
////    appName.adjustsImageWhenHighlighted = NO;
////    appName.backgroundColor = [UIColor colorWithRed:0.1 green:0.63 blue:0.96 alpha:0.93];
////    [grayBK addSubview:appName];
//    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake1(20, 20, 260, 440)];
//    label.textColor = [UIColor colorWithRed:75.0/255 green:75.0/255 blue:75.0/255 alpha:1];
//    label.font = [UIFont systemFontOfSize:14*AutoSizeScaley];
//    label.numberOfLines=0;
//    label.text=@"\t苹果公司及其发布平台AppStore对本软件一切行为均不承担责任。\n\n\t鉴于上海至臻文化传播有限公司提供的萌宝派软件平台，在平台上会员或其发布的相关信息均由会员自行提供，会员依法应对其提供的任何信息承担全部责任。\n\n\t任何单位或个人认为萌宝派平台的内容可能涉嫌侵犯其合法权益，应及时向萌宝派提出书面权利通知并提供身份证明、权属证明、具体链接（URL）及详细侵权情况证明。萌宝派在收到上述法律文件后，将会依法尽快移除相关涉嫌侵权的内容。\n\n\t萌宝派平台转载作品（包括论坛内容）出于传递更多信息之目的，并不意味萌宝派赞同其观点或证实其内容的真实性。萌宝派尊重合法版权，反对侵权盗版。若本平台有部分文字、摄影作品等侵害了您的权益，请您立即与萌宝派联系，萌宝派将尽快予以解决。\n\n\t如有任何异议，请发送邮件到mengbaopai@126.com";
//    [grayBK addSubview:label];
//    
//    
//    
}

-(BOOL)canBecomeFirstResponder{
    return NO;
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
