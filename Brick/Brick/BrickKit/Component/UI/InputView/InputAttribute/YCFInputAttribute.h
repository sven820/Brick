//
//  YCFInputAttribute.h
//  YCFComponentKit_OC
//
//  Created by jinxiaofei on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 * 这个类包装了textField, textView的输入文本和占位符的属性
 */
@interface YCFInputAttribute : NSObject
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) UIColor *textColor;//默认black
@property(nonatomic, strong) UIFont *textFont;//默认14

@property(nonatomic, strong) NSString *placeHolder;
@property(nonatomic, strong) UIColor *placeHolderColor;//默认lightGray
@property(nonatomic, assign) UIFont *placeHolderFont;//默认14

@property(nonatomic, assign) NSInteger textLimitCount;

@property(nonatomic, strong, getter=getTextAttribute) NSMutableDictionary *textAttribute;
@property(nonatomic, strong, getter=getAttributeText) NSAttributedString *attributeText;

@property(nonatomic, strong, getter=getPlaceHolderAttribute) NSMutableDictionary *placeHolderAttribute;
@property(nonatomic, strong, getter=getAttributePlaceHolder) NSAttributedString *attributePlaceHolder;

@end
