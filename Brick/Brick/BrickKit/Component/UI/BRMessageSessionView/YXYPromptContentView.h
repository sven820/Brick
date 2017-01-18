//
//  YXYChatPromptContentHelper.h
//  Brick
//
//  Created by jinxiaofei on 16/9/23.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>

//base
@interface YXYPromptContentView : UIView
@property (nonatomic, strong) NSString *identify;
@end
//time
@interface YXYChatPromptContentTimeView : YXYPromptContentView
@property (nonatomic, strong) UILabel *timeLabel;
@end
//time
@interface YXYChatPromptContentTipsView : YXYPromptContentView
@property (nonatomic, strong) UILabel *tipsLabel;
@end
