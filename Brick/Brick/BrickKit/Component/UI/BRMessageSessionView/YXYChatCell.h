//
//  YXYChatCell.h
//  YXY
//
//  Created by Captain Black on 16/7/22.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXYChatCellType) {
    YXYChatCellTypeLeft,
    YXYChatCellTypeRight,
};


typedef NS_ENUM(NSUInteger, YXYChatBubbleContentType) {
    YXYChatBubbleContentTypeText,
    YXYChatBubbleContentTypeImage,
    YXYChatBubbleContentTypeGifImage,
    YXYChatBubbleContentTypeAudio,
    YXYChatBubbleContentTypeCustom,
};


@interface YXYChatCellAttributes : NSObject

@property (nonatomic, assign) YXYChatCellType cellType;
@property (nonatomic, assign) YXYChatBubbleContentType bubbleType;


@property (nonatomic, strong) NSURL *avatarImageUrl;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) NSURL *gifImageUrl;
@end

@interface YXYChatCell : UICollectionViewCell

+ (CGFloat)caculateCellHeightWithAttributes:(YXYChatCellAttributes *)attributes;
- (void)configWithCellAttributes:(YXYChatCellAttributes *)attributes;

@end
