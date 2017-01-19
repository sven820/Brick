//
//  YXYChatHelper.m
//  Brick
//
//  Created by jinxiaofei on 16/9/23.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "YXYChatHelper.h"

@interface YXYChatContentViewReusableManager : NSObject
@property (nonatomic, strong) NSString *identify;
@property(nonatomic, assign) Class class;
@property (nonatomic, strong) NSMutableSet *reusableItems;
@end

@implementation YXYChatContentViewReusableManager
- (NSMutableSet *)reusableItems
{
    if (!_reusableItems)
    {
        _reusableItems = [NSMutableSet set];
    }
    return _reusableItems;
}
@end

@interface YXYChatHelper ()
@property (nonatomic, strong) NSCache<NSString *, YXYChatContentViewReusableManager *> *contentReusableCache;
@end

@implementation YXYChatHelper
static YXYChatHelper *helper;
static dispatch_once_t onceToken;

+ (instancetype)helper
{
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

- (void)releaseCache
{
    [self.contentReusableCache removeAllObjects];
    self.contentReusableCache = nil;
}

- (void)releaseCacheWithIdentify:(NSString *)identify
{
    YXYChatContentViewReusableManager *manager = [self.contentReusableCache objectForKey:identify];
    if (manager)
    {
        [manager.reusableItems removeAllObjects];
        [self.contentReusableCache removeObjectForKey:identify];
    }
}

#pragma mark - YXYBubbleContentView

- (void)recycleBubbleContentViewWithBubbleContentView:(UIView *)bubbleContentView
{
    [self saveResumeContentView:bubbleContentView];
}

- (YXYBubbleContentTextView *)dequeContentViewWithText:(NSString *)text bubbleContentView:(YXYBubbleContentView *)bubbleContentView
{
    YXYBubbleContentTextView *contentView = nil;
    if (bubbleContentView.superview && [bubbleContentView isMemberOfClass:[YXYBubbleContentTextView class]])
    {
        contentView = (YXYBubbleContentTextView *)bubbleContentView;
    }
    else
    {
        [self saveResumeContentView:bubbleContentView];
        contentView = (YXYBubbleContentTextView *)[self getResumeContentView:NSStringFromClass([YXYBubbleContentTextView class])];
    }
    contentView.textView.text = text;
    CGSize size = [self calculateTextSizeWithText:text attributedText:nil];
    contentView.bounds = CGRectMake(0, 0, size.width, size.height);
    contentView.textView.bounds = contentView.bounds;
    return contentView;
}
- (YXYBubbleContentTextView *)dequeContentViewWithAttributedText:(NSAttributedString *)attributedText bubbleContentView:(YXYBubbleContentView *)bubbleContentView
{
    YXYBubbleContentTextView *contentView = nil;
    if (bubbleContentView.superview && [bubbleContentView isMemberOfClass:[YXYBubbleContentTextView class]])
    {
        contentView = (YXYBubbleContentTextView *)bubbleContentView;
    }
    else
    {
        [self saveResumeContentView:bubbleContentView];
        contentView = (YXYBubbleContentTextView *)[self getResumeContentView:NSStringFromClass([YXYBubbleContentTextView class])];
    }
    contentView.textView.attributedText = attributedText;
    CGSize size = [self calculateTextSizeWithText:nil attributedText:attributedText];
    contentView.bounds = CGRectMake(0, 0, size.width, size.height);
    contentView.textView.bounds = contentView.bounds;
    return contentView;
}

- (YXYBubbleContentImageView *)dequeContentViewWithGift:(id)gift bubbleContentView:(YXYBubbleContentView *)bubbleContentView
{
    return nil;
}

- (YXYBubbleContentImageView *)dequeContentViewWithImage:(NSURL *)imageUrl bubbleContentView:(YXYBubbleContentView *)bubbleContentView
{
    YXYBubbleContentImageView *contentView = nil;
    if (bubbleContentView.superview && [bubbleContentView isMemberOfClass:[YXYBubbleContentImageView class]])
    {
        contentView = (YXYBubbleContentImageView *)bubbleContentView;
    }
    else
    {
        [self saveResumeContentView:bubbleContentView];
        contentView = (YXYBubbleContentImageView *)[self getResumeContentView:NSStringFromClass([YXYBubbleContentImageView class])];
    }
    [contentView.imageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
#warning 处理图片上传, 怎么显示, 逻辑
    }];
    [contentView.imageView sizeToFit];
    CGSize size = contentView.bounds.size;
    if (size.width > kBubbleContentViewImageMaxWidth) {
        size.width = kBubbleContentViewImageMaxWidth;
        size.height = size.height / size.width * kBubbleContentViewImageMaxWidth;
    }
    contentView.bounds = CGRectMake(0, 0, size.width, size.height);
    contentView.imageView.bounds = contentView.bounds;
    return contentView;
}
- (YXYBubbleContentGifImageView *)dequeContentViewWithGifImage:(NSURL *)gifImageUrl bubbleContentView:(YXYBubbleContentView *)bubbleContentView
{
    return nil;
    
}

