//
//  YXYHeaderIndicatorView.h
//  Brick
//
//  Created by jinxiaofei on 16/10/2.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YXYHeaderIndicatorView : UIView

@property (nonatomic, strong) NSString *left;
@property (nonatomic, strong) NSString *right;

- (void)addTargetForLeft:(id)target sel:(SEL)sel;
- (void)addTargetForRight:(id)target sel:(SEL)sel;
@end
