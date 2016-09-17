//
//  JJInfiniteTitleBar.h
//  TableViewInfinite
//
//  Created by jxf on 16/2/21.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const JJInfiniteTitleBarBtnDidClicked;

@interface JJInfiniteTitleBar : UIScrollView
@property(nonatomic, assign) NSInteger numberOfPages;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, strong) NSArray * titles;
@property(nonatomic, assign) CGFloat titleWidth;
@end
