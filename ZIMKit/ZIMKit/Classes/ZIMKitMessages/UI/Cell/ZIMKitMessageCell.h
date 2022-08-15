//
//  ZIMKitMessageCell.h
//  ZIMKit
//
//  Created by zego on 2022/5/25.
//

#import <UIKit/UIKit.h>
#import "ZIMKitMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessageCell : UITableViewCell

/// 消息时间间隔
@property (nonatomic, strong) UILabel *timeLabel;

/// 头像
@property (nonatomic, strong) UIImageView *avatarImageView;

/// 昵称
@property (nonatomic, strong) UILabel *nameLabel;

/// 装内容区域的View
@property (nonatomic, strong) UIView *containerView;

/// 消息发送中的loading
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

/// 重发
@property (nonatomic, strong) UIButton *retryButton;

/// 多选时
@property (nonatomic, strong) UIButton *selectedButton;

- (void)fillWithMessage:(ZIMKitMessage *)message;

@end

NS_ASSUME_NONNULL_END
