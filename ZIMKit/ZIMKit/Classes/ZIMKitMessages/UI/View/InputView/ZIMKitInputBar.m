//
//  ZIMKitInputBar.m
//  ZIMKit
//
//  Created by zego on 2022/6/1.
//

#import "ZIMKitInputBar.h"

@interface ZIMKitInputBar ()

@property (nonatomic, assign) InputStatus status;

@end

@implementation ZIMKitInputBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
        [self addObserver];
        self.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
    }
    return self;
}

- (void)setupViews {
    _inputTextView = [[UITextView alloc] init];
    _inputTextView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2) lightColor:ZIMKitHexColor(0xF2F2F2)];
    _inputTextView.layer.cornerRadius = 12.0;
    _inputTextView.font = [UIFont systemFontOfSize:15];
    _inputTextView.contentInset = UIEdgeInsetsMake(5, 10, 5, 5);
    [self addSubview:_inputTextView];
    _inputTextView.frame = CGRectMake(12.0, 8.5, self.width - 12*3 -34 , ZIMKitChatToolBarHeight - 8.5*2);
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setImage:[UIImage zegoImageNamed:@"sendMessage_icon"] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButton];
    _sendButton.frame = CGRectMake(_inputTextView.maxX + 12, 13.5, 34, ZIMKitChatToolBarHeight - 13.5*2);
    
    self.status = InputStatusInput;
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)sendAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(sendAction:)]) {
        [_delegate sendAction:self.inputTextView.text];
    }
    self.inputTextView.text = @"";
}

- (void)reset {
    if (self.status == InputStatusInput) {
        return;
    }
    _status = InputStatusInput;
    [_inputTextView resignFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(inputBar:keyboardWillHide:)]){
        [_delegate inputBar:self keyboardWillHide:0];
    }
}
#pragma mark UIKeyboard
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (_delegate && [_delegate respondsToSelector:@selector(inputBar:keyboardWillShow:)]){
        [_delegate inputBar:self keyboardWillShow:keyboardFrame.size.height];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.status = InputStatusInput;
    if (_delegate && [_delegate respondsToSelector:@selector(inputBar:keyboardWillHide:)]){
        [_delegate inputBar:self keyboardWillHide:0];
    }
}
- (void)keyboardWillShow:(NSNotification *)notification {
    self.status = InputStatusInputKeyboard;
}
@end
