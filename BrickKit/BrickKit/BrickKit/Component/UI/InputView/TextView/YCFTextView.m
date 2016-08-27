//
//  AutoKeyBoard.m
//  test
//
//  Created by jinxiaofei on 16/5/27.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "YCFTextView.h"

static NSString * const keyBoardManagerOberverKeyPath = @"status";

@interface YCFTextView ()
//@property(nonatomic, weak) id<YCFTextViewDelegate> delegate_;
// 容器view的原始frame
@property(nonatomic, assign) CGRect contentViewOriginalFrame;
@property(nonatomic, assign) CGRect oriFrame;
@property(nonatomic, assign) CGFloat lastTextRectHeight;
// 容器view是scrollView时的原始offset
@property(nonatomic, assign) CGPoint contentScrollViewOriginalOffset;
@property(nonatomic, assign) CGPoint afterMovedContentOffset;
@property(nonatomic, assign) BOOL hasCachedOri;

// 判断容器view是否是scrollView或者其子类
@property(nonatomic, assign) BOOL contentViewIsScrollViewClass;

// 一些标记,控制执行次数
@property(nonatomic, assign) BOOL markForIsSettingOri;
@property(nonatomic, assign) BOOL markForFrameChange;

@property(nonatomic, assign) BOOL isEditing;
@property(nonatomic, assign) BOOL keyBoardIsShow;
@property(nonatomic, assign) BOOL hasMatchingKeyBoard;

@property(nonatomic, strong) UILabel *placeHolder;

@property(nonatomic, weak) YCFKeyBoardManager *manager;

@property(nonatomic, strong) UILabel *textLenghtLabel;
@property(nonatomic, assign) NSInteger textLengthLimit;
@end

@implementation YCFTextView

@synthesize containerView = _containerView;
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //will show -> didBeginEditing -> did show
        //will hide -> didEndEditing -> did hide
        [self.manager addObserver:self forKeyPath:keyBoardManagerOberverKeyPath options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing) name:UITextViewTextDidEndEditingNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [self.manager removeObserver:self forKeyPath:keyBoardManagerOberverKeyPath];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self p_addTextLenghtLabel];
    [self setContentOffset:CGPointMake(0, self.contentSize.height - self.frame.size.height + self.contentInset.bottom) animated:NO];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context
{
    if ([keyPath isEqualToString:keyBoardManagerOberverKeyPath])
    {
        switch ([YCFKeyBoardManager shareInstance].status)
        {
            case YCFKeyBoardStatusWillShow:
                self.keyBoardIsShow = YES;
                break;
            case YCFKeyBoardStatusDidShow:
                
                break;
            case YCFKeyBoardStatusWillHide:
                self.keyBoardIsShow = NO;
                [self p_dealWithKeyBoardHide];
                break;
            case YCFKeyBoardStatusDidHide:
                break;
            default:
                break;
        }
    }
}


- (void)textViewDidBeginEditing
{
    self.isEditing = YES;
    self.manager.curEditView = self;
    self.lastTextRectHeight = [self p_getTextRect].size.height;
    [self p_dealWithKeyBoardShow];
}
- (void)textViewDidChange
{
    [self p_dealWithTextLengthLabel];
    
    [self p_dealWithPlaceHolder];
    
    if (!self.isNeedAdjustHeight)
    {
        return;
    }
    
    CGFloat oriTextRectHeight = self.lastTextRectHeight;
    CGFloat newTextRectHeight = [self p_getFixtedSize:self.frame.size.width].height - self.textContainerInset.bottom;
    
//    相同行,由text计算所得的newHeight跟原来oriHeight有少许出入,设立设置个2的公差范围,高度差大于2则更新高度
    if (ABS(oriTextRectHeight - newTextRectHeight) > 2)
    {
        CGFloat delta = newTextRectHeight - oriTextRectHeight;
        
        if (self.adjustMaxHeight && self.frame.size.height >= self.adjustMaxHeight && delta > 0)
        {
            delta = 0;
        }
        if (self.adjustMinHeight && self.frame.size.height <= self.adjustMinHeight && delta < 0)
        {
            delta = 0;
        }
        CGRect frame = self.frame;
        if (newTextRectHeight + self.lengthLabelPadding.top + _textLenghtLabel.frame.size.height + self.lengthLabelPadding.bottom > self.frame.size.height || delta < 0)
        {
            frame.size.height += delta;
            if (self.adjustMaxHeight && frame.size.height > self.adjustMaxHeight)
            {
                frame.size.height = self.adjustMaxHeight;
                delta = self.adjustMaxHeight - oriTextRectHeight;
            }
            if (frame.size.height < self.adjustMinHeight)
            {
                frame.size.height = self.adjustMinHeight;
                delta = frame.size.height - oriTextRectHeight;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.frame.size.height != self.oriFrame.size.height)
            {
                if ([self.delegate respondsToSelector:@selector(textView:willChangeToHeight:oriHeight:)])
                {
                    [self.delegate textView:self willChangeToHeight:frame.size.height oriHeight:self.oriFrame.size.height];
                }
            }
        });
        
        [self p_dealWithTextViewFrameChange:delta newFrame:frame];
        self.lastTextRectHeight = [self p_getTextRect].size.height;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.frame.size.height != self.oriFrame.size.height)
            {
                if ([self.delegate respondsToSelector:@selector(textView:didChangeToHeight:oriHeight:keyBoardIsResign:)])
                {
                    [self.delegate textView:self didChangeToHeight:frame.size.height oriHeight:self.oriFrame.size.height keyBoardIsResign:NO];
                }
            }
        });
       
    }
}
- (void)textViewDidEndEditing
{
    if (self.keyBoardIsShow == NO)
    {
        self.isEditing = NO;
    }
}

