//
//  NSDictionary+YCFSafe.h
//  YCFComponentKit_OC
//
//  Created by JJ.sven on 16/8/22.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YXYSafe)

#pragma mark - 仿止crash容错API
+ (BOOL)checkIsEmptyOrNotDict:(NSDictionary *)dict;

//取不到或出错返回nil;
+ (id)safe_objectForKey:(id)key dict:(NSDictionary *)dict;
+ (id)safe_objectForKey:(id)key dict:(NSDictionary *)dict classType:(Class)classType;

//set obj 出错则直接返回
+ (void)safe_setObject:(id)value key:(id)key dict:(NSMutableDictionary *)dict;


@end
