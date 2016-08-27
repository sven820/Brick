//
//  YCFDemoTableViewCell.m
//  YCFComponentKit_OC
//
//  Created by jinxiaofei on 16/8/8.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "YCFDemoTextFieldCell.h"
#import "YCFTextField.h"

static NSString * const demoTextFieldCellIndetify = @"demoTextFieldCellIndetify";

@interface YCFDemoTextFieldCell ()
@property(nonatomic, strong) YCFTextField *textField;
@end
@implementation YCFDemoTextFieldCell

+ (instancetype)demoTextFieldCellWithTableView:(UITableView *)tableView
{
    YCFDemoTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:demoTextFieldCellIndetify];
    if (!cell)
    {
        cell = [[YCFDemoTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:demoTextFieldCellIndetify];
    }
    cell.textField.containerView = tableView;
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

- (void)p_drawViews
{
    [self.contentView addSubview:self.textField];
}

- (void)p_constraints
{
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.textField.superview;
        make.left.top.right.equalTo(superView);
        make.bottom.equalTo(superView).offset(-20);
    }];
}

#pragma mark - getter
- (YCFTextField *)textField
{
    if (!_textField)
    {
        _textField = [[YCFTextField alloc] init];
        _textField.placeholder = @"demo textField";
        _textField.backgroundColor = [UIColor lightGrayColor];
    }
    return _textField;
}
@end
