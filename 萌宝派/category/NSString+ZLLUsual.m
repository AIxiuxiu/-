//
//  NSString+ZLLUsual.m
//  萌宝派
//
//  Created by zhizhen on 15/6/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "NSString+ZLLUsual.h"
#import <CoreText/CoreText.h>
@implementation NSString (ZLLUsual)
//移除内容前后的空格和回车
-(NSString*)removeWhitespaceAndNewlineCharacter;{
    return [self   stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
}

//截取一定长度的字符串
-(NSString*)subStringFromTitleOrcontentWithLength:(NSUInteger)wordCount{
    
    NSString*  text = self;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSUInteger  subWordCount = wordCount/2;
    NSData* da = [text dataUsingEncoding:enc];
    if (da.length>wordCount) {
        NSString*  str = nil;
        for (NSUInteger i = subWordCount; i<text.length; i++) {
            
            if ([[text substringToIndex:i] dataUsingEncoding:enc].length >= wordCount) {
                
                str = [text substringToIndex:i];
                
                break;
            }
        }
        return str;
    }else{
        return text;
    }
}

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    if(font == nil){
        font = [UIFont  systemFontOfSize:16];
    }
  
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize  backSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
     return CGSizeMake(ceil(backSize.width)+1, ceil(backSize.height));
}
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size{
    if(font == nil){
        font = [UIFont  systemFontOfSize:16];
    }
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    CGSize  backSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
  
    return CGSizeMake(ceil(backSize.width)+1, ceil(backSize.height));
}
-(NSUInteger) unicodeLength
{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar uc = [self characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    //    NSUInteger unicodeLength = asciiLength / 2;
    //    if(asciiLength % 2) {
    //        unicodeLength++;
    //    }
    return asciiLength;
}

- (BOOL)isPhoneNumber{
    NSString *telRegex = @"^1[34578]\\d{9}$";
    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    return [prediate evaluateWithObject:self];
}
- (BOOL)isSecutityNumber{
    NSString *telRegex = @"[0-9]{6}$";
    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    return [prediate evaluateWithObject:self];
}


- (BOOL)isPassWordWithMin:(NSUInteger)min max:(NSUInteger)max{
      NSString *telRegex = [NSString  stringWithFormat:@"[A-Za-z0-9]{%ld,%ld}$", min,max];
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",telRegex];
    return [emailTest evaluateWithObject:self];
}

- (NSMutableAttributedString *)getReplyAttributedStringFont:(UIFont *)font  color:(UIColor *)color{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString   alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle  alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //    paragraphStyle.maximumLineHeight = 60;  //最大的行高

    paragraphStyle.lineSpacing = ZZReplyLineSpace;  //行自定义行高度
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
    long number = ZZCharSpace;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString addAttribute:NSKernAttributeName value:(__bridge id)num range:range];
    CFRelease(num);
    
    return attributedString;
}
@end
