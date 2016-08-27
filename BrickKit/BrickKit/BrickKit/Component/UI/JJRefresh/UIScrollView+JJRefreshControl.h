//
//  UIScrollView+JJRefreshControl.h
//  TableViewInfinite
//
//  Created by jxf on 16/3/22.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJRefreshView;

@interface UIScrollView (JJRefreshControl)

@property(nonatomic, strong) JJRefreshView * header;
@property(nonatomic, strong) JJRefreshView * footer;

@end
