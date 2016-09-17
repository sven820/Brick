//
//  BRTestViewModel.h
//  BrickKit
//
//  Created by jinxiaofei on 16/8/24.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BRTestViewModel : NSObject

/*
 为例配合讲解, 我故意营造很多场景
 BRTestViewModel: 我们常见的MVVM模式, viewModel会包含我们大部分数据,网络请求等处理逻辑
 
 BRLoadImageAPI: 负责请求数据和回调, 我习惯YTKNetWork这种网络请求方式, 讲解怎么Mock网络请求
 
 BRImageTools: 处理图片的工具类, 单例, 讲解Mock使用, 单例怎么Mock, 怎么stub同名ClassMethod和InstanceMethod
*/

//这里我们模拟请求一张图片

// 这里我们以 @"图片"来代表image, 最后返回结果是: @"图片超人"

- (void)loadImage;

@property(nonatomic, strong, getter=getImage) NSString *image;
@end
