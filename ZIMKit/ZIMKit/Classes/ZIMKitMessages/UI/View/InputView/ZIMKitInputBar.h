//
//  ZIMKitInputBar.h
//  ZIMKit
//
//  Created by zego on 2022/6/1.
//

#import <UIKit/UIKit.h>

@class ZIMKitInputBar;
@protocol ZIMKitInputBarDelegate <NSObject>

- (void)sendAction:(NSString *_Nullable)text;

- (void)inputBar:(ZIMKitInputBar *_Nullable)inputView keyboardWillShow:(CGFloat)height;

- (void)inputBar:(ZIMKitInputBar *_Nullable)inputView keyboardWillHide:(CGFloat)height;

@end

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, InputStatus) {
    InputStatusInput,
    InputStatusInputFace,
    InputStatusInputMore,
    InputStatusInputKeyboard,
};

@interface ZIMKitInputBar : UIView

@property (nonatomic, weak) id<ZIMKitInputBarDelegate>delegate;

@property (nonatomic, strong) UITextView *inputTextView;

@property (nonatomic, strong) UIButton *sendButton;


- (void)reset;
@end

NS_ASSUME_NONNULL_END
