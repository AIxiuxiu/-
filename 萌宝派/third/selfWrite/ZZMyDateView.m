//
//  ZZMyDateView.m
//  聪明宝宝
//
//  Created by zhizhen on 14-9-2.
//  Copyright (c) 2014年 zhizhen. All rights reserved.
//

#import "ZZMyDateView.h"

@implementation ZZMyDateView


-(instancetype)initWithFrame:(CGRect)frame  andString:(NSString*)str{
    self = [super  initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        
        self.backgroundColor = [UIColor  whiteColor];
        self.layer.borderColor = [UIColor  blackColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.shadowColor = [UIColor  blackColor].CGColor;
        
        self.layer.shadowRadius = 1;
        
        self.layer.shadowOffset = CGSizeMake(0, 1);
        
        self.layer.shadowOpacity = 0.3;
        
        self.layer.masksToBounds = YES;
        
        UIView *middleSepView = [[UIView alloc] initWithFrame:CGRectMake(2, 46+(self.frame.size.height-114)/2, self.frame.size.width-4, 23)];
        
        [middleSepView setBackgroundColor:[UIColor grayColor]];
        
        [self addSubview:middleSepView];
        
        self.birthday =str;
        
        self.userInteractionEnabled=YES;
        
        [self  setYearScrollView];
        
        [self  setMonthScrollView];
        
        [self  setDayScrollView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
           }
    return self;
}



//设置年月日时分的滚动视图
- (void)setYearScrollView
{
    self.yearScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake((self.frame.size.width-140)/2, (self.frame.size.height-114)/2, 60, 114)];
    NSInteger yearint = [self setNowTimeShow:0];
    [self.yearScrollView setCurrentSelectPage:(yearint-2002)];
    self.yearScrollView.delegate = self;
    self.yearScrollView.datasource = self;
   [self setAfterScrollShowView:self.yearScrollView andCurrentPage:1];
    [self addSubview:self.yearScrollView];
    
}
//设置年月日时分的滚动视图
- (void)setMonthScrollView
{
    self.monthScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake((self.frame.size.width-140)/2+60, (self.frame.size.height-114)/2, 40, 114)];
  NSInteger monthint = [self setNowTimeShow:1];
    [self.monthScrollView setCurrentSelectPage:(monthint-3)];
    self.monthScrollView.delegate = self;
    self.monthScrollView.datasource = self;
   [self setAfterScrollShowView:self.monthScrollView andCurrentPage:1];
    [self addSubview:self.monthScrollView];
}
//设置年月日时分的滚动视图
- (void)setDayScrollView
{
    self.dayScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake((self.frame.size.width-140)/2+100, (self.frame.size.height-114)/2, 40, 114)];
    NSInteger dayint = [self setNowTimeShow:2];
    [self.dayScrollView setCurrentSelectPage:(dayint-3)];
    self.dayScrollView.delegate = self;
    self.dayScrollView.datasource = self;
    [self setAfterScrollShowView:self.dayScrollView andCurrentPage:1];
    [self addSubview:self.dayScrollView];
}
//
//-(void)layoutSubviews{
//    NSInteger yearint = [self setNowTimeShow:0];
//    [self.yearScrollView setCurrentSelectPage:(yearint-2002)];
//    
//    [self setAfterScrollShowView:self.yearScrollView andCurrentPage:1];
//    
//    //
//    NSInteger monthint = [self setNowTimeShow:1];
//    [self.monthScrollView setCurrentSelectPage:(monthint-3)];
//  
//    [self setAfterScrollShowView:self.monthScrollView andCurrentPage:1];
//    
//    //
//    NSInteger dayint = [self setNowTimeShow:2];
//    [self.dayScrollView setCurrentSelectPage:(dayint-3)];
//   
//    [self setAfterScrollShowView:self.dayScrollView andCurrentPage:1];
//}
//

