//
//  ZIMKitConversationVM.m
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import "ZIMKitConversationVM.h"
#import "ZIMKitEventHandler.h"


@interface ZIMKitConversationVM ()

/// 总未读数
@property (nonatomic, assign, readwrite) int totalUnreadMessageCount;

/// 数据加载中
@property (nonatomic, assign) uint64_t isLoading;
/// 没有更多需要加载的数据
@property (nonatomic, assign) uint64_t isFinished;

///第一次加载
@property (nonatomic, assign) uint64_t isFirstLoad;

@end

@implementation ZIMKitConversationVM

- (instancetype)init {
    if (self = [super init]) {
        [self addConversationEventHadle];
        self.isFirstLoad = YES;
    }
    return self;
}

/// 加载会话列表
- (void)loadConversation:(ZIMKitLoadConversationBlock)completeBlock {
    
    if (self.isFinished) { //正在加载, 加载完成 直接返回
        if (completeBlock) {
            completeBlock(self.coversationList, self.isFirstLoad, self.isFinished, nil);
        }
        return;
    }
//    self.isLoading = YES;
    
    ZIMConversationQueryConfig *queryCon = [[ZIMConversationQueryConfig alloc] init];
    queryCon.count = 20;
    if (self.coversationList.count) {
        ZIMKitConversationModel *model = self.coversationList.lastObject;
        ZIMConversation *con = [model toZIMConversationModel];
        queryCon.nextConversation = con;
    } else {
        queryCon.nextConversation = nil;
    }
    NSLog(@"------------------loadConversation");
    @weakify(self);
    [[ZIMKitManager shared].zim queryConversationListWithConfig:queryCon callback:^(NSArray<ZIMConversation *> * _Nonnull conversationList, ZIMError * _Nonnull errorInfo) {

        @strongify(self);
        if (errorInfo.code == ZIMErrorCodeSuccess) {
            NSLog(@"------------------loadConversation Success");
            self.isFinished = conversationList.count < queryCon.count ? YES : NO;
            
            NSMutableArray *allData = [NSMutableArray arrayWithArray:self.coversationList];
            for (ZIMConversation *con in conversationList) {
                ZIMKitConversationModel *model = [[ZIMKitConversationModel alloc] init];
                [model fromZIMConversationWith:con];
                if (model && model.conversationID.length) {
                    [allData addObject:model];
                }
            }

            // orderKey 重新排序
            [self sortDataList:allData];
            self.coversationList = allData;
            if (completeBlock) {
                completeBlock(self.coversationList, self.isFirstLoad, self.isFinished, nil);
            }
            
            self.isLoading = NO;
            if (self.isFirstLoad) {
                self.isFirstLoad = NO;
            }
        } else {
            NSLog(@"------------------loadConversation fail %@ code is %ld", errorInfo.message , errorInfo.code);
            if (completeBlock) {
                completeBlock(nil, self.isFirstLoad,self.isFinished, errorInfo);
            }
            
            self.isLoading = NO;
            if (self.isFirstLoad) {
                self.isFirstLoad = NO;
            }
        }
    }];
}

/// 清除数据
- (void)removeData:(ZIMKitConversationModel *)data
     completeBlock:(ZIMKitConversationBlock)completeBlock {
    NSMutableArray *list = [NSMutableArray arrayWithArray:self.coversationList];
    [list removeObject:data];
    self.coversationList = list;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onConversationListChange:)]) {
        [self.delegate onConversationListChange:self.coversationList];
    }
    
    ZIMConversationDeleteConfig *config = [[ZIMConversationDeleteConfig alloc] init];
    config.isAlsoDeleteServerConversation = YES;
    [ZIMKitManagerZIM deleteConversation:data.conversationID conversationType:data.type config:config callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
        if (completeBlock) {
            completeBlock(errorInfo);
        }
//        ZIMMessageDeleteConfig *config = [ZIMMessageDeleteConfig new];
//        config.isAlsoDeleteServerMessage = YES;
//        [ZIMKitManagerZIM deleteAllMessageByConversationID:conversationID conversationType:conversationType config:config callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
//
//        }];
    }];
}

