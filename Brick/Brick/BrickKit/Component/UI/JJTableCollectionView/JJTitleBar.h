//
//  JJTitleBar.h
//  JJTableCollectionView
//
//  Created by jxf on 16/2/24.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const JJTitleBarBtnDidClicked;

@interface JJTitleBar : UIView
@property(nonatomic, assign) NSInteger numberOfPages;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, strong) NSArray * titles;

@end
