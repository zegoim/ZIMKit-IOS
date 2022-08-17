//
//  ZIMKitGroupMember.h
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitGroupMember : NSObject

/// 成员昵称
@property (nonatomic, copy) NSString *memberNickname;

/// 成员角色
@property (nonatomic, assign) int memberRole;

/// 成员ID
@property (nonatomic, copy) NSString *userID;

/// 成员昵称
@property (nonatomic, copy) NSString *userName;

/// 从SDKZIMGroupMemberInfo->ZIMKitGroupMember
- (void)fromZIMGroupMemberInfo:(ZIMGroupMemberInfo*)info;
@end

NS_ASSUME_NONNULL_END
