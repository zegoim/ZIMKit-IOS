//
//  ZIMKitRefreshAutoHeader.m
//  ZIMKit
//
//  Created by zego on 2022/5/31.
//

#import "ZIMKitRefreshAutoHeader.h"
#import "ZIMKitDefine.h"

@interface ZIMKitRefreshAutoHeader()
@property (weak, nonatomic) UILabel *label;

@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation ZIMKitRefreshAutoHeader

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor dynamicColor:ZIMKitHexColor(0x394256) lightColor:ZIMKitHexColor(0x394256)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;

    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];

    self.loading.center = CGPointMake(self.mj_w/2 - 20, self.mj_h * 0.5);
    self.label.centerY = self.loading.centerY;
    self.label.x = self.loading.x + self.loading.width;
    self.label.height = self.loading.height;
    self.label.width = 90;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
//            [self.s setOn:NO animated:YES];
            self.label.text = @"";
            break;
        case MJRefreshStatePulling:
            [self.loading startAnimating];
//            [self.s setOn:YES animated:YES];
//            self.label.text = @"赶紧放开我吧(开关是打酱油滴)";
//            self.label.text = @"加载中...";
            break;
        case MJRefreshStateRefreshing:
//            [self.s setOn:YES animated:YES];
            self.label.text = [NSBundle ZIMKitlocalizedStringForKey:@"common_loading"];
            [self.loading startAnimating];
            break;
        default:
            break;
    }
}

@end
