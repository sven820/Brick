//
//  UIScrollView+CBWRefresh.h
//  CBWRefresh
//
//  Created by 陈博文 on 16/5/30.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBWHeader;
@class CBWFooter;

@interface UIScrollView (CBWRefresh)

@property(nonatomic, strong) CBWHeader * header;
@property(nonatomic, strong) CBWFooter * footer;


@end
