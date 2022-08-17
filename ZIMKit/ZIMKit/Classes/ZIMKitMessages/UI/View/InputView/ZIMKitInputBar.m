//
//  ZIMKitInputBar.m
//  ZIMKit
//
//  Created by zego on 2022/6/1.
//

#import "ZIMKitInputBar.h"

#define ZIMKitFaceKeybordH 250
#define inputViewH 44
#define inputButtonH 34
#define inputMargin 12

@interface ZIMKitInputBar ()<ZIMKitInputTextViewDelegate>

@property (nonatomic, assign) InputStatus status;

@property (nonatomic, assign) ZIMKitBottomInputType currentType;

/// 切换声音键盘、文字键盘的声音按钮
@property (nonatomic, strong) UIButton  *voiceButton;

///按住说话的按钮
@property (nonatomic, strong) UIButton  *voiceControl;

/// 最右边的按钮为发送状态
@property (nonatomic, assign) BOOL isSend;

@end

@implementation ZIMKitInputBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupToolbar];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupToolbar];
    }
    return self;
}
   

- (void)setCanOrNotClick:(BOOL)isClick{
    if (isClick){
        self.userInteractionEnabled = YES;
    }
    else {
        self.userInteractionEnabled = NO;
    }
}

- (void)setStyle:(ZIMKitInputToolbarType)style{
    _style = style;
}

- (void)setupToolbar {
    CGFloat buttonTop = (ZIMKitChatToolBarHeight - inputButtonH)*0.5;
    
    //文字输入框
    self.inputTextView = [[ZIMKitInputTextView alloc] initWithFrame:CGRectMake(inputMargin, (ZIMKitChatToolBarHeight - inputViewH)*0.5, (Screen_Width - inputMargin - inputButtonH*2 - inputMargin*3), inputViewH)];
    self.inputTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.inputTextView.delegate = self;
    self.inputTextView.layer.cornerRadius = 12.0;
    self.inputTextView.font = [UIFont systemFontOfSize:15];
    self.inputTextView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2) lightColor:ZIMKitHexColor(0xF2F2F2)];
    [self addSubview:self.inputTextView];
    
    // 表情
    self.emotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.emotionButton.frame = CGRectMake(self.bounds.size.width - inputButtonH*2 - inputMargin*2, buttonTop, inputButtonH, inputButtonH);
    self.emotionButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.emotionButton addTarget:self action:@selector(switchButtonClcick:) forControlEvents:UIControlEventTouchUpInside];
    [self.emotionButton setImage:[UIImage zegoImageNamed:@"chat_faceIcon"] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage zegoImageNamed:@"chat_face_keybordIcon"] forState:UIControlStateSelected];
    [self addSubview:self.emotionButton];
    
    //功能
    self.funcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.funcButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.funcButton.frame = CGRectMake(self.bounds.size.width - inputButtonH - inputMargin, buttonTop, inputButtonH, inputButtonH);
    [self.funcButton addTarget:self action:@selector(switchButtonClcick:) forControlEvents:UIControlEventTouchUpInside];
    [self.funcButton setImage:[UIImage zegoImageNamed:@"chat_face_functionIcon"] forState:UIControlStateNormal];
    [self.funcButton setImage:[UIImage zegoImageNamed:@"chat_face_functionIcon"] forState:UIControlStateSelected];
    [self addSubview:self.funcButton];
    
    self.inputTextView.hidden = NO;
}

- (void)setType:(ZIMKitInputToolbarType)type {
    _type = type;
    
    switch (type) {
        case ZIMKitInputToolbar_Default:{
        
        }
            break;
        case ZIMKitInputToolbar_HiddenFunction: {
            self.emotionButton.frame = CGRectMake(self.bounds.size.width - inputButtonH*2 - inputMargin*2, (ZIMKitChatToolBarHeight - inputButtonH) * 0.5, inputButtonH, inputButtonH);
            [self.funcButton removeFromSuperview];
            CGRect oldRect = CGRectMake(45, (ZIMKitChatToolBarHeight - 37) * 0.5, (Screen_Width - 45 - 85), 37);
            oldRect.size.width += 40;
            self.inputTextView.frame = oldRect;
        }
            break;
        
        default:
            break;
    }
}

- (void)setNoForEmotionAndFuction {
    self.emotionButton.selected = NO;
    self.funcButton.selected = NO;
}

