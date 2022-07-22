//
//  ZIMKitMessageTool.m
//  ZIMKit
//
//  Created by zego on 2022/5/25.
//

#import "ZIMKitMessageTool.h"


@implementation ZIMKitMessageTool

+ (ZIMMessage *)fromZIMKitMessageConvert:(ZIMKitMessage *)message {
    ZIMMessage *msg;
    if (message.type == ZIMMessageTypeText) {
        ZIMKitTextMessage *textMessage =  (ZIMKitTextMessage *)message;
        msg = [textMessage toZIMTextMessageModel];
    }
    return msg;
}

+ (ZIMKitMessage *)fromZIMMessageConvert:(ZIMMessage *)message {
    ZIMKitMessage *msg ;
    if (message.type == ZIMMessageTypeText) {
        msg = [[ZIMKitTextMessage alloc] init];
        [msg fromZIMMessage:message];
    }
    return msg;
}

@end
