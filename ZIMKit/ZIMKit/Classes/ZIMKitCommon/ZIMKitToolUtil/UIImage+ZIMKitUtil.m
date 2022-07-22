//
//  UIImage+ZIMKitUtil.m
//  ZIMKit
//
//  Created by zego on 2022/5/22.
//

#import "UIImage+ZIMKitUtil.h"

@implementation UIImage (ZIMKitUtil)

+ (NSBundle *)ZIMKitCommonBundle
{
    static NSBundle *commonBundle = nil;
    if (commonBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        commonBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"ZIMKitNavigationController")] pathForResource:@"ZIMKitRecources" ofType:@"bundle"]];
    }
    return commonBundle;
}

+ (nullable instancetype)zegoImageNamed:(nullable NSString *)name
{
    if (name == nil || name.length == 0) {
        return nil;
    }
    
//    NSString *resourceBundle = [[NSBundle mainBundle] pathForResource:@"ZIMKitRecources" ofType:@"bundle"];
//    NSBundle *bundle = [NSBundle bundleWithPath:resourceBundle];
    NSBundle *bundle = [self ZIMKitCommonBundle];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

@end
