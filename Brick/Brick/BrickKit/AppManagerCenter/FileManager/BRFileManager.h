//
//  BRFileManager.h
//  BrickKit
//
//  Created by jinxiaofei on 16/7/23.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRBaseManager.h"

typedef NS_ENUM(NSUInteger, BRFileManagerFileCreateWhere) {
    BRFileManagerFileCreateHome,
    BRFileManagerFileCreateCaches,
    BRFileManagerFileCreateDocument,
    BRFileManagerFileCreatePreference,
};

@interface BRFileManager : BRBaseManager

@property(nonatomic, strong) NSUserDefaults *userDefaults;

@property(nonatomic, strong) NSString *homeDirectoryPath;
@property(nonatomic, strong) NSString *cachesPath;
@property(nonatomic, strong) NSString *documentsPath;
@property(nonatomic, strong) NSString *preferencesPath;
@property(nonatomic, strong) NSString *tempPath;

//NSUserDefaults
- (void)saveUserDefaults:(id)object forKey:(NSString *)aKey;
- (id)objectForKey:(NSString *)aKey;
- (void)removeObjectForKey:(NSString *)aKey;

//save for plist,plist文件不能够保存自定义对象

//save data

//SQLite

//获取路径, 没有则创建, 创建失败返回nil
- (NSString *)pathIfExist:(NSString *)directoryName where:(BRFileManagerFileCreateWhere)where;
- (NSString *)pathIfExist:(NSString *)directoryName wherePath:(NSString *)wherePath;
- (NSString *)absolutePath:(NSString *)directoryPath;


-(void)moveDirectoryFile:(NSString *)fromPath to:(NSString *)toPath;

+ (void)calculateDirectorySize:(NSString *)directoryPath completeBlock:(void(^)(NSInteger size))completeBlock;
+ (NSString *)conversionFileSize:(NSInteger)size;//.0GB/.0MB/.0KB/.0B

+ (void)clearDirectoryFiles:(NSString *)directoryPath;

@end
