//
//  HelpCenter.h
//  ZIMKitDemo
//
//  Created by zego on 2022/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define HelperCenterCacheKey(userId) [NSString stringWithFormat:@"HelperCenter_%@", userId]


@interface HelpCenter : NSObject

// 获取用户名
+ (NSString *)getUserNameWith:(NSString *)userID;

// 获取用户头像
+ (NSString *)getUserAvatar:(NSString *)userID;

+ (UIViewController *)currentViewController;
@end

NS_ASSUME_NONNULL_END
