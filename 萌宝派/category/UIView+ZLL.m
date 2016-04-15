//
//  UIView+ZLL.m
//  萌宝派
//
//  Created by zhizhen on 15/6/15.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//
static CGFloat const vOffsetX = 10;
static CGFloat const vDuration = 0.06;
static NSUInteger const vRepeatCount = 3;
#import "UIView+ZLL.h"

@implementation UIView (ZLL)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}


+(UIView*)viewByChildView:(UIView*)view{
    
    if ([view isKindOfClass:[self  class]]) {
        return view;
    }else{
        if(view.class == nil){
            return nil;
        }
        return  [self  viewByChildView:view.superview];
    }
}

-(void)setLayerCornerRadius:(CGFloat) redius{
    if (redius<=0) {
        return;
    }
    
    self.layer.cornerRadius = redius;
    self.layer.masksToBounds = YES;
}

-(void)setViewContentMode:(UIViewContentMode)viewContentMode{
    self.clipsToBounds = YES;
    self.contentMode = viewContentMode;
}

- (NSMutableAttributedString *)getAttributedStringWithText:(NSString *)text paragraphSpacing:(CGFloat)paragraphSpacing lineSpace:(CGFloat)lineSpace stringCharacterSpacing:(CGFloat)stringCharacterSpacing  textAlignment:(NSTextAlignment) textAlignment font:(UIFont *)font  color:(UIColor *)color{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString   alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle  alloc] init];
    paragraphStyle.alignment = textAlignment;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //    paragraphStyle.maximumLineHeight = 60;  //最大的行高
    if (lineSpace<0) {
        lineSpace = 0;
    }
    if (paragraphSpacing < 0) {
        paragraphSpacing = 0;
    }
    paragraphStyle.lineSpacing = lineSpace;  //行自定义行高度
    paragraphStyle.paragraphSpacing = paragraphSpacing;  //段间距
    // [paragraphStyle setFirstLineHeadIndent:self.usernameLabel.frame.size.width + 5];//首行缩进 根据用户昵称宽度在加5个像素
    NSRange range = NSMakeRange(0,attributedString.length);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    //字体大小
    if (font) {
        [attributedString  addAttributes:@{NSFontAttributeName:font} range:range];
    }
    if (color) {
        [attributedString  addAttributes:@{NSForegroundColorAttributeName :color} range:range];
    }
    //字间距
   
    long number = stringCharacterSpacing;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString addAttribute:NSKernAttributeName value:(__bridge id)num range:range];
    CFRelease(num);
    
   
    return attributedString;
}
- (void)shakeAnimation:(CGFloat)offsetX duration:(CGFloat)duration repeatCount:(NSUInteger)repeatCount

{
    offsetX = offsetX > 0 ? offsetX : vOffsetX;
    duration = duration > 0 ? duration : vDuration;
    repeatCount = repeatCount > 0 ? repeatCount : vRepeatCount;
    // 获取到当前的View
    CALayer *viewLayer = self.layer;
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + offsetX, position.y);
    CGPoint y = CGPointMake(position.x - offsetX, position.y);
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    // 设置自动反转
    [animation setAutoreverses:YES];
    // 设置时间
    [animation setDuration:duration];
    // 设置次数
    [animation setRepeatCount:repeatCount];
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}
- (void)shakeAnimation{
    [self  shakeAnimation:vOffsetX duration:vDuration repeatCount:vRepeatCount];
}
@end
