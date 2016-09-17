//
//  JJStatusBarExtension.m
//  JJStatusBarExtension
//
//  Created by jxf on 16/2/22.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "JJStatusBarExtension.h"
#import <objc/runtime.h>

/*********************************JJViewController********************************************/
@interface JJTopViewController : UIViewController
@property(nonatomic, strong) void(^clickedBlock)();
@property(nonatomic, strong) UIViewController * showingVc;
@end

@implementation JJTopViewController

- (BOOL)prefersStatusBarHidden
{
    return self.showingVc.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.showingVc.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return self.showingVc.preferredStatusBarUpdateAnimation;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.clickedBlock) {
        self.clickedBlock();
    }
}

@end

/*********************************JJViewController********************************************/

/*********************************JJStatusBarExtension****************************************/
@implementation JJStatusBarExtension

static JJStatusBarExtension *_topWindow;

+ (instancetype)sharedStatusBarExtension
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _topWindow = [[self alloc] init];
    });
    return _topWindow;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _topWindow = [super allocWithZone:zone];
    });
    return _topWindow;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _topWindow;
}

+ (void)showWithStatusBarClickBlock:(void (^)())block
{
    if (_topWindow) return;
    
    [JJStatusBarExtension sharedStatusBarExtension].windowLevel = UIWindowLevelAlert;
    [JJStatusBarExtension sharedStatusBarExtension].backgroundColor = [UIColor clearColor];
    // 先显示window
    [JJStatusBarExtension sharedStatusBarExtension].hidden = NO;
    
    // 设置根控制器
    JJTopViewController *topVc = [[JJTopViewController alloc] init];
    topVc.view.backgroundColor = [UIColor clearColor];
    topVc.view.frame = [UIApplication sharedApplication].statusBarFrame;
    topVc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topVc.clickedBlock = block;
    [JJStatusBarExtension sharedStatusBarExtension].rootViewController = topVc;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (point.y > 20) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

+ (void)scrollToTopInsideView:(UIView *)view
{
    CGRect viewRect = [view convertRect:view.bounds toView:nil];
    if (!CGRectIntersectsRect([UIApplication sharedApplication].keyWindow.frame, viewRect)) {
        return;
    }
    
    for (UIView *subview in view.subviews) {
        [self scrollToTopInsideView:subview];
    }
    if (![view isKindOfClass:[UIScrollView class]]) {
        return;
    }
    UIScrollView *scrollView = (UIScrollView *)view;
    //    CGPoint contentOffset = scrollView.contentOffset;
    //    contentOffset.y = - scrollView.contentInset.top;
    //    [scrollView setContentOffset:contentOffset animated:YES];
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (CGFloat)statusBarAnimationDuration
{
    if (_statusBarAnimationDuration == 0) {
        _statusBarAnimationDuration = 0.25;
    }
    return _statusBarAnimationDuration;
}

@end
/*********************************JJStatusBarExtension****************************************/

/*********************************JJStatusBarExtension****************************************/

@implementation UIViewController (JJStatusBarExtension)

+ (void)load
{
    Method method1 = class_getInstanceMethod(self, @selector(jj_viewWillAppear:));
    Method method2 = class_getInstanceMethod(self, @selector(viewWillAppear:));
    method_exchangeImplementations(method1, method2);
}


- (void)jj_viewWillAppear:(BOOL)animated
{
    [self jj_viewWillAppear:animated];
    // 如果非当前窗口显示的控制器, 我只测试到UINavigationController下,"UIInputWindowController"会产生影响, 把它屏蔽掉
//    NSLog(@"%@", self.class);
    if ([NSStringFromClass(self.class) isEqualToString:@"UIInputWindowController"]) return;

    if ([self respondsToSelector:@selector(jj_ignoreStatusBar)]) {
    if ([self jj_ignoreStatusBar]) return;
    }

    JJTopViewController *statusBarVc = (JJTopViewController *)[JJStatusBarExtension sharedStatusBarExtension].rootViewController;
    if (statusBarVc == self) return;
    statusBarVc.showingVc = self;
    
    if (statusBarVc.showingVc.preferredStatusBarUpdateAnimation == UIStatusBarAnimationNone) {
        [statusBarVc setNeedsStatusBarAppearanceUpdate];
    }else{
        [UIView animateWithDuration:[JJStatusBarExtension sharedStatusBarExtension].statusBarAnimationDuration animations:^{
            [statusBarVc setNeedsStatusBarAppearanceUpdate];
        }];
    }
}
@end
