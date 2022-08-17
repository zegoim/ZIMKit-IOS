//
//  ZIMKitUnReadView.h
//  ZIMKit
//
//  Created by zego on 2022/5/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitUnReadView : UIView

/// 未读数展示 label
@property (nonatomic, strong) UILabel *unReadLabel;

/// 设置未读数
- (void)setNum:(NSInteger)num;

@end

NS_ASSUME_NONNULL_END
