//
//  CBWHeader.h
//  CBWRefresh
//
//  Created by 陈博文 on 16/5/30.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBWrefreshComponet.h"

@interface CBWHeader : CBWrefreshComponet

//TODO
//设置不同状态的下字体


/** 创建header */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
@end
