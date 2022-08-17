//
//  ZIMKitGroupVM.m
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import "ZIMKitGroupVM.h"
#import "ZIMKitGroupInfo.h"
#import "ZIMKitGroupMember.h"

@implementation ZIMKitGroupVM

- (void)createGroup:(NSString *)groupID
          groupName:(NSString *)groupName
         userIDList:(NSArray <NSString *>*)userIDList
           callBack:(ZIMKitCreateGroupCallback)callBack {
    ZIMGroupInfo *info = [[ZIMGroupInfo alloc] init];
    info.groupID = groupID;
    info.groupName = groupName;
    
    [ZIMKitManagerZIM createGroup:info userIDs:userIDList callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        if (callBack) {
            ZIMKitGroupInfo *info = [[ZIMKitGroupInfo alloc] init];
            [info fromZIMGroupFullInfo:groupInfo];
            callBack(info, errorUserList, errorInfo);
        }
    }];
}

- (void)joinGroup:(NSString *)groupID
         callBack:(ZIMKitGroupCallback)callBack {
    [ZIMKitManagerZIM joinGroup:groupID callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, ZIMError * _Nonnull errorInfo) {
        if (callBack) {
            ZIMKitGroupInfo *info = [[ZIMKitGroupInfo alloc] init];
            [info fromZIMGroupFullInfo:groupInfo];
            callBack(info, errorInfo);
        }
    }];
}

- (void)queryGroupMemberListByGroupID:(NSString *)groupID
                                    config:(ZIMGroupMemberQueryConfig *)config
                                  callback:(ZIMKitGroupMemberListQueriedCallback)callback {
    NSAssert(groupID,  @"queryqueryGroupMemberListByGroupID The groupID should not be nil.");
    
    [ZIMKitManagerZIM queryGroupMemberListByGroupID:groupID config:config callback:^(NSString * _Nonnull groupID, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, unsigned int nextFlag, ZIMError * _Nonnull errorInfo) {
        if (callback) {
            NSMutableArray *members = [NSMutableArray array];
            for (ZIMGroupMemberInfo *user in userList) {
                ZIMKitGroupMember *member = [[ZIMKitGroupMember alloc] init];
                [member fromZIMGroupMemberInfo:user];
                if (member) {
                    [members addObject:member];
                }
            }
            callback(groupID, members, nextFlag, errorInfo);
            
        }
    }];
}
@end