- (void)setAfterScrollShowView:(MXSCycleScrollView*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    UILabel *oneLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber];
  
    [oneLabel setFont:[UIFont systemFontOfSize:14]];
    [oneLabel setTextColor: [UIColor colorWithRed:75.0/255 green:75.0/255 blue:75.0/255 alpha:1]];
    UILabel *twoLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+1];

    [twoLabel setFont:[UIFont systemFontOfSize:16]];
    [twoLabel setTextColor: [UIColor colorWithRed:75.0/255 green:75.0/255 blue:75.0/255 alpha:1]];
    
    UILabel *currentLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+2];

    [currentLabel setFont:[UIFont systemFontOfSize:18]];
    [currentLabel setTextColor:  [UIColor whiteColor]];
    
    UILabel *threeLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+3];
 
    [threeLabel setFont:[UIFont systemFontOfSize:16]];
    [threeLabel setTextColor: [UIColor colorWithRed:75.0/255 green:75.0/255 blue:75.0/255 alpha:1]];
    UILabel *fourLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+4];

    [fourLabel setFont:[UIFont systemFontOfSize:14]];
    [fourLabel setTextColor: [UIColor colorWithRed:75.0/255 green:75.0/255 blue:75.0/255 alpha:1]];
}



#pragma mark mxccyclescrollview delegate
#pragma mark mxccyclescrollview databasesource
- (NSInteger)numberOfPages:(MXSCycleScrollView*)scrollView
{
    if (scrollView == self.yearScrollView) {
        return 99;
    }
    else if (scrollView == self.monthScrollView)
    {
        return 12;
    }
    else if (scrollView == self.dayScrollView)
    {
        return 31;
    }
    return 60;
    
}
- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(MXSCycleScrollView *)scrollView
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height/5)];
    l.tag = index+1;
    if (scrollView == self.yearScrollView) {
        l.text = [NSString stringWithFormat:@"%ld",2000+index];
    }
    else if (scrollView == self.monthScrollView)
    {
        l.text = [NSString stringWithFormat:@"%ld",1+index];
    }
    else if (scrollView == self.dayScrollView)
    {
        l.text = [NSString stringWithFormat:@"%ld",1+index];
    }
    else
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld",index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld",index];
    
    l.font = [UIFont systemFontOfSize:12];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor clearColor];
    return l;
}


//设置现在时间
- (NSInteger)setNowTimeShow:(NSInteger)timeType
{
    //    NSDate *now = [NSDate date];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //    NSString *dateString = [dateFormatter stringFromDate:now];
    
    NSString *dateString =self.birthday;
    
    switch (timeType) {
        case 0:
        {
            NSRange range = NSMakeRange(0, 4);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 1:
        {
            NSRange range = NSMakeRange(5, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 2:
        {
            NSRange range = NSMakeRange(8, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;

    }
    return 0;
}
//选择设置的播报时间

//滚动时上下标签显示(当前时间和是否为有效时间)
- (void)scrollviewDidChangeNumber
{
    UILabel *yearLabel = [[(UILabel*)[[self.yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *monthLabel = [[(UILabel*)[[self.monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *dayLabel = [[(UILabel*)[[self.dayScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    
    
    NSInteger yearInt = yearLabel.tag + 1999;
    NSInteger monthInt = monthLabel.tag;
    NSInteger dayInt = dayLabel.tag;
    

    
    NSString*  dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",yearInt,monthInt,dayInt];
    if ((monthInt==4||monthInt==6||monthInt==9||monthInt==11)&&(dayInt==31)) {
       dateStr=@"输入错误";
    }
    
    if ((yearInt%4==0)&&(yearInt%100!=0)&&(monthInt==2)&&(dayInt==30||dayInt==31)) {
        dateStr=@"输入错误";
    }
    
    if ((yearInt%4!=0)&&(monthInt==2)&&(dayInt==29||dayInt==30||dayInt==31)) {
        dateStr=@"输入错误";
    }
    
    [self.delegate  getDateStr:dateStr];
    
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
