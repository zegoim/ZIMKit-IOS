//
//  ZIMKitMessageCellConfig.h
//  ZIMKit
//
//  Created by zego on 2022/5/26.
//

#import <Foundation/Foundation.h>
@class ZIMKitMessage;

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessageCellConfig : NSObject

- (instancetype)initWithMessage:(ZIMKitMessage *)message;

/// 头像大小
- (CGSize)avatarSize;

/// 消息文字字体大小
+ (CGFloat)messageTextFontSize;

/// 用户名字体大小
- (CGFloat)userNameFontSize;

/// 文字消息字体颜色
- (UIColor *)messageTextColor;

/// 用户名字体颜色
- (UIColor *)userNameColor;

/// 内容与四周边缘距离
- (UIEdgeInsets)contentViewInsets;

+ (UIImage *)receiveBubble;

+ (UIImage *)sendBubble;
@end

NS_ASSUME_NONNULL_END
