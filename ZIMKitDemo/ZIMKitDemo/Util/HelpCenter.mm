//
//  HelpCenter.m
//  ZIMKitDemo
//
//  Created by zego on 2022/5/19.
//

#import "HelpCenter.h"
#import "KeyCenter.h"
#import "ZegoServerAssistant.h"
#import "ZegoRTCServerAssistant.h"

@implementation HelpCenter

+ (NSString *)getTokenWithUserID:(NSString *)userID {
    NSString *token = [[NSString alloc] init];
    if(userID != nil){
        auto tokenResult = ZEGO::SERVER_ASSISTANT::ZegoServerAssistant::GenerateToken(KeyCenter.appID, userID.UTF8String,KeyCenter.Secret.UTF8String, 3600*24);
        token = [NSString stringWithCString:tokenResult.token.c_str() encoding:[NSString defaultCStringEncoding]];
    }
    return token;
}

+ (NSString *)getUserNameWith:(NSString *)userID {
    NSString *userName;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userName = [defaults objectForKey:HelperCenterCacheKey(userID)];
    /// 随机生成
    if (!userName) {
        // 获取文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"user_name" ofType:@"txt"];
        NSString *jsonStr  = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSArray *names = [jsonStr componentsSeparatedByString:@"\n"];
        int port = arc4random() % (names.count -1);
        userName = names[port];
        if (userName) {
            [defaults setObject:userName forKey:HelperCenterCacheKey(userID)];
        }
    }
    
    return userName;
}
@end
