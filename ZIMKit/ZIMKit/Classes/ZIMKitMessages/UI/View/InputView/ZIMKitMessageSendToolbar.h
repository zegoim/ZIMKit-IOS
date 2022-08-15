//
//  ZIMKitMessageSendToolbar.h
//  ZIMKit
//
//  Created by zego on 2022/8/11.
//

#import <Foundation/Foundation.h>
#import "ZIMKitFaceManagerView.h"
#import "ZIMKitInputBar.h"
#import "ZIMKitChatBarMoreView.h"

@protocol ZIMKitMessageSendToolbarDelegate <NSObject>

///输入框frame改变
- (void)messageToolbarInputFrameChange;

///发送文本消息
- (void)messageToolbarSendTextMessage:(NSString *_Nullable)text;

///功能键盘的点击
- (void)messageToolbarDidSelectedMoreViewItemAction:(ZIMKitFunctionType)type;
@end

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMessageSendToolbar : NSObject

@property (nonatomic, weak) id<ZIMKitMessageSendToolbarDelegate>delegate;

/// 消息输入框
@property (nonatomic, strong) ZIMKitInputBar        *inputBar;

/// 表情键盘
@property (nonatomic, strong) ZIMKitFaceManagerView *faceKeyBoard;

/// 更多键盘
@property (nonatomic, strong) ZIMKitChatBarMoreView *moreFunctionView;

- (instancetype)initWithSuperView:(UIView *)fatherView ;

/// 隐藏键盘
- (void)hiddeKeyborad;
@end

NS_ASSUME_NONNULL_END
