//
//  ZIMKitRouter.h
//  ZIMKit
//
//  Created by zego on 2022/6/30.
//

#import <Foundation/Foundation.h>

static NSString * const routerHandlerKey = @"routerHandlerKey";
static NSString * const backBlockKey  = @"backBlockKey";

typedef NS_ENUM(NSUInteger, JumpType) {
    Push,
    Present,
    Pop,
    PopRoot,
    PopSome,
    Dismiss,
};

typedef NS_ENUM(NSInteger, CallBackType) {
    CallBackFirst,
    CallBackSecond,
    CallBackThird,
    CallBackFourth,
    CallBackFifth,
    CallBackSixth,
    CallBackSeventh,
    CallBackEighth,
    CallBackNinth,
    CallBackTenth
};

@interface ZIMKitRouter : NSObject

typedef void (^componentBlock) (id param, UINavigationController *nav, JumpType type, UIViewController *fromVC);
typedef void (^handlerBlock) (void);
typedef void (^callBackBlock)(id param, CallBackType type);

@property (nonatomic, strong) NSMutableDictionary * dataDict;
@property (nonatomic, strong) NSMutableDictionary * paramDict;
@property (nonatomic, strong) NSMutableDictionary * cachDict;

@property(nonatomic, copy) ZIMKitRouter *(^jump)(JumpType type);
@property(nonatomic, copy) ZIMKitRouter *(^fromVC)(UIViewController *VC);
@property(nonatomic, copy) ZIMKitRouter *(^toVC)(UIViewController *VC);
@property(nonatomic, copy) ZIMKitRouter *(^fromNav)(UINavigationController *nav);
@property(nonatomic, copy) ZIMKitRouter *(^openUrl)(NSString *url);
@property(nonatomic, copy) ZIMKitRouter *(^openUrlWithParam)(NSString *url,id param);
@property(nonatomic, copy) ZIMKitRouter *(^animated)(BOOL animated);
@property(nonatomic, copy) ZIMKitRouter *(^closeWithUrl)(NSString *url);

@property(nonatomic, copy) id (^getVCFromUrl)(NSString *url);
@property(nonatomic, copy) void (^deregisterURL)(NSString *url);

+ (ZIMKitRouter *)shareInstance;

- (ZIMKitRouter *)callBackBlock:(callBackBlock)callBack;
- (void)handler:(handlerBlock)block;

// 绑定URI和Class
- (void)registerURLPattern:(NSString *)urlPattern Class:(Class)vcClass toHandler:(componentBlock)blk;

// 注册业务模块
- (void)registerModules:(NSArray *)modulesArray;

// 带回调模块之间调用
+ (id)postModuleWithTarget:(NSString *)moduleStr action:(SEL)aSelector withObject:(id)obj;

// 不带回调模块之间调用
+ (id)postModuleWithTarget:(NSString *)moduleStr action:(SEL)aSelector withObject:(id)obj callBackBlock:(void (^)(id blockParam))block;

NSString *getCachDictKey(NSString *ZIMKitRouter);



@end

@interface NSObject (ZIMKitRouter)

@property (nonatomic, strong) ZIMKitRouter *router;
@property (nonatomic,copy) callBackBlock callBackBlock;

@end



