//
//  AutoKeyBoard.h
//  test
//
//  Created by jinxiaofei on 16/5/27.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCFKeyBoardManager.h"
#import "YCFInputAttribute.h"

@interface YCFTextField : UITextField

@property(nonatomic, weak) UIView * containerView; //处理键盘遮挡, 默认为自己, 为自己的时候只移动自己的frame

//这个类包装了textField, textView的输入文本和占位符的属性
@property(nonatomic, strong, setter=setInputAttribute:) YCFInputAttribute *inputAttribute;
@end

