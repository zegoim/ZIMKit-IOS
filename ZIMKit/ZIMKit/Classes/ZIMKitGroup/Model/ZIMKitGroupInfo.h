//
//  ZIMKitGroupInfo.h
//  ZIMKit
//
//  Created by zego on 2022/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMKitGroupInfo : NSObject

/// 群ID
@property (nonatomic, copy) NSString *groupID;

/// 群名称
@property (nonatomic, copy) NSString *groupName;

/// 群公告
@property (nonatomic, copy) NSString *groupNotice;

/// 群附加信息
@property (nonatomic, strong) NSDictionary *groupAttribution;

/// 从SDKZIMGroupFullInfo ->ZIMKitGroupInfo
- (void)fromZIMGroupFullInfo:(ZIMGroupFullInfo*)info;
@end

NS_ASSUME_NONNULL_END
