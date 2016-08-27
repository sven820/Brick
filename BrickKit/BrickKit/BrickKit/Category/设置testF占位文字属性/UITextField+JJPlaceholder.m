//
//  UITextField+JJPlaceholder.m
//  JJBaiSiBuDeJie
//
//  Created by jxf on 16/1/23.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "UITextField+JJPlaceholder.h"
#import <objc/message.h>

@implementation UITextField (JJPlaceholder)

+ (void)load
{
    Method setPlaceholder = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method jj_setPlaceholder = class_getInstanceMethod(self, @selector(jj_setPlaceholder:));
    method_exchangeImplementations(setPlaceholder, jj_setPlaceholder);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    // 为了, 扩充通用性,将颜色保存起来,placeLabel是懒加载的, 等正真设置placeHolder文字的时候再设置文字颜色
    // 给系统类添加属性,要用运行时
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UILabel *placeholderLabel = [self valueForKeyPath:@"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
    
}

- (UIColor *)placeholderColor
{
    return objc_getAssociatedObject(self, @"placeholderColor");
}

- (void)jj_setPlaceholder:(NSString *)placeholder
{
    [self jj_setPlaceholder:placeholder];
    
    self.placeholderColor = self.placeholderColor;
}

// 不能直接在这里面设置placeholder, 因为这里我们并不知道系统是么时候懒加载label和设置文字的, 所以用交换方法老设置placeholderLabel
//- (void)setPlaceholder:(NSString *)placeholder
//{
//    UILabel *placeholderLabel = [self valueForKeyPath:@"placeholderLabel"];
//    self.placeholderColor = self.placeholderColor;
//}

@end
