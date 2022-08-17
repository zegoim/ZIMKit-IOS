//
//  ZIMKitConversationListNoDataView.h
//  ZIMKit
//
//  Created by zego on 2022/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitConversationListNoDataView : UIView

@property (nonatomic, copy) void (^createChatActionBlock)(void);

- (void)setTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
