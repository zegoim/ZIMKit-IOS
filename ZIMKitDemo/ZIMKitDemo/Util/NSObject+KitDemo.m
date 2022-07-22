//
//  NSObject+KitDemo.m
//  ZIMKitDemo
//
//  Created by zego on 2022/6/27.
//

#import "NSObject+KitDemo.h"

@implementation NSObject (KitDemo)

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
