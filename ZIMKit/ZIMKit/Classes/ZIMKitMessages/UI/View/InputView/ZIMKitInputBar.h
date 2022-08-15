//
//  ZIMKitInputBar.h
//  ZIMKit
//
//  Created by zego on 2022/6/1.
//

#import <UIKit/UIKit.h>
#import "ZIMKitInputTextView.h"

typedef enum {
    Kit_Default,//正常文字输入框
    Kit_VoiceInput//声音输入框
} ZIMKitBottomInputType;

typedef enum {
    Kit_Emotion,//显示表情
    Kit_Keyboard,//显示文字键盘
    Kit_Function,//显示功能按钮，相册、照相机等
} ZIMKitInputKeyboardType;//输入框键盘类型

typedef NS_ENUM(NSInteger, ZIMKitInputToolbarType)
{
    ZIMKitInputToolbar_Default = 0,//显示功能区
    ZIMKitInputToolbar_HiddenFunction,//隐藏功能区
};

typedef NS_ENUM(NSUInteger, InputStatus) {
    InputStatusInput,
    InputStatusInputFace,
    InputStatusInputMore,
    InputStatusInputKeyboard,
};

typedef enum {
    ZIMKitKeyboardStatus_Emotion,//表情
    ZIMKitKeyboardStatus_Keyboard,//键盘
    ZIMKitKeyboardStatus_Function,//功能
    ZIMKitKeyboardStatus_None,
} ZIMKitKeyboardStatusType;

@class ZIMKitInputBar;
@protocol ZIMKitInputBarDelegate <NSObject>

///点击语音/键盘按钮切换
- (void)inputViewSwitchInputType:(ZIMKitBottomInputType)type;
///点击表情/键盘按钮切换
- (void)inputViewEmotionButtonClick:(ZIMKitInputKeyboardType)type;
///点击+按钮切换
- (void)inputViewFunctionButtonClick:(ZIMKitInputKeyboardType)type;
///更改高度
- (void)moveBottomInputViewWithHeight:(float)height withDuration:(NSTimeInterval)time;
/// 输入框文本发生了改变
- (void)inputViewTextDidChange:(ZIMKitInputBar *_Nullable)inputToolBar deleteChar:(BOOL)isDeleteChar;

/// 点击了键盘的删除
- (void)inputViewDeleteBackward:(ZIMKitInputBar *_Nullable)inputToolBar;

- (void)sendMessageAction:(NSString *_Nullable)text;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitInputBar : UIView <ZIMKitInputBarDelegate>

@property (nonatomic, weak) id<ZIMKitInputBarDelegate>delegate;
///文本输入
@property (nonatomic, strong) ZIMKitInputTextView *inputTextView;
///表情按钮
@property (nonatomic, strong) UIButton *emotionButton;
///发送按钮
@property (nonatomic, strong) UIButton *sendButton;
///加号按钮
@property (nonatomic, strong) UIButton  *funcButton;

@property (nonatomic, assign) ZIMKitInputToolbarType style;
@property (nonatomic, assign) ZIMKitInputToolbarType   type;
@property (nonatomic, assign) ZIMKitInputKeyboardType  inputKBType;

@property (nonatomic, assign) CGFloat toolbarH;//当前高度

- (void)setNoForEmotionAndFuction;
- (void)setCanOrNotClick:(BOOL)isClick;
- (void)switchTextInputState;
//- (void)selectedVoice;
- (void)switchToTextInput;

//改变为文本键盘
- (void)switchTextInputText;

//- (void)reset;
@end

NS_ASSUME_NONNULL_END
