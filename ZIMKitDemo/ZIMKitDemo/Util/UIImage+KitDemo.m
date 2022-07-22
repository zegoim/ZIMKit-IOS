//
//  UIImage+KitDemo.m
//  ZIMKitDemo
//
//  Created by zego on 2022/5/18.
//

#import "UIImage+KitDemo.h"

@implementation UIImage (KitDemo)

+ (UIImage *)kitDemo_imageName:(NSString *)imageName {
    return [UIImage imageNamed:imageName];
}

//通过颜色来生成一个纯色图片
+(UIImage *)imageFromColor:(UIColor *)color rectSize:(CGRect)Rect
{
    UIGraphicsBeginImageContext(Rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, Rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
