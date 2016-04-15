//
//  ZZMyAlertView.m
//  聪明宝宝
//
//  Created by zhizhen on 14-9-2.
//  Copyright (c) 2014年 zhizhen. All rights reserved.
//

#import "ZZMyAlertView.h"

@interface ZZMyAlertView ()

//@property (nonatomic, strong) UIWindow *alertWindow;
//@property (nonatomic, strong) UIWindow *previousKeyWindow;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *destructiveButton;
@property(nonatomic, copy) NSString *cancelBtnTitle;

@property(nonatomic, copy) NSString *sureBtnTitle;

@end


@implementation ZZMyAlertView



-(UILabel *)messageLabel{
    
    if (!_messageLabel) {
        _messageLabel = [[UILabel  alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 50)];
        
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = ZZTitleBoldFont;
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        [self  addSubview:_messageLabel];
    }
    
    return _messageLabel;
}

-(UIButton *)cancelButton{
    
    if (!_cancelButton) {
        
        _cancelButton = [[UIButton  alloc]initWithFrame:CGRectMake(10, 70, 115, 36.5)];
        
        [_cancelButton  addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
       // [_cancelButton setTitleColor: [UIColor  grayColor] forState:UIControlStateNormal];
        
        _cancelButton.tag = 0;
        
        _cancelButton.layer.cornerRadius = 5.0f;
        
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.titleLabel.font = ZZButtonBoldFont;
        _cancelButton.backgroundColor = [UIColor  colorWithRed:0.45 green:0.8 blue:0.21 alpha:0.92];
        

    }
    
    return _cancelButton;
}
-(UIButton *)destructiveButton{
    
    if (!_destructiveButton) {
        
        _destructiveButton = [[UIButton  alloc]initWithFrame:CGRectMake(135, 70, 115, 36.5)];
        
        [_destructiveButton  addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _destructiveButton.titleLabel.font = ZZButtonBoldFont;
        _destructiveButton.backgroundColor = [UIColor  colorWithRed:0.1 green:0.63 blue:0.96 alpha:0.93];
        
        _destructiveButton.layer.cornerRadius  = 5.0;
        
        _destructiveButton.layer.masksToBounds = YES;
        
        _destructiveButton.tag = 1;
        
     
    }
    
    return _destructiveButton;
}


- (id)initWithMessage:(NSString *)message delegate:(id <ZZMyAlertViewDelgate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle sureButtonTitle:(NSString *)sureButtonTitle{
    
    CGRect frame = CGRectMake(0, 0, ScreenWidth -60, 120);
    
   if (cancelButtonTitle.length == 0&&sureButtonTitle.length==0) {
        
        frame =  CGRectMake(0, 0, ScreenWidth - 60, 70);
   }

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor  whiteColor];
        
        self.message = message;
        
        self.delegate = delegate;
        
        self.cancelBtnTitle = cancelButtonTitle;
        
        self.sureBtnTitle = sureButtonTitle;
        
        self.layer.cornerRadius = 5;
        
        self.layer.masksToBounds = YES;
    }
    return self;
}
-(void)layoutSubviews{
    
    [super  layoutSubviews];
    
    self.messageLabel.text = self.message;

    [self  addSubview:self.messageLabel];

    if (self.cancelBtnTitle.length==0 || self.sureBtnTitle.length==0) {
        
       
        if (self.cancelBtnTitle==0&&self.sureBtnTitle>0) {
            
            [self.destructiveButton  setTitle:self.sureBtnTitle forState:UIControlStateNormal];
         
            [self  addSubview:self.destructiveButton];
            
            self.destructiveButton.frame =CGRectMake(60, 70, 140, 35);
            self.destructiveButton.centerX = self.width/2;
        } else if ( self.sureBtnTitle==0&&self.cancelBtnTitle>0){
            
             [self.cancelButton  setTitle:self.cancelBtnTitle forState:UIControlStateNormal];
            
            [self  addSubview:self.cancelButton];
            
            self.cancelButton.frame =CGRectMake(60, 70, 140, 35);
            self.cancelButton.centerX = self.width/2;
        }
        
    }else{
        
        [self.cancelButton  setTitle:self.cancelBtnTitle forState:UIControlStateNormal];
        
        [self  addSubview:self.cancelButton];
        
        [self.destructiveButton  setTitle:self.sureBtnTitle forState:UIControlStateNormal];
        
        [self  addSubview:self.destructiveButton];
        
        CGFloat  margin = 10;
        CGFloat  separ = (self.width - 3*margin - 2*115)/3;
        self.cancelButton.x += separ;
        self.destructiveButton.x += separ*2;
    }
    
    if (self.backgroundImage) {
        
        self.backgroundColor = [UIColor  colorWithPatternImage:self.backgroundImage];
    }
    
    self.center =CGPointMake([UIScreen mainScreen].bounds.size.width/2, ([UIScreen  mainScreen].bounds.size.height )/2);
    
}

-(void)show{
   

    
	// Create a new radial gradiant background image to do the screen dimming effect
   UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
	UIView *dimView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    
	//dimView.image = [UIImage  imageNamed:@"background3"];
    
    dimView.backgroundColor = [UIColor  colorWithRed:0 green:0 blue:0 alpha:0.5];
    
	//dimView.userInteractionEnabled = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [keyWindow addSubview:dimView];
        
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
        });
      
        
      
        
        // Restore previous key window and tear down our own window
   
	};
	
	
		// This animation does a Tweetbot-style tumble animation where the alert view "falls"
		// off the screen while rotating slightly off-kilter. Use sparingly.
		[UIView animateWithDuration:0.2
							  delay:0.0
							options:UIViewAnimationOptionCurveEaseIn
						 animations:^
		 {
//			 CGPoint offset = CGPointMake(0, self.superview.bounds.size.height * 1.5);
//			 offset = CGPointApplyAffineTransform(offset, self.transform);
//			 self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeRotation(-M_PI_4));
//			 self.center = CGPointMake(self.center.x + offset.x, self.center.y + offset.y);
			 self.superview.alpha = 0;
		 }
						 completion:completionBlock];
	
}



-(void)buttonClicked:(UIButton*)btn{
    
   
    
    [self.delegate   alertView:self clickedButtonAtIndex:btn.tag  ];
    
     [self  dismiss];
    //NSLog(@"ddd");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
