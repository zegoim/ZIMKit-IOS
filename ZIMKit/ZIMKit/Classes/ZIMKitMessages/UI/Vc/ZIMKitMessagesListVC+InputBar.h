//
//  ZIMKitMessagesListVC+InputBar.h
//  ZIMKit
//
//  Created by zego on 2022/7/13.
//

#import <ZIMKit/ZIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessagesListVC (InputBar)<ZIMKitMessageSendToolbarDelegate>

/// 更新tableview的frame
- (void)updateTableViewLayout;

@end

NS_ASSUME_NONNULL_END