#pragma mark - private methods

- (void)p_dealWithKeyBoardShow
{
    // 转换到window上的y值
    CGFloat selfComparativelyWindowY = 0.0;
    // 容器为scrollView时, 用这个
    UIScrollView *selfContentScrollView;
    
    if (self.contentViewIsScrollViewClass)
    {
        selfContentScrollView = (UIScrollView *)self.containerView;
        CGPoint contentViewComparativelyWindowP = [selfContentScrollView convertPoint:selfContentScrollView.bounds.origin toView:nil];
        CGPoint selfComparativelyScrollViewP = [self convertPoint:self.bounds.origin toView:selfContentScrollView];
        selfComparativelyWindowY = selfComparativelyScrollViewP.y + CGRectGetHeight([self p_getTextRect]) - (selfContentScrollView.contentOffset.y) + contentViewComparativelyWindowP.y;
    }
    else
    {
        CGPoint contentViewComparativelyWindowP = [self.containerView convertPoint:self.containerView.bounds.origin toView:nil];
        selfComparativelyWindowY = self.frame.origin.y + CGRectGetHeight([self p_getTextRect]) + contentViewComparativelyWindowP.y;
    }
    
    // 记录原始位置, 该方法可能多次执行, 只记录初始位置
    if (self.hasCachedOri == NO)
    {
        [self p_cacheOriginalLocation];
        self.hasCachedOri = YES;
    }
    
    if (selfComparativelyWindowY <= self.manager.keyBoardFrame.origin.y)
    {
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
            self.hasMatchingKeyBoard = YES;
        }];
    }
    else
    {
        [UIView animateWithDuration:self.manager.keyBoardDuration delay:0.0 options:self.manager.keyBoardAnimationOptions animations:^{
            CGRect rect = self.containerView.frame;
            rect.origin.y -= offsetY;
            self.containerView.frame = rect;
        } completion:^(BOOL finished) {
            self.hasMatchingKeyBoard = YES;
        }];
    }
}

- (void)p_dealWithKeyBoardHide
{
    //只处理编辑过的
    if (self.isEditing)
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.frame.size.height != self.oriFrame.size.height)
            {
                if ([self.delegate respondsToSelector:@selector(textView:didChangeToHeight:oriHeight:keyBoardIsResign:)])
                {
                    [self.delegate textView:self didChangeToHeight:self.frame.size.height oriHeight:self.oriFrame.size.height keyBoardIsResign:YES];
                }
            }
        });
        
        
        //复位一些标记
        self.markForIsSettingOri = NO;
        self.hasCachedOri = NO;
        self.markForFrameChange = NO;
        self.hasMatchingKeyBoard = NO;
    }
}

