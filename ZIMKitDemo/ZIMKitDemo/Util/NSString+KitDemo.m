//
//  NSString+KitDemo.m
//  ZIMKitDemo
//
//  Created by zego on 2022/5/18.
//

#import "NSString+KitDemo.h"

@implementation NSString (KitDemo)

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    if (mobileNum.length != 11) {
        return NO;
    }
    
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)) {
        return YES;
    }
    else if (([regextestcm evaluateWithObject:mobileNum] == YES)) {
        NSLog(@"中国移动");
        return YES;
    }
     else if (([regextestct evaluateWithObject:mobileNum] == YES)) {
         NSLog(@"中国电信");
         return YES;
     }
     else if (([regextestcu evaluateWithObject:mobileNum] == YES)) {
         NSLog(@"中国联通");
         return YES;
     }else {
         return NO;
     }
}

/// 获取字符串的长度
- (NSInteger)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    NSData* da = [strtemp dataUsingEncoding:enc];

    return [da length];
}

- (CGSize)getHeightWithFont:(UIFont *)font width:(CGFloat)width wordWap:(NSLineBreakMode)lineBreadMode
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = lineBreadMode;
        
        NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
        size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        if (size.width > -fabs(0.000001) && size.width < fabs(0.000001))
        {
            size.height = 0.0f;
        }
        
    }
    else
    {
        size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:lineBreadMode];
    }
    
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

@end
