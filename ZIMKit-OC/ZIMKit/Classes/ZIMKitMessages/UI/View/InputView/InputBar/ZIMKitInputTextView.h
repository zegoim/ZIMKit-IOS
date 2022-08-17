//
//  ZIMKitInputTextView.h
//  ZIMKit
//
//  Created by zego on 2022/7/13.
//

#import <UIKit/UIKit.h>
#import "ZIMKitInputTextViewInternal.h"
@class ZIMKitInputTextView;

NS_ASSUME_NONNULL_BEGIN

@protocol  ZIMKitInputTextViewDelegate <NSObject>

@optional
- (BOOL)expandingTextViewShouldBeginEditing:(ZIMKitInputTextView *)expandingTextView;
- (BOOL)expandingTextViewShouldEndEditing:(ZIMKitInputTextView *)expandingTextView;

- (void)expandingTextViewDidBeginEditing:(ZIMKitInputTextView *)expandingTextView;
- (void)expandingTextViewDidEndEditing:(ZIMKitInputTextView *)expandingTextView;

- (void)expandingTextViewDidChange:(ZIMKitInputTextView *)expandingTextView deleteChar:(BOOL)isDeleteChar;

- (void)expandingTextViewDidChangeSelection:(ZIMKitInputTextView *)expandingTextView;

- (void)expandingTextViewDeleteBackward:(ZIMKitInputTextView *)expandingTextView;
@end

@interface ZIMKitInputTextView : UIView<UITextViewDelegate, ZIMKitInputTextViewInternalDelegate>

/**
 *  @brief 文本框
 */
@property (nonatomic, strong) ZIMKitInputTextViewInternal *internalTextView;
/**
 *  @brief delegate
 */
@property (nonatomic, weak) id<ZIMKitInputTextViewDelegate> delegate;
/**
 *  @brief 短信内容
 */
@property (nonatomic, strong) NSString            *text;

@property (nonatomic, strong) NSAttributedString  *attributeText;
/**
 *  @brief 字体
 */
@property (nonatomic, strong) UIFont              *font;
/**
 *  @brief 颜色
 */
@property (nonatomic, strong) UIColor             *textColor;
/**
 *  @brief 选择文本range
 */
@property(nonatomic) NSRange                     selectedRange;
/**
 *  @brief 是否可编辑
 */
@property(nonatomic) BOOL          editable;
/**
 *  @brief 文本格式
 */
@property(nonatomic) UIDataDetectorTypes         dataDetectorTypes;
/**
 *  @brief 返回键类型
 */
@property(nonatomic) UIReturnKeyType             returnKeyType;
/**
 *  @brief 背景视图
 */
@property(nonatomic,strong) UIImageView         *textViewBackgroundImage;

- (BOOL)hasText;

- (void)scrollRangeToVisible:(NSRange)range;

- (void)textViewDidChange:(UITextView *)textView;

@end

NS_ASSUME_NONNULL_END
