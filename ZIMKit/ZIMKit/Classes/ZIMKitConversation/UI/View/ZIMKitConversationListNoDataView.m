//
//  ZIMKitConversationListNoDataView.m
//  ZIMKit
//
//  Created by zego on 2022/5/21.
//

#import "ZIMKitConversationListNoDataView.h"
#import "ZIMKitDefine.h"
#import <Masonry/Masonry.h>

@interface ZIMKitConversationListNoDataView ()

/// Nodata label
@property (nonatomic, strong) UILabel *noDataLabel;
/// 创建聊天按钮
@property (nonatomic, strong) UIButton *createChatBtn;

@end

@implementation ZIMKitConversationListNoDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _noDataLabel = [[UILabel alloc] init];
    _noDataLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _noDataLabel.textAlignment = NSTextAlignmentCenter;
    _noDataLabel.text = [NSBundle ZIMKitlocalizedStringForKey:@"conversation_empty"];
    _noDataLabel.numberOfLines = 0;
    _noDataLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xA4A4A4) lightColor:ZIMKitHexColor(0xA4A4A4)];
    _noDataLabel.layer.masksToBounds = YES;
    [self addSubview:_noDataLabel];
    
    _createChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_createChatBtn setTitle:[NSBundle ZIMKitlocalizedStringForKey:@"conversation_start_chat"] forState:UIControlStateNormal];
    _createChatBtn.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
    [_createChatBtn setTitleColor:[UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)] forState:UIControlStateNormal];
    _createChatBtn.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0x3478FC) lightColor:ZIMKitHexColor(0x3478FC)];
    _createChatBtn.layer.cornerRadius = 12.0;
    [_createChatBtn addTarget:self action:@selector(createChatBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_createChatBtn];
    
    [self layout];
}

- (void)layout {
    [_noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
//        make.centerY.mas_equalTo(self.mas_centerY);
        make.top.mas_equalTo(self.mas_top).offset(self.height*1/3);
    }];
    
    [_createChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.noDataLabel.mas_bottom).offset(200);
        make.left.mas_equalTo(self.mas_left).offset(37.0);
        make.right.mas_equalTo(self.mas_right).offset(-37.0);
        make.height.mas_equalTo(50.0);
    }];
}

- (void)createChatBtnAction {
    if (_createChatActionBlock) {
        _createChatActionBlock();
    }
}

- (void)setTitle:(NSString *)title {
    [_createChatBtn setTitle:title forState:UIControlStateNormal];
    _noDataLabel.hidden = YES;
}

@end
