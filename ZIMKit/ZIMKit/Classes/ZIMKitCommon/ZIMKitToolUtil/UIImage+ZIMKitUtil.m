//
//  UIImage+ZIMKitUtil.m
//  ZIMKit
//
//  Created by zego on 2022/5/22.
//

#import "UIImage+ZIMKitUtil.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIImage (ZIMKitUtil)

+ (NSBundle *)ZIMKitChatBundle
{
    static NSBundle *commonBundle = nil;
    if (commonBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        commonBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"ZIMKitNavigationController")] pathForResource:@"ChatResources" ofType:@"bundle"]];
    }
    return commonBundle;
}

+ (nullable instancetype)zegoImageNamed:(nullable NSString *)name
{
    if (name == nil || name.length == 0) {
        return nil;
    }
    
    NSBundle *bundle = [self ZIMKitChatBundle];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

+ (NSBundle *)ZIMKitConversationBundle {
    static NSBundle *conversationBundle = nil;
    if (conversationBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        conversationBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"ZIMKitNavigationController")] pathForResource:@"ConversationResources" ofType:@"bundle"]];
    }
    return conversationBundle;
}

+ (UIImage *)ZIMKitConversationImage:(NSString *)imageName {
    if (imageName == nil || imageName.length == 0) {
        return nil;
    }
    NSBundle *bundle = [self ZIMKitConversationBundle];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

+ (NSBundle *)ZIMKitGruopBundle {
    static NSBundle *groupBundle = nil;
    if (groupBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        groupBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"ZIMKitNavigationController")] pathForResource:@"GroupResources" ofType:@"bundle"]];
    }
    return groupBundle;
}

+ (UIImage *)ZIMKitGroupImage:(NSString *)imageName {
    if (imageName == nil || imageName.length == 0) {
        return nil;
    }
    NSBundle *bundle = [self ZIMKitGruopBundle];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize {
    if ((img.size.width == newsize.width) && (img.size.height == newsize.height)) {
        return img;
    }
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(UIImage *)originImage:(UIImage *)image size:(CGSize)size{
    if ((image.size.width == size.width) && (image.size.height == size.height)) {
        return image;
    }
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);// 关键代码
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (NSData *)scallGIFWithData:(NSData *)data scallSize:(CGSize)scallSize {
  if (!data) {
    return nil;
  }
  CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
  size_t count = CGImageSourceGetCount(source);
  
  // 设置 gif 文件属性 (0:无限次循环)
  NSDictionary *fileProperties = [self filePropertiesWithLoopCount:0];
  
  NSString *tempFile = [NSTemporaryDirectory() stringByAppendingString:@"scallTemp.gif"];
  NSFileManager *manager = [NSFileManager defaultManager];
  if ([manager fileExistsAtPath:tempFile]) {
    [manager removeItemAtPath:tempFile error:nil];
  }
  NSURL *fileUrl = [NSURL fileURLWithPath:tempFile];
  CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileUrl, kUTTypeGIF , count, NULL);
  
  NSTimeInterval duration = 0.0f;
  for (size_t i = 0; i < count; i++) {
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    UIImage *scallImage = [image scallImageWidthScallSize:scallSize];
    
    NSTimeInterval delayTime = [self frameDurationAtIndex:i source:source];
    duration += delayTime;
    // 设置 gif 每针画面属性
    NSDictionary *frameProperties = [self framePropertiesWithDelayTime:delayTime];
    CGImageDestinationAddImage(destination, scallImage.CGImage, (CFDictionaryRef)frameProperties);
    CGImageRelease(imageRef);
  }
  CGImageDestinationSetProperties(destination, (CFDictionaryRef)fileProperties);
  // Finalize the GIF
  if (!CGImageDestinationFinalize(destination)) {
    NSLog(@"Failed to finalize GIF destination");
    if (destination != nil) {
      CFRelease(destination);
    }
    return nil;
  }
  CFRelease(destination);
  CFRelease(source);
  return [NSData dataWithContentsOfFile:tempFile];
}

- (UIImage *)scallImageWidthScallSize:(CGSize)scallSize{
  CGFloat width = self.size.width;
  CGFloat height = self.size.height;
  
  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = scallSize.width;
  CGFloat scaledHeight = scallSize.height;
  CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
  
  if (!CGSizeEqualToSize(self.size, scallSize))
  {
    CGFloat widthFactor = scaledWidth / width;
    CGFloat heightFactor = scaledHeight / height;
    
    scaleFactor = MAX(widthFactor, heightFactor);
    
    scaledWidth= width * scaleFactor;
    scaledHeight = height * scaleFactor;
    
    // center the image
    if (widthFactor > heightFactor)
    {
      thumbnailPoint.y = (scallSize.height - scaledHeight) * 0.5;
    }
    else if (widthFactor < heightFactor)
    {
      thumbnailPoint.x = (scallSize.width - scaledWidth) * 0.5;
    }
  }
  CGRect rect;
  rect.origin = thumbnailPoint;
  rect.size = CGSizeMake(scaledWidth, scaledHeight);
  UIGraphicsBeginImageContext(rect.size);
  [self drawInRect:rect];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return  image;
}

+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
  float frameDuration = 0.1f;
  CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
  NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
  NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
  
  NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
  if (delayTimeUnclampedProp) {
    frameDuration = [delayTimeUnclampedProp floatValue];
  }
  else {
    
    NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
    if (delayTimeProp) {
      frameDuration = [delayTimeProp floatValue];
    }
  }

  if (frameDuration < 0.011f) {
    frameDuration = 0.100f;
  }
  CFRelease(cfFrameProperties);
  frameDuration += 0.1;
  return frameDuration;
}

+ (NSDictionary *)filePropertiesWithLoopCount:(int)loopCount {
  return @{(NSString *)kCGImagePropertyGIFDictionary:
             @{(NSString *)kCGImagePropertyGIFLoopCount: @(loopCount)}
           };
}

+ (NSDictionary *)framePropertiesWithDelayTime:(NSTimeInterval)delayTime {
  
  return @{(NSString *)kCGImagePropertyGIFDictionary:
             @{(NSString *)kCGImagePropertyGIFDelayTime: @(delayTime)},
           (NSString *)kCGImagePropertyColorModel:(NSString *)kCGImagePropertyColorModelRGB
           };
}

@end
