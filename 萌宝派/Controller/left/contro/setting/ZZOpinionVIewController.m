//
//  ZZOpinionVIewController.m
//  萌宝派
//
//  Created by sky on 14-10-22.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZOpinionVIewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZMyAlertView.h"
#import "ZZTextView.h"
@interface ZZOpinionVIewController ()<UITextViewDelegate>

@property(nonatomic,strong)ZZTextView * opinionTextView;
@end

@implementation ZZOpinionVIewController
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"意见反馈";
    self.view.backgroundColor = ZZViewBackColor;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(sureButtonAction)];
    rightBar.tintColor = [UIColor  whiteColor];
    [self.navigationItem  setRightBarButtonItem:rightBar animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self initUI];
}

-(void)initUI{
    
    CGFloat margin = 10;
    CGFloat textX = margin;
    CGFloat textY = ZZNaviHeight + margin;
    CGFloat textW = ScreenWidth - 2 *textX;
     CGFloat textH = 200;
    if (ScreenHeight <568) {
        textH = 150;
    }
   
    
    ZZTextView *textView = [[ZZTextView alloc]initWithFrame:CGRectMake(textX, textY, textW, textH)];
    textView.delegate = self;
    textView.placeholder = @"你想对萌宝派说些什么，不少于十个字";
    //  self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = 5;
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.21].CGColor;
    textView.font = ZZContentFont;
    textView.returnKeyType=UIReturnKeyDone;
    self.opinionTextView = textView;
    [self.view addSubview:self.opinionTextView];

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view  endEditing:YES];
    //[self]
}
#pragma mark event response
- (void)sureButtonAction{
    
    if ([self   strLengthWith: self.opinionTextView.text].length<10) {
        
        ZZMyAlertView*  alert = [[ZZMyAlertView  alloc]initWithMessage:@"你的填写的内容较短" delegate:nil cancelButtonTitle:nil sureButtonTitle:@"确定"];
        [alert  show];
        
        return;
    }
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postAddFeedBackAndContent:self.opinionTextView.text andBack:^(id obj) {
        
        if (obj) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark  UITextViewDelegate


-(void)textViewDidChange:(UITextView *)textView{
   
    if (textView.text.length > 10) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
         self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [textView.text dataUsingEncoding:enc];
    
    
    NSInteger offset = [textView offsetFromPosition:position toPosition:[textView positionFromPosition:selectedRange.end offset:0]];
    if ( da.length-offset >2000) {

        NSString*  str = [textView.text   substringToIndex:textView.text.length-offset];
    
            
            for (int i = 999; i<str.length; i++) {
                
                if ([[str substringToIndex:i] dataUsingEncoding:enc].length >=2000) {
                    
                    textView.text = [textView.text substringToIndex:i];
                    
                    break;
                }
            }
    }
}

//限定字数

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
        
    }
    [textView  markedTextRange];
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [textView.text dataUsingEncoding:enc];
    
    
    NSInteger offset = [textView offsetFromPosition:position toPosition:[textView positionFromPosition:selectedRange.end offset:0]];

    
    if (da.length-offset <2000) {

        return YES;
        
    }
 
    
    return NO;
}
#pragma mark  private methods
-(NSString*)strLengthWith:(NSString*)str{
    return  [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
