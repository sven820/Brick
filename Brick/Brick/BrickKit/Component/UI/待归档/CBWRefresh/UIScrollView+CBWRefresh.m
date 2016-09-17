//
//  UIScrollView+CBWRefresh.m
//  CBWRefresh
//
//  Created by 陈博文 on 16/5/30.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "UIScrollView+CBWRefresh.h"
#import "CBWHeader.h"
#import "CBWFooter.h"
#import <objc/runtime.h>

@interface UIScrollView ()

@end

@implementation UIScrollView (CBWRefresh)

static const char CBWRefreshHeaderKey = '\0';
- (void)setHeader:(CBWHeader *)header
{
    if (header != self.header) {
        // 删除旧的，添加新的
        [self.header removeFromSuperview];
        [self insertSubview:header atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"header"]; // KVO
        objc_setAssociatedObject(self, &CBWRefreshHeaderKey,
                                 header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"header"]; // KVO
    }
}

static const char CBWRefreshFooterkey = '\0';
- (void)setFooter:(CBWFooter *)footer
{
    
    if (self.footer != footer) {
        
        [self.footer removeFromSuperview];
        [self addSubview:footer];
        
        [self willChangeValueForKey:@"footer"];//KVO
        objc_setAssociatedObject(self, &CBWRefreshFooterkey, footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"footer"];//KVO
    }

}

- (CBWHeader *)header
{
    return objc_getAssociatedObject(self, &CBWRefreshHeaderKey);
}

- (CBWFooter *)footer
{
    return objc_getAssociatedObject(self, &CBWRefreshFooterkey);
}


@end
