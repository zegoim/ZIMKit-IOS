//
//  ZIMKitTextMessage.m
//  ZIMKit
//
//  Created by zego on 2022/5/24.
//

#import "ZIMKitTextMessage.h"
#import "NSString+ZIMKitUtil.h"

@implementation ZIMKitTextMessage

- (void)fromZIMMessage:(ZIMTextMessage *)message {
    [super fromZIMMessage:message];
    self.message = message.message;
}

- (ZIMTextMessage *)toZIMTextMessageModel {
    ZIMTextMessage *textMessage = [[ZIMTextMessage alloc] init];
    textMessage.message = self.message;
    return textMessage;
}

//- (CGFloat)cellHeight {
//    return 0;
//}

- (CGSize)contentSize {
    CGSize size = [super contentSize];
    
    size = [self sizeAttributedWithFont:[UIFont systemFontOfSize:[ZIMKitMessageCellConfig messageTextFontSize]] width:ZIMKitMessageCell_Text_MaxW wordWap:NSLineBreakByCharWrapping string:self.message];
    return size;
}
@end
