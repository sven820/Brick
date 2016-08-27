//
//  JJPhoto.m
//  JJBaiSiBuDeJie
//
//  Created by jxf on 16/2/20.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "JJPhoto.h"
#import <Photos/Photos.h>

@implementation JJPhoto

+ (void)saveImage:(UIImage *)image errorBlock:(void (^)())errorOperation andSuccessBlock:(void (^)())successOperation
{
    // 判断读取系统相册的状态
    /*
     PHAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
     PHAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
     // The user cannot change this application’s status, possibly due to active restrictions
     //   such as parental controls being in place.
     PHAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.
     PHAuthorizationStatusAuthorized         // User has authorized this application to access photos data.
     */
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
            
        case PHAuthorizationStatusNotDetermined:{ // 未询问权限
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self save:image errorBlock:errorOperation andSuccessBlock:successOperation];
                }else{
                    NSLog(@"不允许存");
                }
            }];
        }
            break;
            
        case PHAuthorizationStatusDenied: // user 拒绝授权
            NSLog(@"用户拒绝授权过, 在这里提醒用户打开授权");
            break;
            
        case PHAuthorizationStatusAuthorized: // user 授权app
            [self save:image errorBlock:errorOperation andSuccessBlock:successOperation];
            break;
            
        case PHAuthorizationStatusRestricted: // 系统级别限制, user无法获得授权
            NSLog(@"没有足够权限");
            break;
    }
}

+ (void)save:(UIImage *)image errorBlock:(void (^)())errorOperation andSuccessBlock:(void (^)())successOperation
{
    // 1. 保存图片到相机胶卷中
    NSError *error = nil;
    __block NSString *savedImageIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        savedImageIdentifier = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    // 等 block 执行忘了才能根据 identifier 拿到 image, 在 block 中是拿不到 image 的, 所以弄了个 identifier 来间接获得 image, collection 同理
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[savedImageIdentifier] options:nil];
    
    // 2. 创建 app 对应的相册
    // 检查相册是已经创建
    NSString *albumTitle = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHAssetCollection *appCollection = nil;
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:albumTitle]) {
            appCollection = collection;
            break;
        }
    }
    if (appCollection == nil) {
        __block NSString *appCollectionIdentifier = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            appCollectionIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumTitle].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error];
        // 新建相册后, 给相册赋值
        appCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[appCollectionIdentifier] options:nil].firstObject;
    }
    
    // 3. 将保存到相机胶卷中的图片引用到新建的 app 相册中
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:appCollection];
        [request insertAssets:assets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    if (error) {
        if (errorOperation) {
            errorOperation();
        }
    }else{
        if (successOperation) {
            successOperation();
        }
    }
}

@end
