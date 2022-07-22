//
//  NSString+ZIMKitUtil.h
//  ZIMKit
//
//  Created by zego on 2022/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZIMKitUtil)

/// 时间格式转换
/// @param timestamp 毫秒
+ (NSString *)convertDateToStr:(long long )timestamp;


/// 会话列表时间格式转换
/// @param timestamp timestamp 毫秒
+ (NSString *)conversationConvertDateToStr:(long long )timestamp;



/// 获取汉字转成拼音 全拼 首字母 简拼
/// @param hanzi 需要转换的字符串
+ (NSArray *)transformSpell2Pinyin:(NSString *)hanzi;

/// 利用YYKit 布局
- (CGSize)sizeAttributedWithFont:(UIFont *)font width:(CGFloat)width  wordWap:(NSLineBreakMode)lineBreadMode;


/// 字符串是否为空
/// @param str str
+ (BOOL) isEmpty:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
