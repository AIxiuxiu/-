//
//  ZZBabyCreatOrChangeController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZBabyCreatOrChangeController.h"
#import "ZZImageSelect.h"
#import "ZZMyDateView.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZBabyViewController.h"
#import "UIImageView+WebCache.h"
#import "ZZMyAlertView.h"
@interface ZZBabyCreatOrChangeController ()<UITextFieldDelegate,ZZImageSelectDelegate,ZZMyDateViewDelegate>
@property(nonatomic,strong)UILabel*   headLabel;
@property(nonatomic,strong)UILabel*   nickLabel;
@property(nonatomic,strong)UILabel*   birthdayLabel;
@property(nonatomic,strong)UILabel*  sexLabel;

@property(nonatomic,strong)UIButton*  selectedSexButton;
@property(nonatomic,strong)UIImageView*  babyHeadImageView;
@property(nonatomic,strong)UITextField*  babyNickTF;
@property(nonatomic,strong)UITextField*  babyBirthdayTF;
@property(nonatomic,strong)UIButton*  boySexButton;
@property(nonatomic,strong)UIButton*  girlSexButton;


@property(nonatomic,strong)UIView*  blackView;
@property(nonatomic,strong)ZZMyDateView*  dateView;

@property(nonatomic,strong)UIImage* boolImage;

@property(nonatomic,strong)ZZImageSelect*  imageSelect;
@end

@implementation ZZBabyCreatOrChangeController
#pragma mark  lazy  load
-(UILabel *)headLabel{
    if (!_headLabel) {
        _headLabel = [[UILabel  alloc]initWithFrame:CGRectMake(25, 114, 75, 20)];
        _headLabel.text = @"宝宝头像";
        _headLabel.textColor = ZZLightGrayColor;
        _headLabel.font = ZZContentFont;
    }
    return _headLabel;
}

-(UIImageView *)babyHeadImageView{
    if (!_babyHeadImageView) {
        _babyHeadImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(110, 74, 100, 100)];
        _babyHeadImageView.layer.borderColor = ZZGreenColor.CGColor;
        _babyHeadImageView.layer.borderWidth = 0.5;
        _babyHeadImageView.layer.cornerRadius = 5;
        _babyHeadImageView.layer.masksToBounds = YES;
        _babyHeadImageView.clipsToBounds = YES;
        _babyHeadImageView.userInteractionEnabled = YES;
        _babyHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
        _babyHeadImageView.image = [UIImage  imageNamed:@"head_portrait_55x55.jpg"];
        UITapGestureRecognizer*  tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tapHeadImageView)];
        [_babyHeadImageView  addGestureRecognizer:tap];
    }
    return _babyHeadImageView;
}

-(UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel  alloc]initWithFrame:CGRectMake(25, 207, 75, 20)];
        _nickLabel.text = @"宝宝昵称";
        _nickLabel.textColor = ZZLightGrayColor;
        _nickLabel.font = ZZContentFont;
    }
    return _nickLabel;
}

-(UITextField *)babyNickTF{
    if (!_babyNickTF) {
        _babyNickTF = [[UITextField  alloc]initWithFrame:CGRectMake(110, 200, ScreenWidth - 138, 37)];
        //_babyNickTF.autocorrectionType=UITextAutocorrectionTypeNo;
       _babyNickTF.borderStyle=UITextBorderStyleRoundedRect;
        _babyNickTF.placeholder = @"最多七位汉字";
        _babyNickTF.font = ZZTitleFont;
        _babyNickTF.textColor =  ZZDarkGrayColor;
        _babyNickTF.tag = 1;
        _babyNickTF.delegate = self;
        _babyNickTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _babyNickTF.returnKeyType = UIReturnKeyDone;
    }
    return _babyNickTF;
}

