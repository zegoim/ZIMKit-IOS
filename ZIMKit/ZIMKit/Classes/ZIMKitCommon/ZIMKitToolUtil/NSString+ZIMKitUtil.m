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

    if(isSameMonth && (nowDateComponents.day == msgDateComponents.day)) //?????????,????????????
    {
        return [self stringFromDate:msgDate format:@"HH:mm"];
    }
    else if(isSameMonth && (nowDateComponents.day == (msgDateComponents.day+1)))//??????
    {
        return [NSString stringWithFormat:@"%@",[NSBundle ZIMKitlocalizedStringForKey:@"common_yesterday"]];
    }
    else if([nowDate timeIntervalSinceDate:msgDate] < 7 * OnedayTimeIntervalValue)//?????????
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
        //??????????????????
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitHour;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
    return [comps day];
}

// ?????????????????????0???0?????????
+ (long long )dateConvert:(NSDate *)now
{
    NSCalendar *cal = [NSCalendar currentCalendar];

    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    NSDateComponents *zerocompents = [cal components:unitFlags fromDate:now];

    // ?????????0???0?????????
    zerocompents.hour = 0;
    zerocompents.minute = 0;
    zerocompents.second = 0;

    // NSdatecomponents???NSdate??????
    NSDate *newdate= [cal dateFromComponents:zerocompents];
    
//    return newdate;

     //?????????????????????????????????(?????????????????????????????????????????????)
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
    
    //???????????????????????????
    NSMutableString *str = [NSMutableString stringWithString:hanzi];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    //?????????????????????????????????
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (int i = 0; i < pinyinArray.count; i++) {
        [allString appendFormat:@"%@",pinyinArray[i]];
    }
    [result addObject:allString];
    
    NSMutableString *initialStr = [NSMutableString new]; //???????????????
    
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
            // ??????????????????
            firstS = [[NSString stringWithFormat:@"%c",ch_chr] lowercaseString];
                
        } else {
//            firstS = @"#";
            firstS = [[NSString stringWithFormat:@"%c",ch_chr] uppercaseString];
                
        }
        [result addObject:firstS];
    
    }
    
    return result;
    
}


- (CGSize)sizeAttributedWithFont:(UIFont *)font width:(CGFloat)width  wordWap:(NSLineBreakMode)lineBreadMode {
    NSAttributedString *string = [self processCommentContentWithFont:font wordWap:lineBreadMode];
    
    // ??????YYTextLayout????????????
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(width, MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:string];
    CGSize textSize = textLayout.textBoundingSize;
    CGFloat textWidth = textSize.width;
    CGFloat textHeight = textSize.height;

    return  CGSizeMake(ceil(textWidth), ceil(textHeight));
}

- (NSMutableAttributedString *)processCommentContentWithFont:(UIFont *)font wordWap:(NSLineBreakMode)lineBreadMode {
    //???????????????????????????
    NSMutableAttributedString *mAttributedString = [[NSMutableAttributedString alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:2];
//    [paragraphStyle setParagraphSpacing:2];
    paragraphStyle.lineBreakMode = lineBreadMode;
    NSDictionary *attri = [NSDictionary dictionaryWithObjects:@[font, paragraphStyle] forKeys:@[NSFontAttributeName, NSParagraphStyleAttributeName]];
    [mAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:self attributes:attri]];
    //????????????????????????????????????????????????
    NSString *pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    //??????????????????
    NSError *error;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    //??????
    if (!regularExpression) { //???????????????????????????nil
        NSLog(@"?????????????????????");
        NSLog(@"error = %@",[error localizedDescription]);
        return nil;
    } else {
        NSArray *resultArray = [regularExpression matchesInString:mAttributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, mAttributedString.string.length)];
        //???????????? ????????????
        for (NSInteger i = resultArray.count - 1; i >= 0; i--) {
            //??????????????????????????????range
            NSTextCheckingResult *result = resultArray[i];
            //??????range???????????????
            NSString *rangeString = [mAttributedString.string substringWithRange:result.range];
            //????????????
            UIImage *image = [self getExpressionWithName:rangeString];//???????????????????????????
            
            if (image != nil) {
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithEmojiImage:image fontSize:15.0f];
                attachText.yy_lineBreakMode = lineBreadMode;
                //????????????
                [mAttributedString replaceCharactersInRange:result.range withAttributedString:attachText];
            }
        }
    }
    
    return mAttributedString;
}


- (UIImage *)getExpressionWithName:(NSString *)name {
    UIImage *image; //???????????????
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

@end
