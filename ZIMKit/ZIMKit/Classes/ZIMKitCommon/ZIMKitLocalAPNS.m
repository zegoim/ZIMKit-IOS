//
//  ZIMKitLocalAPNS.m
//  ZIMKit
//
//  Created by zego on 2022/7/22.
//

#import "ZIMKitLocalAPNS.h"
#import "ZIMKitEventHandler.h"
#import "ZIMKitMessageTool.h"
#import <UserNotifications/UserNotifications.h>
#import "ZIMMessage+Extension.h"

@interface ZIMKitLocalAPNS ()
{
    UIBackgroundTaskIdentifier _keepAliveTask;
}

@end


@implementation ZIMKitLocalAPNS

+ (instancetype)shared {
    static ZIMKitLocalAPNS *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZIMKitLocalAPNS alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)setupLocalAPNS {
    [self removeConversationEventHadle];
    [self addConversationEventHadle];
    
}

- (void)didEnterBackground:(NSNotification *)noti {
    [self startBackgroundTask];
}

/**
 *  启动后台延时
 */
- (void)startBackgroundTask {
    UIApplication *application = [UIApplication sharedApplication];
     _keepAliveTask = [application beginBackgroundTaskWithExpirationHandler:^{
         [application endBackgroundTask:self->_keepAliveTask];
    }];
    
    if (_keepAliveTask == UIBackgroundTaskInvalid) {
        return;
    }
}

- (void)didEnterForground:(NSNotification *)noti {
    [[UIApplication sharedApplication] endBackgroundTask: _keepAliveTask];
    _keepAliveTask = UIBackgroundTaskInvalid;
}

- (void)addConversationEventHadle {
    /// 收到单聊消息
    @weakify(self);
    [[ZIMKitEventHandler shared] addEventListener:KEY_RECEIVE_PEER_MESSAGE
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        NSArray<ZIMMessage *>* messageLlist = param[PARAM_MESSAGE_LIST];
        NSString *fromUserID = param[PARAM_FROM_USER_ID];
        
        [self receiveMessages:messageLlist fromID:fromUserID];
    }];
    
    [[ZIMKitEventHandler shared] addEventListener:KEY_RECEIVE_GROUP_MESSAGE
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        NSArray<ZIMMessage *>* messageLlist = param[PARAM_MESSAGE_LIST];
        NSString *fromGroupID = param[PARAM_FROM_GROUP_ID];
        
        [self receiveMessages:messageLlist fromID:fromGroupID];
    }];
    
    [[ZIMKitEventHandler shared] addEventListener:KEY_RECEIVE_ROOM_MESSAGE
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        NSArray<ZIMMessage *>* messageLlist = param[PARAM_MESSAGE_LIST];
        NSString *fromRoomID = param[PARAM_FROM_ROOM_ID];
        
        [self receiveMessages:messageLlist fromID:fromRoomID];
    }];
}

- (void)receiveMessages:(NSArray <ZIMMessage *>*)messageLlist fromID:(NSString *)fromID {
    BOOL background = [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
    
    if (background) {
        //这里的消息需要先排序
        NSArray *list = [messageLlist sortedArrayUsingComparator:^NSComparisonResult(ZIMMessage *obj1, ZIMMessage *obj2) {
            return obj1.timestamp > obj2.timestamp;
        }];
        
        for (ZIMMessage *message in list) {
            [self addLocalNotice:message];
        }
    }
}

- (void)addLocalNotice:(ZIMMessage *)message {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        // 内容
        content.body = [message getMessageTypeShorStr];
        // 声音
        content.sound = [UNNotificationSound defaultSound];

//        content.badge = @1;
        // 添加通知的标识符，可以用于移除，更新等操作
        NSString *identifier = @"noticeId";
        content.userInfo = @{@"conversationID" : message.conversationID ?:@"", @"conversationType" : @(message.conversationType)};
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:nil];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            NSLog(@"成功添加推送");
        }];
    }else {
        UILocalNotification *notif = [[UILocalNotification alloc] init];
        // 推送的内容
        notif.alertBody = [message getMessageTypeShorStr];
        // 可以添加特定信息
        notif.userInfo = @{@"conversationID" : message.conversationID ?:@"", @"conversationType" : @(message.conversationType)};
        // 角标
//        notif.applicationIconBadgeNumber = 1;
        // 提示音
        notif.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
}

/// 移除事件的监听
- (void)removeConversationEventHadle {
    [[ZIMKitEventHandler shared] removeEventListener:KEY_RECEIVE_GROUP_MESSAGE listener:self];
    [[ZIMKitEventHandler shared] removeEventListener:KEY_RECEIVE_GROUP_MESSAGE listener:self];
    [[ZIMKitEventHandler shared] removeEventListener:KEY_RECEIVE_ROOM_MESSAGE listener:self];
}
@end
