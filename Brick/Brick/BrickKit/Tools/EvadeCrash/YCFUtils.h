//
//  YCFUtils.h
//  MyYaoChuFaApp
//
//  Created by qiuxiaofeng on 15/10/10.
//  Copyright © 2015年 要出发. All rights reserved.
//

#ifndef MyYaoChuFaApp_YCFUtils_h
#define MyYaoChuFaApp_YCFUtils_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark UIColor

#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define UIColorFromHex(hexValue)            UIColorFromHexWithAlpha(hexValue,1.0)
#define UIColorFromRGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b)               UIColorFromRGBA(r,g,b,1.0)
#define RandomColor UIColorFromRGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));

#pragma mark -
#pragma mark IndexPath

#define INDEX_PATH(a,b) [NSIndexPath indexPathWithIndexes:(NSUInteger[]){a,b} length:2]

#pragma mark -
#pragma mark Transforms

#define DEGREES_TO_RADIANS(degrees) degrees * M_PI / 180

#pragma mark - 
#pragma mark onePixel

#define kOnePixel (1.0f / [UIScreen mainScreen].scale)

#define WeakSelf @weakify(self);
#define StrongSelf @strongify(self);

//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

#pragma mark -
#pragma mark static method

static inline BOOL IsEmpty(id thing) {
    return thing == nil || [thing isEqual:[NSNull null]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

static inline id objectForKey(NSDictionary *dict, NSString *key)
{
    if (!([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSMutableDictionary class]])) {
        return nil;
    }
    if (dict.count == 0 || !dict)
    {
        return nil;
    }
    if (!key) {
        return nil;
    }
    id object = [dict objectForKey:key];
    return [object isEqual:[NSNull null]] ? nil : object;
}

static inline id objectAtArrayIndex(NSArray *array, NSUInteger index)
{
    if (!([array isKindOfClass:[NSArray class]] || [array isKindOfClass:[NSMutableArray class]])) {
        return nil;
    }
    if (array && array.count > index) {
        return array[index];
    } else {
        return nil;
    }
}

//非数组类型或者数组越界或者取出的元素不是给定的类型，都返回nil
static inline id objectInArray(NSArray *array, NSInteger index, Class elementClass)
{
    if (!([array isKindOfClass:[NSArray class]] || [array isKindOfClass:[NSMutableArray class]]))
    {
        return nil;
    }
    if (array && array.count > index && index >= 0)
    {
        id element = array[index];
        if ([element isMemberOfClass:elementClass] || [element isKindOfClass:elementClass])
        {
            return element;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

static inline void onMainThreadAsync(void (^block)())
{
    if ([NSThread isMainThread]) block();
    else dispatch_async(dispatch_get_main_queue(), block);
}

/**
 *  注意：当value为空字符串时无法增加
 */
static inline void setObjectAtDictionary(NSMutableDictionary *dic, id key, id value)
{
    if (dic == nil || ![dic isKindOfClass:[NSMutableDictionary class]])
    {
        return;
    }
//    if (IsEmpty(key) || ([key isKindOfClass:[NSString class]] && [NSString checkIsEmptyOrNull:key]) || ![key conformsToProtocol:@protocol(NSCopying)])
//    {
//        return;
//    }
//    if (IsEmpty(value) || ([value isKindOfClass:[NSString class]] && [NSString checkIsEmptyOrNull:value]))
//    {
//        return;
//    }
    [dic setObject:value forKey:key];
}
#endif
