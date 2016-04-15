//
//  ZZBaby.m
//  聪明宝宝
//
//  Created by ZZWangtao on 14-8-25.
//  Copyright (c) 2014年 ZZWangtao. All rights reserved.
//

#import "ZZBaby.h"

@implementation ZZBaby


-(NSInteger)getAgeFromBirthday:(NSString*)date  byAgeShowType:(ZZAgeShowType)ageShowType{
    
  
    NSDateFormatter*  dateFormatter = [[NSDateFormatter  alloc]init];
    [dateFormatter  setDateFormat:@"yyyy年MM月dd日"];
    NSDate *   dateStr = [dateFormatter  dateFromString:date];
    
    NSInteger  size  ;
    
    switch (ageShowType) {
            
        case ZZAgeShowTypeDay:
        {
       //  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
           NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSUInteger unitFlags =  NSCalendarUnitDay;
            NSDateComponents *components = [gregorian components:unitFlags fromDate:dateStr toDate:[NSDate date]options:0];
            
            // NSInteger months = [components month];
            size = [components day]+1;
            
        }
            
            break;
            
        case ZZAgeShowTypeMonth:
            
        {
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSUInteger unitFlags = NSCalendarUnitMonth ;
            
            NSDateComponents *components = [gregorian components:unitFlags fromDate:dateStr toDate:[NSDate  date] options:0];
            
            size = [components month]+1;
            
            
        }
            
            break;
            
        case ZZAgeShowTypeYear:
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSUInteger unitFlags = NSCalendarUnitYear;
            
            NSDateComponents *components = [gregorian components:unitFlags fromDate:dateStr toDate:[NSDate  date] options:0];
            
            size = [components year]+1;
            
        }
            break;
            
        case ZZAgeShowTypeWeek:
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSUInteger unitFlags = NSCalendarUnitWeekdayOrdinal;
            
            NSDateComponents *components = [gregorian components:unitFlags fromDate:dateStr toDate:[NSDate  date] options:0];
            
            size = [components weekdayOrdinal]+1;
            
        }
            
    }
    
    
    return size;
}
//通过生日和 选择的是星座还是生肖 对应返回对应的星座或生肖
-(NSString*)getFashionStateFromBirthday:(NSDate*)date  byFashionState:(ZZFashionState)fashionState{
    
    NSString*  fashion;
    
    switch (fashionState) {
        case ZZFashionStateConstellation:
        {
            NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *comp1 = [myCal components:NSCalendarUnitMonth| NSCalendarUnitDay fromDate:date];
            
            NSInteger month = [comp1 month];
            
            
            NSInteger day = [comp1 day];
            
            fashion = [self  getAstroWithMonth:month day:day];
            
        }
            break;
            
            
            //鼠１，牛２，虎３，兔４，龙５，蛇６，马７，羊８，猴９，鸡１０，狗１１，猪１２
        case ZZFashionStateZodiac:
        {
            NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *comp1 = [myCal components:NSCalendarUnitYear fromDate:date];
            
            NSInteger year = [comp1 year];
            
            
            
            
            fashion = [self  getZodiacWithYear:year];
            
        }
            break;
            
    }
    
    
    return fashion;
}
//根据月 日返回对应星座
-(NSString *)getAstroWithMonth:(NSInteger)m day:(NSInteger)d{
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    
    NSString *astroFormat = @"102123444543";
    
    NSString *result;
    
    if (m<1||m>12||d<1||d>31){
        
        return @"错误日期格式!";
        
    }
    
    if(m==2 && d>29)
        
    {
        
        return @"错误日期格式!!";
        
    }else if(m==4 || m==6 || m==9 || m==11) {
        
        if (d>30) {
            
            return @"错误日期格式!!!";
            
        }
        
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    return [result stringByAppendingString:@"座"];
    
}

-(NSString *)getZodiacWithYear:(NSInteger)y{
    if (y <0) {
        return @"错误日期格式!!!";
    }
    
    NSString *zodiacString = @"鼠牛虎兔龙蛇马羊猴鸡狗猪";
    
    NSRange range = NSMakeRange ((y+9)%12-1, 1);
    
    NSString*  result = [zodiacString  substringWithRange:range];
    
    return [result stringByAppendingString:@"宝宝"];
    
}
-(NSString *)getBirthdayString:(NSDate *)birthday{
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df stringFromDate:birthday];
}
-(NSString*)getRecodeDateString:(NSDate*)recodeDate{
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy年MM月dd日"];
    return [df stringFromDate:recodeDate];
}
/*
-(NSArray*)getPointByRecord:(ZZBabyRecordInfo*)record  andindex:(NSInteger)index{
    
    NSInteger x =0;
    
    CGFloat y = 0;
    
    NSString*  str = nil;
    switch (index) {
        case 0:
            str = record.weight;
            break;
        case 1:
            str = record.height;
            break;
        case 2:
            str = record.outTime;
            break;
        default:
            break;
    }
    
  
    
    x = [self  getAgeFromBirthday:record.date byAgeShowType:ZZAgeShowTypeDay];
    
    //
    y = [  str floatValue];
    
    return @[@(x),@(y)];
}
 */
