//
//  YXYChatBubbleContentHelper.m
//  YXY
//
//  Created by jinxiaofei on 16/9/22.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "YXYBubbleContentView.h"

@implementation YXYBubbleContentView

@end

@implementation YXYBubbleContentTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.textView = [[UITextView alloc]init];
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.textView.superview;
            make.edges.equalTo(superView);
        }];
    }
    return self;
}

@end

@implementation YXYBubbleContentGiftView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.giftView = [[UIView alloc]init];
        [self addSubview:self.giftView];
        [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = self.giftView.superview;
            make.edges.equalTo(superView);
        }];
    }
    return self;
}
@end

@implementation YXYBubbleContentImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageView = [[UIImageView alloc]init];
        [self addSubview:self.imageView];
    }
    return self;
}
@end

@implementation YXYBubbleContentGifImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.gifImageView = [[UIImageView alloc]init];
        [self addSubview:self.gifImageView];
    }
    return self;
}
@end

@implementation YXYBubbleContentAudioLeftView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.audioLeft = [[UIView alloc]init];
        [self addSubview:self.audioLeft];
    }
    return self;
}
@end

@implementation YXYBubbleContentAudioRightView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.audioRight = [[UIView alloc]init];
        [self addSubview:self.audioRight];
    }
    return self;
}
@end
