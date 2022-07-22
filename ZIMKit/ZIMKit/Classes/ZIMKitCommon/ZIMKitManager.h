//
//  ZIMKitManager.h
//  ZIMKit
//
//  Created by zego on 2022/5/18.
//

#import <Foundation/Foundation.h>
#import <ZIM/ZIM.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitManager : NSObject

@property (nonatomic, strong, readonly) ZIM *zim;

@property (nonatomic, strong, readonly) ZIMUserInfo *userInfo;

/*!
 *  获取实例
 */
+ (instancetype)shared;

- (void)createZIM:(int)appID;

- (void)login:(ZIMUserInfo *)userInfo
        token:(NSString *)token
     callback:(ZIMLoggedInCallback)callback;

- (void)logout;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
