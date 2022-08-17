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
    } else if (message.type == ZIMMessageTypeImage) {
        ZIMKitImageMessage *imageMessage = (ZIMKitImageMessage *)message;
        msg = [imageMessage toZIMTextMessageModel];
    }
    return msg;
}

+ (ZIMKitMessage *)fromZIMMessageConvert:(ZIMMessage *)message {
    ZIMKitMessage *msg ;
    if (message.type == ZIMMessageTypeText) {
        msg = [[ZIMKitTextMessage alloc] init];
        [msg fromZIMMessage:message];
    } else if (message.type == ZIMMessageTypeImage) {
        msg = [[ZIMKitImageMessage alloc] init];
        [msg fromZIMMessage:message];
    } else {
        msg = [[ZIMKitUnknowMessage alloc] init];
        [msg fromZIMMessage:message];
        msg.type = ZIMMessageTypeUnknown;
    }
    
    return msg;
}

@end
