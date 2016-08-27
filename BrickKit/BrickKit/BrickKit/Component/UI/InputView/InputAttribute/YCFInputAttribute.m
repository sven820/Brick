//
//  YCFInputAttribute.m
//  YCFComponentKit_OC
//
//  Created by jinxiaofei on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "YCFInputAttribute.h"

@implementation YCFInputAttribute
- (instancetype)init
{
    if (self = [super init])
    {
        self.textFont = [UIFont systemFontOfSize:14];
        self.textColor = [UIColor blackColor];
        
        self.placeHolderFont = [UIFont systemFontOfSize:14];
        self.placeHolderColor = [UIColor lightGrayColor];
    }
    return self;
}

- (NSMutableDictionary *)getTextAttribute
{
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionary];
    textAttr[NSFontAttributeName] = self.textFont;
    textAttr[NSForegroundColorAttributeName] = self.textColor;
    return textAttr;
}

- (NSAttributedString *)getAttributeText
{
    if (self.text && self.text.length > 0)
    {
        return [[NSAttributedString alloc] initWithString:self.text attributes:self.textAttribute];
    }
    return nil;
}

- (NSMutableDictionary *)getPlaceHolderAttribute
{
    NSMutableDictionary *placeHolderAttr = [NSMutableDictionary dictionary];
    placeHolderAttr[NSFontAttributeName] = self.placeHolderFont;
    placeHolderAttr[NSForegroundColorAttributeName] = self.placeHolderColor;
    return placeHolderAttr;
}

- (NSAttributedString *)getAttributePlaceHolder
{
    if (self.placeHolder && self.placeHolder.length > 0)
    {
        return [[NSAttributedString alloc] initWithString:self.placeHolder attributes:self.placeHolderAttribute];
    }
    return nil;
}
@end
