//
//  TestView.m
//  Brick
//
//  Created by jinxiaofei on 16/9/6.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import "TestView.h"
#import "UIView+Magic.h"

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self.containerView addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews
{
    self.label.frame = self.containerView.bounds;
}


- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
    }
    return _label;
}
@end
