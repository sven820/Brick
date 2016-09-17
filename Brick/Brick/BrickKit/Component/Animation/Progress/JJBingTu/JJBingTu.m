//
//  JJBingTu.m
//  饼图
//
//  Created by jxf on 15/12/8.
//  Copyright © 2015年 JJ.sevn. All rights reserved.
//

#import "JJBingTu.h"

@implementation JJBingTu


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (instancetype)bingTu
{
    return [[self alloc] init];
}

+ (instancetype)bingTuWithFrame:(CGRect)rect
{
    return [[self alloc] initWithFrame:rect];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat startAngle = 0;
    CGFloat endAngle = 0;
    CGFloat radius = self.frame.size.width * 0.5 - 10;
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    NSArray *arrK = [self.dict allKeys];
    NSArray *arrAllValue = [self.dict allValues];
    double totalValues = 0;
    for (NSNumber *num in arrAllValue) {
        totalValues += [num doubleValue];
    }
    for (NSString *str in arrK) {
        double value = [self.dict[str] doubleValue];
        startAngle = endAngle;
        endAngle = startAngle + M_PI * 2 *(value / totalValues);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [path addLineToPoint:center];
        [[self setColor] set];
    }
}

- (UIColor *)setColor
{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}
@end
