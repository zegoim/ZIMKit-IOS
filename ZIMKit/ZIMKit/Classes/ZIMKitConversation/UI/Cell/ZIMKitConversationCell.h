//
//  ZIMKitConversationCell.h
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import <UIKit/UIKit.h>
#import "ZIMKitConversationModel.h"
#import "ZIMKitUnReadView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitConversationCell : UITableViewCell

/// 头像
@property (nonatomic, strong) UIImageView *headImageView;

/// 会话标题
@property (nonatomic, strong) UILabel *titleLabel;

/// 会话消息概览（下标题）
@property (nonatomic, strong) UILabel *subTitleLabel;

/// 时间标签
@property (nonatomic, strong) UILabel *timeLabel;

/// 消息免打扰红点
@property (nonatomic, strong) UIView *unReadCountRedDot;

/// 消息免打扰icon
@property (nonatomic, strong) UIImageView *notDisturbIcon;

/// 会话未读数
@property (nonatomic, strong) ZIMKitUnReadView *unReadView;

/// 分割线
@property (nonatomic, strong) UIView *sepline;

/// 会话选中
@property (nonatomic, strong) UIImageView *selectedIcon;

/// 最后一条消息发送失败
@property (nonatomic, strong) UIImageView *msgFailImageView;

/// 会话数据源
@property (atomic, strong) ZIMKitConversationModel *data;

- (void)fillWithData:(ZIMKitConversationModel *)data;

@end

NS_ASSUME_NONNULL_END
