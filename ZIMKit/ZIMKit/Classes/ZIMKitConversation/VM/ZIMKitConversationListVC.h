//
//  ZIMKitConversationListVC.h
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import <UIKit/UIKit.h>
#import "ZIMKitConversationModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZIMKitConversationListVCDelegate <NSObject>

- (void)onTotalUnreadMessageCountChange:(NSInteger)totalCount;

@end

@interface ZIMKitConversationListVC : UIViewController

@property (nonatomic, weak) id<ZIMKitConversationListVCDelegate>delegate;

@property (nonatomic, copy) void (^logoutBlock)(void);

@end

NS_ASSUME_NONNULL_END
