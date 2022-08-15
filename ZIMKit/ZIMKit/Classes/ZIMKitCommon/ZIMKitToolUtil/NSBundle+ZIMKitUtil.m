//
//  NSBundle+ZIMKitUtil.m
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import "NSBundle+ZIMKitUtil.h"

@implementation NSBundle (ZIMKitUtil)

+ (instancetype)ZIMKitCommonBundle
{
    static NSBundle *commonBundle = nil;
    if (commonBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        commonBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"ZIMKitNavigationController")] pathForResource:@"ZIMKitCommon" ofType:@"bundle"]];
    }
    return commonBundle;
}

+ (NSString *)ZIMKitlocalizedStringForKey:(NSString *)key {
    return [self localizedStringForKey:key value:@""];
}

+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;;
        // 如果配置中没有配置语言
        
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else if ([language hasPrefix:@"ko"]) {
            language = @"ko";
        } else if ([language hasPrefix:@"ru"]) {
            language = @"ru";
        } else if ([language hasPrefix:@"uk"]) {
            language = @"uk";
        } else {
            language = @"en";
        }
        bundle = [NSBundle bundleWithPath:[[NSBundle ZIMKitCommonBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}
@end
