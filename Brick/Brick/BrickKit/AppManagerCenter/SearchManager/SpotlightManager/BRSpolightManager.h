//
//  BRSpolightManager.h
//  BrickKit
//
//  Created by jinxiaofei on 16/7/22.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRBaseManager.h"

@interface BRSpolightManager : BRBaseManager

/**
 *  新建Spolight搜索条目
 *
 *  @param contentType      item类型
 *  @param title            title
 *  @param description      desc
 *  @param keywords         keywords
 *  @param uniqueIdentifier 每个搜索都有一个唯一标示，当用户点击搜索到得某个内容的时候，系统会调用代理方法，会将这个唯一标示传给你，以便让你确定是点击了哪一，方便做页面跳转
 *  @param domainIdentifier 搜索域标识，删除条目的时候调用的delegate会传过来这个值
 */
- (void)addOneSpotlightItem:(NSString *)contentType title:(NSString *)title description:(NSString *)description keyWords:(NSArray<NSString *> *)keywords uniqueIdentifier:(NSString *)uniqueIdentifier domainIdentifier:(NSString *)domainIdentifier;

/**
 *  设置Spolight关联索引
 *
 *  @return 成功/失败
 */
- (BOOL)setSpotlightItemsToSearchableIndexIfHasAdded;

/**
 *  删除spotlight索引
 */
- (void)deleteSearchableItemsWithIdentifiers:(NSArray<NSString *> *)identifiers completionHandler:(void (^ __nullable)(NSError * __nullable error))completionHandler;

- (void)deleteSearchableItemsWithDomainIdentifiers:(NSArray<NSString *> *)domainIdentifiers completionHandler:(void (^ __nullable)(NSError * __nullable error))completionHandler;

- (void)deleteAllSearchableItemsWithCompletionHandler:(void (^ __nullable)(NSError * __nullable error))completionHandler;
@end
