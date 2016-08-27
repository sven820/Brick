//
//  YCFDemoTableViewCell.m
//  YCFComponentKit_OC
//
//  Created by jinxiaofei on 16/8/8.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "YCFDemoTextViewCell.h"
#import "YCFTextView.h"

static NSString * const demoTextViewCellIndetify = @"demoTextViewCellIndetify";

@interface YCFDemoTextViewCell ()<YCFTextViewDelegate>
@property(nonatomic, strong) YCFTextView *textView;
@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, strong) YCFTestCellModel *model;
@end
@implementation YCFDemoTextViewCell

+ (instancetype)demoTextViewCellWithTableView:(UITableView *)tableView
{    YCFDemoTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:demoTextViewCellIndetify];
    if (!cell)
    {
        cell = [[YCFDemoTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:demoTextViewCellIndetify];
    }
    cell.textView.containerView = tableView;
    cell.tableView = tableView;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self p_drawViews];
        [self p_constraints];
    }
    return self;
}

- (void)configWithModel:(YCFTestCellModel *)model
{
    self.model = model;
    self.textView.text = model.text;
    [self.textView fitSizeWithMaxSize:100];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(self.textView.frame.size.height);
    }];
}

- (void)p_drawViews
{
    [self.contentView addSubview:self.textView];
}

- (void)p_constraints
{
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.textView.superview;
        make.left.top.equalTo(superView);
    }];
}

- (void)textView:(YCFTextView *)textView didChangeToHeight:(CGFloat)height oriHeight:(CGFloat)oriHeight keyBoardIsResign:(BOOL)isResign
{
    if (!isResign) {
        return;
    }
    self.model.text = self.textView.text;
    self.model.height = self.model.height + height - oriHeight;
    
    [self.tableView reloadData];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.tableView reloadData];
}
#pragma mark - getter
- (YCFTextView *)textView
{
    if (!_textView)
    {
        _textView = [[YCFTextView alloc] init];
        _textView.backgroundColor = [UIColor lightGrayColor];
        _textView.isNeedAdjustHeight = YES;
        _textView.adjustMaxHeight = 100;
        _textView.delegate = self;
    }
    return _textView;
}
@end
