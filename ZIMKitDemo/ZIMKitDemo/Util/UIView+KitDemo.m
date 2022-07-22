//
//  UIView+KitDemo.m
//  ZIMKitDemo
//
//  Created by zego on 2022/6/28.
//

#import "UIView+KitDemo.h"

@implementation UIView (KitDemo)

- (UIWindow *)getKeyWindow {
    UIWindow* window = nil;
     
    if (@available(iOS 13.0, *))
    {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
        {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                window = windowScene.windows.firstObject;

                break;
            }
        }
    }else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}

@end
