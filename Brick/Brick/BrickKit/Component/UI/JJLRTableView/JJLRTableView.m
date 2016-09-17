//
//  JJLRTableView.m
//  JJLRTableView
//
//  Created by jxf on 16/2/18.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "JJLRTableView.h"
#import "JJLeftTableViewCell.h"
#import "JJRightTableViewCell.h"

@interface JJLRTableView ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSArray * subCategories;
@property(nonatomic, assign) NSInteger leftSelectedRow;

@end

@implementation JJLRTableView

+ (instancetype)lrTableView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initLrTableView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initLrTableView];
}


- (void)initLrTableView
{
    UITableView *leftTableView = [[UITableView alloc] init];
    UITableView *rightTableView = [[UITableView alloc] init];
    [self addSubview:leftTableView];
    [self addSubview:rightTableView];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    self.leftTableView = leftTableView;
    self.rightTableView = rightTableView;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.leftTableView.frame = CGRectMake(0, 0, self.frame.size.width * 0.5, self.frame.size.height);
    self.rightTableView.frame = CGRectMake(CGRectGetMaxX(self.leftTableView.frame), 0, self.frame.size.width - self.leftTableView.frame.size.width, self.frame.size.height);
}

#pragma mark ------------------------------------------
#pragma mark TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return [self.dataSource numberOfRowsWithLeftTableView:self];
    }else{
        return [self.dataSource numberOfRowsWithRightTableView:self];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == self.leftTableView) {
        cell = [self.dataSource lrTableView:self leftCellForRowAtIndexPath:indexPath];
        
    }else{
        cell = [self.dataSource lrTableView:self rightCellForRowAtIndexPath:indexPath];
    }
    return cell;
}
#pragma mark ------------------------------------------
#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        if ([self.delegate respondsToSelector:@selector(lrTableView:didSelectedRowInLeft:)]) {
            [self.delegate lrTableView:self didSelectedRowInLeft:indexPath.row];
        }
        self.leftSelectedRow = indexPath.row;
    }else{
        if ([self.delegate respondsToSelector:@selector(lrTableView:didSelectedRowInRight:andLeft:)]) {
            [self.delegate lrTableView:self didSelectedRowInRight:indexPath.row andLeft:self.leftSelectedRow];
        }
    }
}


@end