-(UILabel *)birthdayLabel{
    if (!_birthdayLabel) {
        _birthdayLabel = [[UILabel  alloc]initWithFrame:CGRectMake(25, 257, 75, 20)];
        _birthdayLabel.text = @"宝宝生日";
        _birthdayLabel.textColor = ZZLightGrayColor;
        _birthdayLabel.font =ZZContentFont;
    }
    return _birthdayLabel;
}

-(UITextField *)babyBirthdayTF{
    if (!_babyBirthdayTF) {
        _babyBirthdayTF = [[UITextField  alloc]initWithFrame:CGRectMake(110, 250, ScreenWidth - 138, 37)];
        _babyBirthdayTF.placeholder = @"选择生日";
        _babyBirthdayTF.borderStyle=UITextBorderStyleRoundedRect;
        _babyBirthdayTF.font = ZZTitleBoldFont;
        _babyBirthdayTF.textColor =  ZZDarkGrayColor;
        _babyBirthdayTF.delegate = self;
        _babyBirthdayTF.tag = 2;
    }
    return _babyBirthdayTF;
}
-(UILabel *)sexLabel{
    if (!_sexLabel) {
        _sexLabel = [[UILabel  alloc]initWithFrame:CGRectMake(25, 307, 75, 20)];
        _sexLabel.text = @"宝宝性别";
        _sexLabel.textColor = ZZLightGrayColor;
        _sexLabel.font = ZZContentFont;
    }
    return _sexLabel;
}

-(UIButton *)boySexButton{
    if (!_boySexButton) {
        _boySexButton=[[UIButton alloc]initWithFrame:CGRectMake(110, 302,85, 30)];
        _boySexButton.backgroundColor = [UIColor  colorWithRed:0.57 green:0.85 blue:0.37 alpha:1];
        _boySexButton.layer.cornerRadius  = 5;
        _boySexButton.layer.masksToBounds = YES;
        
        [_boySexButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_boySexButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"gray_choose_16x16" ofType:@"png"]] forState:UIControlStateNormal];
        [_boySexButton   setTitle:@"小王子" forState:UIControlStateNormal];
        [_boySexButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _boySexButton.tag=1;
        _boySexButton.titleLabel.font = ZZTitleBoldFont;
        
        _boySexButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _boySexButton;
}

-(UIButton *)girlSexButton{
    if (!_girlSexButton) {
        _girlSexButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 85-28, 302,85, 30)];
        _girlSexButton.layer.cornerRadius=5;
        _girlSexButton.layer.masksToBounds = YES;
        _girlSexButton.backgroundColor = [UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1];
        [_girlSexButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_girlSexButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"gray_choose_16x16" ofType:@"png"]] forState:UIControlStateNormal];
    
        [_girlSexButton   setTitle:@"小公主" forState:UIControlStateNormal];
        [_girlSexButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _girlSexButton.tag = 2;
        _girlSexButton.titleLabel.font = ZZTitleBoldFont;
        
        _girlSexButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _girlSexButton;
}

-(ZZMyDateView *)dateView{
    if (!_dateView) {
        NSDate*  date = [NSDate  date];
        
        NSDateFormatter*  formatter = [[NSDateFormatter   alloc]init];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString*  dateStr = [formatter   stringFromDate:date];
        
        _dateView = [[ZZMyDateView  alloc]initWithFrame:CGRectMake(110, 206,ScreenWidth - 138,125)  andString:dateStr];
        _dateView.delegate = self;
    }
    return _dateView;
}

-(UIView *)blackView{
    if (!_blackView) {
        _blackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _blackView.backgroundColor=[UIColor blackColor];
        _blackView.tag=1000;
        _blackView.alpha=0.3;
    }
    return _blackView;
}
-(ZZImageSelect *)imageSelect{
    if (_imageSelect == nil) {
        _imageSelect = [[ZZImageSelect  alloc]init];
        _imageSelect.delegate = self;
        _imageSelect.head = YES;
        _imageSelect.headEdit = YES;
    }
    return _imageSelect;
}
//-(ZZSelectImageView *)selectedImageview{
//    if (!_selectedImageview) {
//        _selectedImageview = [[ZZSelectImageView  alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        _selectedImageview.delegate = self;
//    }
//    return _selectedImageview;
//}

