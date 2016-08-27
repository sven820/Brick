//
//  NSDictionary+BRLog.h
//  JJKit
//
//  Created by jinxiaofei on 16/6/16.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BRLog)
- (NSString *)descriptionWithLocale:(id)locale;

@end

@interface NSArray (BRLog)
- (NSString *)descriptionWithLocale:(id)locale;

@end