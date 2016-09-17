//
//  BRFileManager.m
//  BrickKit
//
//  Created by jinxiaofei on 16/7/23.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRFileManager.h"

@implementation BRFileManager

- (instancetype)init
{
    if (self = [super init])
    {
        [self getPaths];
    }
    return self;
}

- (void)getPaths
{
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.homeDirectoryPath = NSHomeDirectory();
    self.cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject; // ~/Library/Caches
    self.documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject; // ~/Documents
    self.preferencesPath = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject; // ~/Library/Preferences
    self.tempPath = NSTemporaryDirectory();
}


- (void)saveUserDefaults:(id)object forKey:(NSString *)key
{
    [self.userDefaults setObject:object forKey:key];
}
- (id)objectForKey:(NSString *)aKey
{
    return [self.userDefaults objectForKey:aKey];
}
- (void)removeObjectForKey:(NSString *)aKey
{
    [self.userDefaults removeObjectForKey:aKey];
}

- (NSString *)pathIfExist:(NSString *)directoryName where:(BRFileManagerFileCreateWhere)where
{
    NSString *path;
    switch (where) {
        case BRFileManagerFileCreateHome: {
            path = [self.homeDirectoryPath stringByAppendingPathComponent:directoryName];
            break;
        }
        case BRFileManagerFileCreateCaches: {
            path = [self.cachesPath stringByAppendingPathComponent:directoryName];
            break;
        }
        case BRFileManagerFileCreateDocument: {
            path = [self.documentsPath stringByAppendingPathComponent:directoryName];
            break;
        }
        case BRFileManagerFileCreatePreference: {
            path = [self.preferencesPath stringByAppendingPathComponent:directoryName];
            break;
        }
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return path;
    }
    
    BOOL res = [self createDirectory:path];
    
    if (res)
    {
        return path;
    }
    return nil;
}

- (NSString *)pathIfExist:(NSString *)directoryName wherePath:(NSString *)wherePath
{
    NSString *path = [wherePath stringByAppendingPathComponent:directoryName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return path;
    }
    
    BOOL res = [self createDirectory:path];
    
    if (res)
    {
        return path;
    }
    return nil;
}

- (NSString *)absolutePath:(NSString *)directoryPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath])
    {
        return directoryPath;
    }
    
    BOOL res = [self createDirectory:directoryPath];
    
    if (res)
    {
        return directoryPath;
    }
    return nil;

}

- (BOOL)createDirectory:(NSString *)directoryPath
{
    return  [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
}

//快速迭代剪切文件
-(void)moveDirectoryFile:(NSString *)fromPath to:(NSString *)toPath
{
    [NSFileManager defaultManager];
    NSArray *subPaths = [[NSFileManager defaultManager] subpathsAtPath:fromPath];
    NSInteger count = subPaths.count;
    
    dispatch_apply(count, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSString *fileName = subPaths[index];
        
        NSString *fromFullPath = [fromPath stringByAppendingPathComponent:fileName];
        NSString *toFullPath = [toPath stringByAppendingPathComponent:fileName];
        NSError *error = nil;
        [[NSFileManager defaultManager] moveItemAtPath:fromFullPath toPath:toFullPath error:&error];
    });
}

//文件夹大小
+ (void)calculateDirectorySize:(NSString *)directoryPath completeBlock:(void(^)(NSInteger size))completeBlock
{
    NSFileManager *manger = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExists = [manger fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isDirectory || !isExists) {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"文件不匹配" reason:@"文件不是文件夹或路径不存在" userInfo:nil];
        [excp raise];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSInteger totoalSize = 0;
        NSArray *subPaths = [manger subpathsAtPath:directoryPath];
        for (NSString *subPath in subPaths) {
            NSString *fullPath = [directoryPath stringByAppendingPathComponent:subPath];
            BOOL isDirectory;
            BOOL isExists = [manger fileExistsAtPath:fullPath isDirectory:&isDirectory];
            if (!isExists || isDirectory || [fullPath containsString:@".DS_StoreZ"])continue;
            NSDictionary *fileAttribue = [manger attributesOfItemAtPath:fullPath error:nil];
            NSInteger fileSize = [fileAttribue[NSFileSize] integerValue];
            totoalSize += fileSize;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (completeBlock) {
                completeBlock(totoalSize);
            }
        });
    });
    
}

+ (void)clearDirectoryFiles:(NSString *)directoryPath
{
    NSFileManager *manger = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExists = [manger fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isDirectory || !isExists) {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"文件类型不匹配" reason:@"文件不是文件夹或路径不存在" userInfo:nil];
        [excp raise];
    }
    
    [manger removeItemAtPath:directoryPath error:nil];
    [manger createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    
}

+ (NSString *)conversionFileSize:(NSInteger)size
{
    NSString *sizeStr ;
    CGFloat totoalSize = 0;
    if (size >= (1000 * 1000 * 1000)) {
        totoalSize = size / (1000.0f * 1000 * 1000);
        sizeStr = [NSString stringWithFormat:@"%.1fGB", totoalSize];
    }else if (size >= (1000 * 1000)) {
        totoalSize = size / (1000.0f * 1000);
        sizeStr = [NSString stringWithFormat:@"%.1fMB", totoalSize];
    }else if(size >= 1000 ){
        totoalSize = size / 1000.0f;
        sizeStr = [NSString stringWithFormat:@"%.1fKB", totoalSize];
    }else if(size > 0){
        sizeStr = [NSString stringWithFormat:@"%zdB", size];
    }
    [sizeStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    
    return sizeStr;
    
}

@end
