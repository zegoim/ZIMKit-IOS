//
//  ZIMKitMediaMessage.h
//  ZIMKit
//
//  Created by zego on 2022/7/18.
//

#import "ZIMKitMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitMediaMessage : ZIMKitMessage

@property (nonatomic, copy) NSString *fileLocalPath;

@property (nonatomic, copy) NSString *fileDownloadUrl;

@property (nonatomic, copy) NSString *fileUID;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, assign) long long fileSize;

- (void)fromZIMMessage:(ZIMMediaMessage *)message;

/// 转成SDK对应的模型
- (ZIMMediaMessage *)toZIMTextMessageModel;

@end

NS_ASSUME_NONNULL_END
