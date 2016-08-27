//
//  BRSmallCalendarView.h
//  BrickKit
//
//  Created by jinxiaofei on 16/7/7.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BRCalendarModel;

@interface BRSmallCalendarView : UIView

+ (instancetype)createSmallCallendarView;

- (void)reloadWithModels:(NSArray<BRCalendarModel *> *)models;
@end
