//
//  ZZMyAlertView.m
//  聪明宝宝
//
//  Created by zhizhen on 14-9-2.
//  Copyright (c) 2014年 zhizhen. All rights reserved.
//

#import "ZZMyNewAlertView.h"

#define alertTitleFont  [UIFont  boldSystemFontOfSize:16]
#define alertTextFont  [UIFont  systemFontOfSize:14]
#define alertButtonFont  [UIFont  boldSystemFontOfSize:16]

#define alertMargin  30
#define alertSpace   10

#define alertSubMaxWidth  (ScreenWidth - 2*alertMargin)
#define alertTextColor   [UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1]
#define alertTitleColor  [UIColor colorWithRed:30.0/255 green:30.0/255 blue:30.0/255 alpha:1]

@interface ZZMyNewAlertView ()
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, strong) UIWindow *previousKeyWindow;
@property (nonatomic,strong )UIView*  firstResponseView;
//@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *destructiveButton;
@property(nonatomic, copy) NSString *cancelBtnTitle;
@property(nonatomic, copy) NSString *sureBtnTitle;
@property(nonatomic,strong)NSMutableArray *buttons;

@end


@implementation ZZMyNewAlertView

-(NSMutableArray *)buttons{
    if (_buttons == nil) {
        _buttons = [NSMutableArray  arrayWithCapacity:2];
    }
    return _buttons;
}
-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel  alloc]init];
        _titleLabel.font = alertTitleFont;
        _titleLabel.textColor = alertTitleColor;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self  addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UILabel *)messageLabel{
    
    if (!_messageLabel) {
        _messageLabel = [[UILabel  alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-80, 50)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = alertTextFont;
        _messageLabel.textColor = alertTextColor;
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self  addSubview:_messageLabel];
    }
    return _messageLabel;
}

