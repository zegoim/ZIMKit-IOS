//
//  ZIMKitInputTextViewInternal.m
//  ZIMKit
//
//  Created by zego on 2022/7/13.
//

#import "ZIMKitInputTextViewInternal.h"

@implementation ZIMKitInputTextViewInternal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGFloat)contentHeightWithAtrributeString
{
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading; // 文本绘制时的附加选项
    CGSize maximumSize = CGSizeMake(self.frame.size.width - 9, MAXFLOAT); // 用于计算文本绘制时占据的矩形块
    CGRect bounds = [self.attributedText boundingRectWithSize:maximumSize options:options  context:nil];
    return floorf(bounds.size.height);//floorf，取整数精度，结果列如14.00，返回必须这个，要不然绘制图片时会有线条
}


#pragma mark -- UIKeyInput
- (void)deleteBackward {
    [super deleteBackward];
    
    if ([self.input_delegate respondsToSelector:@selector(textViewDeleteBackward:)]) {
        [self.input_delegate textViewDeleteBackward:self];
    }
}

@end
