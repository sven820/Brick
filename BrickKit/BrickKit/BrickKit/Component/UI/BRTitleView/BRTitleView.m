
//
//  BRTitleView.m
//  BrickKit
//
//  Created by jinxiaofei on 16/7/6.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRTitleView.h"

@interface BRTitleView ()
@property(nonatomic, assign) CGFloat itemWidth;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, strong) NSArray * contents;
@property(nonatomic, assign) BOOL canScroll;
@end

@implementation BRTitleView
+ (instancetype)createTitleViewWithWidth:(CGFloat)width itemWidth:(CGFloat)itemWidth andContents:(NSArray<NSString *> *)contents canScroll:(BOOL)canScroll;
{
    BRTitleView *titleView = [[BRTitleView alloc] initWithWidth:width ttemWidth:itemWidth andContents:contents canScroll:canScroll];
    return titleView;
}

- (instancetype)initWithWidth:(CGFloat)width ttemWidth:(CGFloat)itemWidth andContents:(NSArray<NSString *> *)contents canScroll:(BOOL)canScroll;
{
    if (self = [super init]) {
        self.itemWidth = itemWidth;
        self.width = width;
        self.contents = contents;
        self.canScroll = canScroll;
        
        [self drawViews];
    }
    return self;
}

- (void)drawViews
{
    
}
@end
