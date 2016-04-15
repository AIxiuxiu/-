//
//  NSObject+Extension.m
//  萌宝派
//
//  Created by zhizhen on 15/7/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "NSObject+Extension.h"
#import <mach/mach_time.h>
#import <CoreText/CoreText.h>


@implementation NSObject (Extension)
-(void)codeBlockCostTime:(void (^)(void))block{
    uint64_t begin = mach_absolute_time();//开始时间

    block();
    uint64_t end = mach_absolute_time();//结束时间
    
    uint64_t middle  = end - begin;
    ZZLog(@"\n代码耗费时间： %g s\n",MachTimeToSecs(middle));
}

double MachTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer /
    (double)timebase.denom /1e9;
}

- (CGSize)getiSizeWithAttString:(NSAttributedString *)attrStr size:(CGSize)size{

 CGRect bounds =   [attrStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return bounds.size;
 // return CGSizeMake(size.width, [self  getAttributedStringHeightWithString:attrStr WidthValue:size.width]);
   
}

- (CGSize)sizeWithLimitSize:(CGSize)limitSize originSize:(CGSize)originSize{
    CGFloat maxW = limitSize.width > 0 ? limitSize.width : 100;
    CGFloat maxH = limitSize.height > 0 ? limitSize.height : 100;
    CGFloat maxhwScale = maxH /maxW;
    
    CGFloat originW = originSize.width > 0 ? originSize.width : 100;
    CGFloat originH = originSize.height > 0 ? originSize.height : 100;
    CGFloat originhwScale = originH /originW;

    CGFloat backW = 0;
    CGFloat backH = 0;
        if (originW >maxW || originH > maxH) {
            if (maxhwScale > originhwScale) {
                backW = maxW < originW ? maxW :originW;
                backH = backW * originhwScale;
            }else{
                backH = maxH < originH ? maxH : originH;
                backW = backH /originhwScale;
            }
        }else{
            backW = originW;
            backH = originH;
        }
    return CGSizeMake(backW, backH);
}

- (int)getAttributedStringHeightWithString:(NSAttributedString *)  string  WidthValue:(int) width
{
    
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 100000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 100000- line_y + (int) descent +1;//+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
//    
//    int total_height = 0;
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
//    CGRect drawingRect = CGRectMake(0, 0, width, 100000);  //这里的高要设置足够大
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, drawingRect);
//    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
//    CGPathRelease(path);
//    CFRelease(framesetter);
//    
//    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
//    
//    CGPoint origins[[linesArray count]];
//    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
//    
//    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
//    
//    CGFloat ascent;
//    CGFloat descent;
//    CGFloat leading;
//    
//    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
//    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
//    
//    total_height = 100000 - line_y + (int) descent+(int)ascent +2;//+1为了纠正descent转换成int小数点后舍去的值
//    
//    CFRelease(textFrame);
//    
//    return total_height;
    

}
@end
