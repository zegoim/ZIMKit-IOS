//
//  ZIMKitMediaMessage.m
//  ZIMKit
//
//  Created by zego on 2022/7/18.
//

#import "ZIMKitMediaMessage.h"

@implementation ZIMKitMediaMessage

- (void)fromZIMMessage:(ZIMMediaMessage *)message {
    [super fromZIMMessage:message];
    self.fileLocalPath = message.fileLocalPath;
    self.fileDownloadUrl = message.fileDownloadUrl;
    self.fileUID = message.fileUID;
    self.fileName = message.fileName;
    self.fileSize = message.fileSize;
}

/// 转成SDK对应的模型
- (ZIMMediaMessage *)toZIMTextMessageModel {
    ZIMMediaMessage *mediaMessage = [[ZIMMediaMessage alloc] init];
    mediaMessage.fileLocalPath = self.fileLocalPath;
    mediaMessage.fileDownloadUrl = self.fileDownloadUrl;
    return mediaMessage;
}

- (CGSize)contentSize {
    CGSize size = [super contentSize];
    return size;
}

@end