- (BOOL)p_hasBeenMovedWhenKeyBoardIsShow
{
    if (self.contentViewIsScrollViewClass)
    {
        //如果在键盘弹起的时候, 用户滚动了界面,退出键盘就不在处理复位, 这样体验好点
        UIScrollView *selfContentScrollView = (UIScrollView *)self.containerView;
        if (self.afterMovedContentOffset.x == selfContentScrollView.contentOffset.x && self.afterMovedContentOffset.y == selfContentScrollView.contentOffset.y)
        {
            return NO;
        }
        if (self.markForFrameChange)//适应文本框大下不算滚动过
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
    
    self.oriFrame = self.frame;
    
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

- (void)p_dealWithPlaceHolder
{
    if (_placeHolder)
    {
        if (self.text && self.text.length > 0)
        {
            self.placeHolder.hidden = YES;
        }
        else
        {
            self.placeHolder.hidden = NO;
        }
    }
}

- (void)p_dealWithTextViewFrameChange:(CGFloat)delta newFrame:(CGRect)newFrame
{
    self.markForFrameChange = YES;
    
    CGFloat selfComparativelyWindowY = 0.0;
    // 容器为scrollView时, 用这个
    UIScrollView *selfContentScrollView;
    
    if (self.contentViewIsScrollViewClass)
    {
        selfContentScrollView = (UIScrollView *)self.containerView;
        CGPoint contentViewComparativelyWindowP = [selfContentScrollView convertPoint:selfContentScrollView.bounds.origin toView:nil];
        CGPoint selfComparativelyScrollViewP = [self convertPoint:self.bounds.origin toView:selfContentScrollView];
        selfComparativelyWindowY = selfComparativelyScrollViewP.y + CGRectGetHeight([self p_getTextRect]) - (selfContentScrollView.contentOffset.y) + contentViewComparativelyWindowP.y;
    }
    else
    {
        CGPoint contentViewComparativelyWindowP = [self.containerView convertPoint:self.containerView.bounds.origin toView:nil];
        selfComparativelyWindowY = self.frame.origin.y + CGRectGetHeight([self p_getTextRect]) + contentViewComparativelyWindowP.y;
    }
    
    if (selfComparativelyWindowY <= self.manager.keyBoardFrame.origin.y && !self.hasMatchingKeyBoard)
    {
        self.frame = newFrame;
        return;
    }

    if (self.contentViewIsScrollViewClass)
    {
        CGPoint offset = selfContentScrollView.contentOffset;
        offset.y += delta;
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [selfContentScrollView setContentOffset:offset];
            self.frame = newFrame;
        } completion:^(BOOL finished) {
            self.afterMovedContentOffset = selfContentScrollView.contentOffset;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = newFrame;
            CGRect rect = self.containerView.frame;
            rect.origin.y -= delta;
            self.containerView.frame = rect;
        } completion:nil];
    }
    
}

- (CGSize)p_getFixtedSize:(CGFloat)maxWidth
{
    CGFloat maxTextWidth = maxWidth - self.textContainer.lineFragmentPadding * 2 - self.textContainerInset.left - self.textContainerInset.right;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (self.attributedText && self.attributedText.length > 0)
    {
        NSRange range = NSMakeRange(0, self.attributedText.length);
        NSRangePointer rangePointer = &range;
        attributes = [NSMutableDictionary dictionaryWithDictionary:[self.attributedText attributesAtIndex:0 effectiveRange:rangePointer]];
    }
    else
    {
        attributes[NSFontAttributeName] = self.font;
        attributes[NSForegroundColorAttributeName] = self.textColor;
    }
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(maxTextWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    //当textViewcopy文本的时候,用sizeThatFits, 由于他会自己预先布局导致显示不准确, 不过boundingRectWithSize计算的高度某些情况也不准确
    //    CGFloat textHeight = [self sizeThatFits:CGSizeMake(maxWidth, MAXFLOAT)].height;
    CGFloat newHeight = textSize.height + self.textContainerInset.top + self.textContainerInset.bottom;
    CGFloat newWidth = textSize.width + self.textContainerInset.left + self.textContainerInset.right + self.textContainer.lineFragmentPadding * 2;
    return CGSizeMake(newWidth, newHeight);
}

- (CGRect)p_getTextRect
{
    CGSize newSize = [self p_getFixtedSize:self.frame.size.width];
    CGRect textRect = CGRectMake(0, 0, newSize.width, newSize.height - self.textContainerInset.bottom);
    if (textRect.size.height > self.frame.size.height)
    {
        textRect.size.height = self.frame.size.height;
    }
    return textRect;
}

- (void)p_addTextLenghtLabel
{
    if (!self.isShowTextLengthLabel)
    {
        return;
    }
    
    if (self.textLenghtLabel.superview)
    {
        CGRect frame = self.textLenghtLabel.frame;
        frame.size.width = self.frame.size.width - self.lengthLabelPadding.left - self.lengthLabelPadding.right;
        self.textLenghtLabel.frame = frame;
        return;
    }
    
    [self addSubview:self.textLenghtLabel];
    
    if (self.textLengthLimit)
    {
        self.textLenghtLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.text.length, self.textLengthLimit];
    }
    else
    {
        self.textLenghtLabel.text = [NSString stringWithFormat:@"%zd", self.text.length];
    }
    
    UIEdgeInsets insets = self.contentInset;
    insets.bottom += self.textLenghtLabel.frame.size.height + self.lengthLabelPadding.top + self.lengthLabelPadding.bottom;
    self.contentInset = insets;
    
    CGFloat Y = self.contentSize.height < self.frame.size.height - self.textLenghtLabel.frame.size.height ? self.frame.size.height - self.textLenghtLabel.frame.size.height : self.contentSize.height;
    CGFloat width = self.frame.size.width - self.lengthLabelPadding.left - self.lengthLabelPadding.right;
    CGFloat height = self.textLenghtLabel.frame.size.height;
    
    self.textLenghtLabel.frame = CGRectMake(self.lengthLabelPadding.left, Y, width, height);
    
    CGRect rect = self.frame;
    rect.size.height += self.textLenghtLabel.frame.size.height + self.lengthLabelPadding.top + self.lengthLabelPadding.bottom;
    self.frame = rect;
}

