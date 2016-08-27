//
//  JJTableCollectionView.h
//  JJTableCollectionView
//
//  Created by jxf on 16/2/18.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJTitleBar.h"
@class JJTableCollectionView;

@protocol JJTableCollectionViewDataSource <NSObject>

@required
- (NSInteger)tableCollectionView:(JJTableCollectionView *)tableCollectionView numberOfItemsInSection:(NSInteger)section;

- (NSInteger)tableCollectionView:(JJTableCollectionView *)tableCollectionView numberOfCellsInCollectionItem:(NSInteger)index;

- (UITableViewCell *)tableCollectionView:(JJTableCollectionView *)tableCollectionView andTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath andItemIndex:(NSInteger)index;
@end

@protocol JJTableCollectionViewDelagate <NSObject>

@optional
- (void)tableCollectionView:(JJTableCollectionView *)tableCollectionView didSelectedRowAtIndexPath:(NSInteger)indexPath;

@end

@interface JJTableCollectionView : UIView

+ (instancetype)tableCollectionView;

@property(nonatomic, weak) id<JJTableCollectionViewDataSource> dataSource;
@property(nonatomic, weak) id<JJTableCollectionViewDelagate> delegate;
@property(nonatomic, weak, readonly) JJTitleBar * titleBar;
@property(nonatomic, assign) CGFloat titleBarHeight;
@end
