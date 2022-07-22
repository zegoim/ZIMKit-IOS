//
//  ZegoTabBarButton.m
//  ZIMKitDemo
//
//  Created by zego on 2022/6/28.
//

#import "ZegoTabBarButton.h"
#import "ZegoBadgeButton.h"

// 图标的比例
#define XWTabBarButtonImageRatio 1.0f

// 按钮的默认文字颜色
#define  XWTabBarButtonTitleColor (iOS7 ? [UIColor blackColor] : [UIColor whiteColor])
// 按钮的选中文字颜色
#define  XWTabBarButtonTitleSelectedColor (iOS7 ? BSColor(234, 103, 7) : BSColor(248, 139, 0))

@interface ZegoTabBarButton ()

// 提醒数字
@property (nonatomic, weak) ZegoBadgeButton *badgeButton;

@end

@implementation ZegoTabBarButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect imageRect = self.imageView.frame;
    CGRect titleRect = self.titleLabel.frame;
    
    imageRect.origin.x = 0.0f;
    imageRect.origin.y = 5.0f;//titleRect.origin.y - imageRect.size.height - 3.0f;
    imageRect.size.width = self.frame.size.width;

    titleRect.origin.x = 0.0f;
    titleRect.origin.y = imageRect.origin.y + imageRect.size.height;//self.frame.size.height - titleRect.size.height - 10.0f;
    titleRect.size.width = self.frame.size.width;
    
    self.imageView.frame = imageRect;
    self.titleLabel.frame = titleRect;
    
    // 设置提醒数字的位置
    CGFloat badgeY = 0;
    CGFloat badgeX = (self.frame.size.width - self.item.image.size.width) / 2.0f + self.item.image.size.width - 6.0f;
    CGRect badgeF = self.badgeButton.frame;
    badgeF.origin.x = badgeX;
    badgeF.origin.y = badgeY;
    self.badgeButton.frame = badgeF;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 图标居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        // 文字颜色
        [self setTitleColor:BSRGBColor(0x666666) forState:UIControlStateNormal];
        [self setTitleColor:BSRGBColor(0x666666) forState:UIControlStateSelected];
        // 添加一个提醒数字按钮
        ZegoBadgeButton *badgeButton = [[ZegoBadgeButton alloc] init];
        badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:badgeButton];
        self.badgeButton = badgeButton;
    }
    return self;
}

// 重写去掉高亮状态
- (void)setHighlighted:(BOOL)highlighted {}

//// 内部图片的frame
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGFloat imageW = contentRect.size.width;
//    CGFloat imageH = contentRect.size.height * XWTabBarButtonImageRatio;
//    return CGRectMake(0, 0, imageW, imageH);
//}

// 设置item
- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    // KVO 监听属性改变
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}

/**
 *  监听到某个对象的属性改变了,就会调用
 *
 *  @param keyPath 属性名
 *  @param object  哪个对象的属性被改变
 *  @param change  属性发生的改变
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 设置文字
    [self setTitle:self.item.title forState:UIControlStateSelected];
    [self setTitle:self.item.title forState:UIControlStateNormal];
    
    // 设置图片
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
    // 设置提醒数字
    self.badgeButton.badgeValue = self.item.badgeValue;
    
    // 设置提醒数字的位置
//    CGFloat badgeY = 5;
//    CGFloat badgeX = (self.frame.size.width - self.item.image.size.width) / 2.0f + self.item.image.size.width - 8.0f;
//    CGRect badgeF = self.badgeButton.frame;
//    badgeF.origin.x = badgeX;
//    badgeF.origin.y = badgeY;
//    self.badgeButton.frame = badgeF;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarButtonContentChange:)]) {
        [self.delegate tabBarButtonContentChange:self];
    }
}


@end