#pragma mark  life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.babyInfo) {
        [self.babyHeadImageView  sd_setImageWithURL:[NSURL URLWithString:self.babyInfo.imageInfo.smallImagePath]  placeholderImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"head_portrait_55x55.jpg" ofType:nil]]options:SDWebImageRetryFailed | SDWebImageLowPriority ];
        self.babyNickTF.text = self.babyInfo.nick;
        self.babyBirthdayTF.text = self.babyInfo.birthday;
        self.selectedSexButton.tag = self.babyInfo.sex;
        if (self.babyInfo.sex%2 == 1) {
             [self.boySexButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"gray_chosed_16x16" ofType:@"png"]] forState:UIControlStateNormal];
            self.selectedSexButton =self.boySexButton;
        }else{
            [self.girlSexButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"gray_chosed_16x16" ofType:@"png"]] forState:UIControlStateNormal];
            self.selectedSexButton =self.girlSexButton;
        }
    }
    [self.view  addSubview:self.headLabel];
    [self.view  addSubview:self.babyHeadImageView];
    [self.view  addSubview:self.nickLabel];
    [self.view  addSubview:self.babyNickTF];
    [self.view  addSubview:self.babyBirthdayTF];
    [self.view  addSubview:self.birthdayLabel];
    [self.view  addSubview:self.sexLabel];
    [self.view  addSubview:self.boySexButton];
    [self.view  addSubview:self.girlSexButton];
    //
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
   
    [center addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
   [ [NSNotificationCenter   defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    UIButton* btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn1  setTitle:@"提交" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn1 addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*  rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -5;//此处修改到边界的距离，请自行测试
        [self.navigationItem setRightBarButtonItems:@[negativeSeperator,rightBarButtonItem]];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem: rightBarButtonItem animated:NO];
    }
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.dateView  removeFromSuperview];
    [self.blackView removeFromSuperview];
    [self.view endEditing:YES];
}

#pragma  mark UItextfieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag ==2) {
        [self.babyNickTF resignFirstResponder];
        [self.view addSubview:self.blackView];
        [self.view  addSubview:self.dateView];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.babyNickTF resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark event response
//性别 button响应事件
-(void)clickAction:(UIButton*)btn{
    if (self.selectedSexButton.tag == btn.tag) {
        return;
    }
    
    if (btn.tag == self.boySexButton.tag) {
        [self.girlSexButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"gray_choose_16x16" ofType:@"png"]] forState:UIControlStateNormal];
    }else{
        [self.boySexButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"gray_choose_16x16" ofType:@"png"]] forState:UIControlStateNormal];
    }
    
    [btn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"gray_chosed_16x16" ofType:@"png"]] forState:UIControlStateNormal];
    self.selectedSexButton =btn;
}

