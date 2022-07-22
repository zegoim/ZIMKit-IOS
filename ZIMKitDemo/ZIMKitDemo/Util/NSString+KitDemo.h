//
//  NSString+KitDemo.h
//  ZIMKitDemo
//
//  Created by zego on 2022/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (KitDemo)

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/// 获取字符串的长度
- (NSInteger)getToInt:(NSString*)strtemp;

- (CGSize)getHeightWithFont:(UIFont *)font width:(CGFloat)width wordWap:(NSLineBreakMode)lineBreadMode;
@end

NS_ASSUME_NONNULL_END
