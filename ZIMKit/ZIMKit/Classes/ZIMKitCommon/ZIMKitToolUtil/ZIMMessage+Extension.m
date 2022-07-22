//
//  ZIMMessage+Extension.m
//  ZIMKit
//
//  Created by zego on 2022/5/20.
//

#import "ZIMMessage+Extension.h"

@implementation ZIMMessage (Extension)

- (NSString *)getMessageTypeShorStr {
    NSString *shorStr;
    ZIMMessage *msg = self;
    
    switch (self.type) {
        case ZIMMessageTypeText:
        {
            ZIMTextMessage *textMessage = (ZIMTextMessage *)msg;
            shorStr = textMessage.message;
            break;
        }
        case ZIMMessageTypeImage:
        {
            shorStr = @"[图片]";
            break;
        }
        case ZIMMessageTypeFile:
        {
            shorStr = @"[文件]";
            break;
        }
        case ZIMMessageTypeVideo:
        {
            shorStr = @"[视频]";
            break;
        }
        case ZIMMessageTypeAudio:
        {
            shorStr = @"[语音]";
            break;
        }
        default:
            break;
    }
    
    return shorStr;
}

@end
