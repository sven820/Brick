//
//  JJLRTableView.h
//  JJLRTableView
//
//  Created by jxf on 16/2/18.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJLRTableView;

@protocol JJLRTableViewDatadource <NSObject>

@required
//- (NSInteger)numberOfRowsWithLrTableView:(JJLRTableView *)lrTableView;
- (NSInteger)numberOfRowsWithLeftTableView:(JJLRTableView *)lrTableView;
- (NSInteger)numberOfRowsWithRightTableView:(JJLRTableView *)lrTableView;
- (UITableViewCell *)lrTableView:(JJLRTableView *)lrTableView leftCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)lrTableView:(JJLRTableView *)lrTableView rightCellForRowAtIndexPath:(NSIndexPath *)indexPath;

//- (NSArray *)lrTableView:(JJLRTableView *)lrTableView subDataForRow:(NSInteger)row;

@optional
//- (NSString *)lrTableView:(JJLRTableView *)lrTableView titleForRow:(NSInteger)row;


@end

@protocol JJLRTableViewDelegate <NSObject>

@optional
- (void)lrTableView:(JJLRTableView *)lrTableView didSelectedRowInLeft:(NSInteger)row;
- (void)lrTableView:(JJLRTableView *)lrTableView didSelectedRowInRight:(NSInteger)rightRow andLeft:(NSInteger)leftRow;

@end

@interface JJLRTableView : UIView

+ (instancetype)lrTableView;

@property(nonatomic, weak) id<JJLRTableViewDelegate> delegate;
@property(nonatomic, weak) id<JJLRTableViewDatadource> dataSource;
@property(nonatomic, weak) UITableView * leftTableView;
@property(nonatomic, weak) UITableView * rightTableView;
@end
