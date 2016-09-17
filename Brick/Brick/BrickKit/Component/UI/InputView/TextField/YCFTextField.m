//
//  AutoKeyBoard.m
//  test
//
//  Created by jinxiaofei on 16/5/27.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "YCFTextField.h"

static NSString * const keyBoardManagerOberverKeyPath = @"status";
@interface YCFTextField ()
// 容器view的原始frame
@property(nonatomic, assign) CGRect contentViewOriginalFrame;
// 容器view是scrollView时的原始offset
@property(nonatomic, assign) CGPoint contentScrollViewOriginalOffset;
@property(nonatomic, assign) CGPoint afterMovedContentOffset;
@property(nonatomic, assign) BOOL hasCachedOri;

// 判断容器view是否是scrollView或者其子类
@property(nonatomic, assign) BOOL contentViewIsScrollViewClass;

// 一些标记,控制执行次数
@property(nonatomic, assign) BOOL markForIsSettingOri;

@property(nonatomic, assign) BOOL hasBeenMoved;

@property(nonatomic, weak) YCFKeyBoardManager *manager;
@end

@implementation YCFTextField

@synthesize containerView = _containerView;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self.manager addObserver:self forKeyPath:keyBoardManagerOberverKeyPath options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self.manager removeObserver:self forKeyPath:keyBoardManagerOberverKeyPath];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context
{
    if ([keyPath isEqualToString:keyBoardManagerOberverKeyPath])
    {
        switch ([YCFKeyBoardManager shareInstance].status)
        {
            case YCFKeyBoardStatusWillShow:
                [self p_dealWithKeyBoardWillShow];
                break;
            case YCFKeyBoardStatusDidShow:
                
                break;
            case YCFKeyBoardStatusWillHide:
                [self p_dealWithKeyBoardWillHide];
                break;
            case YCFKeyBoardStatusDidHide:
                
                break;
            default:
                break;
        }
    }
}

#pragma mark - private methods
- (void)p_dealWithKeyBoardWillShow
{
    if (self.isEditing == NO)
    {
        return;
    }
    self.manager.curEditView = self;
    // 转换到window上的y值
    CGFloat selfComparativelyWindowY = 0.0;
    // 容器为scrollView时, 用这个
    UIScrollView *selfContentScrollView;

    if (self.contentViewIsScrollViewClass)
    {
        selfContentScrollView = (UIScrollView *)self.containerView;
        CGPoint contentViewComparativelyWindowP = [selfContentScrollView convertPoint:selfContentScrollView.bounds.origin toView:nil];
        CGPoint selfComparativelyScrollViewP = [self convertPoint:self.bounds.origin toView:selfContentScrollView];
        selfComparativelyWindowY = selfComparativelyScrollViewP.y + CGRectGetHeight(self.frame) - (selfContentScrollView.contentOffset.y) + contentViewComparativelyWindowP.y;
    }
    else
    {
        CGPoint contentViewComparativelyWindowP = [self.containerView convertPoint:self.containerView.bounds.origin toView:nil];
        selfComparativelyWindowY = self.frame.origin.y + CGRectGetHeight(self.frame) + contentViewComparativelyWindowP.y;
    }
    
    // 记录原始位置, 该方法可能多次执行, 只记录初始位置
    if (self.hasCachedOri == NO)
    {
        [self p_cacheOriginalLocation];
        self.hasCachedOri = YES;
    }
    
    if (selfComparativelyWindowY <= self.manager.keyBoardFrame.origin.y)
    {
        // 标记后, 第一次进来编辑,没被挡住就不后续处理, 进入编辑后, 没被挡住可能是提示bar等条隐藏, 此时也需要处理
        return;
    }

    CGFloat offsetY = selfComparativelyWindowY - self.manager.keyBoardFrame.origin.y + self.manager.distanceWithKeyBoard;
    
    if (self.contentViewIsScrollViewClass)
    {
        CGPoint offset = selfContentScrollView.contentOffset;
        offset.y += offsetY;
        [UIView animateWithDuration:self.manager.keyBoardDuration delay:0.0 options:self.manager.keyBoardAnimationOptions animations:^{
            [selfContentScrollView setContentOffset:offset];
        } completion:^(BOOL finished) {
            self.afterMovedContentOffset = selfContentScrollView.contentOffset;
        }];
    }
    else
    {
        [UIView animateWithDuration:self.manager.keyBoardDuration delay:0.0 options:self.manager.keyBoardAnimationOptions animations:^{
            CGRect rect = self.containerView.frame;
            rect.origin.y -= offsetY;
            self.containerView.frame = rect;
        } completion:nil];
    }
    if (offsetY > 0 && !self.hasBeenMoved)
    {
        self.hasBeenMoved = YES;
    }
}

- (void)p_dealWithKeyBoardWillHide
{
    if (self.hasBeenMoved)
    {
        if (![self p_hasBeenMovedWhenKeyBoardIsShow])
        {
            if (self.contentViewIsScrollViewClass)
            {
                [UIView animateWithDuration:self.manager.keyBoardDuration delay:0.0 options:self.manager.keyBoardAnimationOptions animations:^{
                    
                    UIScrollView *selfContentScrollView = (UIScrollView *)self.containerView;
                    [selfContentScrollView setContentOffset:self.contentScrollViewOriginalOffset];
                } completion:nil];
            }
            else
            {
                [UIView animateWithDuration:self.manager.keyBoardDuration delay:0.0 options:self.manager.keyBoardAnimationOptions animations:^{
                    
                    self.containerView.frame = self.contentViewOriginalFrame;
                } completion:nil];
            }
        }
    }
    
    if (self.isEditing)
    {
        //复位一些标记
        self.markForIsSettingOri = NO;
        self.hasBeenMoved = NO;
        self.hasCachedOri = NO;
    }

}

- (BOOL)p_hasBeenMovedWhenKeyBoardIsShow
{
    if (self.contentViewIsScrollViewClass)
    {
        UIScrollView *selfContentScrollView = (UIScrollView *)self.containerView;
        if (self.afterMovedContentOffset.x == selfContentScrollView.contentOffset.x && self.afterMovedContentOffset.y == selfContentScrollView.contentOffset.y)
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
    return YES;
}

- (void)p_cacheOriginalLocation
{
    if (self.markForIsSettingOri)
    {
        return;
    }
    // 记录原始frame
    if (self.contentViewIsScrollViewClass)
    {
        UIScrollView *selfContentScrollView = (UIScrollView *)self.containerView;
        self.contentScrollViewOriginalOffset = selfContentScrollView.contentOffset;
    }
    else
    {
        self.contentViewOriginalFrame = self.containerView.frame;
    }
    
    self.markForIsSettingOri = YES;
}

#pragma mark - getter

- (YCFKeyBoardManager *)manager
{
    if (!_manager)
    {
        _manager = [YCFKeyBoardManager shareInstance];
    }
    return _manager;
}

- (UIView *)containerView
{
    if (!_containerView)
    {
#warning nil的时候默认为自己, 检查是否内存泄漏
        return self;
    }
    return _containerView;
}
#pragma mark - setter
- (void)setContainerView:(UIView *)containerView
{
    _containerView = containerView;
    if ([self.containerView isKindOfClass:[UIScrollView class]])
    {
        self.contentViewIsScrollViewClass = YES;
    }
    else
    {
        self.contentViewIsScrollViewClass = NO;
    }
}

- (void)setInputAttribute:(YCFInputAttribute *)inputAttribute
{
    _inputAttribute = inputAttribute;
    
    self.attributedText = inputAttribute.attributeText;
    self.attributedPlaceholder = inputAttribute.attributePlaceHolder;
}
@end

