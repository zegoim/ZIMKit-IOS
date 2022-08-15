//
//  UIImage+ZIMKitUtil.h
//  ZIMKit
//
//  Created by zego on 2022/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZIMKitUtil)

+ (nullable instancetype)zegoImageNamed:(nullable NSString *)name;

+ (UIImage *)ZIMKitConversationImage:(NSString *)imageName;

+ (UIImage *)ZIMKitGroupImage:(NSString *)imageName;

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;

- (UIImage *)originImage:(UIImage *)image size:(CGSize)size;

+ (NSData *)scallGIFWithData:(NSData *)data scallSize:(CGSize)scallSize ;
@end

NS_ASSUME_NONNULL_END
