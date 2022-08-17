//
//  ZIMKitTextMessage.h
//  ZIMKit
//
//  Created by zego on 2022/5/24.
//

#import "ZIMKitMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitTextMessage : ZIMKitMessage

@property (nonatomic, copy) NSString *message;

- (void)fromZIMMessage:(ZIMTextMessage *)message;

/// 转成SDK对应的模型
- (ZIMTextMessage *)toZIMTextMessageModel;
@end

NS_ASSUME_NONNULL_END
