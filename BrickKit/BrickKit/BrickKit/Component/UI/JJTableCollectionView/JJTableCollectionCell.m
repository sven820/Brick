//
//  JJTableCollectionCell.m
//  JJTableCollectionView
//
//  Created by jxf on 16/2/19.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "JJTableCollectionCell.h"

@interface JJTableCollectionCell ()
@end

@implementation JJTableCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UITableView *tableView = [[UITableView alloc] init];
//        NSLog(@"%p", tableView);
        [self.contentView addSubview:tableView];
        self.tableView = tableView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.contentView.bounds;
}

@end
