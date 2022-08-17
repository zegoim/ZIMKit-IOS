//
//  ZIMKitMessagesListVC.h
//  ZIMKit
//
//  Created by zego on 2022/5/30.
//

#import <UIKit/UIKit.h>
#import "ZIMKitBaseViewController.h"
#import "ZIMKitMessageSendToolbar.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessagesListVC : ZIMKitBaseViewController

@property (nonatomic, strong) ZIMKitMessageSendToolbar *messageToolbar;

- (instancetype)initWithConversationID:(NSString *)conversationID conversationType:(ZIMConversationType)conversationType conversationName:(NSString *)conversationName;

- (UITableView *)messageTableView;

/// 发送消息
- (void)sendAction:(NSString *)text;

/// 发送图片消息
- (void)sendImageMessage:(NSData *)data fileName:(NSString *)fileName;

- (void)scrollToBottom:(BOOL)animate;

- (void) reloaddataAndScrolltoBottom;
@end

NS_ASSUME_NONNULL_END
