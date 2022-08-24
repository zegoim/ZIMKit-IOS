//
//  ZIMKitMessage.h
//  ZIMKit
//
//  Created by zego on 2022/5/24.
//

#import <Foundation/Foundation.h>
#import "ZIMKitMessageCellConfig.h"
#import <ZIM/ZIM.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessage : NSObject

@property (nonatomic, assign) ZIMMessageType type;

@property (nonatomic, assign) long long messageID;

@property (nonatomic, assign) long long localMessageID;

@property (nonatomic, copy) NSString *senderUserID;

@property (nonatomic, copy) NSString *senderUsername;

@property (nonatomic, copy) NSString *senderUserAvatar;

/// Description: Session ID. Ids of the same session type are unique.
@property (nonatomic, copy) NSString *conversationID;

/// Description: Used to describe whether a message is sent or received.
@property (nonatomic, assign) ZIMMessageDirection direction;

/// Description: Describes the sending status of a message.
@property (nonatomic, assign) ZIMMessageSentStatus sentStatus;

/// Description: The type of session to which the message belongs.
@property (nonatomic, assign) ZIMConversationType conversationType;

/// Caution: This is a standard UNIX timestamp, in milliseconds.
@property (nonatomic, assign) unsigned long long timestamp;

/// Description:The larger the orderKey, the newer the message, and can be used for ordering messages.
@property (nonatomic, assign) long long orderKey;

@property (nonatomic, strong) ZIMKitMessageCellConfig *cellConfig;

/// 消息的时间间隔是否需要显示
@property (nonatomic, assign) BOOL needShowTime;

/// 是否要显示昵称
@property (nonatomic, assign) BOOL needShowName;

/// 是否是UI 最顶上的数据
@property (nonatomic, assign) BOOL isLastTop;

/// cell helght
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) NSString *reuseId;

/// SDK 消息对象
@property (nonatomic, strong) ZIMMessage* zimMsg;

/// 内容的大小
- (CGSize)contentSize;

/// ZIMMessage ->ZIMKitMessage
- (void)fromZIMMessage:(ZIMMessage *)message;

/// 时间戳的单位是ms
- (BOOL)isNeedshowtime:(unsigned long long)timestamp;

/// 重新计算高度
- (CGFloat)resetCellHeight;

/// 计算文本消息size
- (CGSize)sizeAttributedWithFont:(UIFont *)font width:(CGFloat)width  wordWap:(NSLineBreakMode)lineBreadMode string:(NSString *)contentString;

@end

NS_ASSUME_NONNULL_END
