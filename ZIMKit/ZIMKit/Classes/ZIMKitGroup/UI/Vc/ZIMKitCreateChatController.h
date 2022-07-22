//
//  ZIMKitCreateChatController.h
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZIMKitCreateChatType) {
    ZIMKitCreateChatTypeUnknow = 0,
    ///创建单聊
    ZIMKitCreateChatTypeSingle = 1,
    ///创建群聊
    ZIMKitCreateChatTypeGroup = 2,
    ///加入群聊
    ZIMKitCreateChatTypeJoin = 3,
};

NS_ASSUME_NONNULL_BEGIN


@interface ZIMKitCreateChatController : UIViewController

@property (nonatomic, assign) ZIMKitCreateChatType createType;

@end

NS_ASSUME_NONNULL_END
