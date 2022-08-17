//
//  NSString+ZIMKitUtil.m
//  ZIMKit
//
//  Created by zego on 2022/5/21.
//

#import "NSString+ZIMKitUtil.h"

@implementation NSString (ZIMKitUtil)

+ (NSString *)convertDateToStr:(long long )timestamp
{
    NSDate *msgDate = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp/1000];
    
    NSDate *nowDate = [NSDate date];
    if (!msgDate) return nil;
    
    long long msgTime = [self dateConvert:msgDate];
    long long nowTime = [self dateConvert:nowDate];
    
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];

    NSTimeInterval OnedayTimeIntervalValue = 24*60*60;
    
    long long marginTime = (nowTime - msgTime)/1000;
    if ( marginTime < OnedayTimeIntervalValue) {
        return [self stringFromDate:msgDate format:@"HH:mm"];
    } else if (marginTime< 2*OnedayTimeIntervalValue && marginTime >= OnedayTimeIntervalValue) {
        return [NSString stringWithFormat:@"%@ %@",[NSBundle ZIMKitlocalizedStringForKey:@"common_yesterday"],[self stringFromDate:msgDate format:@"HH:mm"]];
    } else if (marginTime < 7 *OnedayTimeIntervalValue) {
        return [self stringFromDate:msgDate format:@"EEEE HH:mm"];
    } else {
        if (nowDateComponents.year != msgDateComponents.year) {
            return [self stringFromDate:msgDate format:@"yyyy-MM-dd HH:mm"];
        } else {
            return [self stringFromDate:msgDate format:@"MM-dd HH:mm"];
        }
    }
}

+ (NSString *)conversationConvertDateToStr:(long long )timestamp
{
    NSDate *msgDate = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp/1000];
    
    NSDate *nowDate = [NSDate date];
    if (!msgDate) return nil;
    
    long long msgTime = [self dateConvert:msgDate];
    long long nowTime = [self dateConvert:nowDate];
    
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];

    NSTimeInterval OnedayTimeIntervalValue = 24*60*60;
    
    long long marginTime = (nowTime - msgTime)/1000;
    if ( marginTime < OnedayTimeIntervalValue) {
        return [self stringFromDate:msgDate format:@"HH:mm"];
    } else if (marginTime< 2*OnedayTimeIntervalValue && marginTime >= OnedayTimeIntervalValue) {
        return [NSString stringWithFormat:@"%@",[NSBundle ZIMKitlocalizedStringForKey:@"common_yesterday"]];
    } else if (marginTime < 7 *OnedayTimeIntervalValue) {
        return [self stringFromDate:msgDate format:@"EEEE"];
    } else {
        if (nowDateComponents.year != msgDateComponents.year) {
            return [self stringFromDate:msgDate format:@"yyyy-MM-dd"];
        } else {
            return [self stringFromDate:msgDate format:@"MM-dd"];
        }
    }
}

+ (NSString *)convertDateToStr2:(long long )timestamp
{
    NSDate *msgDate = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp/1000];
    NSDate *nowDate = [NSDate date];
    if (!msgDate) return nil;
    
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];

    NSTimeInterval OnedayTimeIntervalValue = 24*60*60;
    
    BOOL isSameMonth = (nowDateComponents.year == msgDateComponents.year) && (nowDateComponents.month == msgDateComponents.month);

    if(isSameMonth && (nowDateComponents.day == msgDateComponents.day)) //同一天,显示时间
    {
        return [self stringFromDate:msgDate format:@"HH:mm"];
    }
    else if(isSameMonth && (nowDateComponents.day == (msgDateComponents.day+1)))//昨天
    {
        return [NSString stringWithFormat:@"%@",[NSBundle ZIMKitlocalizedStringForKey:@"common_yesterday"]];
    }
    else if([nowDate timeIntervalSinceDate:msgDate] < 7 * OnedayTimeIntervalValue)//一周内
    {
        return [self stringFromDate:msgDate format:@"EEEE HH:mm"];
    }
    else if (nowDateComponents.year != msgDateComponents.year)
   {
       return [self stringFromDate:msgDate format:@"yyyy-MM-dd HH:mm"];
       
   } else {
       return [self stringFromDate:msgDate format:@"MM-dd HH:mm"];
   }
}

+ (NSInteger)getDifferenceByDate:(NSDate *)oldDate {
        //获得当前时间
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitHour;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
    return [comps day];
}

// 将时间戳转化成0晨0点时间
+ (long long )dateConvert:(NSDate *)now
{
    NSCalendar *cal = [NSCalendar currentCalendar];

    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    NSDateComponents *zerocompents = [cal components:unitFlags fromDate:now];

    // 转化成0晨0点时间
    zerocompents.hour = 0;
    zerocompents.minute = 0;
    zerocompents.second = 0;

    // NSdatecomponents转NSdate类型
    NSDate *newdate= [cal dateFromComponents:zerocompents];
    
//    return newdate;

     //时间转毫秒的时间戳格式(该时间已经是当天凌晨零点的时刻)
    NSTimeInterval zerointerval = [newdate timeIntervalSince1970]*1000;
    long long time = (long long)zerointerval;
    return time;
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:format];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    dateFormatter = nil;
    return destDateString;
}

+ (NSArray *)transformSpell2Pinyin:(NSString *)hanzi {
    
    //转换成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:hanzi];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (int i = 0; i < pinyinArray.count; i++) {
        [allString appendFormat:@"%@",pinyinArray[i]];
    }
    [result addObject:allString];
    
    NSMutableString *initialStr = [NSMutableString new]; //拼音首字母
    
    for (NSString *s in pinyinArray) {
        
        if (s.length > 0) {
            [initialStr appendString:[s substringToIndex:1]];
        }
    }
    [result addObject:initialStr];
    
    if (initialStr.length > 0) {
        
        NSString *firstS = nil;
        unichar ch_chr = [initialStr characterAtIndex:0];
        if ((ch_chr >= 'A' && ch_chr <= 'Z') || (ch_chr >= 'a' && ch_chr <= 'z')) {
            // 第一个是字母
            firstS = [[NSString stringWithFormat:@"%c",ch_chr] lowercaseString];
                
        } else {
//            firstS = @"#";
            firstS = [[NSString stringWithFormat:@"%c",ch_chr] uppercaseString];
                
        }
        [result addObject:firstS];
    
    }
    
    return result;
    
}

- (UIImage *)getExpressionWithName:(NSString *)name {
    UIImage *image; //二期表情用
    return image;
}

+ (BOOL) isEmpty:(NSString *)str {
    if (!str) {
        return YES;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if (trimedString.length == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (NSString *)getCurrentThumbFileName:(NSString *)extension
{
    /**
     *  由于同时发多张图片 使用时间戳 导致所有的图片文件名都是一个  ->添加随机数
     */
  
    return [NSString stringWithFormat:@"%d%0.0f_thumb_%@", arc4random() % 10000,[[NSDate date] timeIntervalSince1970] *1000,extension];
}

@end
