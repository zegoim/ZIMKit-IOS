//
//  ZegoTabBarController.m
//  ZIMKitDemo
//
//  Created by zego on 2022/6/7.
//

#import "ZegoTabBarController.h"
#import "ZIMKitDemoNavigationController.h"
#import "ZegoBadgeView.h"
#import "ConversationController.h"
#import "ZegoTabBar.h"

#define  IOS_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]

@interface ZegoTabBarController ()<ZegoTabBarDelegate>

//@property (nonatomic, strong) ZegoBadgeView *badgeView;

@property (nonatomic, weak) ZegoTabBar *customTabBar;
@end

@implementation ZegoTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTabbar];
    [self setupAllChildViewControllers];
}

//- (void)setupTabbar {
//    self.tabBar.layer.borderWidth = 0.50;
//    self.tabBar.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
//    self.tabBar.barStyle = UIBarStyleBlackOpaque;
//    self.tabBar.barTintColor = [UIColor whiteColor]; ///设置背景色
//    self.tabBarController.tabBar.translucent = NO;
//}

//解决popToViewController后tabBar重叠的问题
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (IOS_VERSION >= 11.0f) {
        [self changeTabbarH];
        [self deleteSystemTabBarButton];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self changeTabbarH];
    [self deleteSystemTabBarButton];
}


//删除系统自带的UITabBarButton
- (void)deleteSystemTabBarButton {
    for (UIView *supView in self.view.subviews) {
        if ([supView isKindOfClass:NSClassFromString(@"UITabBar")]) {
            for (UIView *child in supView.subviews) {
                if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                    [child removeFromSuperview];
                }
            }
        }
    }
}

- (void)changeTabbarH {
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = kTabBarH;
    tabFrame.origin.y = self.view.frame.size.height - kTabBarH;
    self.tabBar.frame = tabFrame;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //去掉tabbar 背景色
    [self.tabBar setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor] rectSize:CGRectMake(0.0f, 0.0f, kSCREEN_WIDTH, kTabBarH)]];

    [self changeTabbarH];
    [self deleteSystemTabBarButton];
}

/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    ZegoTabBar *customTabBar = [[ZegoTabBar alloc] init];
    customTabBar.frame = CGRectMake(0.0f, 0.0f, kSCREEN_WIDTH, kTabBarH);
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
    self.tabBarController.tabBar.translucent = NO;
}

#pragma mark ZegoTabBarDelegate
/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(ZegoTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to {
    self.selectedIndex = to;
}

- (void)tabBar:(ZegoTabBar *)tabBar tabBarButtonContentChange:(ZegoTabBarButton *)tabBarButton {
    //解决tabBarButton偶尔出现重叠的问题
    [self deleteSystemTabBarButton];
}



- (void)setupAllChildViewControllers {

    ConversationController *conversationListVc = [[ConversationController alloc] init];
    [self setupChildViewController:conversationListVc title:KitDemoLocalizedString(@"demo_message", LocalizedDemoKey, nil) imageName:@"tabbar_message" selectedImageName:@"tabbar_message"];
}

- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.tabBarItem.title = title;
    // 设置图标
    childVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置选中的图标
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    childVc.tabBarItem.selectedImage = selectedImage;
    // 2.包装一个导航控制器
    ZIMKitNavigationController *nav = [[ZIMKitNavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
    
}


- (UIView *)tabBarContentView:(UITabBarItem *)tabBarItem {
    UIView *bottomView = [tabBarItem valueForKeyPath:@"_view"];
    UIView *contentView = bottomView;
    if (bottomView) {
        __block UIView *targetView = bottomView;
        [bottomView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([subview isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                targetView = subview;
                *stop = YES;
            }
        }];
        contentView = targetView;
    }
    return contentView;
}


@end