-(NSString*)getMumKnowByBabyBirthday:(NSDate*)birDate{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // NSUInteger unitFlags = NSCalendarUnitWeekdayOrdinal|NSCalendarUnitYear;
    
    // NSDateComponents *components = [gregorian components:unitFlags fromDate:birDate toDate:[NSDate  date] options:0];
    
    NSInteger  week = [self   getAgeFromBirthday:birDate byAgeShowType:ZZAgeShowTypeWeek];
    
    NSInteger  year= [self   getAgeFromBirthday:birDate byAgeShowType:ZZAgeShowTypeYear];
    
    
    
    
    
    //从已有日期获取日期
    
    NSUInteger units  = NSCalendarUnitMonth;
    
    NSDateComponents *comp1 = [gregorian components:units fromDate:[NSDate  date]];
    
    NSInteger month = [comp1 month];
    
    NSString*  nameStr = nil;
    
    if (week<145) {
        nameStr = [NSString   stringWithFormat:@"Mum,do you know_%ld",week];
    }else{
        NSString* season = nil;
        
        if (month == 3||month ==4||month==5) {
            season=@"spr";
        }else  if(month == 6||month==7||month==8){
            season = @"sum";
        }else if(month == 9||month == 10||month==11){
            season = @"aut";
        }else{
            season = @"win";
        }
        if (year>6) {
            year = 6;
        }
        nameStr = [NSString   stringWithFormat:@"Mum,do you know_%ld_%@",year,season];
    }
    
    
    NSError *error;
    
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString*  content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:nameStr ofType:@"txt"] encoding:encode error: & error];
    if (content) {
        
    }else{
        content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:nameStr ofType:@"txt"] encoding:NSUTF8StringEncoding error: & error];
    }
    if (content.length) {
        NSString*   newContent  =   [content stringByTrimmingCharactersInSet:[NSCharacterSet  newlineCharacterSet]];
        
        return newContent;
    }else{
        return nil;
    }
    
    
    
}
-(NSArray*)getAdvicesByBabyBirthday:(NSDate*)birDate  andSex:(NSInteger)sex{
    
    
    NSInteger  week = [self  getAgeFromBirthday:birDate byAgeShowType:ZZAgeShowTypeWeek];
    NSInteger  month = [self  getAgeFromBirthday:birDate byAgeShowType:ZZAgeShowTypeMonth];
  
    NSInteger  year = [self   getAgeFromBirthday:birDate byAgeShowType:ZZAgeShowTypeYear];
    NSString*  grow  = nil;
    NSString*  feeding   = nil;
    NSString*  nursing  = nil;
    if (week<145) {
        grow  = [NSString   stringWithFormat:@"grow_%ld",month];
        feeding   = [NSString   stringWithFormat:@"feed_%ld",week];
        nursing  = [NSString   stringWithFormat:@"nursing_%ld",week];        // 指标标准
        //arr5 = [arr4[1]  componentsSeparatedByString:@"男孩"];
        //男孩参数
        
        
        
    }else{
        
        if (year>6) {
            year = 6;
        }
        
        grow = [NSString   stringWithFormat:@"grow_%ld_year",year];
        feeding   = [NSString   stringWithFormat:@"feed_%ld_year",year];
        nursing  = [NSString   stringWithFormat:@"nursing_%ld_year",year];
    }

    NSError *error;
    
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString* growContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:grow ofType:@"txt"] encoding:encode error: & error];
    NSString* feedingContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:feeding ofType:@"txt"] encoding:encode error: & error];
    NSString* nursingContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:nursing ofType:@"txt"] encoding:encode error: & error];
    if (growContent) {
        
    }else{
        growContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:grow ofType:@"txt"] encoding:NSUTF8StringEncoding error: & error];
    }
    if (feedingContent) {
        
    }else{
        feedingContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:feeding ofType:@"txt"] encoding:NSUTF8StringEncoding error: & error];
    }
    if (nursingContent) {
        
    }else{
        nursingContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:nursing ofType:@"txt"] encoding:NSUTF8StringEncoding error: & error];
    }
    if (growContent.length&&feedingContent.length&&nursingContent.length) {
        NSString*   newInitialGrowContent  =   [growContent stringByTrimmingCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@"性别"]];
        NSString*   newInitialGrowContent2  =   [newInitialGrowContent  stringByTrimmingCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@"\t"]];
        NSString *newGrowContent= [newInitialGrowContent2  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        NSString*   newFeedingContent  =   [feedingContent stringByTrimmingCharactersInSet:[NSCharacterSet  newlineCharacterSet]];
        NSString*   newNursingContent  =   [nursingContent stringByTrimmingCharactersInSet:[NSCharacterSet  newlineCharacterSet]];
        
        
        NSArray *  growArray = [newGrowContent   componentsSeparatedByString:@"男孩"];
        
        NSArray*  growArray2 = [growArray[1]  componentsSeparatedByString:@"女孩"];
        
        NSString*  growStr = nil;
        if (sex == 2) {
            growStr = growArray2[1];
        }else if(sex == 1){
            growStr = growArray2[0];
        }
        NSArray* advice=@[
                          @{@"护理要点":newNursingContent},
                          @{@"喂养要点":newFeedingContent},
                          @{@"本月发育指标":[NSString  stringWithFormat:@"%@%@",growArray[0],growStr] }];
        return advice;
    }else{
        return nil;
    }
    
    
    
}