// 确定按钮响应事件
-(void)sureButtonAction:(UIButton*)btn{
    NSString* babyBirthDay;
    NSString* babyNick;
    NSInteger babySex;
    //生日
    if ([self.babyBirthdayTF.text isEqualToString:self.babyInfo.birthday]) {
        babyBirthDay = nil;
    }else{
        babyBirthDay = self.babyBirthdayTF.text;
    }
    //名字
    if ([self.babyNickTF.text isEqualToString:self.babyInfo.nick]) {
        babyNick = nil;
    }else{
        babyNick = self.babyNickTF.text;
    }
    //性别
    if (self.selectedSexButton.tag == self.babyInfo.sex) {
        babySex = 0;
    }else{
        babySex = self.selectedSexButton.tag;
    }
    
    if (self.babyInfo&&!(babyBirthDay||babyNick||babySex||self.boolImage)) {
        ZZMyAlertView*  alertView = [[ZZMyAlertView  alloc]initWithMessage:@"你没有修改信息" delegate:nil cancelButtonTitle:@"确定" sureButtonTitle:nil];
        [alertView  show];
        
        return;
    }
    
    if (!self.babyInfo&&!(babySex&&babyNick&&babyBirthDay)) {
        ZZMyAlertView*  alertView = [[ZZMyAlertView  alloc]initWithMessage:@"信息没有填写完整" delegate:nil cancelButtonTitle:@"确定" sureButtonTitle:nil];
        [alertView  show];
        
        return;
    }
    
    //        ZZMyAlertView*  alertView = [[ZZMyAlertView  alloc]initWithMessage:@"你没有修改信息" delegate:nil cancelButtonTitle:@"确定" sureButtonTitle:nil];
    //        [alertView  show];
    
    [[ZZMengBaoPaiRequest shareMengBaoPaiRequest]postAddBabyOrUpdateBabyInfoWithImage:self.boolImage andBirthday:babyBirthDay andNick:babyNick andSex:babySex andBabyId:self.babyInfo.babyId andback:^(id obj) {
        
        if (obj) {
            
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[ZZBabyViewController class]]) {
                    ZZBabyViewController*  uprightVC =(ZZBabyViewController*)temp;
                    
                    [uprightVC  publishSuccessRefreshWith:obj];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }];
    
}

// 头像点击响应事件
-(void)tapHeadImageView{
    [self.imageSelect  imageSelectShow];
}


#pragma  mark  NSNotification
- (void)keyboardAppear:(NSNotification *)notification{
    //1.获取键盘的高度
    NSDictionary *userInfo = notification.userInfo;
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];

    CGFloat height =[UIScreen  mainScreen].bounds.size.height-self.babyNickTF.frame.size.height-self.babyNickTF.frame.origin.y;
    if( keyboardFrame.size.height>height){
        CGRect  origneFrame = self.view.frame;
        origneFrame.origin.y =origneFrame.origin.y+ height-keyboardFrame.size.height-5;
        NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
        UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
              self.view.frame = origneFrame;
        } completion:nil];
    } 
}

-(void)textFieldDidChange:(NSNotification*)noti{
    
    UITextField*  tf = noti.object;
    
    UITextRange *selectedRange = [tf markedTextRange];
    UITextPosition *position = [tf positionFromPosition:selectedRange.start offset:0];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [tf.text dataUsingEncoding:enc];
    
    NSInteger offset = [tf offsetFromPosition:position toPosition:[tf positionFromPosition:selectedRange.end offset:0]];

    if (da.length-offset >14) {
        
        NSString*  str = tf.text ;
        for (int i = 6; i<str.length; i++) {
            
            if ([[str substringToIndex:i] dataUsingEncoding:enc].length >= 14) {
                
                tf.text = [tf.text substringToIndex:i];
                
                break;
            }
        }
        
    }
    
    
    
}

//键盘收起
- (void)keyboardDisappear:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
  
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
//
    CGFloat height =[UIScreen  mainScreen].bounds.size.height-self.babyNickTF.frame.size.height-self.babyNickTF.frame.origin.y;
    if (keyboardFrame.size.height>height) {
        CGRect originFrame = self.view.frame;
//        origneFrame.origin.y =origneFrame.origin.y+ height-keyboardFrame.size.height-5
        originFrame.origin.y=originFrame.origin.y- height+keyboardFrame.size.height+5;
        [UIView animateWithDuration:duration delay:0  options:options animations:^{
            self.view.frame = originFrame;
        } completion:nil];
    }
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter  defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma  mark ZZImageSelectDelegate
-(void)imageSelect:(ZZImageSelect *)imageSelect images:(NSArray *)images{
    self.boolImage = images[0];
    self.babyHeadImageView.image = self.boolImage;
}

#pragma  mark  ZZMyDateViewDelegate
-(void)getDateStr:(NSString*)str{
    self.babyBirthdayTF.text = str;
}


@end
