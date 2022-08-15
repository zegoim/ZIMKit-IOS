//
//  ZIMKitMessageSendToolbar.m
//  ZIMKit
//
//  Created by zego on 2022/8/11.
//

#import "ZIMKitMessageSendToolbar.h"

@interface ZIMKitMessageSendToolbar ()<ZIMKitInputBarDelegate, ZIMKitFaceManagerViewDelegate, ZIMKitChatBarMoreViewDelegate>

/// 键盘的rect
@property (nonatomic, assign) CGRect                keyboardRect;

///是否显示了键盘
@property (nonatomic, assign) BOOL                  isShowKeybord;

/// 键盘动画时间
@property (nonatomic, assign) double                animationDuration;

///键盘类型
@property (nonatomic, assign) ZIMKitKeyboardStatusType type;

@property (nonatomic, strong) UIView                *fatherView;

@end

@implementation ZIMKitMessageSendToolbar

- (instancetype)initWithSuperView:(UIView *)fatherView {
    self = [super init];
    if (self) {
        _fatherView = fatherView;
        [self.fatherView addSubview:self.inputBar];
        [self addObserver];
    }
    return self;
}

- (void)addObserver {
    //键盘即将显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘即将消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    //键盘高度发生改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.isShowKeybord = YES;
}

//键盘即将隐藏
- (void)keyboardWillHidden:(NSNotification *)notification
{
    self.keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.isShowKeybord = NO;
}

//键盘发生改变
- (void)keyboardChange:(NSNotification *)notification
{
    if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y < CGRectGetHeight(self.fatherView.frame)) {
        [self keyboardWithMessageRect:
         [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] inputViewRect:self.inputBar.frame
                                      duration:self.animationDuration
                                    state:ZIMKitKeyboardStatus_Keyboard];
        self.type = ZIMKitKeyboardStatus_Keyboard;
    } else {
        if (self.isShowKeybord) {
            if (self.type == ZIMKitKeyboardStatus_Keyboard) {
                CGRect finalRect = CGRectZero;
                
                if (self.inputBar.inputKBType == Kit_Emotion) {
                    finalRect = self.faceKeyBoard.bounds;
                }else if (self.inputBar.inputKBType == Kit_Function) {
                    finalRect = self.moreFunctionView.bounds;
                }
                [self keyboardWithMessageRect:finalRect inputViewRect:self.inputBar.frame duration:self.animationDuration state:ZIMKitKeyboardStatus_None];
                self.type = ZIMKitKeyboardStatus_None;
            }
        }
    }
}

/// 隐藏键盘
- (void)hiddeKeyborad
{
    if ([self.inputBar.inputTextView.internalTextView isFirstResponder] || self.type == ZIMKitKeyboardStatus_Keyboard) {
        self.inputBar.inputKBType = Kit_Keyboard;
        [self.inputBar.inputTextView.internalTextView resignFirstResponder];
        
        // 当键盘是文字键盘时，在聊天界面跳转进其他页面时，toolbar键盘不会弹下去
        [self keyboardWithMessageRect:CGRectZero inputViewRect:self.inputBar.bounds duration:self.animationDuration != 0?self.animationDuration:0.25  state:ZIMKitKeyboardStatus_None];
    }
    
    if (self.type  == ZIMKitKeyboardStatus_Emotion || self.type == ZIMKitKeyboardStatus_Function) {
        [self keyboardWithMessageRect:CGRectZero inputViewRect:self.inputBar.bounds duration:self.animationDuration != 0?self.animationDuration:0.25  state:ZIMKitKeyboardStatus_None];
    }
    
    self.type = ZIMKitKeyboardStatus_None;
    [self.inputBar setNoForEmotionAndFuction];
}

- (void)keyboardWithMessageRect:(CGRect)rect inputViewRect:(CGRect)inputViewRect duration:(double)duration state:(ZIMKitKeyboardStatusType)state
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIMenuControllerWillHideMenuNotification object:nil];
    [UIView animateWithDuration:duration animations:^
     {
         CGRect keyboardRect = rect;// 这个rect是包含系统输入键盘，表情键盘，功能键盘
         CGRect inputRect = inputViewRect;
         switch (state)
         {
             case ZIMKitKeyboardStatus_Emotion://表情
             {
                 if (Bottom_SafeHeight) {
                     inputRect.size.height = ZIMKitChatToolBarHeight;
                 }
                 self.faceKeyBoard.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) - CGRectGetHeight(rect), CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(rect));
                 self.moreFunctionView.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(self.moreFunctionView.frame));
             }
                 break;
             case ZIMKitKeyboardStatus_Keyboard://系统键盘
             {
                 if (Bottom_SafeHeight) {
                     inputRect.size.height = ZIMKitChatToolBarHeight;
                 }
                 self.faceKeyBoard.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(self.faceKeyBoard.frame));
                 self.moreFunctionView.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame), CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(self.moreFunctionView.frame));
             }
                 break;
             case ZIMKitKeyboardStatus_Function://功能
             {
                 if (Bottom_SafeHeight) {
                     inputRect.size.height = ZIMKitChatToolBarHeight;
                 }
                 self.moreFunctionView.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) - CGRectGetHeight(rect), CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(rect));
                 
                 self.faceKeyBoard.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(self.faceKeyBoard.frame));
             }
                 break;
                 
             case ZIMKitKeyboardStatus_None://正常
             {
                 if (Bottom_SafeHeight) {
                     inputRect.size.height = ZIMKitChatToolBarHeight +Bottom_SafeHeight;
                 }
                 self.faceKeyBoard.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(self.faceKeyBoard.frame));
                 self.moreFunctionView.frame = CGRectMake(0.0f, CGRectGetHeight(self.fatherView.frame) + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), CGRectGetHeight(self.moreFunctionView.frame));
             }
                 break;
             default:
                 break;
         }
         
        self.inputBar.frame = CGRectMake(0.0f,
                                         CGRectGetHeight(self.fatherView.frame)-CGRectGetHeight(keyboardRect)-CGRectGetHeight(inputRect),
                                         CGRectGetWidth(self.fatherView.frame),
                                         CGRectGetHeight(inputRect));
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolbarInputFrameChange)]) {
            [self.delegate messageToolbarInputFrameChange];
        }
     } completion:^(BOOL finished) {
     }];
}

