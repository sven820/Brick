//
//  YCFDemoTableViewCell.h
//  YCFComponentKit_OC
//
//  Created by jinxiaofei on 16/8/8.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCFTestCellModel.h"

@interface YCFDemoTextViewCell : UITableViewCell
+ (instancetype)demoTextViewCellWithTableView:(UITableView *)tableView;


- (void)configWithModel:(YCFTestCellModel *)model;
@end
