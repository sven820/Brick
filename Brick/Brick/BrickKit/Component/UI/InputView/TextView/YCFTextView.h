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

@class YCFTextView;

@protocol YCFTextViewDelegate <UITextViewDelegate>

@optional
/**
 *  将要改变textView frame高度的回调, 注意这里frame只会改变高度, 不会改变坐标, 如果你布局用的是frame, 需要在代理中更新相关坐标, 如果你用的是autoLayout,则需更新相关高度约束
    需要注意是, 此回调, 键盘任然处于弹出状态, 某些情况下, 用此代理回调更新约束, 会强制退出键盘,体验不好, 比如[tableView reload],此时请用下面的代理
 *
 *  @param textView  textView
 *  @param height    改变后的高度
 *  @param oriHeight 改变前的高度(编辑前的高度)
 */
- (void)textView:(YCFTextView *)textView willChangeToHeight:(CGFloat)height oriHeight:(CGFloat)oriHeight;

/**
 *  textView 高度改变后的回调, 注意由于tableView在reload会自动退出键盘, 如果你的textView在tableView cell中, 则需判读isResign==yes的时候来更新你的布局, 其他view, scrollView中随意
 *
 *  @param textView  textView
 *  @param height    改变后的高度
 *  @param oriHeight 改变前的高度(编辑前的高度)
 *  @param isResign  当前键盘是否退出
 */
- (void)textView:(YCFTextView *)textView didChangeToHeight:(CGFloat)height oriHeight:(CGFloat)oriHeight keyBoardIsResign:(BOOL)isResign;

- (void)textView:(YCFTextView *)textView didOverTextLength:(NSInteger)textLength;
@end

@interface YCFTextView : UITextView
@property(nonatomic, weak) id<YCFTextViewDelegate> delegate;
@property(nonatomic, weak) UIView * containerView; //处理键盘遮挡, 默认为自己, 为自己的时候只移动自己的frame

//这个类包装了textField, textView的输入文本和占位符, 以及相关属性
@property(nonatomic, strong, setter=setInputAttribute:) YCFInputAttribute *inputAttribute;

//根据内容适配大小, 内部会改变bounds,在开始布局的时候使用
- (void)fitSizeWithMaxSize:(CGFloat)maxWidth;

@property(nonatomic, assign) BOOL isNeedAdjustHeight;//默认NO:不自适应文本大小, YES:自适应文本大小, 会改变bounds大小, 但不会改坐标, 请在代理里面更新相应frame或约束
@property(nonatomic, assign) CGFloat adjustMaxHeight;//不赋值, 则不限制高度
@property(nonatomic, assign) CGFloat adjustMinHeight;//默认一行的高度

//限制行数需要与lineBreakMode一起使用, 不然没效果, 这里一般用来限制不可编辑的情况, 可编辑时不要限制行数(超过行数的字会看不见), 可以用adjustMaxHeight限制高度
//用原生的editable限制是否可编辑, 但是用editable限制为NO时, 文本可以发生滚动, 不想滚动, 请使用scrollEnable限制
@property(nonatomic, assign, setter=setLineBreakMode:) NSLineBreakMode lineBreakMode;//原生:textContainer->lineBreakMode
@property(nonatomic, assign, setter=setNumberOfLines:) NSInteger numberOfLines;//原生:textContainer->maximumNumberOfLines

//文本字数限制
@property(nonatomic, assign) BOOL isShowTextLengthLabel;
@property(nonatomic, assign) UIEdgeInsets lengthLabelPadding;

//对应原生textContainerInset(默认上下8, 左右0), 但原生的在textContainer属性中有个lineFragmentPadding(影响文本左右间距), 且默认为5
//如果使用textInsets属性, 这里会将原生的lineFragmentPadding至为0, 并赋值给textContainerInset
@property(nonatomic, assign, setter=setTextInsets:) UIEdgeInsets textInsets;

@end