//type 1  为周，  2  为年
+(NSArray*)getAdvicesByIndex:(NSUInteger)index    andType:(NSInteger)type{
    
    
    NSInteger  week = index;
    NSInteger  month = week/7+1;
    
    NSInteger  year ;
    NSString*  grow  = nil;
    NSString*  feeding   = nil;
    NSString*  nursing  = nil;
    if (type==1) {
        grow  = [NSString   stringWithFormat:@"grow_%ld",month];
        feeding   = [NSString   stringWithFormat:@"feed_%ld",week];
        nursing  = [NSString   stringWithFormat:@"nursing_%ld",week];        // 指标标准
        //arr5 = [arr4[1]  componentsSeparatedByString:@"男孩"];
        //男孩参数
        
        
        
    }else{
        year = index+3;
        grow = [NSString   stringWithFormat:@"grow_%ld_year",year];
        feeding   = [NSString   stringWithFormat:@"feed_%ld_year",year];
        nursing  = [NSString   stringWithFormat:@"nursing_%ld_year",year];
    }
    
    NSError *error;
    
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString* growContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:grow ofType:@"txt"] encoding:encode error: & error];
    NSString* feedingContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:feeding ofType:@"txt"] encoding:encode error: & error];
    NSString* nursingContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:nursing ofType:@"txt"] encoding:encode error: & error];
    if (growContent) {
        
    }else{
        growContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:grow ofType:@"txt"] encoding:NSUTF8StringEncoding error: & error];
    }
    if (feedingContent) {
        
    }else{
        feedingContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:feeding ofType:@"txt"] encoding:NSUTF8StringEncoding error: & error];
    }
    if (nursingContent) {
        
    }else{
        nursingContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:nursing ofType:@"txt"] encoding:NSUTF8StringEncoding error: & error];
    }
    if (growContent.length&&feedingContent.length&&nursingContent.length) {
        NSString*   newInitialGrowContent  =   [growContent stringByTrimmingCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@"性别"]];
        NSString*   newInitialGrowContent2  =   [newInitialGrowContent  stringByTrimmingCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@"\t"]];
        NSString *newGrowContent= [newInitialGrowContent2  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        NSString*   newFeedingContent  =   [feedingContent stringByTrimmingCharactersInSet:[NSCharacterSet  newlineCharacterSet]];
        NSString*   newNursingContent  =   [nursingContent stringByTrimmingCharactersInSet:[NSCharacterSet  newlineCharacterSet]];
        
        
        NSArray *  growArray = [newGrowContent   componentsSeparatedByString:@"男孩"];
        
        NSArray*  growArray2 = [growArray[1]  componentsSeparatedByString:@"女孩"];
        
       NSArray*  aray = [growArray2[0]  componentsSeparatedByString:@"\t"];
   
        for (int i = 0; i<aray.count/2; i++) {
          
            NSString*  str = [aray[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
            NSString*  indexStr = [aray[i+aray.count/2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
          
            [NSString  stringWithFormat:@"    %@   :   %@",str,indexStr];
          
        }

        NSArray* advice=@[
                          @{@"护理要点":newNursingContent},
                          @{@"喂养要点":newFeedingContent},
                          @{@"男孩发育指标": [self  getStringWithString:   [NSString  stringWithFormat:@"%@%@",growArray[0],growArray2[0]] ]},
                          @{@"女孩发育指标":[self  getStringWithString:   [NSString  stringWithFormat:@"%@%@",growArray[0],growArray2[1]] ]}];
        return advice;
    }else{
        return nil;
    }
    
    
    
}
/*
-(NSInteger)getMaxRecordWithIndex:(NSInteger)index{
    
    NSInteger   maxRecord =1;
    
    
    for (int i = 0; i<self.babyRecordInfoArray.count; i++) {
        
        ZZBabyRecordInfo*  recordInfo = self.babyRecordInfoArray[i];
        
        NSArray*  point = [self  getPointByRecord:recordInfo andindex:index];
          CGFloat y =[[point  lastObject]floatValue];
        if (maxRecord<y) {
            maxRecord= (NSInteger)y;
        }
    }
    return (maxRecord+1);
}

-(NSInteger)getMinRecordWithIndex:(NSInteger)index{
    NSInteger   minRecord =999;
    for (int i = 0; i<self.babyRecordInfoArray.count; i++) {
        
        ZZBabyRecordInfo*  recordInfo = self.babyRecordInfoArray[i];
        NSArray*  point = [self  getPointByRecord:recordInfo andindex:index];
     
        CGFloat y =[[point  lastObject]floatValue];
        if (minRecord>y) {
            minRecord= (NSInteger)y;
        }
    }
    return minRecord;
}
 */
//-(NSString*)getBabyNoteByDate:(NSDate*)date{
//   int   age = (int)[self  getAgeFromBirthday:date byAgeShowType:ZZAgeShowTypeMonth ];
//    if (age>12) {
//        age = (int)[self   getAgeFromBirthday:date byAgeShowType:ZZAgeShowTypeYear];
//        
//        return [NSString   stringWithFormat:@"宝宝 %d岁",age-1];
//    }else  if(age==1){
//        age = (int)[self   getAgeFromBirthday:date byAgeShowType:ZZAgeShowTypeWeek];
//        if (age==1) {
//            age =(int)[ self   getAgeFromBirthday:date byAgeShowType:ZZAgeShowTypeDay];
//             return [NSString   stringWithFormat:@"宝宝婴儿期"];
//        }else{
//              return [NSString   stringWithFormat:@"宝宝婴儿期"];
//        }
//      
//    }else{
//          return [NSString   stringWithFormat:@"宝宝婴儿期"];
//    }
//}

-(NSString*)getGreetingString{
    
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH"];
    NSString* DateString =  [dateFormatter stringFromDate:date];
    int nowDate = [DateString intValue];
    
    NSString*  str =nil;
    if (nowDate>=0&&nowDate<6) {
        str=@"凌晨";
    }else if (nowDate>=6&&nowDate<12){
        
        str=@"早上";
        
    }else if (nowDate>=12&&nowDate<18){
        
        str=@"下午";
    }else if(nowDate>=18&&nowDate<24){
        
        str=@"晚上";
    }
    
    return str;
    
}

+(NSString*)getStringWithString:(NSString*)str{
    NSMutableString*  lastAtr = [NSMutableString  string];
    NSArray*  aray = [str  componentsSeparatedByString:@"\t"];

    for (int i = 0; i<aray.count/2; i++) {
        
        NSString*  str = [aray[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
       
        NSString*  indexStr = [aray[i+aray.count/2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      
        [lastAtr   appendString:[NSString  stringWithFormat:@"    %@   :   %@\n",str,indexStr]] ;
        
    }
    return lastAtr;
}
@end
