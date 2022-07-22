//
//  ZegoTabBar.m
//  ZIMKitDemo
//
//  Created by zego on 2022/6/28.
//

#import "ZegoTabBar.h"
#import "ZegoTabBarButton.h"

@interface ZegoTabBar ()<ZegoTabBarButtonDelegate>

@property (nonatomic, weak) ZegoTabBarButton *selectedButton;
@end

@implementation ZegoTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0.5)];
        line.backgroundColor = BSRGBColor(0xE6E6E6);
        [self addSubview:line];
        
    }
    return self;
}

- (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize {
    CGFloat scale = [[UIScreen mainScreen]scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    // 1.创建按钮
    ZegoTabBarButton *button = [[ZegoTabBarButton alloc] init];
    button.tag = kTabBarButtonTag + self.subviews.count;
    button.delegate = self;
    [self addSubview:button];
    
    // 2.设置数据
    button.item = item;
    
    // 3.监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 4.默认选中第0个按钮
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(ZegoTabBarButton *)button
{
    // 1.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:(int)self.selectedButton.tag to:(int)button.tag];
    }
    
    // 2.设置按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 按钮的frame数据
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonW = self.frame.size.width / (self.subviews.count -1); // 减去上面的UIView *line
    CGFloat buttonY = 6;
    
    NSMutableArray *subViews = [NSMutableArray arrayWithArray:self.subviews];
    [subViews removeObjectAtIndex:0];
//    for (int index = 0; index<self.subviews.count -1; index++) {
    for (int index = 0; index < subViews.count; index++) {
        
        // 1.取出按钮
        ZegoTabBarButton *button = subViews[index];
        if ([button isKindOfClass:[ZegoTabBarButton class]]) {
            // 2.设置按钮的frame
            CGFloat buttonX = index * buttonW;
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            
            // 3.绑定tag
            button.tag = index;
        }
        
    }
}

- (void)pushChat:(NSNotification *)noti {
    
    ZegoTabBarButton *btn = nil;
    for (UIView *tem in self.subviews) {
        if ([tem isKindOfClass:[ZegoTabBarButton class]]) {
            btn = (ZegoTabBarButton *)tem;
            break;
        }
    }
    if (btn) {
        [self buttonClick:btn];
    }
}

#pragma mark ZegoTabBarButtonDelegate
-(void)tabBarButtonContentChange:(ZegoTabBarButton *)tabBarButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:tabBarButtonContentChange:)]) {
        [self.delegate tabBar:self tabBarButtonContentChange:tabBarButton];
    }
}


@end
