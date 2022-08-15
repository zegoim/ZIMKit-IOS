//
//  ZIMKitFaceManagerView.h
//  ZIMKit
//
//  Created by zego on 2022/7/11.
//

#import <UIKit/UIKit.h>

@protocol ZIMKitFaceManagerViewDelegate <NSObject>

///选中表情
- (void)didSelectItem:(NSString *_Nullable)emojiString;

///删除输入内容
- (void)deleteInputItemAction;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitFaceManagerView : UIView

@property (nonatomic, weak) id<ZIMKitFaceManagerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
