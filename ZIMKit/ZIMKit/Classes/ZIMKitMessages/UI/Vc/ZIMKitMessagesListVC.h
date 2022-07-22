//
//  ZIMKitMessagesListVC.h
//  ZIMKit
//
//  Created by zego on 2022/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessagesListVC : UIViewController

- (instancetype)initWithConversationID:(NSString *)conversationID conversationType:(ZIMConversationType)conversationType conversationName:(NSString *)conversationName;
@end

NS_ASSUME_NONNULL_END
