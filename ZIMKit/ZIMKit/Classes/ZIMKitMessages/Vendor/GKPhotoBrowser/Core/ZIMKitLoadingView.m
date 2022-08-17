//
//  ZIMKitLoadingView.m
//  ZIMKit
//
//  Created by zego on 2022/7/21.
//

#import "ZIMKitLoadingView.h"

@implementation ZIMKitLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.loadingImageView];
        [self addSubview:self.loadingLabel];
        
        [self.loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.loadingImageView.mas_bottom).offset(15.0);
            make.centerX.mas_equalTo(self.loadingImageView.mas_centerX);
        }];
    }
    return self;
}


- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [UIImageView new];
        _loadingImageView.image = [UIImage zegoImageNamed:@"chat_loading"];
        [_loadingImageView sizeToFit];
        _loadingImageView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
        rotationAnimation.duration = 1;
        rotationAnimation.repeatCount = HUGE_VALF;
        rotationAnimation.removedOnCompletion = NO;
        [_loadingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    return _loadingImageView;
}

- (UILabel *)loadingLabel {
    if (!_loadingLabel) {
        _loadingLabel           = [UILabel new];
        _loadingLabel.font      = [UIFont systemFontOfSize:13.0f];
        _loadingLabel.textColor = [UIColor dynamicColor:ZIMKitHexColor(0xFFFFFF) lightColor:ZIMKitHexColor(0xFFFFFF)];
        _loadingLabel.text      = [NSBundle ZIMKitlocalizedStringForKey:@"message_album_loading_txt"];;
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        [_loadingLabel sizeToFit];
        
    }
    return _loadingLabel;
}
@end
