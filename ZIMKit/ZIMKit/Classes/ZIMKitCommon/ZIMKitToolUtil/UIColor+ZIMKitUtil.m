//
//  UIColor+ZIMKitUtil.m
//  ZIMKit
//
//  Created by zego on 2022/5/21.
//

#import "UIColor+ZIMKitUtil.h"

@implementation UIColor (ZIMKitUtil)

+ (UIColor *)dynamicColor:(UIColor *)darkColor  lightColor:(UIColor *)lightColor
{
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            switch (traitCollection.userInterfaceStyle) {
                case UIUserInterfaceStyleDark:
                    // 加载暗黑，如果没有配置黑夜主题，使用默认值
                    return darkColor;
                case UIUserInterfaceStyleLight:
                case UIUserInterfaceStyleUnspecified:
                default:
                    return lightColor;
            }
        }];
    } else {
        return lightColor;
    }
}
@end
