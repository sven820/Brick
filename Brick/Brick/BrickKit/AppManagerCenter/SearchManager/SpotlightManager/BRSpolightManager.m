//
//  BRSpolightManager.m
//  BrickKit
//
//  Created by jinxiaofei on 16/7/22.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRSpolightManager.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface BRSpolightManager ()
@property(nonatomic, strong) NSMutableArray *spotlightItems;
@end

@implementation BRSpolightManager

- (void)addOneSpotlightItem:(NSString *)contentType title:(NSString *)title description:(NSString *)description keyWords:(NSArray<NSString *> *)keywords uniqueIdentifier:(NSString *)uniqueIdentifier domainIdentifier:(NSString *)domainIdentifier
{
    /*应用内搜索，想搜索到多少个界面就要创建多少个set ，每个set都要对应一个item*/
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:contentType];
    //标题
    attributeSet.title = title;
    //详细描述
    attributeSet.contentDescription = description;
    //关键字，
    attributeSet.contactKeywords = keywords;

    //UniqueIdentifier每个搜索都有一个唯一标示，当用户点击搜索到得某个内容的时候，系统会调用代理方法，会将这个唯一标示传给你，以便让你确定是点击了哪一，方便做页面跳转
    //domainIdentifier搜索域标识，删除条目的时候调用的delegate会传过来这个值
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:@"firstItem" domainIdentifier:@"first" attributeSet:attributeSet];
    
#warning TODO 归档
    [self.spotlightItems addObject:item];
}

- (BOOL)setSpotlightItemsToSearchableIndexIfHasAdded
{
#warning TODO 解归档后新增条目建立索引
    __block BOOL res = [CSSearchableIndex isIndexingAvailable];
    
    if (res == NO)
    {
        return NO;
    }
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:self.spotlightItems completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"setSpotlightItemsToSearchableIndex failure %@",error);
            res = NO;
        }else{
            NSLog(@"setSpotlightItemsToSearchableIndex success");
            res = YES;
        }
    }];
    return res;
}

#warning TODO
- (void)spotlightAndJumpToApp:(NSUserActivity *)userActivity
{
    NSString *idetifier  = userActivity.userInfo[@"kCSSearchableItemActivityIdentifier"];
    NSLog(@"%@",idetifier);
    
    
}

- (void)deleteSearchableItemsWithIdentifiers:(NSArray<NSString *> *)identifiers completionHandler:(void (^ __nullable)(NSError * __nullable error))completionHandler
{
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:identifiers completionHandler:completionHandler];
}
- (void)deleteSearchableItemsWithDomainIdentifiers:(NSArray<NSString *> *)domainIdentifiers completionHandler:(void (^ __nullable)(NSError * __nullable error))completionHandler
{
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithDomainIdentifiers:domainIdentifiers completionHandler:completionHandler];
}

- (void)deleteAllSearchableItemsWithCompletionHandler:(void (^ __nullable)(NSError * __nullable error))completionHandler
{
    [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:completionHandler];
}
#pragma mark - getter
- (NSMutableArray *)spotlightItems
{
    if (!_spotlightItems)
    {
        _spotlightItems = [NSMutableArray array];
    }
    return _spotlightItems;
}
@end