-(UIButton *)cancelButton{
    
    if (!_cancelButton) {
        _cancelButton = [[UIButton  alloc]init];
        [_cancelButton  addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
       // [_cancelButton setTitleColor: [UIColor  grayColor] forState:UIControlStateNormal];
        _cancelButton.tag = 0;
        _cancelButton.layer.cornerRadius = 5.0f;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.titleLabel.font = alertTitleFont;
        _cancelButton.backgroundColor = [UIColor  colorWithRed:0.45 green:0.8 blue:0.21 alpha:0.92];
        [self  addSubview:_cancelButton];
        [self.buttons  addObject:_cancelButton];
    }
    
    return _cancelButton;
}
-(UIButton *)destructiveButton{
    
    if (!_destructiveButton) {
        _destructiveButton = [[UIButton  alloc]init];
        [_destructiveButton  addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _destructiveButton.titleLabel.font = alertTitleFont;
        _destructiveButton.backgroundColor = [UIColor  colorWithRed:0.1 green:0.63 blue:0.96 alpha:0.93];
        _destructiveButton.layer.cornerRadius  = 5.0;
        _destructiveButton.layer.masksToBounds = YES;
        _destructiveButton.tag = 1;
        [self.buttons  addObject:_destructiveButton];
       [self  addSubview:_destructiveButton];
    }
    
    return _destructiveButton;
}

//-(void)setTitle:(NSString *)title{
//    _title = title;
//    //self.titleLabel.text = title;
//}
//
//-(void)setMessage:(NSString *)message{
//    _message = message;
//   // self.messageLabel.text = message;
//}

-(void)setCancelBtnTitle:(NSString *)cancelBtnTitle{
    _cancelBtnTitle = cancelBtnTitle;
    [self.cancelButton  setTitle:cancelBtnTitle forState:UIControlStateNormal];
}

-(void)setSureBtnTitle:(NSString *)sureBtnTitle{
    _sureBtnTitle = sureBtnTitle;
    [self.destructiveButton  setTitle:sureBtnTitle forState:UIControlStateNormal];
}

//-(void)setTextAlignment:(NSTextAlignment)textAlignment{
//    _textAlignment  = textAlignment;
//    self.messageLabel.textAlignment = textAlignment;
//}
- (id)initWithMessage:(NSString *)message delegate:(id <ZZMyNewAlertViewDelgate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle sureButtonTitle:(NSString *)sureButtonTitle{
    if (self = [super init]) {
        self.backgroundColor = [UIColor  whiteColor];
        self.message = message;
        self.delegate = delegate;
        self.cancelBtnTitle = cancelButtonTitle;
        self.sureBtnTitle = sureButtonTitle;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}
-(void)layoutSubviews{
    [super  layoutSubviews];
    //
    if (self.title.length) {
      //  CGSize  titleSize=  [self  seta]
        CGSize  titleSize =[self.titleLabel  setAttributedText:self.title  maxW:alertSubMaxWidth - 2*alertSpace lineSpace:1];
       // CGSize  titleSize  = [self.title  sizeWithFont:alertTitleFont maxW:alertSubMaxWidth - 2*alertSpace];
        self.titleLabel.frame =  (CGRect){{alertSpace, alertSpace}, titleSize};
    }
    if (self.message.length) {
        self.messageLabel.textAlignment = self.textAlignment;
        CGSize  messageSize = [self.messageLabel setAttributedText:self.message  maxW:alertSubMaxWidth - 2*alertSpace lineSpace:2];
//        CGSize  messageSize  = [self.message  sizeWithFont:alertTextFont maxW:alertSubMaxWidth - 2*alertSpace];
        self.messageLabel.frame =  (CGRect){{alertSpace,CGRectGetMaxY(self.titleLabel.frame) +alertSpace}, messageSize};
    }
    NSInteger  count = self.buttons.count;
    CGFloat  buttonWidth = 115;
    CGFloat  buttonHeight = 36.5;
    CGFloat  y = CGRectGetMaxY(self.messageLabel.frame) + 2*alertSpace;
    CGFloat  x = (alertSubMaxWidth - count*buttonWidth)/(count+1);
  
    for (NSInteger i = 0; i < count; i++) {
        UIView* view = self.buttons[i];
        view.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        x += CGRectGetMaxX(view.frame);
    }
    self.bounds = CGRectMake(0, 0, alertSubMaxWidth, y+buttonHeight+alertSpace);
    self.center =CGPointMake([UIScreen mainScreen].bounds.size.width/2, ([UIScreen  mainScreen].bounds.size.height )/2);
   
}

-(void)show{
    NSArray *windows = [[UIApplication  sharedApplication]windows];
    for (UIWindow *window in windows) {
       
       
        UIView *firstResponder = [window performSelector:@selector(firstResponder)];
        if (firstResponder) {
            self.firstResponseView = firstResponder;
            [firstResponder  resignFirstResponder];
        }
    }
 
    self.frame = CGRectMake(0, 0, alertSubMaxWidth, 0);
	// Create a new radial gradiant background image to do the screen dimming effect
   //NSArray *array = [[UIApplication sharedApplication] windows];
    self.alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.alertWindow.backgroundColor = [UIColor  clearColor];
    //self.alertWindow.windowLevel = UIWindowLevelAlert;
    self.previousKeyWindow = [[UIApplication sharedApplication] keyWindow];
    //
    self.alertWindow.windowLevel = UIWindowLevelAlert;
    [self.alertWindow makeKeyAndVisible];
	UIView *dimView = [[UIView alloc] initWithFrame:self.alertWindow.bounds];
    dimView.backgroundColor = [UIColor  colorWithRed:0 green:0 blue:0 alpha:0.35];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.alertWindow addSubview:dimView];
        
        [dimView addSubview:self];
    });
}

-(void)dismiss{
    
    
    AHAnimationCompletionBlock completionBlock = ^(BOOL finished)
	{
		// Remove relevant views.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.superview removeFromSuperview];
            
            [self removeFromSuperview];
            [self.previousKeyWindow makeKeyAndVisible];
            [self.firstResponseView becomeFirstResponder];
            self.firstResponseView = nil;
            self.alertWindow = nil;
            self.previousKeyWindow = nil;
        });
   
	};

		[UIView animateWithDuration:0.2
							  delay:0.0
							options:UIViewAnimationOptionCurveEaseIn
						 animations:^
		 {

			 self.superview.alpha = 0;
		 }
						 completion:completionBlock];
	
}



-(void)buttonClicked:(UIButton*)btn{
    
    if ([self.delegate  respondsToSelector:@selector(myNewAlertView:clickedButtonAtIndex:)]) {
        [self.delegate   myNewAlertView:self clickedButtonAtIndex:btn.tag];
    }
     [self  dismiss];
}



@end
