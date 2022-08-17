//
//  ZIMKitMessage.m
//  ZIMKit
//
//  Created by zego on 2022/5/24.
//

#import "ZIMKitMessage.h"
#import <objc/runtime.h>

@interface ZIMKitMessage ()

@end

@implementation ZIMKitMessage

- (void)fromZIMMessage:(ZIMMessage *)message {
//    unsigned int count = 0;
//    objc_property_t *properties = class_copyPropertyList([message class], &count);
//    for (int i = 0; i < count; i++) {
//        const char *name = property_getName(properties[i]);
//        NSString *propertyName = [NSString stringWithUTF8String:name];
//        id propertyValue = [message valueForKey:propertyName];
//        if (propertyValue) {
//            [self setValue:propertyValue forKey:propertyName];
//        }
//    }
    self.type = message.type;
    self.messageID = message.messageID;
    self.localMessageID = message.localMessageID;
    self.senderUserID = message.senderUserID;
    self.conversationID = message.conversationID;
    self.direction = message.direction;
    self.sentStatus = message.sentStatus;
    self.conversationType = message.conversationType;
    self.timestamp = message.timestamp;
    self.orderKey = message.orderKey;
    self.zimMsg = message;
}

- (NSString *)reuseId {
    
    if (self.type == ZIMMessageTypeText) {
        return @"ZIMKitTextMessageCell";
    } else if (self.type == ZIMMessageTypeImage) {
        return @"ZIMKitImageMessageCell";
    } else if (self.type == ZIMKitSystemMessageType) {
        return @"ZIMKitSystemMessageCell";
    } else {
        return @"ZIMKitUnKnowMessageCell";
    }
}

- (CGFloat)cellHeight {
    CGFloat height = 0;
    
    if (_cellHeight > 0) {
        height = _cellHeight;
    } else {
        if (self.needShowTime) {
            height += self.isLastTop ? ZIMKitMessageCell_Top_Time_H : ZIMKitMessageCell_Bottom_Time_H; //时间到顶部的高度
            height += ZIMKitMessageCell_Time_H; // 时间高度
            height += ZIMKitMessageCell_Time_Avatar_Margin; // 时间到头像的间隔
        }

        if (self.needShowName) {
            height += ZIMKitMessageCell_Name_H; //昵称的高度
        }
        
        CGSize size = [self contentSize]; // 内容高度
        
        height += size.height;
        
        height += [self.cellConfig contentViewInsets].top * 2; // 气泡与内容之间的间隔
        height += ZIMKitMessageCell_TO_Cell_Margin; // cell 与cell 之间的间隔
        
        if (height < ZIMKitMessageCell_Default_Height) {
            height = ZIMKitMessageCell_Default_Height;
        }
            
        _cellHeight = height;
    }
    return height;
}

- (CGFloat)resetCellHeight {
    CGFloat height = 0;
    
    if (self.needShowTime) {
        height += ZIMKitMessageCell_Time_H; // 时间高度
        height += ZIMKitMessageCell_Time_Avatar_Margin; // 时间到头像的间隔
    }

    if (self.needShowName) {
        height += ZIMKitMessageCell_Name_H; //昵称的高度
    }
    
    CGSize size = [self contentSize]; // 内容高度
    
    height += size.height;
    
    height += [self.cellConfig contentViewInsets].top * 2; // 气泡与内容之间的间隔
    
    if (height < ZIMKitMessageCell_Default_Height) {
        height = ZIMKitMessageCell_Default_Height;
    } else {
        height += ZIMKitMessageCell_TO_Cell_Margin;
    }
        
    _cellHeight = height;
    
    return height;
}

- (CGSize)contentSize {
    
    return CGSizeZero;
}

- (ZIMKitMessageCellConfig *)cellConfig {
    if (!_cellConfig) {
        _cellConfig = [[ZIMKitMessageCellConfig alloc] initWithMessage:self];
    }
    return _cellConfig;
}

/// 时间戳的单位是ms
- (BOOL)isNeedshowtime:(unsigned long long)timestamp
{
    BOOL result = NO;
    result = (self.timestamp/1000.0 - timestamp/1000.0) > MaxTimeCellToCell;
    return result;
}

/// 是否显示昵称
- (BOOL)needShowName {
    if (self.conversationType == ZIMConversationTypeGroup && self.direction == ZIMMessageDirectionReceive) {
        return YES;
    } else {
        return NO;
    }
}

- (CGSize)sizeAttributedWithFont:(UIFont *)font width:(CGFloat)width  wordWap:(NSLineBreakMode)lineBreadMode string:(NSString *)contentString {
    NSAttributedString *string = [self processCommentContentWithFont:font wordWap:lineBreadMode string:contentString];
    
    // 利用YYTextLayout计算高度
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(width, MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:string];
    CGSize textSize = textLayout.textBoundingSize;
    CGFloat textWidth = textSize.width;
    CGFloat textHeight = textSize.height;

    return  CGSizeMake(ceil(textWidth), ceil(textHeight));
}

- (NSMutableAttributedString *)processCommentContentWithFont:(UIFont *)font wordWap:(NSLineBreakMode)lineBreadMode string:(NSString *)contentString {
    //转成可变属性字符串
    NSMutableAttributedString *mAttributedString = [[NSMutableAttributedString alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:2];
//    [paragraphStyle setParagraphSpacing:2];
    paragraphStyle.lineBreakMode = lineBreadMode;
    NSDictionary *attri = [NSDictionary dictionaryWithObjects:@[font, paragraphStyle] forKeys:@[NSFontAttributeName, NSParagraphStyleAttributeName]];
    [mAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:contentString attributes:attri]];
    //创建匹配正则表达式的类型描述模板
//    NSString *pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    //创建匹配对象
//    NSError *error;
//    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    //判断
//    if (!regularExpression) { //如果匹配规则对象为nil
//        NSLog(@"正则创建失败！");
//        NSLog(@"error = %@",[error localizedDescription]);
//        return nil;
//    } else {
//        NSArray *resultArray = [regularExpression matchesInString:mAttributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, mAttributedString.string.length)];
//        //开始遍历 逆序遍历
//        for (NSInteger i = resultArray.count - 1; i >= 0; i--) {
//            //获取检查结果，里面有range
//            NSTextCheckingResult *result = resultArray[i];
//            //根据range获取字符串
//            NSString *rangeString = [mAttributedString.string substringWithRange:result.range];
//            //获取图片
//            UIImage *image = [self getExpressionWithName:rangeString];//这是个自定义的方法
//
//            if (image != nil) {
//                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithEmojiImage:image fontSize:15.0f];
//                attachText.yy_lineBreakMode = lineBreadMode;
//                //开始替换
//                [mAttributedString replaceCharactersInRange:result.range withAttributedString:attachText];
//            }
//        }
//    }
    
    return mAttributedString;
}
@end
