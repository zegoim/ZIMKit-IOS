//
//  ZIMKitMessageCellConfig.m
//  ZIMKit
//
//  Created by zego on 2022/5/26.
//

#import "ZIMKitMessageCellConfig.h"
#import "ZIMKitMessage.h"
#import "ZIMKitDefine.h"

@interface ZIMKitMessageCellConfig ()

@property (nonatomic, strong) ZIMKitMessage *message;
@end

@implementation ZIMKitMessageCellConfig

- (instancetype)initWithMessage:(ZIMKitMessage *)message {
    self = [super init];
    if (self) {
        _message = message;
    }
    
    return self;
}
/// 头像大小
- (CGSize)avatarSize {
    return CGSizeMake(43.0, 43.0);
}

/// 消息文字字体大小
+ (CGFloat)messageTextFontSize {
    return 15.0;
}

/// 用户名字体大小
- (CGFloat)userNameFontSize {
    return 11.0;
}

/// 文字消息字体颜色
- (UIColor *)messageTextColor {
    
    if (_message.direction == ZIMMessageDirectionSend) {
        return [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    } else {
        return [UIColor dynamicColor:ZIMKitHexColor(0x2A2A2A) lightColor:ZIMKitHexColor(0x2A2A2A)];
    }
}

/// 用户名字体颜色
- (UIColor *)userNameColor {
    return [UIColor dynamicColor:ZIMKitHexColor(0x666666) lightColor:ZIMKitHexColor(0x666666)];
}

/// 内容与四周边缘距离
- (UIEdgeInsets)contentViewInsets {
    
    if (self.message.type == ZIMMessageTypeText) {
        return UIEdgeInsetsMake(11, 12, 11, 12);
    } else {
        return UIEdgeInsetsZero;
    }
}

static UIImage *sRecevieBubble;
+ (UIImage *)receiveBubble
{
    if (!sRecevieBubble) {
        UIImage *image = [UIImage zegoImageNamed:@"receve_bubble"];
        sRecevieBubble = [image resizableImageWithCapInsets:UIEdgeInsetsMake(11, 12, 11, 12) resizingMode:UIImageResizingModeStretch];
    }
    return sRecevieBubble;
}

static UIImage *sSendBubble;
+ (UIImage *)sendBubble
{
    if (!sSendBubble) {
        UIImage *image = [UIImage zegoImageNamed:@"send_bubble"];
        sSendBubble = [image resizableImageWithCapInsets:UIEdgeInsetsMake(11, 12, 11, 12) resizingMode:UIImageResizingModeStretch];
    }
    return sSendBubble;
}
@end
