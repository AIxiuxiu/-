//
//  NSString+ZLLUsual.h
//  萌宝派
//
//  Created by zhizhen on 15/6/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZLLUsual)
/**
 *  移除字符串前后的回车和空格
 *
 *  @return 返回格式化后的字符串
 */
-(NSString*)removeWhitespaceAndNewlineCharacter;
/**
 *  根据字数截取字符串
 *
 *  @param wordCount 需要的字符数
 *
 *  @return 返回截取后的字符串
 */
-(NSString*)subStringFromTitleOrcontentWithLength:(NSUInteger)wordCount;

/**
 *  计算字符串高度
 *
 *  @param font <#font description#>
 *  @param maxW <#maxW description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size;
/**
 *  计算字符长度，一个汉字为两个字符，一个英文字母为一个字符
 *
 *  @return <#return value description#>
 */
- (NSUInteger)unicodeLength;

/**
 *  是否是电话号码
 *
 *  @return <#return value description#>
 */
- (BOOL)isPhoneNumber;

/**
 *  是否是验证码
 *
 *  @return <#return value description#>
 */
- (BOOL)isSecutityNumber;

/**
 *  符合密码的长度
 *
 *  @param min <#min description#>
 *  @param max <#max description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)isPassWordWithMin:(NSUInteger)min max:(NSUInteger)max;

- (NSMutableAttributedString *)getReplyAttributedStringFont:(UIFont *)font  color:(UIColor *)color;
@end