/// 会话根据orderKey 排序
- (void)sortDataList:(NSMutableArray<ZIMKitConversationModel *> *)dataList {
    [dataList sortUsingComparator:^NSComparisonResult(ZIMKitConversationModel *obj1, ZIMKitConversationModel *obj2) {
        return obj1.orderKey < obj2.orderKey;
    }];
}

/// 清空会话未读数
- (void)clearConversationUnreadMessageCount:(NSString *)coversationID
                           conversationType:(ZIMConversationType)conversationType
                              completeBlock:(ZIMKitConversationBlock)completeBlock {
    [ZIMKitManagerZIM clearConversationUnreadMessageCount:coversationID conversationType:conversationType callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
        if (completeBlock) {
            completeBlock(errorInfo);
        }
    }];
}

/// 添加事件的监听
- (void)addConversationEventHadle {
    /// 会话列表更新
    @weakify(self);
    [[ZIMKitEventHandler shared] addEventListener:KEY_CONVERSATION_CHANGED
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        NSArray<ZIMConversationChangeInfo *> *conversationChangeInfoList = param[PARAM_CONVERSATION_CHANGED_LIST];
        for (ZIMConversationChangeInfo *changinfo in conversationChangeInfoList) {
            [self conversationChangeWith:changinfo];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(onConversationListChange:)]) {
            [self.delegate onConversationListChange:self.coversationList];
        }
    }];
    
    /// 更新总未读数
    [[ZIMKitEventHandler shared] addEventListener:KEY_CONVERSATION_TOTALUNREADMESSAGECOUNT_UPDATED
                                         listener:self
                                         callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        int totalUnreadCount = [param[PARAM_CONVERSATION_TOTALUNREADMESSAGECOUNT] intValue];
        self.totalUnreadMessageCount = totalUnreadCount;
        if (self.delegate && [self.delegate respondsToSelector:@selector(onTotalUnreadMessageCountChange:)]) {
            [self.delegate onTotalUnreadMessageCountChange:totalUnreadCount];
        }
    }];
    
    /// 连接状态
    [[ZIMKitEventHandler shared] addEventListener:KEY_CONNECTION_STATE_CHANGED listener:self callBack:^(NSDictionary * _Nullable param) {
        @strongify(self);
        
        NSDictionary *extendedData = param[PARAM_EXTENDED_DATA];
        ZIMConnectionState state = [param[PARAM_STATE] intValue];
        ZIMConnectionEvent event = [param[PARAM_EVENT] intValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onConnectionStateChange:event:extendedData:)]) {
            [self.delegate onConnectionStateChange:state event:event extendedData:extendedData];
        }
    }];
}

/// 处理收到SDK会话列表改变
- (void)conversationChangeWith:(ZIMConversationChangeInfo *)changinfo {
    NSMutableArray *list = [NSMutableArray arrayWithArray:self.coversationList];
    
    BOOL isExit = NO;
    ZIMKitConversationModel *temModel = [[ZIMKitConversationModel alloc] init];
    for (ZIMKitConversationModel *mode in list) { //查找本地是否否存在
        if ([mode.conversationID isEqualToString:changinfo.conversation.conversationID]) {
            isExit = YES;
            temModel = mode;
            break;
        }
    }
    
    temModel.conversationEvent = changinfo.event;
    
    if (changinfo.event == ZIMConversationEventAdded || changinfo.event == ZIMConversationEventUpdated) {
        
        if (isExit) { /// 存在更新
            [temModel fromZIMConversationWith:changinfo.conversation];
        } else { /// 不存在新增
            [temModel fromZIMConversationWith:changinfo.conversation];
            [list addObject:temModel];
        }
        
    } else if (changinfo.event == ZIMConversationEventDisabled) {
        
    }
    
    // orderKey 重新排序
    [self sortDataList:list];
    
    self.coversationList = list;
}

/// 移除事件的监听
- (void)removeConversationEventHadle {
    [[ZIMKitEventHandler shared] removeEventListener:KEY_CONVERSATION_CHANGED listener:self];
    [[ZIMKitEventHandler shared] removeEventListener:KEY_CONVERSATION_TOTALUNREADMESSAGECOUNT_UPDATED listener:self];
}

- (void)clearAllCacheData {
    [self removeConversationEventHadle];
}

- (void)dealloc {
    NSLog(@"ZIMKitConversationVM delloc");
}


@end
