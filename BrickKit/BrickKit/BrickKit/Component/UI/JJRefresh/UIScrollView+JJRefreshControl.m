//
//  UIScrollView+JJRefreshControl.m
//  TableViewInfinite
//
//  Created by jxf on 16/3/22.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "UIScrollView+JJRefreshControl.h"
#import "JJRefreshView.h"
#import "UIScrollView+JJExtension.h"
#import "UIView+AdjustFrame.h"

@implementation UIScrollView (JJRefreshControl)
static JJRefreshView *headerView;
static JJRefreshView *footerView;
- (void)setHeader:(JJRefreshView *)header
{
    [header removeFromSuperview];
    headerView = header;
    [self insertSubview:header atIndex:0];
    header.frame = CGRectMake(0, -44, self.jj_width, 44);
}

- (void)setFooter:(JJRefreshView *)footer
{
    [footer removeFromSuperview];
    footerView = footer;
    [self insertSubview:footer atIndex:0];
    footer.frame = CGRectMake(0, self.contentSize.height, self.jj_width, 44);
    self.jj_insetB = footer.jj_height;
}

- (JJRefreshView *)header
{
    return headerView;
}

- (JJRefreshView *)footer
{
    return footerView;
}

@end

