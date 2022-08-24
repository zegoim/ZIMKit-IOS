//
//  ZIMKitMessagesVM.h
//  ZIMKit
//
//  Created by zego on 2022/5/24.
//

#import <Foundation/Foundation.h>
#import <ZIM/ZIM.h>

@class ZIMKitMessage,ZIMKitMediaMessage, ZIMKitMessagesVM;

typedef void (^ZIMKitMessageCallback)(ZIMKitMessage * _Nullable message, ZIMError * _Nullable errorInfo);
typedef void (^ZIMKitLoadMessagesCallback)(NSArray<ZIMKitMessage *> * _Nullable messageList, ZIMError * _Nullable errorInfo);
typedef void (^ZIMKitMessageCallback2)(ZIMError * _Nullable errorInfo);
typedef void(^ZIMKitCallBlock) (ZIMError * _Nullable errorInfo);

NS_ASSUME_NONNULL_BEGIN
@protocol ZIMKitMessagesVMDelegate <NSObject>
@optional
/// 收到单聊消息
- (void)onReceivePeerMessage:(NSArray<ZIMKitMessage *> *)messageList fromUserID:(NSString *)fromUserID;

/// 收到群聊消息
- (void)onReceiveGroupMessage:(NSArray<ZIMKitMessage *> *)messageList fromGroupID:(NSString *)fromGroupID;

/// 收到房间消息
- (void)onReceiveRoomMessage:(NSArray<ZIMKitMessage *> *)messageList fromRoomID:(NSString *)fromRoomID;

/// 群成员变更
- (void)onGroupMemberStateChanged:(ZIMGroupMemberState)state event:(ZIMGroupMemberEvent)event userList:(NSArray<ZIMGroupMemberInfo *> *)userList operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo groupID:(NSString *)groupID;

#pragma mark 数据源的更新代理
/// 数据源插入
- (void)dataSourceInsert:(ZIMKitMessagesVM *)VM index:(int)index animation:(BOOL)animation;
@end

@interface ZIMKitMessagesVM : NSObject

@property (nonatomic, weak) id<ZIMKitMessagesVMDelegate> delegate;
/// 消息list
@property (nonatomic, readonly) NSArray<ZIMKitMessage *> *messageList;

/// init messageVM
/// @param conversationID  current conversationID
- (instancetype)initWith:(NSString *)conversationID;

/// 发送单聊消息
/// @param message 发送消息对象
/// @param toUserID 发送对方ID
/// @param config 发送消息配置
/// @param callBack callBack
- (void)sendPeerMessage:(ZIMKitMessage *)message
               toUserID:(NSString *)toUserID
                 config:(ZIMMessageSendConfig *)config
               callBack:(ZIMKitMessageCallback)callBack;

/// 发送群聊消息
/// @param message 发送消息对象
/// @param toGroupID 群ID
/// @param config 发送消息配置
/// @param callBack callBack
- (void)sendGroupMessage:(ZIMKitMessage *)message
              toGroupID:(NSString *)toGroupID
                 config:(ZIMMessageSendConfig *)config
               callBack:(ZIMKitMessageCallback)callBack;


/// 发送媒体消息
/// @param message 消息
/// @param conversationID 会话ID
/// @param conversationType 会话类型
/// @param config 发送消息配置
/// @param progress 媒体进度
/// @param callBack callBack
- (void)sendMeidaMessage:(ZIMKitMediaMessage *)message
          conversationID:(NSString *)conversationID
        conversationType:(ZIMConversationType)conversationType
                  config:(ZIMMessageSendConfig *)config
                progress:(ZIMMediaUploadingProgress)progress
                callBack:(ZIMKitMessageCallback)callBack;


/// 查询历史消息
/// @param conversationID 会话ID
/// @param type 会话类型
/// @param config 查询消息配置项(首次查询时 nextMessage 为 `null`。后续的分页查询时，nextMessage 为当前查询到的消息列表的最后一条消息。)
/// @param callBack callBack
- (void)queryHistoryMessage:(NSString *)conversationID
                       type:(ZIMConversationType)type
                     config:(ZIMMessageQueryConfig *)config
                   callBack:(ZIMKitLoadMessagesCallback)callBack;


/// 删除消息
/// @param conversationID 会话ID
/// @param conversationType 会话类型
/// @param config  可配置(isAlsoDeleteServerMessage 是否同时删除服务器)
/// @param messageList 删除消息集合
/// @param callBack callBack
- (void)deleteMessage:(NSString *)conversationID
     conversationType:(ZIMConversationType)conversationType
               config:(ZIMMessageDeleteConfig *)config
          messageList:(NSArray <ZIMKitMessage *>*)messageList
             callBack:(ZIMKitCallBlock)callBack;


/// 删除所有消息
/// @param conversationID 会话ID
/// @param conversationType 会话类型
/// @param config  可配置(isAlsoDeleteServerMessage 是否同时删除服务器)
/// @param callBack callBack
- (void)deleteAllMessage:(NSString *)conversationID
        conversationType:(ZIMConversationType)conversationType
                  config:(ZIMMessageDeleteConfig *)config
                callBack:(ZIMKitCallBlock)callBack;

/// 查询群成员
/// @param groupID 群ID
/// @param config 查询设置
/// @param callback callback
- (void)queryGroupMemberListByGroupID:(NSString *)groupID
                               config:(ZIMGroupMemberQueryConfig *)config
                             callback:(ZIMGroupMemberListQueriedCallback)callback;


/// 查询群信息
/// @param groupID 群ID
/// @param callback callback
- (void)queryGroupInfoWithGroupID:(NSString *)groupID callback:(ZIMGroupInfoQueriedCallback)callback;


/// 清空会话未读数
- (void)clearConversationUnreadMessageCount:(NSString *)coversationID
                           conversationType:(ZIMConversationType)conversationType
                              completeBlock:(ZIMKitMessageCallback2)completeBlock;

/// 清空数据(外界VC 持有VM ,在销毁的时候需要调用,要不VM释放不了)
- (void)clearAllCacheData;


/// 获取本地图片路径
- (NSString *)getImagepath;
@end

NS_ASSUME_NONNULL_END