#pragma mark ZIMKitInputBarDelegate
//切换声音、文字
- (void)inputViewEmotionButtonClick:(ZIMKitInputKeyboardType)type {
    self.faceKeyBoard.hidden = NO;
    if (type == Kit_Keyboard) {//键盘
        [self keyboardWithMessageRect:self.keyboardRect inputViewRect:self.inputBar.frame duration:self.animationDuration state:ZIMKitKeyboardStatus_Keyboard];
        self.type = ZIMKitKeyboardStatus_Keyboard;
    }else{//表情
        [self keyboardWithMessageRect:self.faceKeyBoard.frame inputViewRect:self.inputBar.frame duration:self.animationDuration != 0?self.animationDuration:0.25 state:ZIMKitKeyboardStatus_Emotion];
        self.type = ZIMKitKeyboardStatus_Emotion;
    }
}

//功能键盘点击
- (void)inputViewFunctionButtonClick:(ZIMKitInputKeyboardType)type {
    if (type == Kit_Keyboard) {//键盘
        [self keyboardWithMessageRect:self.keyboardRect inputViewRect:self.inputBar.frame duration:self.animationDuration state:ZIMKitKeyboardStatus_Keyboard];
        self.type = ZIMKitKeyboardStatus_Keyboard;
    } else {//功能
        [self keyboardWithMessageRect:self.moreFunctionView.frame inputViewRect:self.inputBar.frame duration:self.animationDuration != 0 ? self.animationDuration:0.25 state:ZIMKitKeyboardStatus_Function];
        self.type = ZIMKitKeyboardStatus_Function;
    }
}

- (void)sendMessageAction:(NSString *)text {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolbarSendTextMessage:)]) {
        [self.delegate messageToolbarSendTextMessage:text];
    }
}

#pragma mark ZIMKitFaceManagerViewDelegate (表情键盘的点击和删除)
- (void)didSelectItem:(NSString *_Nullable)emojiString {
    NSString *content = [NSString stringWithFormat:@"%@", self.inputBar.inputTextView.text];
    NSMutableString *muContent = [NSMutableString stringWithString:content];
    NSRange range = self.inputBar.inputTextView.selectedRange;
    [muContent insertString:emojiString atIndex:range.location];
    self.inputBar.inputTextView.text = muContent;
    //记录位置,用户有可能会把光标移动到某个位置,在输入表情
    self.inputBar.inputTextView.selectedRange = NSMakeRange(range.location+emojiString.length, 0);
}

- (void)deleteInputItemAction {

    [self.inputBar.inputTextView.internalTextView deleteBackward];
}

#pragma mark ZIMKitChatBarMoreViewDelegate 功能键盘的点击
- (void)didSelectedMoreViewItemAction:(ZIMKitFunctionType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageToolbarDidSelectedMoreViewItemAction:)]) {
        [self.delegate messageToolbarDidSelectedMoreViewItemAction:type];
    }
}

#pragma mark lazy
//输入框
- (ZIMKitInputBar *)inputBar {
    if (!_inputBar) {
        _inputBar = [[ZIMKitInputBar alloc] initWithFrame:CGRectMake(0, self.fatherView.height - ZIMKitChatToolBarHeight-Bottom_SafeHeight, self.fatherView.width, ZIMKitChatToolBarHeight+Bottom_SafeHeight)];
        _inputBar.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        _inputBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _inputBar.delegate = self;
    }
    return _inputBar;
}

/// 表情键盘
- (ZIMKitFaceManagerView *)faceKeyBoard {
    if (!_faceKeyBoard) {
        _faceKeyBoard = [[ZIMKitFaceManagerView alloc] initWithFrame:CGRectMake(0.0f, self.fatherView.bounds.size.height + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), kMessageFaceViewHeight)];
        _faceKeyBoard.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        _faceKeyBoard.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        _faceKeyBoard.delegate = self;
        [self.fatherView addSubview:_faceKeyBoard];
    }
    return _faceKeyBoard;
}

///功能键盘
- (ZIMKitChatBarMoreView *)moreFunctionView {
    if (!_moreFunctionView) {
        _moreFunctionView = [[ZIMKitChatBarMoreView alloc] initWithFrame:CGRectMake(0.0f, self.fatherView.bounds.size.height + Bottom_SafeHeight, CGRectGetWidth(self.fatherView.frame), kChatBarMoreView)];
        _moreFunctionView.delegate = self;
        _moreFunctionView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        [self.fatherView addSubview:_moreFunctionView];
    }
    
    return _moreFunctionView;
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)dealloc {
    [self removeObserver];
}

@end
