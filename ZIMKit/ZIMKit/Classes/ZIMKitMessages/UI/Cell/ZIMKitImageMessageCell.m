//
//  ZIMKitImageMessageCell.m
//  ZIMKit
//
//  Created by zego on 2022/7/18.
//

#import "ZIMKitImageMessageCell.h"

@interface ZIMKitImageMessageCell ()

@property (nonatomic, strong) ZIMKitImageMessage *message;

@end

@implementation ZIMKitImageMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _thumbnailImageView = [[UIImageView alloc] init];
        _thumbnailImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_thumbnailImageView addGestureRecognizer:tap];
        _thumbnailImageView.layer.cornerRadius = 5.0;
        [_thumbnailImageView.layer setMasksToBounds:YES];
        _thumbnailImageView.clipsToBounds = YES;
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailImageView.backgroundColor = [UIColor whiteColor];
        _thumbnailImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.containerView addSubview:_thumbnailImageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets edge = [self.message.cellConfig contentViewInsets];
    _thumbnailImageView.frame = CGRectMake(edge.left, edge.top, self.containerView.width - edge.left * 2, self.containerView.height - edge.top * 2);
}

- (void)fillWithMessage:(ZIMKitImageMessage *)message {
    [super fillWithMessage:message];
    self.message = message;
    
    //发送端失败的时候读取本地图片
    if (message.direction == ZIMMessageDirectionSend && message.sentStatus == ZIMMessageSentStatusSendFailed) {
        UIImage *image;
//        NSString *filename = message.fileLocalPath;
//        NSData *data;
//        if (![[NSFileManager defaultManager] fileExistsAtPath:message.fileLocalPath]) {//沙盒目录可能变更
//            NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/ZIMKitSDK/image/"];
//            path = [path stringByAppendingPathComponent:[ZIMKitManager shared].userInfo.userID];
//            filename = [path stringByAppendingPathComponent:[message.fileLocalPath lastPathComponent]];
//        }
//        data = [NSData dataWithContentsOfFile:filename];
//
//        if ([NSData sd_imageFormatForImageData:data] == SDImageFormatGIF) {
//            image = [UIImage sd_imageWithGIFData:data];
//        } else {
//            image = [UIImage imageWithData:data];
//        }
        image = [[SDImageCache sharedImageCache] imageFromCacheForKey:message.fileLocalPath];
        
        if (!image) {
            [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:message.thumbnailDownloadUrl] placeholderImage:[UIImage zegoImageNamed:@"chat_image_fail_bg"]];
        } else {
            self.thumbnailImageView.image = image;
        }
        
    } else {
        [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:message.thumbnailDownloadUrl] placeholderImage:[UIImage zegoImageNamed:@"chat_image_fail_bg"]];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.browseImageBlock) {
        self.browseImageBlock(self.message, self);
    }
}

@end