- (void)p_dealWithTextLengthLabel
{
    if (self.textLengthLimit)
    {
        self.textLenghtLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.text.length, self.textLengthLimit];
    }
    else
    {
        self.textLenghtLabel.text = [NSString stringWithFormat:@"%zd", self.text.length];
    }
    
    CGRect frame = self.textLenghtLabel.frame;
    frame.origin.y = self.contentSize.height < self.frame.size.height - self.textLenghtLabel.frame.size.height ? self.frame.size.height - self.textLenghtLabel.frame.size.height : self.contentSize.height;
    self.textLenghtLabel.frame = frame;
    
    if (self.textLengthLimit && self.text.length > self.textLengthLimit)
    {
        self.text = [self.text substringToIndex:self.textLengthLimit - 1];
        if ([self.delegate respondsToSelector:@selector(textView:didOverTextLength:)])
        {
            [self.delegate textView:self didOverTextLength:self.textLengthLimit];
        }
    }
}
#pragma mark - public methods
- (void)fitSizeWithMaxSize:(CGFloat)maxWidth
{
    CGSize fixedSize = [self p_getFixtedSize:maxWidth];
    CGRect rect = self.frame;
    rect.size.height = fixedSize.height;
    rect.size.width = fixedSize.width;
    self.frame = rect;
    [self p_addTextLenghtLabel];
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
        return self;
    }
    return _containerView;
}

- (UILabel *)placeHolder
{
    if (!_placeHolder)
    {
        _placeHolder = [[UILabel alloc] init];
        _placeHolder.font = self.font;
        
    }
    return _placeHolder;
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
    if (inputAttribute.placeHolder && inputAttribute.placeHolder.length > 0)
    {
        self.placeHolder.attributedText = inputAttribute.attributePlaceHolder;
        [self addSubview:self.placeHolder];
        [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.placeHolder.superview;
            make.left.equalTo(superView).offset(self.textContainer.lineFragmentPadding + self.textContainerInset.left);
            make.top.equalTo(superView).offset(self.textContainerInset.top);
        }];
        if (inputAttribute.text && inputAttribute.text.length > 0)
        {
            self.placeHolder.hidden = YES;
        }
        else
        {
            self.placeHolder.hidden = NO;
        }
    }
    self.textLengthLimit = inputAttribute.textLimitCount;
    self.textLenghtLabel.font = inputAttribute.textFont;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    _lineBreakMode = lineBreakMode;
    self.textContainer.lineBreakMode = lineBreakMode;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    _numberOfLines = numberOfLines;
    self.textContainer.maximumNumberOfLines = numberOfLines;
}

- (void)setTextInsets:(UIEdgeInsets)textInsets
{
    _textInsets = textInsets;
    self.textContainer.lineFragmentPadding = 0;
    self.textContainerInset = textInsets;
}

- (UILabel *)textLenghtLabel
{
    if (!_textLenghtLabel)
    {
        _textLenghtLabel = [[UILabel alloc] init];
        _textLenghtLabel.font = self.font;
        _textLenghtLabel.textAlignment = NSTextAlignmentRight;
        
        _textLenghtLabel.text = [NSString stringWithFormat:@"%zd", self.text.length];
        _textLenghtLabel.backgroundColor = [UIColor purpleColor];
        
        [_textLenghtLabel sizeToFit];
    }
    return _textLenghtLabel;
}

@end

