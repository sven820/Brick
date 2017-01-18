//
//  YXYChatHelper.h
//  Brick
//
//  Created by jinxiaofei on 16/9/23.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXYBubbleContentView.h"
#import "YXYPromptContentView.h"

@interface YXYChatHelper : NSObject
+ (instancetype)helper;

- (void)releaseCache;
- (void)releaseCacheWithIdentify:(NSString *)identify;

/**
 * YXYBubbleContentView 循环利用机制说明:
 *
 * 参数:bubbleContentView -> 如果bubbleContentView有superView, 并且class等于返回值的class, 则不会创建新的view, 会直接处理内容
 如果bubbleContentView为空, 或者bubbleContentView的class不等于返回值所需的class, 则会将此bubbleContentView移出superView, 再放入缓存池中, 然后重新去缓存池中寻找需要class的view, 找不到会重新创建个新的
 */

/**
 * 备注: 返回的contentView 都将有明确的bounds大小, 内部会做相关尺寸计算, 暂时没做自定义尺寸大小
 */

//将contentView 放到缓存池中, 被重复利用
- (void)recycleBubbleContentViewWithBubbleContentView:(UIView *)bubbleContentView;

#pragma mark - YXYBubbleContentView

//text
- (YXYBubbleContentTextView *)dequeContentViewWithText:(NSString *)text bubbleContentView:(YXYBubbleContentView *)bubbleContentView;
- (YXYBubbleContentTextView *)dequeContentViewWithAttributedText:(NSAttributedString *)attributedText bubbleContentView:(YXYBubbleContentView *)bubbleContentView;

//gift
- (YXYBubbleContentImageView *)dequeContentViewWithGift:(id)gift bubbleContentView:(YXYBubbleContentView *)bubbleContentView;

//image
- (YXYBubbleContentImageView *)dequeContentViewWithImage:(NSURL *)imageUrl bubbleContentView:(YXYBubbleContentView *)bubbleContentView;
//gif image
- (YXYBubbleContentGifImageView *)dequeContentViewWithGifImage:(NSURL *)gifImageUrl bubbleContentView:(YXYBubbleContentView *)bubbleContentView;

//audio left
- (YXYBubbleContentAudioLeftView *)dequeContentViewWithAudioLeft:(id)voice bubbleContentView:(YXYBubbleContentView *)bubbleContentView;
//audio right
- (YXYBubbleContentAudioRightView *)dequeContentViewWithAudioRight:(id)voice bubbleContentView:(YXYBubbleContentView *)bubbleContentView;

#pragma mark - YXYPromptContentView

- (YXYChatPromptContentTimeView *)dequeContentViewWithTime:(NSString *)time promptContentView:(YXYPromptContentView *)promptContentView;

- (YXYChatPromptContentTipsView *)dequeContentViewWithTips:(NSString *)tips promptContentView:(YXYPromptContentView *)promptContentView;

@end
