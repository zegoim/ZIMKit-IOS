//
//  ZIMKitManager.m
//  ZIMKit
//
//  Created by zego on 2022/5/18.
//

#import "ZIMKitManager.h"
#import "ZIMKitEventHandler.h"

@interface ZIMKitManager ()

@property (nonatomic, strong, readwrite) ZIM *zim;
@property (nonatomic, strong, readwrite) ZIMUserInfo *userInfo;
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

- (void)createZIM:(int)appID {
    self.zim = [ZIM createWithAppID:appID];
    [self.zim setEventHandler:[ZIMKitEventHandler shared]];
    NSLog(@"ZIM 已经初始化了-----");
}

- (void)destroy {
    [self.zim destroy];
}

- (void)login:(ZIMUserInfo *)userInfo
        token:(NSString *)token
     callback:(ZIMLoggedInCallback)callback {
    self.userInfo = userInfo;
    [self.zim loginWithUserInfo:userInfo token:token callback:callback];
}

- (void)logout {
    [self.zim logout];
//    [self destroy];
}

@end
