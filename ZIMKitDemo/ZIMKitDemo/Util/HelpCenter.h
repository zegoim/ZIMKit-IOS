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

+ (NSString *)getTokenWithUserID:(NSString *)userID;

// 获取用户名
+ (NSString *)getUserNameWith:(NSString *)userID;
@end

NS_ASSUME_NONNULL_END
