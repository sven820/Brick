//
//  NSArray+YCFSafe.h
//  YCFComponentKit_OC
//
//  Created by JJ.sven on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (YXYSafe)

#pragma mark - 仿止crash容错API
+ (BOOL)checkIsEmptyOrNotArray:(NSArray *)array;

//没有找到则返回NSNotFound
+ (NSUInteger)safe_indexOfObject:(id)obj inArray:(NSArray *)array;

//没有或没有对应类型则返回nil
+ (id)safe_objectAtIndex:(NSInteger)index array:(NSArray *)array;
+ (id)safe_objectAtIndex:(NSInteger)index array:(NSArray *)array classType:(Class)classType;

//操作失败时候, 直接返回
+ (void)safe_addObject:(id)obj array:(NSMutableArray *)array;
+ (void)safe_insertObject:(id)obj index:(NSInteger)index array:(NSMutableArray *)array;
+ (void)safe_insertObjects:(NSArray *)objs indexSet:(NSIndexSet *)indexSet array:(NSMutableArray *)array;
@end
