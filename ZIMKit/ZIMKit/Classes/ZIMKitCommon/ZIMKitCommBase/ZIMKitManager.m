//
//  ZIMKitManager.m
//  ZIMKit
//
//  Created by zego on 2022/5/18.
//

#import "ZIMKitManager.h"
#import "ZIMKitEventHandler.h"
#import "ZIMKitDefine.h"

@interface ZIMKitManager ()

@property (nonatomic, strong, readwrite) ZIM *zim;
@property (nonatomic, strong, readwrite) ZIMUserFullInfo *userfullinfo;
@end

@implementation ZIMKitManager

+ (instancetype)shared {
    static ZIMKitManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZIMKitManager alloc] init];
    });
    return instance;
}

- (void)createZIM:(int)appID appSign:(nonnull NSString *)appSign {
    ZIMAppConfig *config = [ZIMAppConfig new];
    config.appID = appID;
    config.appSign = appSign;
    self.zim = [ZIM createWithAppConfig:config];
    [self.zim setEventHandler:[ZIMKitEventHandler shared]];
    NSLog(@"ZIM 已经初始化了-----");
}

- (void)destroy {
    [self.zim destroy];
}

- (void)login:(ZIMUserInfo *)userInfo
     callback:(ZIMLoggedInCallback)callback {
    self.userfullinfo.baseInfo = userInfo;
    @weakify(self);
    [self.zim loginWithUserInfo:userInfo token:@"" callback:^(ZIMError * _Nonnull errorInfo) {
        @strongify(self);
        [self createCachePath];
        if (callback) {
            callback(errorInfo);
        }
    }];
}

- (void)queryUsersInfo:(NSArray<NSString *>*)userIDs callback:(ZIMUsersInfoQueriedCallback)callback {
    ZIMUsersInfoQueryConfig *config = [ZIMUsersInfoQueryConfig new];
    [self.zim queryUsersInfo:userIDs config:config callback:callback];
}

- (void)updateupdateUserAvatarUrl:(NSString *)avatarUrl callback:(ZIMUserAvatarUrlUpdatedCallback)callback {
    self.userfullinfo.userAvatarUrl = avatarUrl;
    [self.zim updateUserAvatarUrl:avatarUrl callback:callback];
}

- (void)logout {
    [self.zim logout];
//    [self destroy];
}

- (void)createCachePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imagePath = [ZIMKit_Image_Path stringByAppendingString:self.userfullinfo.baseInfo.userID];
    if(![fileManager fileExistsAtPath:imagePath]){
        [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString *)getImagepath {
    return [ZIMKit_Image_Path stringByAppendingString:self.userfullinfo.baseInfo.userID];
}

- (ZIMUserFullInfo *)userfullinfo {
    if (!_userfullinfo) {
        _userfullinfo = [[ZIMUserFullInfo alloc] init];
    }
    return _userfullinfo;
}
@end