- (void)switchTextInputState {
    self.inputTextView.hidden = NO;
}

- (void)switchStatusForVoiceControlAndTextView:(BOOL)hidden {
    
    self.inputTextView.hidden = !hidden;
    if (!hidden) {
        self.emotionButton.selected = NO;
        self.funcButton.selected = NO;
    }
}

- (void)switchButtonClcick:(UIButton *)switchButton {
    if (switchButton != self.funcButton) {
        self.funcButton.selected = NO;
    }
    
    if (switchButton != self.emotionButton) {
        self.emotionButton.selected = NO;
    }
    
    if (switchButton == self.emotionButton) {
        self.emotionButton.selected = !self.emotionButton.isSelected;
        [self switchToTextInput];
        if (!self.emotionButton.selected) {// 键盘
            self.inputKBType = Kit_Keyboard;
            [self.inputTextView.internalTextView becomeFirstResponder];
        } else {// 表情
            self.inputKBType = Kit_Emotion;
            [self.inputTextView.internalTextView resignFirstResponder];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewEmotionButtonClick:)]) {// 功能点击
            [self.delegate inputViewEmotionButtonClick:self.emotionButton.selected ? Kit_Emotion : Kit_Keyboard];
        }
    } else {//文件
        if (self.isSend) { //发送消息
            if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessageAction:)]) {
                [self.delegate sendMessageAction:self.inputTextView.internalTextView.text];
                self.inputTextView.internalTextView.text = @"";
                [self changSendButtonIcon:NO];
                return;
            }
        }
        
        self.funcButton.selected = !self.funcButton.isSelected;
        [self switchToTextInput];
        if (!self.funcButton.selected) {// 键盘
            self.inputKBType = Kit_Keyboard;
            [self.inputTextView.internalTextView becomeFirstResponder];
        } else {// 表情
            self.inputKBType = Kit_Function;
            [self.inputTextView.internalTextView resignFirstResponder];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewFunctionButtonClick:)]) {// 功能点击
            [self.delegate inputViewFunctionButtonClick:self.funcButton.selected ? Kit_Function : Kit_Keyboard];
        }
    }
}
    
- (void)changSendButtonIcon:(BOOL)isSend {
    self.isSend = isSend;
    if (isSend) {
        [self.funcButton setImage:[UIImage zegoImageNamed:@"sendMessage_icon"] forState:UIControlStateNormal];
        [self.funcButton setImage:[UIImage zegoImageNamed:@"sendMessage_icon"] forState:UIControlStateSelected];
    } else {
        [self.funcButton setImage:[UIImage zegoImageNamed:@"chat_face_functionIcon"] forState:UIControlStateNormal];
        [self.funcButton setImage:[UIImage zegoImageNamed:@"chat_face_functionIcon"] forState:UIControlStateSelected];
    }
}

- (void)switchTextInputText {
    self.voiceButton.selected = YES;
    [self switchButtonClcick:self.voiceButton];
}

- (void)switchToTextInput {
    if (self.voiceButton.selected) {//切换为文本输入
        self.voiceButton.selected = NO;
        
        self.voiceControl.hidden = YES;
        
        self.inputTextView.hidden = NO;
    }
}
 
#pragma mark UIExpandingTextView delegate
- (BOOL)expandingTextViewShouldBeginEditing:(ZIMKitInputTextView *)expandingTextView {
    return YES;
}

- (void)expandingTextViewDidBeginEditing:(ZIMKitInputTextView *)expandingTextView{
    [self setNoForEmotionAndFuction];
}

- (void)expandingTextViewDidEndEditing:(ZIMKitInputTextView *)expandingTextView{

}

///文字输入框文本发生了改变
- (void)expandingTextViewDidChange:(ZIMKitInputTextView *)expandingTextView  deleteChar:(BOOL)isDeleteChar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewTextDidChange:deleteChar:)]) {
        [self.delegate inputViewTextDidChange:self deleteChar:isDeleteChar];
    }

    [self changSendButtonIcon:expandingTextView.text.length];
}

///点击了键盘的删除
- (void)expandingTextViewDeleteBackward:(ZIMKitInputTextView *)expandingTextView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDeleteBackward:)]) {
        [self.delegate inputViewDeleteBackward:self];
    }
}

@end
