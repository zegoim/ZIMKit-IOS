//
//  ZIMKitImageMessage.m
//  ZIMKit
//
//  Created by zego on 2022/7/18.
//

#import "ZIMKitImageMessage.h"
#import "ZIMKitDefine.h"

@implementation ZIMKitImageMessage

- (void)fromZIMMessage:(ZIMImageMessage *)message {
    [super fromZIMMessage:message];
    self.thumbnailDownloadUrl = message.thumbnailDownloadUrl;
    self.thumbnailLocalPath = message.thumbnailLocalPath;
    self.largeImageDownloadUrl = message.largeImageDownloadUrl;
    self.largeImageLocalPath = message.largeImageLocalPath;
    self.originalImageSize = message.originalImageSize;
    self.largeImageSize = message.largeImageSize;
    self.thumbnailSize = message.thumbnailSize;
}

/// 转成SDK对应的模型
- (ZIMImageMessage *)toZIMTextMessageModel {
    ZIMImageMessage *imageMessage = [[ZIMImageMessage alloc] init];
    imageMessage.largeImageDownloadUrl = self.largeImageDownloadUrl;
    imageMessage.thumbnailDownloadUrl = self.thumbnailDownloadUrl;
    imageMessage.fileLocalPath = self.fileLocalPath;
    imageMessage.fileDownloadUrl = self.fileDownloadUrl;
    return imageMessage;
}

- (instancetype)initWithFileLocalPath:(NSString *)fileLocalPath {
    ZIMKitImageMessage *imageMsg = [[ZIMKitImageMessage alloc] init];
    imageMsg.type = ZIMMessageTypeImage;
    imageMsg.fileLocalPath = fileLocalPath;
    return imageMsg;
}

- (CGSize)contentSize {
    CGSize size = [super contentSize];
    //先给个最小宽高 屏幕的1/3
    size = [self getScaleImage:self.thumbnailSize.width h:self.thumbnailSize.height];
    return size;
}

//根据物理像素
- (CGSize)getScaleImage:(CGFloat)w h:(CGFloat)h {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat mScreenWidth = Screen_Width * scale;
    
    CGFloat maxW = (mScreenWidth * 2/3);
    CGFloat maxH = (mScreenWidth * 2/3);
    
    CGFloat minW = (mScreenWidth /3);
    CGFloat minH = (mScreenWidth /3);
    
    if (w == 0 && h == 0) {
        return CGSizeMake(minW/scale, minH/scale);
    }
    
    if (w <= 0) {
        w = minW;
    }
    
    if (h <= 0) {
        h = minH;
    }
    //容器宽高
    CGFloat thumbnailImgConWidth = 0;
    CGFloat thumbnailImgConHeight = 0;
    
    if (w > h) {
        if (h <= minH) {
            w = (minH / h) * w;
            h = minH;
            if (w <= minW) {
                thumbnailImgConWidth = minW;
                thumbnailImgConHeight = (minW / w) * h;
            } else if (w >= maxW) {
                thumbnailImgConWidth = maxW;
                thumbnailImgConHeight = h;
            } else {
                thumbnailImgConWidth = w;
                thumbnailImgConHeight = h;
            }
        } else if (h >= maxH) {
            w = (maxH / h) * w;
            h = maxH;
            if (w >= maxW) {
                thumbnailImgConWidth = maxW;
                thumbnailImgConHeight = h;
            } else {
                thumbnailImgConWidth = w;
                thumbnailImgConHeight = h;
            }
        } else {
            if (w <= minW) {
                thumbnailImgConWidth = minW;
                thumbnailImgConHeight = (minW / w) * h;
            } else if (w >= maxW) {
                thumbnailImgConWidth = maxW;
                thumbnailImgConHeight = h;
            } else {
                thumbnailImgConWidth = w;
                thumbnailImgConHeight = h;
            }
        }
    } else if (w < h) {
        if (w <= minW) {
            thumbnailImgConWidth = minW;
            thumbnailImgConHeight = maxH;//
        } else if (w >= maxW) {
            thumbnailImgConWidth = maxW;
            thumbnailImgConHeight = maxH;
        } else {
            thumbnailImgConWidth = w;
            thumbnailImgConHeight = maxH;
        }
    } else {
        if (w <= minW) {
            thumbnailImgConWidth = minW;
            thumbnailImgConHeight = maxH;
        } else if (w >= maxW) {
            thumbnailImgConWidth = maxW;
            thumbnailImgConHeight = maxH;
        } else {
            thumbnailImgConWidth = w;
            thumbnailImgConHeight = maxH;
        }
    }

    return CGSizeMake(thumbnailImgConWidth/scale, thumbnailImgConHeight/scale);

}
@end
