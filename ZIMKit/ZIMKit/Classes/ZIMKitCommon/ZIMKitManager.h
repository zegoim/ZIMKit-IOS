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

@property (nonatomic, strong, readonly) ZIMUserFullInfo *userfullinfo;

/*!
 *  获取实例
 */
+ (instancetype)shared;

- (void)createZIM:(int)appID appSign:(NSString *)appSign;

- (void)login:(ZIMUserInfo *)userInfo
     callback:(ZIMLoggedInCallback)callback;

- (void)logout;

/// 查询个人信息
/// @param userIDs 用户ID集合
/// @param callback callback
- (void)queryUsersInfo:(NSArray<NSString *>*)userIDs callback:(ZIMUsersInfoQueriedCallback)callback;


/// 更新用户头像
/// @param avatarUrl avatarUrl
/// @param callback callback
- (void)updateupdateUserAvatarUrl:(NSString *)avatarUrl callback:(ZIMUserAvatarUrlUpdatedCallback)callback;

/// 获取本地图片路径
- (NSString *)getImagepath;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
