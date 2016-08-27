//
//  BRTestViewModel.m
//  BrickKit
//
//  Created by jinxiaofei on 16/8/24.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "BRTestViewModel.h"
#import "BRLoadImageAPI.h"
#import "BRImageTools.h"

@interface BRTestViewModel ()

@property(nonatomic, strong) NSString *img;
@end

@implementation BRTestViewModel

- (void)loadImage
{
    [BRLoadImageAPI loadImageSuccess:^(NSString *image, NSInteger statusCode) {
        
        if (statusCode == 200)
        {
            self.img = image;
        }

    } errBlock:^(NSString *errorMessage, NSInteger statusCode) {
        self.image = nil;
    }];
}

- (NSString *)getImage
{
    BRImageTools *tool = [BRImageTools shareTools];
    
    // 同名方法stub, 请详见测试类
    NSString *img = [tool dealImage:self.img];
//    NSString *img = [BRImageTools dealImage:self.img];
    
    img = [self privateMehtodDealImage:img];//私有逻辑
    
    return img;
}

//私有方法
- (NSString *)privateMehtodDealImage:(NSString *)image
{
    //想象这里有一大坨...
    self.img = [NSString stringWithFormat:@"%@归来", self.img];
    return self.img;
}
@end
