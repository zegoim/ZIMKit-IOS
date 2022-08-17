//
//  ZIMKitBaseModule.h
//  ZIMKit
//
//  Created by zego on 2022/6/30.
//

#import <Foundation/Foundation.h>
#import "ZIMKitRouter.h"

#define selfCallBackBlock(param, type) \
    if (self.callBackBlock && [self isMemberOfClass:[UIViewController class]]) {\
        self.callBackBlock(param, type);\
    } else {\
        NSLog(@"触发回调者不是<UIViewController>或者没有设置回调处理");\
    }


@interface ZIMKitBaseModule : NSObject

// 有回调
+ (void)jumpTovc:(JumpType)type nav:(UINavigationController *)nav fromeV:(UIViewController *)fromVC toVC:(id)toVC urlString:(NSString *)urlStr;
// 无回调
+ (void)jumpTovc:(JumpType)type nav:(UINavigationController *)nav fromeV:(UIViewController *)fromVC toVC:(id)toVC;
+ (void)registerURL;

@end

