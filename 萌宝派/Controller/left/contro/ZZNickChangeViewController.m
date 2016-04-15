//
//  ZZNickChangeViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-6.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZNickChangeViewController.h"
#import "ZZUser.h"
#import "ZZMengBaoPaiRequest.h"
@interface ZZNickChangeViewController ()

@property(nonatomic,strong)UILabel*  tipslabel;
@end

@implementation ZZNickChangeViewController
#pragma mark lazy load
-(UITextField *)nickTextField{
    if (!_nickTextField) {
        _nickTextField = [[UITextField  alloc]initWithFrame:CGRectMake(15, ZZNaviHeight + 15, ScreenWidth - 30, 40)];
        _nickTextField.borderStyle  = UITextBorderStyleRoundedRect;
        _nickTextField.font = [UIFont systemFontOfSize:16];
        _nickTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    }
    
    return _nickTextField;
}

-(UILabel *)tipslabel{
    if (!_tipslabel) {
        _tipslabel = [[UILabel  alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nickTextField.frame)+10,CGRectGetWidth(self.nickTextField.frame), 20)];
        _tipslabel.text = @"请勿频繁修改！(长度为7个汉字)";
        _tipslabel.textColor = ZZGrayWhiteColor;
        _tipslabel.font = [UIFont  systemFontOfSize:14];
    }
    
    return _tipslabel;
}
#pragma mark  life  cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改昵称";
    self.view.backgroundColor = ZZViewBackColor;
    
    [self.view  addSubview:self.nickTextField];
    [self.view  addSubview:self.tipslabel];
    [self.nickTextField  becomeFirstResponder];
    self.nickTextField.text = [ZZUser  shareSingleUser].nick;

      [[NSNotificationCenter   defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.nickTextField];
    //self.rightButton.alpha = 0.0;
    //    self.rightButton.hidden = YES;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(sureButtonAction)];
    rightBar.tintColor = [UIColor  whiteColor];
    //  rightBar.width = 10;
    [self.navigationItem  setRightBarButtonItem:rightBar animated:YES];
   
    self.navigationItem.rightBarButtonItem.enabled = NO;
    //self.rightButton.userInteractionEnabled = NO;
    
    // Do any additional setup after loading the view.
}

#pragma mark  event response
-(void)sureButtonAction{

    self.navigationItem.rightBarButtonItem.enabled = NO;

    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postUpdateUserinfoWithNick:self.nickTextField.text andStatus:0 andImage:nil andBack:^(id obj) {
      
        [self.nickTextField resignFirstResponder];
        
        if (obj) {
         
        }else{
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
      
    }];
}
#pragma mark  NSNotification
-(void)textFieldDidChange:(NSNotification*)noti{
    
    
    UITextField*  tf = noti.object;
    if ([tf.text  isEqualToString:[ZZUser shareSingleUser].nick]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
        UITextRange *selectedRange = [tf markedTextRange];
        UITextPosition *position = [tf positionFromPosition:selectedRange.start offset:0];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData* da = [tf.text dataUsingEncoding:enc];
        
        NSInteger offset = [tf offsetFromPosition:position toPosition:[tf positionFromPosition:selectedRange.end offset:0]];
        // NSLog(@"%d",da.length);
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



-(void)dealloc{
    [[NSNotificationCenter  defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
