//
//  ZIMKitImageMessageCell.h
//  ZIMKit
//
//  Created by zego on 2022/7/18.
//

#import "ZIMKitBubbleMessageCell.h"
#import "ZIMKitImageMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitImageMessageCell : ZIMKitMessageCell

@property (nonatomic, strong) UIImageView *thumbnailImageView;

@property (nonatomic, copy) void (^browseImageBlock)(ZIMKitImageMessage *msg, ZIMKitImageMessageCell *cell);

@end

NS_ASSUME_NONNULL_END
