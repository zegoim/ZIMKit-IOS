//
//  ZIMKitSystemMessage.m
//  ZIMKit
//
//  Created by zego on 2022/6/9.
//

#import "ZIMKitSystemMessage.h"
#import "NSString+ZIMKitUtil.h"

@implementation ZIMKitSystemMessage

- (CGSize)contentSize {
    CGSize size = [super contentSize];
    
    size = [self.content sizeAttributedWithFont:[UIFont systemFontOfSize:[ZIMKitMessageCellConfig messageTextFontSize]] width:ZIMKitMessageCell_Sys_MaxW wordWap:NSLineBreakByCharWrapping];
    
    return size;
}

@end
