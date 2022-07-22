//
//  UIColor+ZIMKitUtil.h
//  ZIMKit
//
//  Created by zego on 2022/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZIMKitUtil)


/// 获取动态颜色
/// @param darkColor 暗黑颜色
/// @param lightColor 普通颜色
+ (UIColor *)dynamicColor:(UIColor *)darkColor lightColor:(UIColor *)lightColor;
@end

NS_ASSUME_NONNULL_END
