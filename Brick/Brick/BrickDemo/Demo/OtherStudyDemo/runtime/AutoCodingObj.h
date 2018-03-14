//
//  AutoCodingObj.h
//  Brick
//
//  Created by 靳小飞 on 2018/2/23.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuperAutoCodingObj : NSObject
@property (nonatomic, strong) NSString *superName;
@end

@interface AutoCodingObj : SuperAutoCodingObj
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *addr;
@end
