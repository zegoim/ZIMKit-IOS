//
//  ZIMKitConversationModel.h
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import <Foundation/Foundation.h>
#import "ZIMKitDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitConversationModel : NSObject
/// 会话ID
@property (nonatomic, copy) NSString *conversationID;

/// 会话名称
@property (nonatomic, copy) NSString *conversationName;

/// 会话头像
@property (nonatomic, copy) NSString *conversationAvatar;

/// 会话类型
@property (nonatomic, assign) ZIMConversationType type;

/// 会话状态
@property (nonatomic, assign) ZIMConversationEvent conversationEvent;

/// 会话的未读数
@property (nonatomic, assign) int unreadMessageCount;

/// 会话的最后一条消息
@property (nonatomic, strong) ZIMMessage *lastMessage;

/// 会话的排序字段
@property (nonatomic, assign) long long orderKey;

/// 会话通知状态
@property (nonatomic, assign) ZIMConversationNotificationStatus notificationStatus;

/// ZIM SDK ZIMConversation 转成ZIMKit对应的对象
- (void)fromZIMConversationWith:(ZIMConversation *)con;

/// ZIMKitConversationModel->ZIMConversation
- (ZIMConversation *)toZIMConversationModel;
@end

NS_ASSUME_NONNULL_END
