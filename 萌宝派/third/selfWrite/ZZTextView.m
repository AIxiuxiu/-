//
//  ZZTextView.m
//  萌宝派
//
//  Created by zhizhen on 15-3-6.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZTextView.h"
@interface ZZTextView ()
@property (nonatomic, strong) UILabel*  placeholderLabel;

@end
@implementation ZZTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super  initWithFrame:frame];
    if (self) {
     
        self.scrollsToTop = NO;
        self.layer.borderColor = [UIColor  colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.enablesReturnKeyAutomatically = YES;
        self.autocorrectionType=UITextAutocorrectionTypeNo;
        self.showsVerticalScrollIndicator=NO;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.alwaysBounceVertical = YES;
        self.layoutManager.allowsNonContiguousLayout=NO;
      
        //self.textContainerInset = UIEdgeInsetsMake(7.5, 3, 7.5, 0);
        [[NSNotificationCenter   defaultCenter]addObserver:self selector:@selector(textViewDidChangeNoti:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

-(UILabel *)placeholderLabel{
    if (!_placeholderLabel) {//WithFrame:CGRectMake(5,5, self.frame.size.width-20, 15)
        _placeholderLabel = [[UILabel  alloc]init];
        _placeholderLabel.font = [UIFont  systemFontOfSize:14];
        _placeholderLabel.textColor = [UIColor   colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    return _placeholderLabel;
}
-(void)setTextContentLength:(NSUInteger)textContentLength{
    _textContentLength= textContentLength;

}
-(void)setPlaceholder:(NSString *)placeholder{
    if (placeholder.length) {
        _placeholder = placeholder ;
        [self  addSubview:self.placeholderLabel];
        self.placeholderLabel.text = placeholder  ;
    }
}



- (void)textViewDidChangeNoti:(NSNotification *)noti{
    if (self.placeholder.length) {
        [self  updatePlaceholderLabelStatus];
    }
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    NSInteger offset = [self offsetFromPosition:position toPosition:[self positionFromPosition:selectedRange.end offset:0]];
    NSString *text = [self.text substringToIndex:(self.text.length -offset)];
    if (self.textContentLength&&text.length > self.textContentLength/2) {
      
        NSInteger textLength = [text  unicodeLength] - offset;
        if (textLength <= self.textContentLength||textLength <0 ) {
           
            return;
        }else{
           
            for (NSUInteger lenth = self.textContentLength/2; lenth < textLength; lenth++) {
                if ([[text  substringToIndex:lenth] unicodeLength] > self.textContentLength) {
                    self.text = [text  substringToIndex:lenth-1];
                    break;
                }
            }
        }

    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.placeholder.length) {
        self.placeholderLabel.y = 8;
        self.placeholderLabel.x = 5;
        self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
        // 根据文字计算label的高度
        CGSize placehoderSize = [self.placeholder sizeWithFont:self.placeholderLabel.font maxW:self.placeholderLabel.width];
        self.placeholderLabel.height = placehoderSize.height;
        [self  updatePlaceholderLabelStatus];
    }
}


-(void)dealloc{
    [[NSNotificationCenter  defaultCenter]removeObserver:self ];
}


-(void)updatePlaceholderLabelStatus{
        if (self.text.length) {
            self.placeholderLabel.hidden = YES;
        }else{
            self.placeholderLabel.hidden = NO;
        }
}

@end
