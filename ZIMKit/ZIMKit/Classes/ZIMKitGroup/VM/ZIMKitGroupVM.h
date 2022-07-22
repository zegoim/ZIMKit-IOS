//
//  ZIMKitGroupVM.h
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import <Foundation/Foundation.h>
@class ZIMKitGroupInfo, ZIMKitGroupMember;

typedef void (^ZIMKitGroupCallback)(ZIMKitGroupInfo  *_Nullable groupInfo, ZIMError * _Nullable errorInfo);
typedef void (^ZIMKitCreateGroupCallback)(ZIMKitGroupInfo  *_Nullable groupInfo,NSArray<ZIMErrorUserInfo *> * _Nullable errorUserList, ZIMError * _Nullable errorInfo);
typedef void (^ZIMKitGroupMemberListQueriedCallback)(NSString *_Nullable groupID,
                                                     NSArray<ZIMKitGroupMember *> * _Nullable userList,
                                                     unsigned int nextFlag, ZIMError * _Nullable errorInfo);

NS_ASSUME_NONNULL_BEGIN

@protocol ZIMKitGroupVMDelegate <NSObject>

@optional
/// group 状态改变
- (void)onGroupStatusChange:(NSString *)groupID
                      state:(ZIMGroupState)state
                      event:(ZIMGroupEvent)event
           operatedUserInfo:(ZIMKitGroupMember *)operatedUserInfo;

/// group 成员状态发生改变
- (void)onGroupMemberStateChanged:(NSString *)groupID
                            state:(ZIMGroupMemberState)state
                            event:(ZIMGroupMemberEvent)event
                         userList:(NSArray *)userList
                 operatedUserInfo:(ZIMKitGroupMember *)operatedUserInfo;
@end

@interface ZIMKitGroupVM : NSObject

@property (nonatomic, weak) id<ZIMKitGroupVMDelegate>delegate;

/// 成员列表
//- (NSArray <ZIMKitGroupMember *>*)memberList;

/// 创建群聊
/// @param groupID 群ID
/// @param groupName 群名称
/// @param userIDList 群成员ID列表
/// @param callBack callback
- (void)createGroup:(NSString *_Nullable)groupID
          groupName:(NSString *)groupName
         userIDList:(NSArray <NSString *>*)userIDList
           callBack:(ZIMKitCreateGroupCallback)callBack;

/// 加入群聊
/// @param groupID 群ID
/// @param callBack callback
- (void)joinGroup:(NSString *)groupID callBack:(ZIMKitGroupCallback)callBack;


///// 退出群聊
///// @param groupID 群ID
///// @param callBack callback
//- (void)leaveGroup:(NSString *)groupID callBack:(ZIMKitGroupCallback)callBack;
//
///// 解散群聊
///// @param groupID 群ID
///// @param callBack callBack
//- (void)dismissGroup:(NSString *)groupID callBack:(ZIMKitGroupCallback)callBack;
//
///// 邀请成员加入群组
///// @param groupID  群ID
///// @param userIDList 成员列表
///// @param callBack callBack
//- (void)inviteUsersJoinGroup:(NSString *)groupID
//                  userIDList:(NSArray *)userIDList
//                    callBack:(ZIMKitGroupCallback)callBack;
//
///// 把成员踢出群组
///// @param groupID  群ID
///// @param userIDList 成员列表
///// @param callBack callBack
//- (void)kickGroupMembers:(NSString *)groupID
//                  userIDList:(NSArray *)userIDList
//                    callBack:(ZIMKitGroupCallback)callBack;
//
///// 查询群组信息
///// @param groupID 群ID
///// @param callBack callBack
//- (void)queryGroupInfo:(NSString *)groupID callBack:(ZIMKitGroupCallback)callBack;


/// 查询群成员
/// @param groupID 群ID
/// @param config 查询设置
/// @param callback callback
- (void)queryGroupMemberListByGroupID:(NSString *)groupID
                                    config:(ZIMGroupMemberQueryConfig *)config
                                  callback:(ZIMKitGroupMemberListQueriedCallback)callback;
@end

NS_ASSUME_NONNULL_END
