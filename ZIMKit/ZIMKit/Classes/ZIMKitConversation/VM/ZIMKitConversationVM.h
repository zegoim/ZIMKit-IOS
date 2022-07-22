//
//  ZIMKitConversationVM.h
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import <Foundation/Foundation.h>
#import "ZIMKitConversationModel.h"

typedef void(^ZIMKitLoadConversationBlock) (NSArray<ZIMKitConversationModel *> *_Nullable dataList, BOOL isFirstLoad,                                              BOOL isFinished, ZIMError * _Nullable errorInfo);
typedef void(^ZIMKitConversationBlock) (ZIMError * _Nullable errorInfo);

@protocol ZIMKitConversationVMDelegate <NSObject>

/// 会话更新
- (void)onConversationListChange:(NSArray<ZIMKitConversationModel *> *_Nullable)conversationList;

///总未读数的更新
- (void)onTotalUnreadMessageCountChange:(unsigned int)totalUnreadMessageCount;

///连接状态
- (void)onConnectionStateChange:(ZIMConnectionState)state event:(ZIMConnectionEvent)event extendedData:(NSDictionary *)extendedData;
@end

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitConversationVM : NSObject

@property (nonatomic, weak) id <ZIMKitConversationVMDelegate>delegate;

/// 分页拉去的数量,默认100
@property (nonatomic, assign) int pagePullCount;

/// 会话列表数据源
@property (nonatomic, strong) NSArray<ZIMKitConversationModel *> *coversationList;

/// 会话的总未读数
@property (nonatomic, assign, readonly) int totalUnreadMessageCount;

/// 加载会话列表
- (void)loadConversation:(ZIMKitLoadConversationBlock)completeBlock ;

/// 清除数据
- (void)removeData:(ZIMKitConversationModel *)data
     completeBlock:(ZIMKitConversationBlock)completeBlock;

/// 清空会话未读数
- (void)clearConversationUnreadMessageCount:(NSString *)coversationID
                           conversationType:(ZIMConversationType)conversationType
                              completeBlock:(ZIMKitConversationBlock)completeBlock;

/// 清空数据(外界VC 持有VM ,在销毁的时候需要调用,要不VM释放不了)
- (void)clearAllCacheData;
@end

NS_ASSUME_NONNULL_END
