//
//  ZIMKitConversationListVC.h
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import <UIKit/UIKit.h>
#import "ZIMKitConversationModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZIMKitConversationListVCDelegate <NSObject>

/// 未读消息总数
- (void)onTotalUnreadMessageCountChange:(NSInteger)totalCount;

/// 用户被踢
- (void)userAccountKickedOut;

/// 导航栏标题内容改变
- (void)titleContentChange:(NSString *)content;
@end

@interface ZIMKitConversationListVC : UIViewController

@property (nonatomic, weak) id<ZIMKitConversationListVCDelegate>delegate;

@property (nonatomic, copy) void (^logoutBlock)(void);

@end

NS_ASSUME_NONNULL_END
