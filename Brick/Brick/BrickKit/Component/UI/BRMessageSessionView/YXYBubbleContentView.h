//
//  YXYChatBubbleContentHelper.h
//  YXY
//
//  Created by jinxiaofei on 16/9/22.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

static CGFloat const kBubbleContentViewTextMaxWidth = 200;
static CGFloat const kBubbleContentViewTextFont = 13;

static CGFloat const kBubbleContentViewImageMaxWidth = 250;

//base
@interface YXYBubbleContentView : UIView
@property (nonatomic, strong) NSString *identify;
@end
//text
@interface YXYBubbleContentTextView : YXYBubbleContentView
@property (nonatomic, strong) UITextView *textView;
@end
//gift
@interface YXYBubbleContentGiftView : YXYBubbleContentView
@property (nonatomic, strong) UIView *giftView;
@end
//image
@interface YXYBubbleContentImageView : YXYBubbleContentView
@property (nonatomic, strong) UIImageView *imageView;
@end
//gif image
@interface YXYBubbleContentGifImageView : YXYBubbleContentView
@property (nonatomic, strong) UIImageView *gifImageView;
@end
//audio left
@interface YXYBubbleContentAudioLeftView : YXYBubbleContentView
@property (nonatomic, strong) UIView *audioLeft;
@end
//audio right
@interface YXYBubbleContentAudioRightView : YXYBubbleContentView
@property (nonatomic, strong) UIView *audioRight;
@end

