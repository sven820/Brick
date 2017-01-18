//
//  YXYChatPromptCell.h
//  Brick
//
//  Created by jinxiaofei on 16/9/23.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXYChatCellPromptAnimationType) {
    YXYChatCellPromptAnimationTypeNone,
    YXYChatCellPromptAnimationTypeLeftIn,
    YXYChatCellPromptAnimationTypeRightIn,
    YXYChatCellPromptAnimationTypeFadeInOut,
};

typedef NS_ENUM(NSUInteger, YXYChatPromptContentType) {
    YXYChatPromptContentTypeTime,
    YXYChatPromptContentTypeTips,
    YXYChatPromptContentTypeCustom,
};
@interface YXYChatPromptCell : UICollectionViewCell

@end
