//
//  ZIMKitMessagesListVC+InputBar.m
//  ZIMKit
//
//  Created by zego on 2022/7/13.
//

#import "ZIMKitMessagesListVC+InputBar.h"

@implementation ZIMKitMessagesListVC (InputBar)

- (void)updateTableViewLayout {
    CGRect tRect = self.messageTableView.frame;
    CGFloat needUpHeight = (self.messageTableView.frame.size.height - self.messageToolbar.inputBar.frame.origin.y);
    
     if (self.messageTableView.contentSize.height < self.messageTableView.bounds.size.height) {
         CGFloat blankSpace = self.messageTableView.bounds.size.height-self.messageTableView.contentSize.height;
         if (blankSpace > needUpHeight) {
             needUpHeight = 0;
         } else {
             needUpHeight = needUpHeight - blankSpace;
         }
     }
    
     tRect.origin.y = -needUpHeight;
     self.messageTableView.frame = tRect;
//     if (self.messageTableView.contentSize.height > self.messageTableView.bounds.size.height){
         [self scrollToBottom:NO];
//     }
}

#pragma mark ZIMKitMessageSendToolbarDelegate
- (void)messageToolbarInputFrameChange {
    [self updateTableViewLayout];
}

- (void)messageToolbarSendTextMessage:(NSString *)text {
    [self sendAction:text];
}

- (void)messageToolbarDidSelectedMoreViewItemAction:(ZIMKitFunctionType)type {
    if (type == ZIMKitFunctionTypePhoto) {
        [self imagePicker];
    }
}

#pragma mark 相册选择
- (void)imagePicker {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];

    imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPreview = YES;//不允许的话GIF 图片不能多选
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    //导航栏
    imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    imagePickerVc.navigationBar.barStyle = UIBarStyleBlack;
    imagePickerVc.navigationBar.barTintColor = UIColor.whiteColor;
    imagePickerVc.navigationBar.tintColor = UIColor.darkGrayColor;
    imagePickerVc.barItemTextColor = UIColor.darkGrayColor;
    imagePickerVc.naviTitleColor = UIColor.darkGrayColor;
    imagePickerVc.navigationItem.backBarButtonItem = [UIBarButtonItem new];
    
    //主题色
    UIColor *themeColor = [UIColor dynamicColor:ZIMKitHexColor(0x3478FC) lightColor:ZIMKitHexColor(0x3478FC)];
    imagePickerVc.oKButtonTitleColorNormal = themeColor;
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    
    //显示选择排序下标
    imagePickerVc.iconThemeColor = themeColor;
    imagePickerVc.showSelectedIndex = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (int i=0; i<assets.count; i++) {
            PHAsset *asset = assets[i];
            NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
            NSString *orgFilename = ((PHAssetResource*)resources[0]).originalFilename;
            PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
            // resource包含大小和宽高
            // file:///var/mobile/Media/DCIM/165APPLE/IMG_5225.MOV
            NSURL *tempPrivateFileURL = [resource valueForKey:@"privateFileURL"];

            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                [self sendImageMessage:imageData fileName:orgFilename];
            }];
        }
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    //隐藏有导航栏按钮
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIViewController *vc in imagePickerVc.childViewControllers) {
            vc.navigationItem.backBarButtonItem = [UIBarButtonItem new];
            vc.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
        }
    });
}
@end