- (YXYBubbleContentAudioLeftView *)dequeContentViewWithAudioLeft:(id)voice bubbleContentView:(YXYBubbleContentView *)bubbleContentView
{
    return nil;
    
}

- (YXYBubbleContentAudioRightView *)dequeContentViewWithAudioRight:(id)voice bubbleContentView:(YXYBubbleContentView *)bubbleContentView
{
    return nil;
}

#pragma mark - YXYPromptContentView

- (YXYChatPromptContentTimeView *)dequeContentViewWithTime:(NSString *)time promptContentView:(YXYPromptContentView *)promptContentView
{
    YXYChatPromptContentTimeView *contentView = nil;
    if (promptContentView.superview && [promptContentView isMemberOfClass:[YXYChatPromptContentTimeView class]])
    {
        contentView = (YXYChatPromptContentTimeView *)promptContentView;
    }
    else
    {
        [self saveResumeContentView:promptContentView];
        contentView = (YXYChatPromptContentTimeView *)[self getResumeContentView:NSStringFromClass([YXYChatPromptContentTimeView class])];
    }
    contentView.timeLabel.text = time;
    return contentView;

}

- (YXYChatPromptContentTipsView *)dequeContentViewWithTips:(NSString *)tips promptContentView:(YXYPromptContentView *)promptContentView
{
    YXYChatPromptContentTipsView *contentView = nil;
    if (promptContentView.superview && [promptContentView isMemberOfClass:[YXYChatPromptContentTipsView class]])
    {
        contentView = (YXYChatPromptContentTipsView *)promptContentView;
    }
    else
    {
        [self saveResumeContentView:promptContentView];
        contentView = (YXYChatPromptContentTipsView *)[self getResumeContentView:NSStringFromClass([YXYChatPromptContentTipsView class])];
    }
    contentView.tipsLabel.text = tips;
    return contentView;

}

#pragma mark - private
- (CGSize)calculateTextSizeWithText:(NSString *)text attributedText:(NSAttributedString *)attributedText
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (attributedText && attributedText.length > 0)
    {
        NSRange range = NSMakeRange(0, attributedText.length);
        NSRangePointer rangePointer = &range;
        attributes = [NSMutableDictionary dictionaryWithDictionary:[attributedText attributesAtIndex:0 effectiveRange:rangePointer]];
    }
    else if(text && text.length > 0)
    {
        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:kBubbleContentViewTextFont];;
        attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    }
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(kBubbleContentViewTextMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return size;
}

- (void)saveResumeContentView:(UIView *)contentView
{
    if (!contentView)
    {
        return;
    }
    [contentView removeFromSuperview];
    NSString *identify = nil;
    YXYPromptContentView *promptContent = nil;
    YXYBubbleContentView *bubbleContent = nil;
    if ([contentView isKindOfClass:[YXYPromptContentView class]])
    {
        promptContent = (YXYPromptContentView *)contentView;
        identify = promptContent.identify;
    }
    else if ([contentView isKindOfClass:[YXYBubbleContentView class]])
    {
        bubbleContent = (YXYBubbleContentView *)contentView;
        identify = bubbleContent.identify;
    }
    if (!identify)
    {
        identify = NSStringFromClass([contentView class]);
    }
    YXYChatContentViewReusableManager *manager = [self.contentReusableCache objectForKey:identify];
    if (!manager)
    {
        manager = [[YXYChatContentViewReusableManager alloc] init];
        manager.identify = identify;
        manager.class = NSClassFromString(identify);
    }
    
    [manager.reusableItems addObject:contentView];
}

- (UIView *)getResumeContentView:(NSString *)identify
{
    YXYChatContentViewReusableManager *manager = [self.contentReusableCache objectForKey:identify];
    if (!manager)
    {
        manager = [[YXYChatContentViewReusableManager alloc] init];
        manager.identify = identify;
        manager.class = NSClassFromString(identify);
    }
    UIView *contentView = [manager.reusableItems anyObject];
    if (!contentView)
    {
        contentView = [[manager.class alloc]init];
        
        if ([identify isEqualToString:NSStringFromClass([YXYPromptContentView class])])
        {
            YXYPromptContentView *promptContent = (YXYPromptContentView *)contentView;
            promptContent.identify = identify;
        }
        else if ([identify isEqualToString:NSStringFromClass([YXYBubbleContentView class])])
        {
            YXYBubbleContentView *bubbleContent = (YXYBubbleContentView *)contentView;
            bubbleContent.identify = identify;
        }
    }
    return contentView;
}

#pragma mark - getter
- (NSCache<NSString *, YXYChatContentViewReusableManager *> *)contentReusableCache
{
    if (!_contentReusableCache)
    {
        _contentReusableCache = [[NSCache alloc]init];
    }
    return _contentReusableCache;
}
@end
